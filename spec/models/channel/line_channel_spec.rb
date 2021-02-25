# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Channel::LineChannel do
  let(:channel) { create(:channel_line_channel) }

  it { is_expected.to validate_presence_of(:account_id) }
  it { is_expected.to belong_to(:account) }

  it 'has a valid name' do
    expect(channel.name).to eq('LINE')
  end

  it 'has 24 hour messaging window' do
    expect(channel.has_24_hour_messaging_window).to eq false
  end
end
