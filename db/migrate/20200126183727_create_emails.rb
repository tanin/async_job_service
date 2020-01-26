class CreateEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.integer :external_id, null: false, index: { unique: true }
      t.json :data, null: false

      t.timestamps
    end
  end
end
