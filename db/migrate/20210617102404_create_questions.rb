class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :question
      t.text :answers
      t.string :category
      t.string :difficulty
      t.text :correct_answers

      t.timestamps
    end
  end
end
