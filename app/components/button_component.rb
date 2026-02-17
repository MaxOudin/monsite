# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary: "text-white bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 shadow-md hover:shadow-lg",
    secondary: "text-gray-700 bg-white border border-gray-300 hover:bg-gray-50",
    dark: "text-white bg-gray-900 hover:bg-gray-800",
    danger: "text-white bg-red-600 hover:bg-red-500"
  }.freeze

  SIZES = {
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base"
  }.freeze

  def initialize(variant: :primary, size: :md, icon: nil, full_width: false, **html_options)
    @variant = variant
    @size = size
    @icon = icon
    @full_width = full_width
    @html_options = html_options
  end

  private

  def classes
    [
      "inline-flex items-center justify-center rounded-lg font-semibold transition-all duration-200",
      VARIANTS.fetch(@variant),
      SIZES.fetch(@size),
      (@full_width ? "w-full" : ""),
      @html_options.delete(:class)
    ].compact_blank.join(" ")
  end
end