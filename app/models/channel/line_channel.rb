# == Schema Information
#
# Table name: channel_line_bots
#
#  id             :bigint           not null, primary key
#  channel_secret :string           not null
#  channel_token  :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer          not null
#  channel_id     :string           not null
#
class Channel::LineChannel < ApplicationRecord
  self.table_name = 'channel_line_channels'

  validates :account_id, presence: true
  validates :channel_id, uniqueness: { scope: :account_id }, presence: true
  validates :channel_secret, presence: true
  validates :channel_token, presence: true
  belongs_to :account

  has_one :inbox, as: :channel, dependent: :destroy

  def name
    'LINE'
  end

  def has_24_hour_messaging_window?
    false
  end
end
