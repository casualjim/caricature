class SwiftCleanupCrew
  
  def initialize(car)
    @car = car
    @car_exploded_handler = method(:handle_car_on_exploded)
    @car.on_exploded.add @car_exploded_handler
  end
  
  def handle_car_on_exploded(sender, args)
    # logic here to cleanup the street, repair buildings etc.
  end
  
  def dispose
    unless @disposed
      @car.on_exploded.remove @car_exploded_handler
      @disposed = true
    end
  end
  alias :__dispose__ :dispose
  
end
