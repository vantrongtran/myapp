class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.integer :lesson_id
      t.string  :references
      t.integer :word_id
      t.string  :references
      t.integer :answer_id

      t.timestamps
    end
  end
end
