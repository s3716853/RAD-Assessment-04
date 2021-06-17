class AddDescriptionToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :description, :string
    add_column :questions, :multiple_correct_answers, :boolean
    add_column :questions, :explanation, :string
    add_column :questions, :tip, :string
    add_column :questions, :tags, :text
  end
end
