using System;
using System.Collections.Generic;

namespace ClrModels {
	public interface IHaveAnIndexer{
    string this[string name]{ get; set; }
  }
}