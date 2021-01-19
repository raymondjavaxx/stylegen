# frozen_string_literal: true

require 'stylegen/data'

module Stylegen
  class Generator
    def initialize(data)
      @data = Data.new(data)
      @file = File.open(@data.output_path, "w")
    end

    def out(line)
      @file << line << "\n"
    end

    def generate
      generate_header
      generate_enums
      generate_lut
      generate_extensions
    end

    private

    def generate_header
      out "//"
      out "//  #{@data.basename}"
      out "//"
      out "//  Autogenerated by stylegen (v#{@data.version})"
      out "//  DO NOT EDIT"
      out "//"
      out ""
      out "import UIKit"
      out ""
    end

    def generate_enums
      out "#{@data.access_level} enum #{@data.enum_name}: Int {"

      @data.enum_members do |name|
        out "    case #{name}"
      end

      out "}"
      out ""
    end

    def generate_extensions
      out "#{@data.access_level} extension #{@data.enum_name} {"
      out ""
      out "    var uiColor: UIColor {"
      out "        guard let color = Self.colorLUT[self] else {"
      out "            preconditionFailure(\"Color not found\")"
      out "        }"
      out ""
      out "        return color"
      out "    }"
      out ""
      out "}"
      out ""

      out "#{@data.access_level} extension UIColor {"
      out ""
      out "    @inline(__always)"
      out "    static func #{@data.util_method_name}(_ color: #{@data.enum_name}) -> UIColor {"
      out "       return color.uiColor"
      out "    }"
      out ""
      out "}"
      out ""

      out "#{@data.access_level} extension CGColor {"
      out ""
      out "    @inline(__always)"
      out "    static func #{@data.util_method_name}(_ color: #{@data.enum_name}) -> CGColor {"
      out "       return color.uiColor.cgColor"
      out "    }"
      out ""
      out "}"
      out ""

      out "private extension UIColor {"
      out ""
      out "    convenience init(light: UIColor, dark: UIColor) {"
      out "        if #available(iOS 13.0, *) {"
      out "            self.init(dynamicProvider: { (traits: UITraitCollection) -> UIColor in"
      out "                switch traits.userInterfaceStyle {"
      out "                case .dark:"
      out "                    return dark"
      out "                default:"
      out "                    return light"
      out "                }"
      out "            })"
      out "        } else {"
      out "            self.init(cgColor: light.cgColor)"
      out "        }"
      out "    }"
      out ""
      out "    convenience init(base: UIColor, elevated: UIColor) {"
      out "        if #available(iOS 13.0, *) {"
      out "            self.init(dynamicProvider: { (traits: UITraitCollection) -> UIColor in"
      out "                switch traits.userInterfaceLevel {"
      out "                case .elevated:"
      out "                    return elevated"
      out "                default:"
      out "                    return base"
      out "                }"
      out "            })"
      out "        } else {"
      out "            self.init(cgColor: base.cgColor)"
      out "        }"
      out "    }"
      out ""
      out "}"
    end

    def generate_lut
      out "private extension #{@data.enum_name} {"
      out ""
      out "    private static let colorLUT: [#{@data.enum_name}: UIColor] = ["

      @data.colors do |enum_member, color|
        out "        .#{enum_member}: #{color.to_s(8)},"
      end

      out "    ]"
      out ""
      out "}"
      out ""
    end
  end
end
