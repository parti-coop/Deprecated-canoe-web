class AddSequentialIdToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :sequential_id, :integer
    reversible do |dir|
      dir.up do
        Discussion.record_timestamps = false

        Discussion.skip_callbacks = true
        Canoe.skip_callbacks = true
        User.skip_callbacks = true

        Discussion.order(id: :asc).with_deleted.each do |discussion|
          discussion.set_sequential_id
          discussion.update_attribute :sequential_id, discussion.sequential_id
        end

        change_column_null :discussions, :sequential_id, false
      end
    end
    add_index :discussions, [:sequential_id, :canoe_id], unique: true
  end
end
