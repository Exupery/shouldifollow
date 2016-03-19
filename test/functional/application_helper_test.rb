require "test_helper"

class ApplicationHelperTest < ActionView::TestCase

  test "get timezones" do
    timezones = get_timezones()
    assert_not_nil timezones
    assert_not_empty timezones
    timezones.each do |k, v|
      assert_kind_of(String, k)
      assert_kind_of(Numeric, v)
    end
  end
end