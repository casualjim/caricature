using System;
using System.Collections.Generic;

namespace ClrModels {
public class ExplodingCar {

  public virtual event EventHandler<EventArgs> OnExploded;

  public void Explode(){
    // do logic here to make car explode
    TriggerOnExploded();
  }

  protected virtual void TriggerOnExploded(){
    var handler = OnExploded;
    if(handler != null){
      handler.Invoke(this, EventArgs.Empty);
    }
  }
}

public class CleanupCrew : IDisposable{
  private bool _isDisposed = false;
  private ExplodingCar _car;

  public CleanupCrew(ExplodingCar car){
    _car = car;
     //don't use anonymous delegates or lambda's
    _car.OnExploded += Handle_carOnExploded; 
  }

  void Handle_carOnExploded (object sender, EventArgs e)
  {
    // Do logic here when car exploded. Clean street, repair buildings etc.
  }

  public void Dispose(){
    Dispose(true);
    // Keep this here for subclasses that may use unmanaged resources
    GC.SuppressFinalize(this); 
  }

  protected virtual void Dispose(bool isDisposing){
    if(!_isDisposed){
      if(isDisposing){
        // detach event handlers here etc.
        _car.OnExploded -= Handle_carOnExploded;

      }
      _isDisposed = true;
      // unmanaged resources here.
    }
  }

}
}