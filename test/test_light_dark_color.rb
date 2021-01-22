# frozen_string_literal: true

require_relative "helper"

class TestLightDarkColor < MiniTest::Test
  def test_to_string
    color = Stylegen::LightDarkColor.new(
      Stylegen::Color.from_hex("#FFFFFF"),
      Stylegen::Color.from_hex("#333333")
    )

    # Default indentation

    expected = <<~CODE.chomp
      ThemeColor(
          light: ThemeColor(white: 1.0, alpha: 1.0),
          dark: ThemeColor(white: 0.2, alpha: 1.0)
      )
    CODE

    assert_equal expected, color.to_s("ThemeColor")

    # Additional indentation

    expected = <<~CODE.chomp
      ThemeColor(
              light: ThemeColor(white: 1.0, alpha: 1.0),
              dark: ThemeColor(white: 0.2, alpha: 1.0)
          )
    CODE

    assert_equal expected, color.to_s("ThemeColor", 4)
  end
end
