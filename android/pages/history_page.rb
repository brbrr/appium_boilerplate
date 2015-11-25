
module BasePage
  module HistoryPage
    class << self
      include BasePage

      CONTAINER = { id: 'container' }
      def on_page?
        present?(CONTAINER, size: 4)
      end

      def close
        toggler = find TOGGLER
        x = toggler.location.x + toggler.size.width / 2
        y = toggler.location.y + toggler.size.height / 2
        swipe start_x: x, start_y: y, end_x: x, end_y: y - 300, touchCount: 1, duration: 1
      end

      def record_present?(amount)
        record = { xpath: "//android.widget.TextView[@text='#{amount}']" }
        present? record
      end
    end # self
  end # HistoryPage
end # BasePage

module Kernel
  def history_page
    BasePage::HistoryPage
  end
end
