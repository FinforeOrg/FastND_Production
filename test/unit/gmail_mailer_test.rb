require 'test_helper'

class GmailMailerTest < ActionMailer::TestCase
  test "reply" do
    @expected.subject = 'Gmail#reply'
    @expected.body    = read_fixture('reply')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Gmail.create_reply(@expected.date).encoded
  end

end
