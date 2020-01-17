require_relative "scraper.rb"

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
    mega_array.each do |l|
      Stock.new(l)
      # binding.pry
    end
  end
  def self.find_stock_by_name


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
end
# Stock.import(Scraper.import)
# binding.pry
