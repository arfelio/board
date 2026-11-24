# will_paginate renderer that outputs Bootstrap 5 pagination markup:
#   <ul class="pagination"><li class="page-item"><a class="page-link">…</a></li>…</ul>
# Used by default through ApplicationHelper#will_paginate.
# Loaded explicitly: when the app is eager loaded (production, zeitwerk:check) this file
# can be loaded before will_paginate has set up its Action View integration.
require "will_paginate/view_helpers/action_view"

class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer
  protected

  def html_container(html)
    tag(:nav, tag(:ul, html, class: "pagination"), "aria-label": "Pagination")
  end

  def page_number(page)
    if page == current_page
      tag(:li, tag(:span, page, class: "page-link"), class: "page-item active", "aria-current": "page")
    else
      tag(:li, link(page, page, class: "page-link", rel: rel_value(page)), class: "page-item")
    end
  end

  def previous_or_next_page(page, text, _classname, _aria_label = nil)
    if page
      tag(:li, link(text, page, class: "page-link"), class: "page-item")
    else
      tag(:li, tag(:span, text, class: "page-link"), class: "page-item disabled")
    end
  end

  def gap
    tag(:li, tag(:span, "&hellip;".html_safe, class: "page-link"), class: "page-item disabled")
  end
end
