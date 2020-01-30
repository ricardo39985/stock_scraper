# require "stock_scraper/version"
require "nokogiri"
require "open-uri"
require_relative './assets.rb'
require_relative "./stock.rb"
require_relative "./interface.rb"
require_relative "./scraper.rb"
require'colorize'

module StockScraper
  class Error < StandardError; end
  # Your code goes here...
end
