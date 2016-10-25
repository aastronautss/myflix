class AddVideoUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :watch_url, :string
  end
end
