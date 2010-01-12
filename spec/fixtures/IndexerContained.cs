using System;
using System.Collections.Generic;

namespace ClrModels {
	public class IndexerContained{

    private Dictionary<string, string> _inner = new Dictionary<string, string>{
      { "key1", "value1" },
      { "key2", "value2" },
      { "key3", "value3" },
      { "key4", "value4" }
    };

    public virtual string this[string name]{
      get { return _inner[name]; }
      set { _inner[name] = value; }
    }
  }
  
}