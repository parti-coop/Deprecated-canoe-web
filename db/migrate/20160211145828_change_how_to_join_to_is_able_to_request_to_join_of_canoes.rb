class ChangeHowToJoinToIsAbleToRequestToJoinOfCanoes < ActiveRecord::Migration
  def execute_sql sql
    ActiveRecord::Base.connection.execute sql
    say sql
  end

  def up
    add_column :canoes, :is_able_to_request_to_join, :boolean, default: true
    execute_sql "UPDATE canoes SET is_able_to_request_to_join = 0 WHERE how_to_join = 'private_join'"
    remove_column :canoes, :how_to_join
  end

  def down
    add_column :canoes, :how_to_join, :string, null: false, default: 'public_join'
    execute_sql "UPDATE canoes SET how_to_join = 'private_join' WHERE is_able_to_request_to_join = 0"
    remove_column :canoes, :is_able_to_request_to_join
  end
end
