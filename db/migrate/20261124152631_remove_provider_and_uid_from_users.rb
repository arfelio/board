# Facebook login was removed; these columns only stored the OAuth provider and user id.
class RemoveProviderAndUidFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
  end
end
