class AddPinnedToOpinions < ActiveRecord::Migration
  def change
    add_column :opinions, :pinned, :boolean
    add_column :opinions, :pinned_at, :datetime
  end
end
