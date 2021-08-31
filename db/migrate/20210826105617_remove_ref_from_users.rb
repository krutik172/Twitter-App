class RemoveRefFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :users, :tweet, foreign_key: true
  end
end
