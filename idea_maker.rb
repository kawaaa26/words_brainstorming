# frozen_string_literal: true

require 'color_echo'
require 'dotenv/load'
require 'webdrivers'
require 'slack-notify'

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

    @client = SlackNotify::Client.new(
      webhook_url: ENV['WEBHOOK_URL'],
      # channel: '#notification',
      channel: ENV['SLACK_CHANNEL'],
      username: 'TopicBOT',
      icon_url: 'http://mydomain.com/myimage.png',
      icon_emoji: ':shipit:',
      link_names: 1
    )
  end

  def words_choice
    @driver.get 'https://tango-gacha.com/'

    @driver.find_elements(:class, 'box')[3, 4].map(&:click)

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

    tabs = @driver.window_handles[1, 2]

    i = 0
    details = []
    tabs.each do |tab|
      @driver.switch_to.window(tab)
      @driver.get('https://www.google.com/')
      search_box = @driver.find_element(:name, 'q')
      search_box.send_keys(search_words[i])
      search_box.submit

      CE.once.fg @orange
      details << "\nURL #{i = i.succ}: #{@driver.current_url}"
    end
    puts details

    details = details.each.with_index(1).map { |key, val| [val, key] }.to_h
  end

  def slack_notification(details)
    @client.notify("@channel\n*Topics Generated*\n#{details[1]}\n#{details[2]}")
  end
end

idea_making = IdeaMaking.new(mode_selection)
words = idea_making.words_choice
google = idea_making.google(words)
idea_making.slack_notification(google)
