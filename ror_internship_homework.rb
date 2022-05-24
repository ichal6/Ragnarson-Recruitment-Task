module Ragnarson
  class Intern
    QUOTES = "Ready to work.", "Work, work.", "Work complete!"

    def initialize(name, luck, skill, power_of_will, pleasure, pain)
      @name = name
      @luck = luck
      @skill = skill
      @power_of_will = power_of_will
      @pleasure = pleasure
      @pain = pain
    end

    def work!
      puts QUOTES[rand(0..2)]
    end

    def to_s
      sprintf("%s\n\t- LUCK: %d\n\t- SKILL: %d\n\t- POWER_OF_WILL: %d\n\t- PLEASURE: %d\n\t- PAIN: %d\n",
              @name, @luck, @skill, @power_of_will, @pleasure, @pain)
    end
  end

  class Internship
    attr_reader :interns, :progress

    def initialize(interns)
      @interns = interns
    end

    def start
      @interns.each do |intern|
        intern.work!
        puts intern
      end
      @progress = 100
    end

    def completed?
      @progress == 100 ? true : false
    end

    def stats
      puts "winner's name => #{pick_a_winner}"
      puts "2nd place name => #{pick_2nd_place}"
      puts "3rd place name => #{pick_3rd_place}"
      puts "average skill => #{average("skill")}"
      puts "average pleasure => #{average("pleasure")}"
      puts "median skill => #{median("skill")}"
      puts "median pleasure => #{median("pleasure")}"
      puts "highest skill => #{highest("skill")}"
      puts "highest pleasure => #{highest("pleasure")}"
      puts "lowest skill => #{highest("skill")}"
      puts "lowest pleasure => #{highest("pleasure")}"

    end

    def pick_a_winner
      participant_result = get_participants_with_points
      participant_result.max_by{|k, v| v}[0]
    end

    def pick_2nd_place
      participant_result = get_participants_with_points
      result_array = participant_result.sort_by { |k, v| v }.reverse!.to_a
      result_array[1][0]
    end

    def pick_3rd_place
      participant_result = get_participants_with_points
      result_array = participant_result.sort_by { |k, v| v }.reverse!.to_a
      result_array[2][0]
    end

    def average(attribute_name)
      average = 0
        @interns.each do |intern|
          average += intern.instance_variable_get :"@#{attribute_name}"
        end
      average/@interns.size
    end

    def highest(attribute_name)
      highest_value = 0
      @interns.each do |intern|
        actual_value = intern.instance_variable_get :"@#{attribute_name}"
        if highest_value < actual_value
          highest_value = actual_value
        end
      end
      highest_value
    end

    def lowest(attribute_name)
      lowest_value = @interns[0].instance_variable_get :"@#{attribute_name}"
      @interns.each do |intern|
        actual_value = intern.instance_variable_get :"@#{attribute_name}"
        if lowest_value > actual_value
          lowest_value = actual_value
        end
      end
      lowest_value
    end

    def median(attribute_name)
      values = Array.new
      @interns.each do |intern|
        values.append intern.instance_variable_get :"@#{attribute_name}"
      end
      values = values.sort
      if values.size % 2 != 0
        return values[values.size/2]
      else
        return (values[values.size / 2] + values[values.size / 2 - 1]) / 2.0
      end
    end

    private
    def calculate_stat(intern, attribute_name)
      actual_value = intern.instance_variable_get :"@#{attribute_name}"
      case attribute_name
      when "luck"
        actual_value*2
      when "skill"
        actual_value*5
      when "power_of_will"
        actual_value*2
      when "pleasure"
        actual_value*3
      when "pain"
        actual_value*-2
      else
        raise ArgumentError.new("Not found attribute: #{attribute_name}")
      end
    end

    def get_participants_with_points
      participant_result = Hash.new
      @interns.each do |intern|
        calculate_value = calculate_stat(intern,"luck")
        calculate_value += calculate_stat(intern, "skill")
        calculate_value += calculate_stat(intern, "power_of_will")
        calculate_value += calculate_stat(intern, "pleasure")
        calculate_value += calculate_stat(intern, "pain")
        name = intern.instance_variable_get :@name
        participant_result.store(name, calculate_value)
      end
      participant_result
    end
  end
end

include Ragnarson

interns_array = []

interns_array.append Intern.new("Astrid", 10, 20, 15, 5, 50)
interns_array.append Intern.new("Bjørn", 5, 15, 10, 10, 50)
interns_array.append Intern.new("Erik", 50, 20, 15, 5, 10)
interns_array.append Intern.new("Harald", 20, 50, 10, 15, 5)
interns_array.append Intern.new("Helga", 30, 50, 5, 10, 5)

internship = Internship.new interns_array
internship.start

if internship.completed?
  internship.stats
end
