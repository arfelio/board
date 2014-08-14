class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.integer :user_id
      t.string :image
      t.text :content
      t.string :author

      t.timestamps
    end
  end
end
