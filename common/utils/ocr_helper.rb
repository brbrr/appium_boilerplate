require 'rtesseract'
require 'RMagick'
require 'tesseract'

# Image processing module
# - Find possition of required text
# - Saying is text present on screen
module OCRHelper
  def toast?(error_msg, screens:5, delay:nil, pre_pause:nil)
    # Thread.new{take_multiple_screens(6, 0.3, 0.5)}
    take_multiple_screens(screens, delay, pre_pause)
    recognize_multiple_screens(screens, error_msg)
  end

  # take screenshot and return coordinates of passed text
  def text_position(text)
    text = text.to_s
    pic_location = "#{Dir.pwd}/gen/screenshots/txt_#{text.tr(' ', '_')}.png"
    $driver.screenshot(pic_location)
    img = process_image(pic_location)
    img2 = img.write("#{Dir.pwd}/gen/screenshots/changed.png")

    e = ocr_proc(img2)
    words = ''
    box = e.each_word do |w|
      words << (' ' + w.to_s)
      break w.bounding_box if w.to_s.include?(text)
    end
    debug words
    x = (box.x + box.width / 2) / 3
    y = (box.y + box.height / 2) / 3
    { x: x, y: y }
  end

  # take multiple screenshots in order to catch the error on the screen
  def take_multiple_screens(circles, delay, pre_pause)
    sleep(pre_pause) unless pre_pause.nil?
    circles.times do|index|
      debug "Taking screenshot # #{index + 1}"
      $driver.screenshot("#{Dir.pwd}/gen/screenshots/rec_#{index}.png")
      sleep(delay) unless delay.nil?
    end
  end

  def recognize_multiple_screens(circles, text)
    circles.times do |index|
      debug "Checking: #{Dir.pwd}/gen/screenshots/rec_#{index}.png"
      rec_text = recognize_text_on_pic("#{Dir.pwd}/gen/screenshots/rec_#{index}.png")
      return true if rec_text.include?(text)
    end
    false
  end

  # by default RTesseract gem is used here
  def recognize_text_on_pic(pic_location = nil)
    img = process_image(pic_location)
    tess = RTesseract.new(img, lang: 'eng')
    debug ocr_proc(img).text if $DEBUG
    rec_text = tess.to_s # recognize
    debug rec_text.gsub(/\n/, '\n')
    rec_text
  end

  def process_image(pic_location)
    img = Magick::Image.read(pic_location).first
    # img = img.quantize(256,Magick::GRAYColorspace)
    img.contrast.normalize.negate.posterize(3).adaptive_resize(3)
  end

  # tesseract-ocr gem is used here (could get better results)
  def ocr_proc(img)
    Tesseract::Engine.new do|e|
      e.language  = :eng
      # e.blacklist = '|'
      e.image = img
    end
  end
end
