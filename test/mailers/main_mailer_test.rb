require 'test_helper'

class MainMailerTest < ActionMailer::TestCase
  test "report_email" do
    mail = MainMailer.report_email
    assert_equal "Report email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
