module Applitools
  module Calabash
    class CalabashScreenshotProvider
      WAIT_BEFORE_SCREENSHOT = 1
      attr_reader :density, :context, :debug_screenshot_provider

      def initialize(_options = {})
        @density = 1
      end

      def with_density(value)
        @density = value
        self
      end

      def using_context(value)
        @context = value
        self
      end

      def with_debug_screenshot_provider(value)
        Applitools::ArgumentGuard.is_a?(
          value,
          'debug_screenshot_provider',
          Applitools::DebugScreenshotProvider
        )
        @debug_screenshot_provider = value
        self
      end

      private

      def save_debug_screenshot(screenshot, suffix)
        debug_screenshot_provider.save(screenshot, suffix || '') if debug_screenshot_provider
      end
    end

    class AndroidScreenshotProvider < CalabashScreenshotProvider
      include Singleton

      def capture_screenshot(options = {})
        sleep WAIT_BEFORE_SCREENSHOT
        result = nil
        Applitools::Calabash::Utils.using_screenshot(context) do |screenshot_path|
          screenshot = ::ChunkyPNG::Image.from_file(screenshot_path)
          save_debug_screenshot(screenshot, options[:debug_suffix])
          result = Applitools::Calabash::EyesCalabashAndroidScreenshot.new(
            Applitools::Screenshot.from_image(
              screenshot
            ),
            density: density
          )
        end
        result
      end
    end

    class IosScreenshotProvider < CalabashScreenshotProvider
      include Singleton
      def capture_screenshot(options = {})
        sleep WAIT_BEFORE_SCREENSHOT
        result = nil
        Applitools::Calabash::Utils.using_screenshot(context) do |screenshot_path|
          screenshot = ::ChunkyPNG::Image.from_file(screenshot_path)
          save_debug_screenshot(screenshot, options[:debug_suffix])
          result = Applitools::Calabash::EyesCalabashIosScreenshot.new(
            Applitools::Screenshot.from_image(
              screenshot
            ),
            scale_factor: density
          )
        end
        result
      end
    end
  end
end
