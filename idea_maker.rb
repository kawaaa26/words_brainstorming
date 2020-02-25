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
    # words appear so slowly and thus @wait doesn't work properly.

    CE.once.fg @white
    CE.once.bg @orange
    puts "\n #{first_word} * #{second_word} = ?? "

    [first_word, second_word]
  end

  def google(search_words)
    # creating two tabs here.
    2.times { @driver.execute_script('window.open()') }

    tabs = @driver.window_handles
    new_tabs = tabs[1, 2]

    i = 0
    new_tabs.each do |tab|
      @driver.switch_to.window(tab)
      @driver.get('https://www.google.com/')
      search_box = @driver.find_element(:name, 'q')
      search_box.send_keys(search_words[i])
      search_box.submit
      i = i.succ

      CE.once.fg @orange
      puts "\nURL #{i}: #{@driver.current_url}"
    end
  end
end

idea_making = IdeaMaking.new(mode_selection)
words = idea_making.words_choice
idea_making.google(words)
