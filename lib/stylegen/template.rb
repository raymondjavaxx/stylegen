# frozen_string_literal: true

require 'stylegen/indent'

module Stylegen
  # rubocop:disable Metrics/ClassLength
  class Template
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def render
      result = []
      result << render_header
      result << render_imports
      result << render_struct
      result << render_colors
      result << render_utils
      result.join("\n")
    end

    private

    def render_header
      @data.file_header << "\n"
    end

    def render_imports
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

    def render_struct
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

    def render_colors
      result = []
      result << '// MARK: Colors'
      result << ''
      result << "#{data.effective_access_level} extension #{data.struct_name} {".lstrip

      data.color_entries.each do |entry|
        unless entry[:description].nil?
          entry[:description].strip.lines.each do |line|
            result << "    /// #{line.strip}"
          end
        end

        result << "    static let #{entry[:property]} = #{entry[:color].to_s(data.struct_name, 4)}"
        result << '' unless entry == data.color_entries.last
      end

      result << '}'
      result << ''
      result.join("\n")
    end

    def render_utils
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

      if data.multiplatform?
        result << '#if canImport(UIKit)'
      end

      if data.supports_uikit?
        result << render_uicolor_extension
      end

      if data.multiplatform?
        result << '#elseif canImport(AppKit)'
      end

      if data.supports_appkit?
        result << render_nscolor_extension
      end

      if data.multiplatform?
        result << '#endif'
      end

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
  # rubocop:enable Metrics/ClassLength
end
