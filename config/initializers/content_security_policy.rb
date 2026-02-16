# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src :self, :data, "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/webfonts/", "https://fonts.gstatic.com/s/montserrat/", "https://fonts.gstatic.com/s/playfairdisplaysc/"
            
    # Configuration img-src avec support Active Storage et Hetzner
    img_sources = [:self, :data, :blob, "https://res.cloudinary.com/dyleaesxc/"]
    img_sources << "https://#{ENV["DOMAIN"]}" if ENV["DOMAIN"].present?
    
    policy.img_src(*img_sources)
    policy.object_src :none
    policy.base_uri :self
    policy.form_action :self, "https://tally.so"
    policy.style_src :self, "https://fonts.googleapis.com", "https://cdnjs.cloudflare.com"
    policy.script_src :self, :strict_dynamic,
                      "https://kit.fontawesome.com/",
                      "https://tally.so",
                      "https://unpkg.com/website-carbon-badges@1.1.3/b.min.js"
    policy.style_src_attr :self, "https://ka-f.fontawesome.com/", :unsafe_inline
    policy.style_src_elem :self,
                          "https://cdn.jsdelivr.net/npm/tom-select@2.4.1/dist/css/tom-select.default.min.css",
                          "https://fonts.googleapis.com",
                          "https://cdnjs.cloudflare.com",
                          :unsafe_inline
    
    # Directive cruciale pour les Web Workers de Mapbox
    policy.worker_src  :self, :blob
    
    # Configuration connect-src avec support pour l'object storage Hetzner
    connect_sources = [:self, "https://ka-f.fontawesome.com/"]
    connect_sources << "http://localhost:*" if Rails.env.development?
    connect_sources << "ws://localhost:*" if Rails.env.development?
    
    policy.connect_src(*connect_sources)
    policy.frame_ancestors :none # ou self / ou url de l'app
    policy.frame_src :self
    
    # Specify URI for violation reports
    policy.report_uri "/csp-violation-report-endpoint"
  end
  
  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
  
  # Report violations without enforcing the policy.
  config.content_security_policy_report_only = true
  config.upgrade_insecure_requests = true if Rails.env.production?
end
