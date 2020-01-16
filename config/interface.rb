require_relative 'scraper.rb'

class RunScrape
  def initialize

    welcome
    main
    exit_m

  end
  def welcome
    puts `clear`
    puts Url.logo.colorize(:blue)
    puts"Welcome to my Scraper!\nIt scrapes stock data and provides access to the latest news"
    intro_timer
    puts `clear`
  end
  def main
    input = nil
    stocks(data_size)
    while input != 'exit'
      puts "**************************************\n".colorize(:blue)+"Below is a list of available commands \n"+"***************************************\n".colorize(:blue)

      puts "1- List of Companies\n2. Search\n3. Sort\n4. View Random Stock"
      input = gets.chomp
      case input
      when '1'
        puts `clear`
        list_stocks
        input= nil
      when '2'
        find_stock_by_ticker
      when '3'
        sort
      when '4'
        rand_stock
      when 'restart'
        main
      end
    end
  end

  def stocks(pages_to_scrape)
    Stock.import(Scraper.import(pages_to_scrape))
    @stock = Stock.all
  end
  def list_stocks
    @stock.each_with_index { |hash, index| puts "#{index+1}. #{hash.company}" }
    puts "\n\n"
  end
  def find_stock_by_ticker(ticker="")
    puts `clear`
    puts "Please enter the ticker :"
    ticker = gets.chomp
    match = Stock.all.detect { |stock|stock.symbol == ticker.upcase  }
    if match
    puts  match.company, match.symbol, match.price, match.volume, match.percent_change, match.news
    else
      puts "Sorry, that stock was not found in the database"
    end
    input = nil
  end
  def sort
    puts `clear`
    puts "1. Sort by name\n2. Sort by price\n3. Sort by symbol\n 4 or anything else to return to previous screen"
    sort_select = gets.chomp
    case sort_select
    when '1'
      puts Stock.all.sort_by {|obj| obj.company}
    when '2'
      pp Stock.all.sort_by(&:price)
    else
     input = nil
    end
  end
  def rand_stock
    puts `clear`
    match = Stock.all[rand(Stock.all.size)]
    puts "Company   "+match.company, "Ticker   "+match.symbol, "Price   "+match.price, "Volume   "+match.volume, "Percent Change   "+match.percent_change, "News  "+match.news
  end
  def intro_timer(timer = 12)
    s = "|"
    timer.downto(0) do |i|
      colors = String.colors
      print s
      s+="|".colorize(colors[rand(16)])
      sleep 0.2
    end
  end
  def exit_m
    puts Url.logo.colorize(:red).on_blue
    puts "Thanks for checking out my work.\nI welcome your feedback!"
    intro_timer(30)
  end
  def data_size
    puts "There are currently #{Scraper.max_page} pages to scrape.\nHow many pages would you like scrape?"
    pages_to_scrape = gets.chomp
    seconds_to_scrape = pages_to_scrape.to_i*2
    while pages_to_scrape.match(/\D/) || pages_to_scrape.to_i > Scraper.max_page || pages_to_scrape.to_i< 0
      puts "Please enter a number between 0 and #{Scraper.max_page}"
      pages_to_scrape = gets.chomp
      # binding.pry
    end

    if seconds_to_scrape >= 3600
      puts "This will take #{seconds_to_scrape/3600}H : #{seconds_to_scrape%3600/60 }M : #{seconds_to_scrape%3600%60}s to scrape. Would like to continue?"
    elsif seconds_to_scrape < 60
      puts "This will take #{00}H : #{00}M : #{seconds_to_scrape}s to scrape. Would like to continue?"
    else
      puts "This will take #{00}H : #{seconds_to_scrape/60}M : #{seconds_to_scrape%60}s to scrape. Would like to continue?\n1. Yes\n2. No"
    end
    response = gets.chomp
    while response != '1' && response !='2'
      puts "Please choose \n1. Yes\n2. No"
      response =gets.chomp
    end
    pages_to_scrape= pages_to_scrape.to_i
    pages_to_scrape-=1
  end

end
