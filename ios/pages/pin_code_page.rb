module IOS
  module BasePage
    PACKAGE = 'your.app.package'

    def base_test
      puts self, 'base_page'
    end
  end
end

module IOS
  module PinCodePage
    class << self
      include BasePage

        def reuse
          puts base_test
        end
        
        def test
          puts PACKAGE
        end
    end
  end
end

module IOS
  def pin_code_page
    PinCodePage
  end
end

include IOS
pin_code_page.test
pin_code_page.base_test
