# frozen_string_literal: true

require 'open3'
require_relative 'helper'

class TestCLI < MiniTest::Test
  def test_version
    stdout, _stderr, status = Open3.capture3('bin/stylegen version')
    assert_equal(0, status.exitstatus)
    assert_includes stdout, "stylegen version #{Stylegen::VERSION}"
  end

  def test_init
    Dir.mktmpdir do |dir|
      stdout, _stderr, status = Open3.capture3("bin/stylegen init -o #{dir}/theme.yaml")
      assert_equal(0, status.exitstatus)
      assert_includes stdout, "Generated '#{dir}/theme.yaml'."

      assert_path_exists("#{dir}/theme.yaml", "Expected '#{dir}/theme.yaml' to exist.")
      assert_equal File.read("#{dir}/theme.yaml"), File.read('lib/stylegen/cli/template.yaml')
    end
  end

  def test_build
    Dir.mktmpdir do |dir|
      _stdout, stderr, status = Open3.capture3("bin/stylegen build -i #{dir}/theme.yaml")
      assert_equal(1, status.exitstatus)
      assert_includes stderr, "'#{dir}/theme.yaml' not found. Create one with 'stylegen init'."

      File.write("#{dir}/theme.yaml", File.read('lib/stylegen/cli/template.yaml'))

      stdout, _stderr, status = Open3.capture3("bin/stylegen build -i #{dir}/theme.yaml")
      assert_equal(0, status.exitstatus)
      assert_includes stdout, "Generated 'Colors.swift' with 5 colors."
    end
  end
end
