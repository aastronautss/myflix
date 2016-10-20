class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :name, :email
      t.text :message
      t.integer :inviter_id
      t.integer :invitee_id

      t.timestamps
    end
  end
end
