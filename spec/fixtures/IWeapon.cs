using System;
using System.Collections.Generic;

namespace ClrModels {
	public interface IWeapon{
      int Attack(IWarrior warrior);
      int Damage();
  }
}