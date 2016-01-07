class AddDiscussedAtToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :discussed_at, :datetime

    reversible do |dir|
      dir.up do
        query = 'UPDATE discussions SET discussed_at = updated_at'
        ActiveRecord::Base.connection.execute query
        say query

        change_column_null :discussions, :discussed_at, false
      end
    end
  end
end
