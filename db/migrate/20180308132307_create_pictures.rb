class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.string :image
      t.float  :emotional_point

      t.timestamps
    end
  end
end
