module Distribution
  class Weibull
    attr_accessor :scale, :shape

    def initialize(scale: 1.0, shape: 1.0)
      @scale = Float(scale)
      @shape = Float(shape)
    end

    def pdf(x)
      if x < 0.0
        0.0
      elsif x == 0.0
        if shape == 1.0
          1.0 / scale
        elsif shape > 1.0
          0.0
        else
          raise 'Overflow'
        end
      else
        result = Math.exp(-((x / scale) ** shape))
        result * ((x / scale) ** (shape - 1)) * (shape / scale)
      end
    end

    def rng
      (scale * -Math.log(1 - rand)) ** (1.0 / shape)
    end
  end
end
