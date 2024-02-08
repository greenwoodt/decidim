# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe InlineMenuPresenter, type: :helper do
    subject { InlineMenuPresenter.new(:custom_menu, view) }

    after { MenuRegistry.destroy(:custom_menu) }

    context "when using compulsory options" do
      before do
        MenuRegistry.register :custom_menu do |menu|
          menu.add_item :foo, "Foo", "/foo"
          menu.add_item :boo, "Bar", "/bar"
        end
      end

      it "renders the menu as a navigation list" do
        expect(subject.render).to have_no_selector("ul")
        expect(subject.render).to \
          have_selector("li", count: 2) &
          have_link("Foo", href: "/foo") &
          have_link("Bar", href: "/bar")
      end
    end

    context "when using position options" do
      before do
        MenuRegistry.register :custom_menu do |menu|
          menu.add_item :foo, "Foo", "/foo", position: 2
          menu.add_item :boo, "Bar", "/bar", position: 1
        end
      end

      it "renders the menu in the right order" do
        expect(subject.render).to have_no_selector("ul")
        expect(subject.render).to \
          have_selector("li:first-child", text: "Bar") &
          have_selector("li:last-child", text: "Foo")
      end
    end

    context "when using visibility options" do
      before do
        MenuRegistry.register :custom_menu do |menu|
          menu.add_item :foo, "Foo", "/foo", if: Time.current.year == 2000
          menu.add_item :boo, "Bar", "/bar"
        end
      end

      it "skips non visible options" do
        expect(subject.render).to have_no_selector("ul")
        expect(subject.render).to \
          have_selector("li", count: 1) &
          have_link("Bar", href: "/bar")
      end
    end
  end
end
