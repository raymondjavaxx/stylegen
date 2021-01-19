# frozen_string_literal: true
#
require_relative 'helper'

class TestColor < MiniTest::Unit::TestCase
  def test_parsing
    color = Stylegen::Color.from_hex("#FF8000")
    assert_equal color.red, 1.0
    assert_equal color.green, 0.5
    assert_equal color.blue, 0.0
    assert_equal color.alpha, 1.0
  end

  def test_grayscale
    color = Stylegen::Color.new(1, 1, 1, 1)
    assert color.grayscale?

    color = Stylegen::Color.new(1, 1, 0.9, 1)
    assert color.grayscale? == false
  end

  def test_to_string
    color = Stylegen::Color.from_hex("#00FF00")
    expected = "UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)"
    assert_equal color.to_s, expected

    # Grayscale
    color = Stylegen::Color.from_hex("#FFFFFF")
    expected = "UIColor(white: 1.0, alpha: 1.0)"
    assert_equal color.to_s, expected
  end
end
