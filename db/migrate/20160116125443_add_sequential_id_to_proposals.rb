class AddSequentialIdToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :sequential_id, :integer
    reversible do |dir|
      dir.up do
        Proposal.order(id: :asc).each do |proposal|
          proposal.skip_setting_discussed_at = true
          proposal.set_sequential_id
          proposal.save!
        end

        change_column_null :proposals, :sequential_id, false
      end
    end
    add_index :proposals, [:sequential_id, :discussion_id], unique: true
  end
end
