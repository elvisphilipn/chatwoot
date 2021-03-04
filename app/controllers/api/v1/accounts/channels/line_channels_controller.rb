class Api::V1::Accounts::Channels::LineChannelsController < Api::V1::Accounts::BaseController
  before_action :authorize_request

  def initialize
    super
    @expires = Time.now.utc
  end

  def create
    ActiveRecord::Base.transaction do
      build_inbox
      setup_webhooks
    rescue StandardError => e
      render_could_not_create_error(e.message)
    end
  end

  private

  def authorize_request
    authorize ::Inbox
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_id = permitted_params[:channel_id]
      config.channel_secret = permitted_params[:channel_secret]
      config.http_options = {
        open_timeout: 5,
        read_timeout: 5
      }
    end
  end

  def channel_token
    @response = client.issue_channel_token
    raise StandardError, @response.message unless @response.code == '200'

    @json_body = JSON.parse(@response.body)
    @token = @json_body['access_token']
    client.channel_token = @token
    @expires += @json_body['expires_in']
    @token
  end

  def build_inbox
    @line_channel = Current.account.line_channels.create!(
      channel_id: permitted_params[:channel_id],
      channel_token: channel_token,
      token_expires_at: Time.at(@expires).utc.to_datetime,
      channel_secret: permitted_params[:channel_secret]
    )
    @inbox = Current.account.inboxes.create(
      name: permitted_params[:name],
      channel: @line_channel
    )
  end

  def setup_webhooks
    ::Twilio::WebhookSetupService.new(inbox: @inbox).perform
  end

  def permitted_params
    params.require(:line_channel).permit(
      :channel_id, :channel_secret, :name
    )
  end
end
