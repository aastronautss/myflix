class CreateQueueMembers < ActiveRecord::Migration
  def change
    create_table :queue_members do |t|
      t.integer :user_id, :video_id
      t.integer :order

      t.timestamps
    end
  end
end
