# frozen_string_literal: true

require "erb"

module Stylegen
  class Template
    def initialize(content, data)
      @content = content
      @data = data
    end

    def render
      ERB.new(@content, nil, "-").result(binding)
    end
  end
end
