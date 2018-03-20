# frozen_string_literal: true

require 'spec_helper'
require_relative 'test_api'

RSpec.describe 'TestFluentApi_Chrome', integration: true do
  let(:test_suit_name) { 'Eyes Selenium SDK - Fluent API - ForceFPS' }
  let(:tested_page_url) { 'http://applitools.github.io/demo/TestPages/FramesTestPage/' }
  let(:force_fullpage_screenshot) { true }
  let(:caps) do
    Selenium::WebDriver::Remote::Capabilities.chrome(
      'chromeOptions' => {
        'args' => ['disable-infobars', 'headless']
      }
    )
  end
  include_context 'test fluent API'
end
