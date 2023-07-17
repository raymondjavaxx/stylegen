# frozen_string_literal: true

module Stylegen
  module Partials
    class Imports
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_s
        result = []

        if data.multiplatform?
          result << '#if canImport(UIKit)'
          result << 'import UIKit'
          result << '#elseif canImport(AppKit)'
          result << 'import AppKit'
          result << '#endif'
        elsif data.supports_uikit?
          result << 'import UIKit'
        elsif data.supports_appkit?
          result << 'import AppKit'
        end

        result << 'import SwiftUI' if data.swiftui?
        result << ''
        result.join("\n")
      end
    end
  end
end
