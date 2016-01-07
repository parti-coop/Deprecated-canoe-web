class RemovePinFromOpinions < ActiveRecord::Migration
  def change
    remove_column :opinions, :pinned, :boolean
    remove_column :opinions, :pinned_at, :datetime
  end
end
