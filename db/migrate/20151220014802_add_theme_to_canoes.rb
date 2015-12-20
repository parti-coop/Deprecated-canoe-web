class AddThemeToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :theme, :text
  end
end
