using System;
using System.Collections.Generic;

namespace ClrModels {
	public interface IWarrior
	{
 		int Id { get; }
	  string Name { get; set; }
	  bool IsKilledBy(IWeapon weapon);
	  int Attack(IWarrior target, IWeapon weapon);
	  int SurviveAttackWith(IWeapon weapon);
	}
}