require_relative 'scraper.rb'

class RunScrape
  def initialize
    welcome
    pages
    proceed_scrape
    stocks(@pages_to_scrape)

    main
    exit_m

  end
  def welcome
    puts `clear`
    puts Url.logo.colorize(:blue)
    sleep 5
    puts"Welcome to my Scraper!\nIt scrapes stock data and provides access to the latest news"
    intro_timer
  end
  def main
    input = nil

    while input != 'exit'
      puts Url.main_menu
      puts "**************************************\n".colorize(:blue)+"Below is a list of available commands \n"+"***************************************\n".colorize(:blue)

      puts "1- List of Companies\n2. Search\n3. Sort\n4. View Random Stock"
      input = gets.chomp
      case input
      when '1'
        puts `clear`
        list_stocks
        input= nil
      when '2'
        Stock.find_stock_by_ticker
      when '3'
        sort
      when '4'
        Stock.rand_stock
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
    print `clear`
    @stock.each_with_index { |hash, index| puts "#{index+1}. #{hash.company}" }
    puts "\n\n"
  end

  def sort
    puts `clear`
    puts Url.main_menu
    sort_select = gets.chomp
    case sort_select
    when '1'
      Stock.all.sort_by {|obj| obj.company}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}" }
    when '2'
      Stock.all.sort_by {|obj| obj.price}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}"  }
    when '3'
      Stock.all.sort_by {|obj| obj.symbol}.each { |e| puts "Company: #{e.company} - Price: $#{e.price}"  }
    else
     input = nil
    end
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
  def pages
    print `clear`
    puts "There are currently #{Scraper.max_page} pages to scrape.\nHow many pages would you like scrape?"
    @pages_to_scrape = gets.chomp
    @seconds_to_scrape = @pages_to_scrape.to_i*17
    while @pages_to_scrape.match(/\D/) || @pages_to_scrape.to_i > Scraper.max_page || @pages_to_scrape.to_i< 0
      puts "Please enter a number between 1 and #{Scraper.max_page}"
      @pages_to_scrape = gets.chomp
    end
    @pages_to_scrape= @pages_to_scrape.to_i
    @pages_to_scrape-=1
    @pages_to_scrape
  end
  def proceed_scrape
    response = 0
    while response
      case response
      when '1'
        break
      when '2'
        pages
      else

        if @seconds_to_scrape >= 3600
          puts "This will take #{@seconds_to_scrape/3600}H : #{@seconds_to_scrape%3600/60 }M : #{@seconds_to_scrape%3600%60}s to scrape. Would like to continue?\n1. Yes\n2. No\n3. Main Menu"
        elsif @seconds_to_scrape < 60
          puts "This will take #{00}H : #{00}M : #{@seconds_to_scrape}s to scrape. Would like to continue?\n1. Yes\n2. No\n3. Main Menu"
        else
          puts "This will take #{00}H : #{@seconds_to_scrape/60}M : #{@seconds_to_scrape%60}s to scrape. Would like to continue?\n1. Yes\n2. No\n3. Main Menu"
        end
      end
      response = gets.chomp
    end
  end

end
