class Question < ApplicationRecord
  serialize :answers, Hash
  serialize :correct_answers, Hash
  serialize :tips, Array
end
