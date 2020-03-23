class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.belongs_to :space
      t.text :body, null: false
      t.string :sent_by, null: false

      t.timestamps
    end
  end
end
