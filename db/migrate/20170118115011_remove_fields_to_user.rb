class RemoveFieldsToUser < ActiveRecord::Migration
  def change
    remove_column :users, :provide, :string
  end
end
