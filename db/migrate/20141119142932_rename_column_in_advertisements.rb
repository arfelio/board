class RenameColumnInAdvertisements < ActiveRecord::Migration[4.2]
  def change
  	change_table :advertisements do |t|
      t.rename :author, :title
    end
  end
end
