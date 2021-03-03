class CreateChannelLineChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_line_channels do |t|
      t.string :name
      t.integer :account_id, null: false
      t.string :channel_id, null: false
      t.string :channel_secret, null: false
      t.string :channel_token, null: false
      t.timestamps
    end
  end
end
