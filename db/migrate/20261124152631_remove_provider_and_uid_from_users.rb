# Facebook login was removed; these columns only stored the OAuth provider and user id.
class RemoveProviderAndUidFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
