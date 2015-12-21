class AddSlugToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :slug, :string
    add_index :canoes, :slug, unique: true

    reversible do |dir|
      dir.up do
        query = 'UPDATE canoes SET slug = id'
        ActiveRecord::Base.connection.execute query
        say query

        change_column_null :canoes, :slug, false
      end
    end
  end
end
