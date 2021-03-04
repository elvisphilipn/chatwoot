class CreateChannelLineChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_line_channels do |t|
      t.integer :account_id, null: false
      t.string :channel_id, null: false
      t.string :channel_secret, null: false
      t.string :channel_token, null: false
      t.datetime :token_expires_at, null: false
      t.timestamps
      t.index [:account_id, :channel_id], name: 'index_channel_line_channels_on_account_id_and_channel_id', unique: true
    end
  end
end
