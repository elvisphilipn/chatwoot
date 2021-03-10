require 'rails_helper'

RSpec.describe '/api/v1/accounts/{account.id}/channels/line_channel', type: :request do
  let(:account) { create(:account) }
  let(:admin) { create(:user, account: account, role: :administrator) }
  let(:agent) { create(:user, account: account, role: :agent) }
  let(:line_client) { instance_double(::Line::Bot::Client) }

  before do
    allow(::Line::Bot::Client).to receive(:new).and_return(line_client)
  end

  describe 'POST /api/v1/accounts/{account.id}/channels/line_channel' do
    let(:params) do
      {
        line_channel: {
          channel_id: '123456',
          channel_secret: 'the-secret-shh',
          name: 'My LINE Channel'
        }
      }
    end

    context 'when unauthenticated user' do
      it 'returns unauthorized' do
        post api_v1_account_channels_line_channel_path(account), params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
