require 'test_helper'

class TaskOccurrenceMailerTest < ActionMailer::TestCase
  test "allocate" do
    mail = TaskOccurrenceMailer.allocate
    assert_equal "Allocate", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "reminder" do
    mail = TaskOccurrenceMailer.reminder
    assert_equal "Reminder", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
