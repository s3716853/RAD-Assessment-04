class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.string :topic
      t.string :difficulty
      t.string :questions
      t.string :results

      t.timestamps
    end
  end
end
