# frozen_string_literal: true

require "cell/partial"

module Decidim
  # @todo Document this cell
  #
  # Example:
  #
  #    cell("decidim/footer_topics", nil)
  class FooterTopicsCell < Decidim::ViewModel
    def show
      return if topics.blank?

      topics
    end

    private

    def topics
      @topics = current_organization.static_page_topics.where(show_in_footer: true)
    end

    def topic_item(page_data, opts = {})
      content_tag(:li, **opts.slice(:class)) do
        link_to page_data[:title], page_data[:path]
      end
    end
  end
end
