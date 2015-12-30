class AddLogoAndCoverToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :logo, :string
    add_column :canoes, :cover, :string
  end
end
