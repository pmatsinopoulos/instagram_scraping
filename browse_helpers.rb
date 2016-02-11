def login(username, password)
  sleep(2)
  if $app.instagram.has_login_link?
    $app.instagram.login_link.click
    sleep(2)
  end
  $app.instagram.username.set username
  $app.instagram.password.set password
  $app.instagram.login.click
  sleep(3)
end

def search(hash_tag)
  $app.explore_tags.load hash_tag: hash_tag
  sleep(3)

  first_post = $app.explore_tags.posts.first
  if first_post.nil?
    return false
  end
  first_post.click
  true
end