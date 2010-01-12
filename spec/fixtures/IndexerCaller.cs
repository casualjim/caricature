using System;
using System.Collections.Generic;

namespace ClrModels {
  public class IndexerCaller{

    public string CallIndexOnClass(IndexerContained klass, string name){
      return klass[name];
    }

    public string CallIndexOnInterface(IHaveAnIndexer klass, string name){
      return klass[name];
    }

  }
	
}