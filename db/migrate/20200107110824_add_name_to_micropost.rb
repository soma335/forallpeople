class AddNameToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :name, :string
  end
end
