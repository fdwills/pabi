unless ENV['CI']
  require 'simplecov'
  
  SimpleCov.start do
    add_filter 'spec'
    add_filter '.bundle'
  end
end

require 'pabi'
require 'rspec'

def receipt_from filename
  file = File.open(File.dirname(__FILE__) + '/' + filename, "r")
  raw_receipt = file.read
  file.close
  raw_receipt
end
