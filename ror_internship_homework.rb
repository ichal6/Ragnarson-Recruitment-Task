module Ragnarson
  class Intern
    # TODO: 
    # Define a constant named QUOTES that consists of the following strings: 
    # - "Ready to work."
    # - "Work, work."
    # - "Work complete!"
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
      # TODO: 
      # Implement a method that randomly selects a single quote from the QUOTES array and prints it in a new line
      puts QUOTES[rand(0..2)]
    end

    def to_s
      # TODO: 
      # Implement a method that returns a string formatted in the following way:
      # {NAME} 
      #   - LUCK: {LUCK_VALUE} 
      #   - SKILL: {SKILL_VALUE} 
      #   - POWER_OF_WILL: {POWER_OF_WILL_VALUE} 
      #   - PLEASURE: {PLEASURE_VALUE}
      #   - PAIN: {PAIN_VALUE}
      "%s\n\t- LUCK: %d\n\t- SKILL: %d\n\t- POWER_OF_WILL: %d\n\t- PLEASURE: %d\n\t- PAIN: %d\n" % [@name, @luck, @skill, @power_of_will, @pleasure, @pain]
    end
  end

  class Internship
    attr_reader :interns, :progress

    def initialize(interns)
      @interns = interns
    end

    def start
      # TODO: 
      # Implement a method that:
      # - iterates over interns and calls `to_s` and `work!` methods for each of them
      # - sets the progress of this internship object to 100
      @interns.each do |intern|
        intern.work!
        intern.to_s
      end
      @progress = 100
    end

    def completed?
      # TODO: 
      # Implement a method that returns true if progress of the internship reached 100, otherwise returns false
      @progress == 100 ? true : false
    end

    def stats
      # TODO: 
      # Implement a method that prints the following stats:
      # - winner's name, 
      # - 2nd place name, 
      # - 3rd place name
      # - average, median, highest value and lowest value of each of the following attributes: skill, pleasure
      # Each stat should be displayed in the separate line in the format: {STAT NAME} => {STAT VALUE}
      puts "#{pick_a_winner} => Winner"
      puts "#{pick_2nd_place} => 2nd place"
      puts "#{pick_3rd_place} => 3rd place"
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
      # TODO: 
      # Implement a method that finds the best participant based on the following critiera:
      # - luck has a weight of 2
      # - skill has a weight of 5
      # - power_of_will has a weight of 2
      # - pleasure has a weight of 3
      # - pain has a weight of -2
      # - the value used for comparison is the weighted sum of the intern's stats.
      participant_result = get_participants_with_points
      participant_result.max_by{|k, v| v}[0]
    end

    def pick_2nd_place
      # TODO: 
      # Implement a method that finds the second best participant based on the following critiera: 
      # - luck has a weight of 2
      # - skill has a weight of 5
      # - power_of_will has a weight of 2
      # - pleasure has a weight of 3
      # - pain has a weight of -2
      # - the value used for comparison is the weighted sum of the intern's stats.
      participant_result = get_participants_with_points
      result_array = participant_result.sort_by { |k, v| v }.reverse!.to_a
      result_array[1][0]
    end

    def pick_3rd_place
      # TODO: 
      # Implement a method that finds the third best participant based on the following critiera:
      # - luck has a weight of 2
      # - skill has a weight of 5
      # - power_of_will has a weight of 2
      # - pleasure has a weight of 3
      # - pain has a weight of -2
      # - the value used for comparison is the weighted sum of the intern's stats.
      participant_result = get_participants_with_points
      result_array = participant_result.sort_by { |k, v| v }.reverse!.to_a
      result_array[2][0]
    end

    def average(attribute_name)
      # TODO: 
      # Implement a method that returns the average of the given attribute among all of the participants
      average = 0
        @interns.each do |intern|
          average += intern.instance_variable_get :"@#{attribute_name}"
        end
      average/@interns.size
    end

    def highest(attribute_name)
      # TODO: 
      # Implement a method that returns the highest value of the given attribute among all of the participants
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
      # TODO: 
      # Implement a method that returns the lowest value of the given attribute among all of the participants
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
      # TODO: 
      # Implement a method that returns the median value of the given attribute among all of the participants
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

# TODO:
# 1. In the main context here, initialize "interns" array with 5 objects with the following features:
#   - Astrid has 10 luck, 20 skill, 15 concentrated power of will, 5 pleasure, 50 pain
#   - Bjørn has 5 luck, 15 skill, 10 concentrated power of will, 10 pleasure, 50 pain
#   - Erik has 50 luck, 20 skill, 15 concentrated power of will, 5 pleasure, 10 pain
#   - Harald has 20 luck, 50 skill, 10 concentrated power of will, 15 pleasure, 5 pain
#   - Helga has 30 luck, 50 skill, 5 concentrated power of will, 10 pleasure, 5 pain
# 2. Initialize new "internship" object using these interns and "start" the internship
#   - Display "stats" of the internship if the "internship" object has been completed
# 3. Run this script/file and make sure that all messages and stats are being displayed in the right format on the screen
# 4. Make sure that implemented methods are returning the correct values
# 5. Make sure you haven't missed any TODO tasks described inside the comments