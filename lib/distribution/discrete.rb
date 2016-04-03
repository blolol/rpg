module Distribution
  # Uses Vose's alias algorithm to choose a random element from a collection, given a set of
  # corresponding probabilities.
  #
  # @see http://www.keithschwarz.com/darts-dice-coins/
  # @see http://www.keithschwarz.com/interesting/code/?dir=alias-method
  class Discrete
    def initialize(values_and_probabilities)
      if values_and_probabilities.empty?
        raise ArgumentError, 'Probabilities must not be empty'
      end

      @values = values_and_probabilities.keys
      @probabilities = values_and_probabilities.values

      unless @probabilities.inject(0) { |p, sum| sum += p } == 1
        raise ArgumentError, 'Probabilities must have a sum of 1'
      end

      # Allocate space for the probability and alias tables.
      @probability = Array.new(@probabilities.size)
      @alias = Array.new(@probabilities.size)

      # Create two stacks to act as worklists as we populate the tables.
      small = []
      large = []

      # Compute the average probability and cache it for later use.
      average = 1.0 / @probabilities.size

      # Populate the stacks with the input probabilities.
      @probabilities.each_with_index do |probability, i|
        if probability >= average
          large << i
        else
          small << i
        end
      end

      until small.empty? || large.empty?
        # Get the index of the small and large probabilities.
        less = small.pop
        more = large.pop

        # Scale these probabilities up to be such that 1/n is given weight 1.0.
        @probability[less] = @probabilities[less] * @probabilities.size
        @alias[less] = more

        # Decrease the probability of the larger one by the appropriate amount.
        @probabilities[more] = (@probabilities[more] + @probabilities[less]) - average

        # If the new probability is less than the average, add it to the small list; otherwise
        # add it to the large list.
        if @probabilities[more] >= average
          large << more
        else
          small << more
        end
      end

      # At this point, everything is in one list, which means that the remaining probabilities
      # should all be 1/n. Based on this, set them appropriately. Due to numerical issues, we can't
      # be sure which stack will hold the entries, so we empty both.
      @probability[small.pop] = 1.0 until small.empty?
      @probability[large.pop] = 1.0 until large.empty?
    end

    def sample
      # Generate a fair die roll to determine which column to inspect.
      column = rand(@probability.size)

      # Generate a biased coin toss to determine which option to pick.
      coin_toss = rand < @probability[column]

      # Based on the outcome, return either the column or its alias
      index = coin_toss ? column : @alias[column]
      @values[index]
    end
  end
end
