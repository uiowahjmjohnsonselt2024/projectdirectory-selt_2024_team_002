class AddTriviaQuestionToQuests < ActiveRecord::Migration[7.1]
  def change
    add_column :quests, :trivia_question, :json
  end
end
