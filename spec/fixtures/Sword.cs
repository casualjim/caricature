using System;
using System.Collections.Generic;

namespace ClrModels {
	public class Sword : IWeapon {

    public virtual int Attack(IWarrior warrior){
      return warrior.SurviveAttackWith(this);
    }

    public int Damage(){
      return 4;
    }
	}
	
}