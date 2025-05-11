class AddTokenCreatedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :token_created_at, :datetime
  end
end
