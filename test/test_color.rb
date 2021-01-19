# frozen_string_literal: true
#
require_relative 'helper'

class TestColor < MiniTest::Unit::TestCase
  def test_parsing
    color = Stylegen::Color.from_hex("#FF8000")
    assert_equal 1.0, color.red
    assert_equal 0.5, color.green
    assert_equal 0.0, color.blue
    assert_equal 1.0, color.alpha

    # Optional pound sign
    color = Stylegen::Color.from_hex("FF8000")
    assert_equal 1.0, color.red
    assert_equal 0.5, color.green
    assert_equal 0.0, color.blue
    assert_equal 1.0, color.alpha

    # Specify alpha
    color = Stylegen::Color.from_hex("#FF8000", 0.5)
    assert_equal 0.5, color.alpha
  end

  def test_parsing_shorthand_syntax
    color = Stylegen::Color.from_hex("#FC0")
    assert_equal 1.0, color.red
    assert_equal 0.8, color.green
    assert_equal 0.0, color.blue
    assert_equal 1.0, color.alpha

    # Optional pound sign
    color = Stylegen::Color.from_hex("FC0")
    assert_equal 1.0, color.red
    assert_equal 0.8, color.green
    assert_equal 0.0, color.blue
    assert_equal 1.0, color.alpha
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
    assert_equal expected, color.to_s

    # Grayscale
    color = Stylegen::Color.from_hex("#FFFFFF")
    expected = "UIColor(white: 1.0, alpha: 1.0)"
    assert_equal expected, color.to_s
  end
end
