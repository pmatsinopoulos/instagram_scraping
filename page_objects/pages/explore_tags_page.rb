module PageObjects
  module Pages
    class ExploreTagsPage < SitePrism::Page
      set_url "#{Settings.instagram_root_url}/explore/tags{/hash_tag}/"

      elements :posts, '._myci9 a'
      elements :likes,  'a.coreSpriteHeartOpen'
      elements :comment_forms, 'form._k3t69'
      elements :comments, "._7uiwk"

      element :next_post, 'a._de018.coreSpriteRightPaginationArrow'
    end
  end
end