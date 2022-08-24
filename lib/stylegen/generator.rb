# frozen_string_literal: true

require 'stylegen/data'
require 'stylegen/template'

module Stylegen
  class Generator
    def initialize(data)
      @data = Data.new(data)
    end

    def generate
      template = Template.new(@data)

      file = File.open(@data.output_path, 'w')
      file << template.render
      file.close
    end

    def stats
      @stats ||= { output_path: @data.output_path, color_count: @data.color_entries.count }
    end
  end
end
