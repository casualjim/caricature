using System;
using System.Collections.Generic;

namespace ClrModels {
	public class Ninja : IWarrior{

    public Ninja(){
      Name = "Tony the Ninja";
      _id = 1;
    }

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

    private int _life = 10;
    public virtual int SurviveAttackWith(IWeapon weapon){
      return _life - weapon.Damage();
    }


  }
  
}