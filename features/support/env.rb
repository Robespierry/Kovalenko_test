# frozen_string_literal: true

require 'rest-client'
require 'active_support/all'
require_relative 'helpers/rest_wrapper'
require_relative 'helpers/file_system_helpers'
require_relative 'helpers/logger'
require_relative 'api_clients/edisoft_api_client'
require 'capybara/cucumber'
require 'selenium-webdriver'
require_relative 'helpers/class_extentions'
require 'webdrivers'

$working_directory = Dir.pwd.gsub('/', '\\')

def browser_setup(browser = 'firefox')
  case browser
  when 'chrome'
    Capybara.register_driver :chrome do |app|
      profile = Selenium::WebDriver::Chrome::Profile.new
      profile['profile.default_content_settings.popups'] = 0 # custom location
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream, text/xml'
      profile['pdfjs.disabled'] = true
      Capybara::Selenium::Driver.new(app, browser: :chrome,
                                     desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
                                       'goog:chromeOptions' => {
                                         'args' => ['--window-size=1920,1080'],
                                         'prefs' => {
                                           'download.default_directory' => "#{$working_directory}\\features\\tmp",
                                           'download.prompt_for_download' => false,
                                           'download.directory_upgrade ' => true,
                                           'plugins.plugins_disabled' => ['Chrome PDF Viewer']
                                         }
                                       }
                                     ))
    end
    Capybara.default_driver = :chrome
    Capybara.page.driver.browser.manage.window.maximize
    Capybara.default_selector = :xpath
    Capybara.default_max_wait_time = 15
  else
    Capybara.register_driver :firefox_driver do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.folderList'] = 2 # custom location
      profile['browser.download.dir'] = "#{Dir.pwd}/features/tmp/"
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream, text/xml'
      profile['pdfjs.disabled'] = true
      profile['unhandledPromptBehavior'] = true

      options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
      Capybara::Selenium::Driver.new(app, browser: :firefox, options: options, port: Random.rand(7000..7999))
    end
    Capybara.default_driver = :firefox_driver
  end
end

browser_setup('chrome')

configuration = YAML.load_file 'configuration/default.yml'

$edisoft_api_client = EdisoftApiClient.new url: 'https://testing4qa.ediweb.ru/api',
                                           **configuration[:credentials]
logger_initialize
