require 'active_support/inflector'
require 'active_support/core_ext/string'
require './lib/garden_library'
require './lib/messages'

require 'byebug'

class GardenRepl
  def initialize
    @vegetable_lib = GardenLibrary
    @veg_options = @vegetable_lib.constants.map(&:to_s)
    @repl_messages = Messages
    @continue = 'y'
    collect_seed_data
  end

  def collect_seed_data
    until continue == 'n'
      begin
      request_plant_info
      create_garden_plant
      puts repl_messages::SUCCESSFUL_ADDITION
      continue = gets.chomp
      rescue => e
        puts e.message
        continue = gets.chomp
      end
    end
  end

  private

  attr_reader :veg_options, :repl_messages
  attr_accessor :continue, :varietal_name, :vegetable_name, :vegetable_plant_date

  def request_plant_info
    get_vegetable_name
    unless vegetable_name
      raise repl_messages::E4_NO_VEGETABLE_FOUND
    end

    get_varietal_name
    if !varietal_name
      puts repl_messages::NO_VARIETAL_ENTERED
    end

    get_planting_date
    unless vegetable_plant_date
      raise repl_messages::E5_INACCURATE_DATE_ENTERED
    end
    byebug
  end

  def get_planting_date
    puts "\n" + repl_messages::Q3_PLANTING_DATE
    a3 = gets.chomp.to_s
    @planting_date = parse_date_response(a3)
  end

  def get_vegetable_name
    puts "\n" + repl_messages::Q1_VEG_TYPE
    a1 = gets.chomp.downcase.pluralize
    @vegetable_name = select_vegetable(a1)
  end

  def get_varietal_name(known_varietal = false)
    @varietal_name = nil

    unless known_varietal
      puts repl_messages:: Q2_VARIETAL_NAME
      a2 = gets.chomp

      until a2 == 'y' || a2 == 'n'
        puts "\n" + repl_messages::E1
        puts repl_messages::Q2_VARIETAL_NAME
        a2 = gets.chomp
      end
    else
      a2 = 'y'
    end

    if a2 == 'y'
      puts "\n" + repl_messages::OK_CALLED
      a3 = gets.chomp
      @varietal_name = select_varietal(a3)
    end
  end

  def parse_date_response(date_response)
    unless /(\d{1,2}\/\d{1,2})/.match(date_response)
      puts repl_messages::FAILED_DATE_PARSE
      new_date = gets.chomp
      parse_date_response(new_date)
    end

    @vegetable_plant_date = date_response + '/' + DateTime.now.year.to_s
  end

  def select_vegetable(entered_name_plural)
    veg_name = veg_options.select{ |v| v.downcase.pluralize.match(entered_name_plural) }
    veg_name.first.downcase.capitalize!
  rescue
    nil
  end

  def select_varietal(entered_varietal_name)
    veg_key = veg_options.select{|v| v == vegetable_name.upcase }.first
    varietal_list = "GardenLibrary::#{veg_key}".constantize.keys
    varietal_list.delete(:average)

    entered_snakecase = entered_varietal_name.parameterize(separator: '_')

    if varietal_list.map(&:to_s).include?(entered_snakecase)
      entered_varietal_name.capitalize
    else
      puts repl_messages::VARIETAL_NOT_FOUND
      a4 = gets.chomp

      until a4 == 'y' || a4 == 'n'
        puts "\n" + repl_messages::E1
        puts repl_messages::VARIETAL_NOT_FOUND
        a4 = gets.chomp
      end

      if a4 == 'y'
        varietal_retry = repl_messages.varietal_list(varietal_list, veg_key.downcase)
        puts varietal_retry ? repl_messages::SUCCESSFUL_VARIETAL_MATCH : repl_messages::VARIETAL_NOT_FOUND
        varietal_retry
      else
        get_varietal_name(true)
      end
    end
  rescue
    nil
  end
end

GardenRepl.new