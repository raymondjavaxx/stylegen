# frozen_string_literal: true

require_relative 'helper'

class TestLightDarkColor < MiniTest::Unit::TestCase
  def test_to_string
    color = Stylegen::LightDarkColor.new(
        Stylegen::Color.from_hex("#FFFFFF"),
        Stylegen::Color.from_hex("#333333")
    )

    # Default indentation

    expected = <<~CODE.chomp
      UIColor(
          light: UIColor(white: 1.0, alpha: 1.0),
          dark: UIColor(white: 0.2, alpha: 1.0)
      )
    CODE

    assert_equal color.to_s, expected

    # Additional indentation

    expected = <<~CODE.chomp
      UIColor(
              light: UIColor(white: 1.0, alpha: 1.0),
              dark: UIColor(white: 0.2, alpha: 1.0)
          )
    CODE

    assert_equal color.to_s(4), expected
  end
end

