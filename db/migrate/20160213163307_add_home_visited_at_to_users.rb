class AddHomeVisitedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :home_visited_at, :datetime

    reversible do |dir|
      dir.up do
        query = 'UPDATE users SET home_visited_at = updated_at'
        ActiveRecord::Base.connection.execute query
        say query

        change_column_null :users, :home_visited_at, false
      end
    end
  end
end
