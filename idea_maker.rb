# frozen_string_literal: true

require 'color_echo'
require 'webdrivers'

puts 'Type 1: Disable Headless\n\nHit Enter: Enable Headless'

mode_selection = gets.to_i

class IdeaMaking
  def initialize(option)

    @options = Selenium::Webdriver::Chrome::Options.new

    if option == 1
      puts 'Headless Disabled.'
      @driver = Selenium::Webdriver.for :chrome
    else
      puts 'Headless Mode Enabled.'
      @options.add_argument('--headless')
      @driver = Selenium::Webdriver.for :chrome, options: @options
    end

    @wait = Selenium::Webdriver::Wait.new(:timeout => 100)
    @orange = :index203
    @white = :white
  end
end

idea_making = IdeaMaking.new(mode_selection)
