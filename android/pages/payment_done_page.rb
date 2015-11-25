module BasePage
  module PaymentDonePage
    class << self
      include BasePage

      BUTTON_OK = { id: PACKAGE + ':id/btn_ok' }
      VALUE_AMOUNT = {}

      def on_page?
        present?(BUTTON_OK, sec: 15)
      end

      def click_ok
        click(BUTTON_OK)
      end

      def amount
        amnt = ''
        (1..3).each do |index|
          xpath = "//*[@resource-id='#{PACKAGE}:id/amount']//android.widget.TextView[#{index}]"
          amnt << get_text(xpath: xpath) if present?(xpath: xpath)
        end
        amnt.tr(',', '.').to_f
      end
    end # self
  end # PaymentDonePage
end # BasePage

module Kernel
  def payment_done_page
    BasePage::PaymentDonePage
  end
end
