require 'dotenv'
Dotenv.load

require "capybara"
require "capybara-webkit"

puts "Using proxy: #{ENV['INSTAGRAM_SCRAPING_PROXY_HOST']}"

Capybara::Webkit.configure do |config|
  # Enable debug mode. Prints a log of everything the driver is doing.
  #config.debug = true

  # By default, requests to outside domains (anything besides localhost) will
  # result in a warning. Several methods allow you to change this behavior.

  # Silently return an empty 200 response for any requests to unknown URLs.
  # config.block_unknown_urls

  # Allow pages to make requests to any URL without issuing a warning.
  config.allow_unknown_urls

  # Allow a specific domain without issuing a warning.
  # config.allow_url("example.com")

  # Allow a specific URL and path without issuing a warning.
  # config.allow_url("example.com/some/path")

  # Wildcards are allowed in URL expressions.
  # config.allow_url("*.example.com")

  # Silently return an empty 200 response for any requests to the given URL.
  # config.block_url("example.com")

  # Timeout if requests take longer than 5 seconds
  config.timeout = 60

  # Don't raise errors when SSL certificates can't be validated
  config.ignore_ssl_errors

  # Don't load images
  config.skip_image_loading

  # Use a proxy
  config.use_proxy(
      host: ENV['INSTAGRAM_SCRAPING_PROXY_HOST'],
      port: ENV['INSTAGRAM_SCRAPING_PROXY_PORT'],
      user: ENV['INSTAGRAM_SCRAPING_PROXY_USERNAME'],
      pass: ENV['INSTAGRAM_SCRAPING_PROXY_PASSWORD']
  )
end


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

Capybara.default_driver = :selenium

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