class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean, default: true

    User.all.each do |user|
      user.activate
    end
  end
end
