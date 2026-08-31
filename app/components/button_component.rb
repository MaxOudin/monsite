# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary:   "text-secondary bg-primary hover:bg-primary-hover",
    secondary: "text-white bg-secondary border border-secondary hover:bg-secondary-hover hover:border-secondary-hover",
    dark:      "text-white bg-gray-900 hover:bg-gray-800",
    danger:    "text-white bg-red-600 hover:bg-red-500",
    link:      "btn-link w-fit text-gray-600 border-b border-gray-300 pb-0.5 hover:text-secondary hover:border-secondary"
  }.freeze

  SIZES = {
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base"
  }.freeze

  PILL_SIZES = {
    sm: "px-4 h-9 text-sm",
    md: "px-6 h-10 text-sm",
    lg: "px-8 h-12 text-base"
  }.freeze

  def initialize(variant: :primary, size: :md, shape: :default, icon: nil, full_width: false, href: nil, classes: nil, html_options: {}, **rest)
    @variant = variant.to_sym
    @size = size.to_sym
    @shape = shape.to_sym
    @icon = icon
    @full_width = full_width
    @href = href
    @extra_classes = classes
    @html_options = html_options.merge(rest)
  end

  private

  def classes
    [
      "inline-flex items-center justify-center transition-all duration-300",
      VARIANTS.fetch(@variant),
      shape_classes,
      size_classes,
      elevation_classes,
      (@full_width ? "w-full" : ""),
      @extra_classes,
      @html_options.delete(:class)
    ].compact_blank.join(" ")
  end

  def shape_classes
    return "" if link?

    pill? ? "rounded-full font-medium" : "rounded-lg font-semibold"
  end

  def size_classes
    return "text-sm font-medium" if link?

    pill? ? PILL_SIZES.fetch(@size) : SIZES.fetch(@size)
  end

  def elevation_classes
    return "" if link?
    return "hover:-translate-y-0.5" if pill?

    "shadow-md hover:shadow-lg hover:-translate-y-0.5"
  end

  def pill?
    @shape == :pill
  end

  def link?
    @variant == :link
  end
end
