class Player
  attr_reader :name,
              :byes,
              :strikes_remaining

  def initialize(name)
    @name = name
    @strikes_remaining = 3
    @byes = 0
  end

  def add_bye
    @byes += 1
  end

  def add_strike
    @strikes_remaining -= 1
  end

  def alive?
    @strikes_remaining > 0
  end
end
