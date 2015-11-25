require_relative '../spec/requires'

describe 'Transaction history' do
  pin_code = USER_TEST[:pin]

  before(:all) do
    if pin_code_page.on_page?
      expect(pin_code_page).to be_on_page
      pin_code_page.login pin_code
    end
  end

  before(:each) do
    expect(home_page).to be_on_page
  end

  context 'open/close' do
    it 'open/close w swipe' do
      home_page.swipe_transaction_history
      expect(history_page).to be_on_page
      history_page.close
      expect(home_page).to be_on_page
    end

    it 'opens w side menu'
  end

  context 'details'

  context 'types' do
    it 'shows include MAKE PAYMENT' do
      usr = UserMonniz.new phone: 380_634_894_835, pin: 1111, kyc: true
      agnt = AgentMonniz.new 8888, 'napoleon'
      otp = agnt.otp_creator 50, 'make_payment'
      usr.sign_operation(otp)
      home_page.swipe_transaction_history
      expect(history_page).to be_on_page

      expect(history_page.record_present?('- 50')).to be_truthy
    end
  end
end
