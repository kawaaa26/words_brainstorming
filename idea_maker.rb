# frozen_string_literal: true

require 'color_echo'
require 'webdrivers'

CE.once.fg :index203
puts "\n\nType 1: Disable Headless\nHit Enter: Enable Headless"

mode_selection = gets.to_i

# IdeaMaking drawing 2 random words to throw source of brainstorming.
class IdeaMaking
  def initialize(option)

    @options = Selenium::WebDriver::Chrome::Options.new

    if option == 1
      CE.once.fg :red
      puts 'Headless Disabled.'
      @driver = Selenium::WebDriver.for :chrome
    else
      CE.once.fg :green
      puts 'Headless Mode Enabled.'
      @options.add_argument('--headless')
      @driver = Selenium::WebDriver.for :chrome, options: @options
    end

    @wait = Selenium::WebDriver::Wait.new(timeout: 100)
    @orange = :index203
    @white = :white
  end

  def words_choice
    @driver.get 'https://tango-gacha.com/'
    check_boxes = @driver.find_elements(:class, 'box')

    check_boxes[3].click
    check_boxes[4].click

    word_volume = @driver.find_element(:id, 'word_volume')
    select = Selenium::WebDriver::Support::Select.new(word_volume)

    select.select_by(:value, '2')

    draw = @driver.find_element(:class, 'mouitido')
    draw.click

    sleep 2
    first_word = @driver.find_element(:id, 'show_txt1').text
    second_word = @driver.find_element(:id, 'show_txt2').text
    # @wait.until {second_word.displayed?}

    CE.once.fg @white
    CE.once.bg @orange
    puts "\n #{first_word} * #{second_word} = ?? "
  end
end

idea_making = IdeaMaking.new(mode_selection)
idea_making.words_choice
