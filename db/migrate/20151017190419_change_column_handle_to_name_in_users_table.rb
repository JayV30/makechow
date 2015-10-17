class ChangeColumnHandleToNameInUsersTable < ActiveRecord::Migration
  def change
    rename_column :users, :handle, :name
  end
end
