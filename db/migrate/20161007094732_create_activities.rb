class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.references :user, foreign_key: true
      t.integer :action_type
      t.integer :target_id

      t.timestamps
    end
  end
end
