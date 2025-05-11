class RemoveTokenAuthenticationColumnsFromUsers < ActiveRecord::Migration[7.2]
  def change
    # Suppression de la colonne authentication_token
    remove_column :users, :authentication_token, :string, if_exists: true
    # Suppression de l'index s'il existe encore
    remove_index :users, :authentication_token, if_exists: true
    
    # Suppression de la colonne token_created_at
    remove_column :users, :token_created_at, :datetime, if_exists: true
  end
end
