# db/migrate/20260904231353_add_unique_index_to_carts_user.rb
class AddUniqueIndexToCartsUser < ActiveRecord::Migration[7.0]
  def change
    # Supprimer l'index existant
    remove_index :carts, :user_id if index_exists?(:carts, :user_id)
    
    # Créer un index UNIQUE
    add_index :carts, :user_id, unique: true
  end
end