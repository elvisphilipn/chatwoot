class Api::V1::Accounts::Channels::LineChannelsController < Api::V1::Accounts::BaseController
  before_action :authorize_request

  def initialize
    super
    @expires = DateTime.now.new_offset(0)
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

  def build_inbox
    @line_channel = Current.account.line_channels.create!(
      channel_id: permitted_params[:channel_id],
      channel_token: permitted_params[:channel_token],
      channel_secret: permitted_params[:channel_secret]
    )
    @inbox = Current.account.inboxes.create(
      name: permitted_params[:name],
      channel: @line_channel
    )
  end

  def setup_webhooks
    ::Line::WebhookSetupService.new(inbox: @inbox).perform
  end

  def permitted_params
    params.require(:line_channel).permit(
      :channel_id, :channel_token, :channel_secret, :name
    )
  end
end
