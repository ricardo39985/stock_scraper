require_relative "scraper.rb"
require "open-uri"

class Stock
  @@all = []
  attr_accessor :symbol, :company, :price, :volume, :percent_change, :news, :bio
  def initialize(hash)
    hash.each do |key, v|
      self.send("#{key}=", v)
    end
    @@all << self
  end

  def self.import(mega_array)
    mega_array.each do |hash|
      Stock.new(hash)
    end
  end
  def self.list_stocks
    Stock.all.each_with_index {|s, i| puts"#{i+1}. #{s.company}"}
    nil
  end
  def self.rand_stock
    puts `clear`
    match = Stock.all[rand(Stock.all.size)]
    puts "Company   "+match.company, "Ticker   "+match.symbol, "Price   "+match.price, "Volume   "+match.volume, "Percent Change   "+match.percent_change, "News  "+match.news, "Bio "+match.bio
  end
  def self.all
    @@all
  end
  def self.find_stock_by_ticker(ticker="")
    puts `clear`
    puts "This options searches from list of already scraped stocks"
    puts "Please enter the ticker :"
    ticker = gets.chomp
    match = Stock.all.detect { |stock|stock.symbol == ticker.upcase  }
    if match
      print `clear`
      puts "Company   "+match.company, "Ticker   "+match.symbol, "Price   "+match.price, "Volume   "+match.volume, "Percent Change   "+match.percent_change, "News  "+match.news, "Bio "+match.bio
    else
      puts "Sorry, that stock was not found in the database"
    end
    input = nil
  end
  def self.sort
    sort_option = nil
    puts `clear`
    while sort_option != '4'
      puts "1. Sort by Name\n2. Sort by price\n3. Sort by symbol\n4 for main menu"
      sort_option =gets.chomp
      case sort_option
      when '1'
        Stock.all.sort_by {|obj| obj.company}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}" }
      when '2'
        Stock.all.sort_by {|obj| obj.price.to_f}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}"  }
      when '3'
        Stock.all.sort_by {|obj| obj.symbol}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}"  }
      else
        puts "Please enter a valid option."
      end
    end
  end
end
