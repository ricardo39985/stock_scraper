require_relative 'scraper.rb'

class RunScrape
  def initialize
    welcome
    input = ''
    pages
    stocks(@pages_to_scrape)
    while input != 'exit'
      puts Url.main_menu.colorize(:blue)
      puts "**************************************\n".colorize(:blue)+"Below is a list of available commands \n"+"***************************************\n".colorize(:blue)
      puts "1- List of Companies\n2. Search\n3. Sort\n4. View Random Stock"
      input = gets.chomp
      case input
      when '1'
        Stock.list_stocks
      when '2'
        Stock.find_stock_by_ticker
      when '3'
        Stock.sort
      when '4'
        Stock.rand_stock
      end
    end
    exit_m
  end
  def welcome
    puts Url.logo.colorize(:blue)
    sleep 3
    puts"Welcome to my Scraper!\nIt scrapes stock data and provides access to the latest news"
    intro_timer
  end

  def stocks(pages_to_scrape)
    Stock.import(Scraper.import(pages_to_scrape))
    @stock = Stock.all
  end


  def intro_timer(timer = 12)
    s = "o"
    timer.downto(0) do |i|
      colors = String.colors
      print s
      s+="o".colorize(colors[rand(16)])
      sleep 0.2
    end
  end
  def exit_m
    puts Url.logo.colorize(:blue)
    puts "Thanks for checking out my work.\nI welcome your feedback!"
    intro_timer(12)
    puts "\n"
  end
  def pages
    response = 0
    while response != '1'
      print`clear`
      puts "There are currently #{Scraper.max_page} pages to scrape.\nHow many pages would you like scrape?"
      @pages_to_scrape = gets.chomp
      @seconds_to_scrape = @pages_to_scrape.to_i*17
      while @pages_to_scrape.match(/\D/) || @pages_to_scrape.to_i > Scraper.max_page || @pages_to_scrape.to_i< 0
        puts "Please enter a number between 1 and #{Scraper.max_page}"
        @pages_to_scrape = gets.chomp
      end
      if @seconds_to_scrape >= 3600
        puts "This will take #{@seconds_to_scrape/3600}H : #{@seconds_to_scrape%3600/60 }M : #{@seconds_to_scrape%3600%60}s to scrape. Would like to continue?\n1. Yes\n2. No"
      elsif @seconds_to_scrape < 60
        puts "This will take #{00}H : #{00}M : #{@seconds_to_scrape}s to scrape. Would like to continue?\n1. Yes\n2. No"
      else
        puts "This will take #{00}H : #{@seconds_to_scrape/60}M : #{@seconds_to_scrape%60}s to scrape. Would like to continue?\n1. Yes\n2. No"
      end
      response = gets.chomp
    end
    @pages_to_scrape= @pages_to_scrape.to_i
    @pages_to_scrape-=1
    @pages_to_scrape
  end
end
