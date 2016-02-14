class AddSailedAtToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :sailed_at, :datetime

    reversible do |dir|
      dir.up do
        query = 'UPDATE canoes SET sailed_at = updated_at'
        ActiveRecord::Base.connection.execute query
        say query

        change_column_null :canoes, :sailed_at, false
      end
    end
  end
end
