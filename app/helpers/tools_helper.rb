module ToolsHelper
  def tool_icon(tool_name)
    icon = case tool_name.downcase
    when /ruby/i then 'fa-regular fa-gem'
    when /rails/i then 'fa-train'
    when /javascript|js/i then 'fa-brands fa-js'
    when /typescript/i then 'fa-code'
    when /vue/i then 'fa-brands fa-vuejs'
    when /nuxt/i then 'fa-n'
    when /bootstrap/i then 'fa-brands fa-bootstrap'
    when /postgresql|postgres/i then 'fa-solid fa-database'
    when /github/i then 'fa-brands fa-github'
    when /gitlab/i then 'fa-brands fa-gitlab'
    when /heroku/i then 'fa-h-square'
    when /aws/i then 'fa-brands fa-aws'
    when /cloudinary/i then 'fa-cloud'
    when /redis/i then 'fa-solid fa-database'
    when /api|postman/i then 'fa-plug'
    when /mapbox|map/i then 'fa-map'
    when /vercel/i then 'fa-v'
    when /trello/i then 'fa-brands fa-trello'
    when /slack/i then 'fa-brands fa-slack'
    when /stimulus/i then 'fa-bolt'
    when /turbo/i then 'fa-forward'
    else 'fa-code'
    end

    tag.i class: "fas #{icon}"
  end
end
