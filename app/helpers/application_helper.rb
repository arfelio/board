module ApplicationHelper
  # Bootstrap 5 alert colour for a flash key. Devise uses :notice / :alert,
  # the app also sets :success.
  FLASH_ALERT_CLASSES = {
    "notice" => "success",
    "success" => "success",
    "alert" => "danger",
    "error" => "danger"
  }.freeze

  def flash_alert_class(key)
    FLASH_ALERT_CLASSES.fetch(key.to_s, "info")
  end

  # Render pagination with Bootstrap 5 markup (app/lib/bootstrap_link_renderer.rb).
  # will_paginate's Rails helper sets its own default renderer, so the global
  # pagination_options setting is ignored; pass the renderer here instead.
  def will_paginate(collection = nil, options = {})
    options, collection = collection, nil if collection.is_a?(Hash)
    super(collection, { renderer: BootstrapLinkRenderer }.merge(options))
  end
end
