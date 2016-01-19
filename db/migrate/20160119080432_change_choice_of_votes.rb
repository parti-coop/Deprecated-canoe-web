class ChangeChoiceOfVotes < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :votes do |t|
        dir.up do
          t.change :choice, :string

          query = "UPDATE votes SET choice = 'in_favor' where choice = '1'"
          ActiveRecord::Base.connection.execute query
          say query

          query = "UPDATE votes SET choice = 'opposed' where choice = '2'"
          ActiveRecord::Base.connection.execute query
          say query
        end
        dir.down do
          query = "UPDATE votes SET choice = '1' where choice = 'in_favor'"
          ActiveRecord::Base.connection.execute query
          say query

          query = "UPDATE votes SET choice = '2' where choice = 'opposed'"
          ActiveRecord::Base.connection.execute query
          say query

          t.change :choice, :integer
        end
      end
    end
  end
end
