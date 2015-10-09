require 'settingslogic'

class Settings < Settingslogic
  source "application.yml"
  namespace ENV['INSTAGRAM_SCRAPPING_ENV'] || 'development'
end