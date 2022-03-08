# frozen_string_literal: true

module Stylegen
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
      result << "import UIKit"
      result << "import SwiftUI" if data.swiftui?
      result << ""
      result.join("\n")
    end

    def render_struct
      <<~HEREDOC
        #{data.access_level} struct #{data.struct_name} {

            let uiColor: UIColor

            fileprivate init(white: CGFloat, alpha: CGFloat) {
                self.uiColor = UIColor(white: white, alpha: alpha)
            }

            fileprivate init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
                self.uiColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }

            fileprivate init(_ color: UIColor) {
                self.uiColor = color
            }

            fileprivate init(light: #{data.struct_name}, dark: #{data.struct_name}) {
                if #available(iOS 13.0, *) {
                    self.uiColor = UIColor(dynamicProvider: { (traits: UITraitCollection) -> UIColor in
                        switch traits.userInterfaceStyle {
                        case .dark:
                            return dark.uiColor
                        default:
                            return light.uiColor
                        }
                    })
                } else {
                    self.uiColor = light.uiColor
                }
            }

            fileprivate init(base: #{data.struct_name}, elevated: #{data.struct_name}) {
                if #available(iOS 13.0, *) {
                    self.uiColor = UIColor(dynamicProvider: { (traits: UITraitCollection) -> UIColor in
                        switch traits.userInterfaceLevel {
                        case .elevated:
                            return elevated.uiColor
                        default:
                            return base.uiColor
                        }
                    })
                } else {
                    self.uiColor = base.uiColor
                }
            }

        }
      HEREDOC
    end

    def render_colors
      result = []
      result << "// MARK: Colors"
      result << ""
      result << "#{data.access_level} extension #{data.struct_name} {"
      result << ""

      data.color_entries.each do |entry|
        unless entry[:description].nil?
          entry[:description].strip.lines.each do |line|
            result << "    /// #{line.strip}"
          end
        end

        result << "    static let #{entry[:property]} = #{entry[:color].to_s(data.struct_name, 4)}\n"
      end

      result << "}"
      result << ""
      result.join("\n")
    end

    def render_utils
      result = []
      result << "// MARK: Utils"
      result << ""

      if data.swiftui?
        result << <<~HEREDOC
          #{data.access_level} extension Color {

              @inline(__always)
              static func #{data.util_method_name}(_ color: #{data.struct_name}) -> Color {
                  return Color(color.uiColor)
              }

          }
        HEREDOC
      end

      result << <<~HEREDOC
        #{data.access_level} extension UIColor {

            @inline(__always)
            static func #{data.util_method_name}(_ color: #{data.struct_name}) -> UIColor {
                return color.uiColor
            }

        }

        #{data.access_level} extension CGColor {

            @inline(__always)
            static func #{data.util_method_name}(_ color: #{data.struct_name}) -> CGColor {
                return color.uiColor.cgColor
            }

        }
      HEREDOC

      result.join("\n")
    end
  end
end
