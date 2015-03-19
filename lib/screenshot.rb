require 'screenshot/version'

module Screenshot
  def self.capture(browser, file_name, page_elements, padding = 0)
    screenshot_directory = ENV['LANGUAGE_SCREENSHOT_PATH'] || 'screenshots'
    FileUtils.mkdir_p screenshot_directory
    screenshot_path = "#{screenshot_directory}/#{file_name}"

    browser.screenshot.save screenshot_path
    self.crop_image screenshot_path, page_elements, padding
  end

  def self.zoom_browser(browser, rate)
    rate.abs.times do
      direction = rate > 0 ? :add : :subtract
      browser.send_keys [:control, direction]
    end
  end

  def self.crop_image(path, page_elements, padding)
    rectangles = self.coordinates_from_page_elements(page_elements)
    crop_rectangle = rectangle(rectangles, padding)

    top_left_x = crop_rectangle[0]
    top_left_y = crop_rectangle[1]
    width = crop_rectangle[2]
    height = crop_rectangle[3]

    require 'chunky_png'
    image = ChunkyPNG::Image.from_file path

    # It happens with some elements that an image goes off the screen a bit,
    # and chunky_png fails when this happens
    width = image.width - top_left_x if image.width < top_left_x + width

    image.crop!(top_left_x, top_left_y, width, height)
    image.save path
  end

  def self.rectangle(rectangles, padding = 0)
    top_left_x, top_left_y = top_left_x_y rectangles
    bottom_right_x, bottom_right_y = bottom_right_x_y rectangles

    # Finding width and height
    width = bottom_right_x - top_left_x
    height = bottom_right_y - top_left_y

    # The new rectangle is constructed with all the co-ordinates calculated above
    [top_left_x - padding, top_left_y - padding, width + padding * 2, height + padding * 2]
  end

  def self.coordinates_from_page_elements(page_elements)
    page_elements.collect do |page_element|
      coordinates_from_page_element page_element
    end
  end

  def self.coordinates_from_page_element(page_element)
    [page_element.element.wd.location.x, page_element.element.wd.location.y, page_element.element.wd.size.width, page_element.element.wd.size.height]
  end

  def self.top_left_x_coordinates(input_rectangles)
    input_rectangles.collect do |rectangle|
      rectangle[0]
    end
  end

  def self.top_left_y_coordinates(input_rectangles)
    input_rectangles.collect do |rectangle|
      rectangle[1]
    end
  end

  def self.bottom_right_x_coordinates(input_rectangles)
    input_rectangles.collect do |rectangle|
      rectangle[0] + rectangle[2]
    end
  end

  def self.bottom_right_y_coordinates(input_rectangles)
    input_rectangles.collect do |rectangle|
      rectangle[1] + rectangle[3]
    end
  end

  def self.bottom_right_x_y(input_rectangles)
    [bottom_right_x_coordinates(input_rectangles).max, bottom_right_y_coordinates(input_rectangles).max]
  end

  def self.top_left_x_y(input_rectangles)
    [top_left_x_coordinates(input_rectangles).min, top_left_y_coordinates(input_rectangles).min]
  end

  def self.highlight(current_page, element, color = '#FF00FF')
    current_page.execute_script("arguments[0].style.border = 'thick solid #{color}'", element)
  end
end
