using System;
using System.Collections.Generic;

namespace ClrModels {
	public interface IExplodingWarrior : IExposingBridge{
      event EventHandler<EventArgs> OnExploding;
      void Explode();

  }
}