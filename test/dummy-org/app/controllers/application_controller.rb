class ApplicationController < ActionController::Base
  before_action :prepare_meta_tags, if: -> { request.get? }
  # CSRF protection is turned on with the protect_from_forgery method. 
  protect_from_forgery unless: -> { request.format.json? }
  def prepare_meta_tags(options={})
    site_name   = DEFAULT_TITLE
    title       = [controller_name, action_name].join(" ")
    description = DEFAULT_DESCRIPTION
    image       = options[:image] || href="/assets/images/logo.png"
    keywords     = DEFAULT_KEYWORDS
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      keywords:    keywords,
      twitter: {
        site_name: site_name,
        site: site_name,
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
end
