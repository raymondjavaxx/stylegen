# frozen_string_literal: true

require_relative 'helper'

class TestBaseElevatedColor < MiniTest::Unit::TestCase
  def test_to_string
    color = Stylegen::BaseElevatedColor.new(
        Stylegen::Color.from_hex("#000000"),
        Stylegen::Color.from_hex("#333333")
    )

    # Default indentation

    expected = <<~CODE.chomp
      UIColor(
          base: UIColor(white: 0.0, alpha: 1.0),
          elevated: UIColor(white: 0.2, alpha: 1.0)
      )
    CODE

    assert_equal expected, color.to_s

    # Additional indentation

    expected = <<~CODE.chomp
      UIColor(
              base: UIColor(white: 0.0, alpha: 1.0),
              elevated: UIColor(white: 0.2, alpha: 1.0)
          )
    CODE

    assert_equal expected, color.to_s(4)
  end
end
