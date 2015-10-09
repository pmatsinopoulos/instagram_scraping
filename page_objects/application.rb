module PageObjects
  class Application
    def initialize
      @pages = {}
    end

    def instagram
      @pages[:instagram] ||= PageObjects::Pages::InstagramPage.new
    end

    def explore_tags
      @pages[:explore_tags] ||= PageObjects::Pages::ExploreTagsPage.new
    end
  end
end