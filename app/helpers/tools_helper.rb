module ToolsHelper
  def tool_icon(tool_name)
    case tool_name.downcase
    when /ruby/i
      image_tag "tech_logos/ruby.svg", class: "tool-logo", alt: "Ruby logo"
    when /rails/i
      image_tag "tech_logos/rails.svg", class: "tool-logo", alt: "Rails logo"
    when /typescript/i
      image_tag "tech_logos/typescript.svg", class: "tool-logo", alt: "TypeScript logo"
    when /javascript|js/i
      image_tag "tech_logos/javascript.svg", class: "tool-logo", alt: "JavaScript logo"
    when /vue/i
      image_tag "tech_logos/vue.svg", class: "tool-logo", alt: "Vue.js logo"
    when /nuxt/i
      image_tag "tech_logos/nuxt.svg", class: "tool-logo", alt: "Nuxt logo"
    when /postgresql|postgres/i
      image_tag "tech_logos/postgresql.svg", class: "tool-logo", alt: "PostgreSQL logo"
    when /vercel/i
      image_tag "tech_logos/vercel.svg", class: "tool-logo", alt: "Vercel logo"
    when /bootstrap/i
      image_tag "tech_logos/bootstrap.svg", class: "tool-logo", alt: "Bootstrap logo"
    when /stimulus/i
      image_tag "tech_logos/stimulus.svg", class: "tool-logo", alt: "Stimulus logo"
    when /turbo/i
      image_tag "tech_logos/hotwire.svg", class: "tool-logo", alt: "Turbo Hotwire logo"
    when /mapbox/i
      image_tag "tech_logos/mapbox.svg", class: "tool-logo", alt: "Mapbox logo"
    when /cloudinary/i
      image_tag "tech_logos/cloudinary.svg", class: "tool-logo", alt: "Cloudinary logo"
    when /github/i
      image_tag "tech_logos/github.svg", class: "tool-logo", alt: "GitHub logo"
    when /gitlab/i
      image_tag "tech_logos/gitlab.svg", class: "tool-logo", alt: "GitLab logo"
    when /heroku/i
      image_tag "tech_logos/heroku.svg", class: "tool-logo", alt: "Heroku logo"
    when /cloudinary/i
      image_tag "tech_logos/cloudinary.svg", class: "tool-logo", alt: "Cloudinary logo"
    when /shazam/i
      image_tag "tech_logos/shazam.svg", class: "tool-logo", alt: "Shazam logo"
    when /postman/i
      image_tag "tech_logos/postman.svg", class: "tool-logo", alt: "Postman logo"
    when /aws/i
      image_tag "tech_logos/aws.svg", class: "tool-logo", alt: "Aws logo"
    when /devise/i
      image_tag "tech_logos/devise.svg", class: "tool-logo", alt: "Devise logo"
    when /openlayers/i
      image_tag "tech_logos/openlayers.svg", class: "tool-logo", alt: "OpenLayers logo"
    when /Star Rating/i
      image_tag "tech_logos/star.svg", class: "tool-logo", alt: "Star Rating logo"
    when /Tom Select/i
      image_tag "tech_logos/tom-select.svg", class: "tool-logo", alt: "Tom Select logo"
    when /zapier/i
      image_tag "tech_logos/zapier.svg", class: "tool-logo", alt: "Zapier logo"
    when /mindee/i
      image_tag "tech_logos/mindee.svg", class: "tool-logo", alt: "Mindee logo"
    when /flatpickr/i
      image_tag "tech_logos/flatpickr.svg", class: "tool-logo", alt: "Flatpickr logo"
    when /trello/i
      image_tag "tech_logos/trello.svg", class: "tool-logo", alt: "Trello logo"
    when /redis/i
      image_tag "tech_logos/redis.svg", class: "tool-logo", alt: "Redis logo"
    else
      tag.i class: "fas fa-code"
    end
  end
end
