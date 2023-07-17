# frozen_string_literal: true

module Stylegen
  module Partials
    # rubocop:disable Metrics/ClassLength
    class Struct
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_s
        <<~HEREDOC.lstrip
          #{data.effective_access_level} final class #{data.struct_name} {
          #{Indent.new(4, render_native_color_alias)}

              fileprivate let rawValue: NativeColor

              private init(_ rawValue: NativeColor) {
                  self.rawValue = rawValue
              }

              private convenience init(white: CGFloat, alpha: CGFloat) {
                  self.init(
                      NativeColor(white: white, alpha: alpha)
                  )
              }

              private convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
                  self.init(
                      NativeColor(red: red, green: green, blue: blue, alpha: alpha)
                  )
              }

          #{Indent.new(4, render_platform_specific_initializers)}
          }
        HEREDOC
      end

      private

      def render_native_color_alias
        result = []
        result << '#if canImport(UIKit)' if data.multiplatform?
        result << 'typealias NativeColor = UIColor' if data.supports_uikit?
        result << '#elseif canImport(AppKit)' if data.multiplatform?
        result << 'typealias NativeColor = NSColor' if data.supports_appkit?
        result << '#endif' if data.multiplatform?
        result.join("\n")
      end

      def render_platform_specific_initializers
        result = []
        result << render_light_dark_initializer
        result << render_base_elevated_initializer
        result.join("\n\n")
      end

      def render_light_dark_initializer
        result = []

        result << "private convenience init(light: #{data.struct_name}, dark: #{data.struct_name}) {"

        if data.multiplatform?
          result << Indent.with_level(4) do
            '#if canImport(UIKit)'
          end
        end

        if data.supports_uikit?
          result << Indent.with_level(4) do
            <<~HEREDOC.strip
              self.init(
                  NativeColor(dynamicProvider: { traits in
                      switch traits.userInterfaceStyle {
                      case .dark:
                          return dark.rawValue
                      default:
                          return light.rawValue
                      }
                  })
              )
            HEREDOC
          end
        end

        if data.multiplatform?
          result << Indent.with_level(4) do
            '#elseif canImport(AppKit)'
          end
        end

        if data.supports_appkit?
          result << Indent.with_level(4) do
            <<~HEREDOC.strip
              self.init(
                NativeColor(name: nil, dynamicProvider: { appearance in
                    switch appearance.name {
                    case .darkAqua,
                        .vibrantDark,
                        .accessibilityHighContrastDarkAqua,
                        .accessibilityHighContrastVibrantDark:
                        return dark.rawValue
                    default:
                        return light.rawValue
                    }
                })
              )
            HEREDOC
          end
        end

        if data.multiplatform?
          result << Indent.with_level(4) do
            '#endif'
          end
        end

        result << '}'
        result.join("\n")
      end

      def render_base_elevated_initializer
        result = []

        result << "private convenience init(base: #{data.struct_name}, elevated: #{data.struct_name}) {"
        if data.multiplatform?
          result << Indent.with_level(4) do
            '#if canImport(UIKit)'
          end
        end

        if data.supports_uikit?
          result << Indent.with_level(4) do
            <<~HEREDOC.strip
              self.init(
                  NativeColor(dynamicProvider: { traits in
                      switch traits.userInterfaceLevel {
                      case .elevated:
                          return elevated.rawValue
                      default:
                          return base.rawValue
                      }
                  })
              )
            HEREDOC
          end
        end

        if data.multiplatform?
          result << Indent.with_level(4) do
            '#elseif canImport(AppKit)'
          end
        end

        if data.supports_appkit?
          result << Indent.with_level(4) do
            <<~HEREDOC.strip
              // macOS doesn't have elevated colors
              self.init(base.rawValue)
            HEREDOC
          end
        end

        if data.multiplatform?
          result << Indent.with_level(4) do
            '#endif'
          end
        end

        result << '}'
        result.join("\n")
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
