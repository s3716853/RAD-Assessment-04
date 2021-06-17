# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

quiz_file = File.read('quiz.json')
quiz_questions = JSON.parse(quiz_file)

quiz_questions.each do |question|
  # For some reason sometimes the API sends back a question with this field,
  # however its not the correct answer field, as that is the 'correct_answers'
  # fields purpose, so no clue why it exists, doesnt even match the right answer 
  # most of the time
  question.delete("correct_answer")
end

quiz_questions.each do |question|
  Question.create!(question)
end