class AddReasonToRequestToJoins < ActiveRecord::Migration
  def change
    add_column :request_to_joins, :reason, :text
  end
end
