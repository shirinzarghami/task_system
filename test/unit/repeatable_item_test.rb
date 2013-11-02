require 'test_helper'

class RepeatableItemTest < ActiveSupport::TestCase

  setup do
    @repeatable_item = create :repeatable_item_every_week
    @payment = create :product_declaration

    @repeatable_item.repeatable = @payment
    @repeatable_item.save
  end

  should "schedule repeatable item" do
    assert_equal 1, ProductDeclaration.count
    assert_equal 1, @repeatable_item.repeat_number

    RepeatableItem.schedule_upcoming

    assert_equal 2, ProductDeclaration.count
    
    next_occurrence = (Time.now.utc + 1.week).to_date
    assert_equal next_occurrence, @repeatable_item.reload.next_occurrence.utc.to_date

    assert_equal 0, @repeatable_item.repeat_number
  end

  should "not schedule it before next_occurrence date" do
    @repeatable_item.update_attributes :next_occurrence => 10.minutes.since
    assert_equal 0, RepeatableItem.to_schedule.count

    @repeatable_item.update_attributes :next_occurrence => Time.now
    assert_equal 1, RepeatableItem.to_schedule.count

  end


end
