require_relative "scraper.rb"

class Stock
  @@all = []
  attr_accessor :symbol, :company, :price, :volume, :percent_change, :news
  def initialize(hash)
    hash.each do |key, v|
      self.send("#{key}=", v)
    end
    @@all << self
  end

  def self.import(mega_array)
    mega_array.each do |l|
      Stock.new(l)
    end
  end
  def self.all
    @@all

  end
end
# binding.pry
