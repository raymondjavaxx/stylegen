# frozen_string_literal: true

module Stylegen
  module Partials
    class Utils
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_s
        result = []
        result << '// MARK: Utils'
        result << ''

        if data.swiftui?
          result << <<~HEREDOC.lstrip
            #{data.effective_access_level} extension Color {
                @inline(__always)
                static func #{data.util_method_name}(_ color: #{data.struct_name}) -> Color {
                    if #available(iOS 15.0, *) {
                        return Color(uiColor: color.rawValue)
                    } else {
                        return Color(color.rawValue)
                    }
                }
            }
          HEREDOC

          result << ''
        end

        result << '#if canImport(UIKit)' if data.multiplatform?
        result << render_uicolor_extension if data.supports_uikit?
        result << '#elseif canImport(AppKit)' if data.multiplatform?
        result << render_nscolor_extension if data.supports_appkit?
        result << '#endif' if data.multiplatform?
        result << ''

        result << <<~HEREDOC.lstrip
          #{data.effective_access_level} extension CGColor {
              @inline(__always)
              static func #{data.util_method_name}(_ color: #{data.struct_name}) -> CGColor {
                  return color.rawValue.cgColor
              }
          }
        HEREDOC

        result.join("\n")
      end

      private

      def render_uicolor_extension
        <<~HEREDOC.strip
          #{data.effective_access_level} extension UIColor {
              @inline(__always)
              static func #{data.util_method_name}(_ color: #{data.struct_name}) -> UIColor {
                  return color.rawValue
              }
          }
        HEREDOC
      end

      def render_nscolor_extension
        <<~HEREDOC.strip
          #{data.effective_access_level} extension NSColor {
              @inline(__always)
              static func #{data.util_method_name}(_ color: #{data.struct_name}) -> NSColor {
                  return color.rawValue
              }
          }
        HEREDOC
      end
    end
  end
end
