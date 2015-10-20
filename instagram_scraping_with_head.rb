require 'dotenv'
Dotenv.load

puts "Using proxy: #{ENV['INSTAGRAM_SCRAPING_PROXY_HOST']}"

require "capybara"
require 'selenium/webdriver'

require 'capybara/dsl'
require 'site_prism'

$LOAD_PATH << File.expand_path("..", __FILE__)

require 'settings'
require 'page_objects/pages/instagram_page'
require 'page_objects/pages/explore_tags_page'
require 'page_objects/application'
require 'browse_helpers'

def read_from_file(filename)
  full_path = "#{File.expand_path("..", __FILE__)}/#{filename}"
  result = []
  File.readlines(full_path).each do |line|
    line.chomp!
    result << line unless line.empty?
  end
  result
end

username = ARGV[0].chomp
hash_tag = ARGV[1].chomp
comments = nil
comments = read_from_file(ARGV[2].chomp) unless ARGV[2].nil?

puts "Email: #{username}"
puts "Hash Tag: #{hash_tag}"

ARGV.clear

puts "Please, give me your password to login to Instagram: "
password = gets.chomp
if password.empty?
  puts "It cannot be blank"
  exit 1
end

puts "Comments to be used: #{comments.inspect}" unless comments.nil?

Capybara.register_driver :firefox_with_proxy do |app|

  proxy = "#{ENV['INSTAGRAM_SCRAPING_PROXY_HOST']}:#{ENV['INSTAGRAM_SCRAPING_PROXY_PORT']}"
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.proxy = Selenium::WebDriver::Proxy.new(
      :http           => proxy,
      :ssl            => proxy,
      :socks_username => ENV['INSTAGRAM_SCRAPING_PROXY_USERNAME'],
      :socks_password => ENV['INSTAGRAM_SCRAPING_PROXY_PASSWORD']
  )

  Capybara::Selenium::Driver.new(app, :profile => profile)
end

Capybara.default_driver = :firefox_with_proxy

$app = PageObjects::Application.new

$app.instagram.load

login(username, password)

any_results = search(hash_tag)

unless any_results
  puts "No results"
  exit(0)
end

sleep(2)

i = 1
next_post_button = true
comments_index = 0
while next_post_button
  puts "going to post #{i}"

  like_heart = $app.explore_tags.likes.first

  if like_heart.nil?
    puts "...no like heart found"
  else
    like_heart.click

    unless comments.nil?
      comment_input = $app.explore_tags.comments.first
      if comment_input.nil?
        puts "...no comment area found"
      else
        comment_input.set "#{comments[comments_index]}\n"
        puts "...comment posted"
        comments_index += 1
        comments_index = 0 if comments_index == comments.size
      end
    end
  end

  sleep(3)

  next_post_button = $app.explore_tags.next_post

  unless next_post_button.nil?
    next_post_button.click
    i += 1
    sleep(2)
  end

end