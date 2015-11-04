class ChangeColumnAdministratorToAdminInUsersTable < ActiveRecord::Migration
  def change
    remove_column :users, :administrator
    add_column :users, :admin, :boolean, default: false
  end
end
