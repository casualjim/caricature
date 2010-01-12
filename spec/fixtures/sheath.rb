class Sheath
  attr_reader :dagger

  def initialize(dagger)
    @dagger = dagger
  end

  def insert(dagger)
    raise "There is already a dagger in here" if @dagger
    @dagger = dagger
  end

  def draw
    raise "Dagger is nowhere to be found" unless @dagger
    d = @dagger
    @dagger = nil
    d
  end
end