module PageObjects
  module Pages
    class InstagramPage < SitePrism::Page
      set_url Settings.instagram_root_url

      element :login_link, "a._k6cv7"
      element :username,   "[name='username']"
      element :password,   "[name='password']"
      element :login,      "button[data-reactid='.0.1.0.1.0.1.2.2']"

      element :search_input, "input[data-reactid='.0.2.0.1.$searchBox.0']"
    end
  end
end