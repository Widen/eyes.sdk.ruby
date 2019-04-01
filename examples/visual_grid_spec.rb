require 'rspec'
require 'eyes_selenium'
require 'pry'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Applitools::EyesLogger.log_handler = Logger.new(STDOUT)

RSpec.shared_examples 'Test for url' do |url|
  let(:url) { url }
  # let(:runner) { Applitools::Selenium::VisualGridRunner }
  let(:web_driver) { Selenium::WebDriver.for :chrome }

  let(:config) do
    Applitools::Selenium::Configuration.new.tap do |config|
    config.app_name = 'Top 10 sites'
    config.test_name = "Top 10 sites - #{url}"
    config.add_browser(800, 600, Applitools::Selenium::BrowserTypes::CHROME)
          .add_browser(700, 500, Applitools::Selenium::BrowserTypes::CHROME)
          .add_browser(1600, 1200, Applitools::Selenium::BrowserTypes::CHROME)
          .add_browser(1280, 1024, Applitools::Selenium::BrowserTypes::CHROME)
    end
  end

  let(:driver) do
    eyes.config = config
    eyes.open(driver: web_driver)
  end

  let(:target1) { Applitools::Selenium::Target.window.send_dom(true) }
  let(:target2) { Applitools::Selenium::Target.window.fully(true).send_dom(true) }

  let(:eyes) { @eyes }

  after do
    eyes.close
    puts eyes.get_all_test_results.map(&:as_expected?)
    driver.quit
  end

  after(:all) do

  end

  it url do
    driver.get(url)
    eyes.check('Step1' + url, target1)
    eyes.check('Step2' + url, target2)
  end
end

RSpec.describe 'My first visual grid test' do
  before(:all) do
    @runner = Applitools::Selenium::VisualGridRunner.new(12)
    @eyes = Applitools::Selenium::Eyes.new(visual_grid_runner: @runner )
    # @eyes = Applitools::Selenium::Eyes.new
    #
    @eyes.proxy = Applitools::Connectivity::Proxy.new('http://localhost:8000')
  end

  after(:all) do
    puts @runner.get_all_test_results.map {|r| r.passed? }
    @runner.stop
  end

  %w(
    http://opzharp.ru
    http://localhost:3000
    https://applitools.com
    https://lcb.org/
    https://google.com
    https://facebook.com
    https://youtube.com
    https://amazon.com
    https://ebay.com
    https://twitter.com
    https://wikipedia.org
    https://instagram.com
    https://www.target.com/c/blankets-throws/-/N-d6wsb?lnk=ThrowsBlankets%E2%80%9C,tc
  )[2..2].each do |url|
    it_behaves_like 'Test for url', url
  end
end