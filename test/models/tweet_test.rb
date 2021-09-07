require "test_helper"

class TweetTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  def setup
    @user=users(:michael)
    @tweet=@user.tweets.build(title: "Abc", body: "Sample Tweet")
  end

  test "valid tweet" do
    tweet=Tweet.new
    assert_not tweet.save
  end

  test "should be valid" do
    assert @tweet.valid?
  end


  test "title and body should be there" do
    @tweet.title=nil
    @tweet.body=nil
    assert_not @tweet.valid?
  end

  test "order should be recent first" do
    assert_equal tweets(:most_recent), Tweet.first
  end
  
end
