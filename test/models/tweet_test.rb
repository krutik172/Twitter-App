require "test_helper"

class TweetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "valid tweet" do
    tweet=Tweet.new
    assert_not tweet.save
  end
end
