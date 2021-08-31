class AddUserRefToTweet < ActiveRecord::Migration[6.1]
  def change
    add_reference :tweets, :user, foreign_key: true
  end
end
