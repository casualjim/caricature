using System;
using System.Collections.Generic;

namespace ClrModels {
	public class ExposedChangedSubscriber{

		private readonly IExposingBridge _warrior;

		public ExposedChangedSubscriber(IExposingBridge warrior){
		  _warrior = warrior;
		  _warrior.OnIsExposedChanged += OnExposedChanged;
		}

		public int Counter { get; set; }
		public object Sender {get; set;  }
		public EventArgs Args { get; set; }

		private void OnExposedChanged(object sender, EventArgs args){
		  Counter++;            
		  Sender = sender;
		  Args = args;
		}

  }
  
}