class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.integer :word_number

      t.timestamps
    end
  end
end
