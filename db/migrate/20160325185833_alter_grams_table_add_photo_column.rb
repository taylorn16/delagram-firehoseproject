class AlterGramsTableAddPhotoColumn < ActiveRecord::Migration
  def change
    add_column :grams, :photo, :string
  end
end
