# frozen_string_literal: true

require 'stylegen/indent'
require 'stylegen/partials/file_header'
require 'stylegen/partials/imports'
require 'stylegen/partials/struct'
require 'stylegen/partials/colors'
require 'stylegen/partials/utils'

module Stylegen
  class Template
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def render
      result = []
      result << Partials::FileHeader.new(data)
      result << Partials::Imports.new(data)
      result << Partials::Struct.new(data)
      result << Partials::Colors.new(data)
      result << Partials::Utils.new(data)
      result.join("\n")
    end
  end
end
