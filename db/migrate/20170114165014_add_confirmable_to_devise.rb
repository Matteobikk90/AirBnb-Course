class AddConfirmableToDevise < ActiveRecord::Migration
  def up
  	add_column :user, :confirmation_token, :string
  	add_column :user, :confirmed_at, :datetime
  	add_column :user, :confirmation_sent_at, :datetime

  	add_index :user, :confirmation_token, unique: true
  end

  def down
  	remove_column :users, :confirmation_token, :confirmed_at, :confirmation_sent_at,
  end
end
