# frozen_string_literal: true

require 'yaml'
require_relative 'helper'

class TestTemplate < Minitest::Test
  def test_render_appkit
    yaml_path = File.join(__dir__, 'fixtures', 'appkit.yaml')
    swift_path = File.join(__dir__, 'fixtures', 'appkit.swift')

    data = File.open(yaml_path) { |file| YAML.safe_load(file) }
    template = Stylegen::Template.new(Stylegen::Data.new(data))

    assert_equal(File.read(swift_path), template.render)
  end

  def test_render_uikit
    yaml_path = File.join(__dir__, 'fixtures', 'uikit.yaml')
    swift_path = File.join(__dir__, 'fixtures', 'uikit.swift')

    data = File.open(yaml_path) { |file| YAML.safe_load(file) }
    template = Stylegen::Template.new(Stylegen::Data.new(data))

    assert_equal(File.read(swift_path), template.render)
  end

  def test_multiplatform
    yaml_path = File.join(__dir__, 'fixtures', 'multiplatform.yaml')
    swift_path = File.join(__dir__, 'fixtures', 'multiplatform.swift')

    data = File.open(yaml_path) { |file| YAML.safe_load(file) }
    template = Stylegen::Template.new(Stylegen::Data.new(data))

    assert_equal(File.read(swift_path), template.render)
  end

  def test_uikit_no_swiftui
    yaml_path = File.join(__dir__, 'fixtures', 'uikit_no_swiftui.yaml')
    swift_path = File.join(__dir__, 'fixtures', 'uikit_no_swiftui.swift')

    data = File.open(yaml_path) { |file| YAML.safe_load(file) }
    template = Stylegen::Template.new(Stylegen::Data.new(data))

    assert_equal(File.read(swift_path), template.render)
  end
end
