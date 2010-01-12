using System;
using System.Collections.Generic;

namespace ClrModels {
	public class StaticCaller{

    public string CallsStatic(){
      return MyClassWithAStatic.GoodByeWorld();
    }
  }
  
}