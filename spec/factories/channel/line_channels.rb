# frozen_string_literal: true

FactoryBot.define do
  factory :channel_line_channel, class: 'Channel::LineChannel' do
    channel_id { SecureRandom.uuid }
    channel_secret { SecureRandom.uuid }
    channel_token { SecureRandom.uuid }
    token_expires_at { DateTime.now }
    account
  end
end
