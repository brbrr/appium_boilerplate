# Plase where all constant values should be stored
module ConstHelper
  DEFAULT_PASSWORD = 'napoleon'
  DEFAULT_PIN_CODE = '1111'

  UserStruct = Struct.new(:gsm_number, :password, :pin_code, :username, :email)
  AgentStruct = Struct.new(:gsm_number, :password, :pin_code, :username, :code, :email)

  TOAST_FILL_FORM = 'Please fill form fields: '

  AGNT = AgentStruct.new(
    '79268888888', DEFAULT_PASSWORD, DEFAULT_PIN_CODE, 'AndroidAgent', '8888', 'androidagent@test.com')

  USR1 = UserStruct.new(
    '79261111111', DEFAULT_PASSWORD, DEFAULT_PIN_CODE, nil, nil)

  CURRENCY = 'EUR'

  ALL_CHARS = ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'
end
