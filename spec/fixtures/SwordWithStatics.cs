using System;
using System.Collections.Generic;

namespace ClrModels {
	public class SwordWithStatics : Sword{

    static SwordWithStatics(){
      ClassNaming = "Sword with statics";
    }

    public SwordWithStatics(){ SwordName = "Sword name for statics"; }

    public void AnotherMethod(){}
    public static void AStaticMethod(){}
    public static string ClassNaming { get; set; }
    public string SwordName{get; set;}
  }
  
}