# frozen_string_literal: true

require_relative 'helper'

class TestColor < Minitest::Test
  def test_parsing
    color = Stylegen::Color.from_hex('#FF8000')

    assert_in_delta(1.0, color.red)
    assert_in_delta(0.5019607843137255, color.green)
    assert_in_delta(0.0, color.blue)
    assert_in_delta(1.0, color.alpha)

    # Optional pound sign
    color = Stylegen::Color.from_hex('FF8000')

    assert_in_delta(1.0, color.red)
    assert_in_delta(0.5019607843137255, color.green)
    assert_in_delta(0.0, color.blue)
    assert_in_delta(1.0, color.alpha)

    # Specify alpha
    color = Stylegen::Color.from_hex('#FF8000', 0.5)

    assert_in_delta(0.5, color.alpha)
  end

  def test_parsing_three_digit_hex
    color = Stylegen::Color.from_hex('#FC0')

    assert_in_delta(1.0, color.red)
    assert_in_delta(0.8000000000000002, color.green)
    assert_in_delta(0.0, color.blue)
    assert_in_delta(1.0, color.alpha)

    # Optional pound sign
    color = Stylegen::Color.from_hex('FC0')

    assert_in_delta(1.0, color.red)
    assert_in_delta(0.8000000000000002, color.green)
    assert_in_delta(0.0, color.blue)
    assert_in_delta(1.0, color.alpha)
  end

  def test_grayscale
    color = Stylegen::Color.new(1, 1, 1, 1)

    assert_predicate color, :grayscale?

    color = Stylegen::Color.new(1, 1, 0.9, 1)

    assert_not_predicate color, :grayscale?
  end

  def test_to_string
    color = Stylegen::Color.from_hex('#00FF00')

    expected = <<~CODE.strip
      ThemeColor(
          red: 0.0,
          green: 1.0,
          blue: 0.0,
          alpha: 1.0
      )
    CODE

    assert_equal expected, color.to_s('ThemeColor')

    # Grayscale
    color = Stylegen::Color.from_hex('#FFFFFF')
    expected = 'ThemeColor(white: 1.0, alpha: 1.0)'

    assert_equal expected, color.to_s('ThemeColor')
  end
end
