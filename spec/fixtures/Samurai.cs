using System;
using System.Collections.Generic;

namespace ClrModels {
	public sealed class Samurai : IWarrior{

    private readonly int _id;

    public string Name { get; set; }
    public int Id { get { return _id; } }

    public int Attack(IWarrior target, IWeapon weapon){
      return weapon.Attack(target);
    }

    public bool IsKilledBy(IWeapon weapon)
    {
      return weapon.Damage() > 5;
    }

    private int _life = 10;
    public int SurviveAttackWith(IWeapon weapon){
      return _life - weapon.Damage();
    }


  }
  
}