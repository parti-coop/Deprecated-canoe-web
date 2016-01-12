class AddSlackWebhookUrlToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :slack_webhook_url, :string, length: 1000
  end
end
