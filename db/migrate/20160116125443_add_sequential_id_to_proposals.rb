class AddSequentialIdToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :sequential_id, :integer
    reversible do |dir|
      dir.up do
        Discussion.skip_callbacks = true
        Canoe.skip_callbacks = true
        User.skip_callbacks = true
        Proposal.order(id: :asc).each do |proposal|
          proposal.set_sequential_id
          proposal.save!
        end

        change_column_null :proposals, :sequential_id, false
      end
    end
    add_index :proposals, [:sequential_id, :discussion_id], unique: true
  end
end
