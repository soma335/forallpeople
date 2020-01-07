class RemoveAlbumFromMicropost < ActiveRecord::Migration[5.1]
  def change
    remove_column :microposts, :name, :string
  end
end
