class RenameOrderInQueueMembersToListOrder < ActiveRecord::Migration
  def change
    rename_column :queue_members, :order, :list_order
  end
end
