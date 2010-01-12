using System;
using System.Collections.Generic;

namespace ClrModels {
	public class ExposingWarrior : IExposingWarrior{
      private readonly int _id;

      public string Name { get; set; }
      public int Id { get { return _id; } }

      public int Attack(IWarrior target, IWeapon weapon){
          return weapon.Attack(target);
      }

      public bool IsKilledBy(IWeapon weapon)
      {
          return weapon.Damage() > 3;
      }

      public virtual event EventHandler<EventArgs> OnIsExposedChanged;
      public bool IsExposed {get; set; }


      public event EventHandler<EventArgs> OnIsAliveChanged;

      public void Die(){
          OnIsAliveChanged(this, EventArgs.Empty);
      }

      public static event EventHandler<EventArgs> OnCountChanged;

      public static void ChangeCount(){
          OnCountChanged(null, EventArgs.Empty);
      }


      public void SomeMethod(){}
      public void OwnMethod(){

      }

      private int _life = 10;
      public int SurviveAttackWith(IWeapon weapon){
          return _life - weapon.Damage();
      }

      public void Explode(){
          IsExposed = !IsExposed;
          var handler = OnIsExposedChanged;
          if(handler != null){
              handler(this, EventArgs.Empty);
          }
      }

      public bool HasEventSubscriptions{ get { return OnIsExposedChanged != null; } }
  }
  
}