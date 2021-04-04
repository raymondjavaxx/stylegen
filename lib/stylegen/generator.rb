# frozen_string_literal: true

require "stylegen/data"
require "stylegen/template"

module Stylegen
  class Generator
    def initialize(data)
      @data = Data.new(data)
    end

    def generate
      template_content = File.read(File.join(__dir__, "resources/template.swift.erb"))
      template = Template.new(template_content, @data)

      file = File.open(@data.output_path, "w")
      file << template.render
      file.close
    end

    def stats
      @stats ||= { output_path: @data.output_path, color_count: @data.colors.count }
    end
  end
end
