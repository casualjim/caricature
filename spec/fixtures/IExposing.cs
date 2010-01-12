using System;
using System.Collections.Generic;

namespace ClrModels {
	public interface IExposing {
	  event EventHandler<EventArgs> OnIsExposedChanged;
	  bool IsExposed {get; set; }
	}
}