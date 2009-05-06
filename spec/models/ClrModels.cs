using System;

namespace ClrModels{
    public interface IWeapon{
        void Attack(IWarrior warrior);
        int Damage();
    }

    public interface IWarrior
    {

        int Id { get; }
        string Name { get; set; }
        bool IsKilledBy(IWeapon weapon);
        void Attack(IWarrior target, IWeapon weapon);
    }

    public interface IExposing {
        event EventHandler<EventArgs> IsExposedChanged;
        bool IsExposed {get; set; }
    }

    public interface IExposingBridge : IWarrior, IExposing {
        void SomeMethod();
    }

    public interface IExposingWarrior : IExposingBridge {
        void OwnMethod();
    }

    public class ExposingWarrior : IExposingWarrior{
        private readonly int _id;

        public string Name { get; set; }
        public int Id { get { return _id; } }

        public void Attack(IWarrior target, IWeapon weapon){
            weapon.Attack(target);
        }

        public bool IsKilledBy(IWeapon weapon)
        {
            return weapon.Damage() > 3;
        }

        public event EventHandler<EventArgs> IsExposedChanged;
        public bool IsExposed {get; set; }

        public void SomeMethod(){}
        public void OwnMethod(){

        }

        public void ChangeIsExposed(){
            IsExposed = !IsExposed;
            var handler = IsExposedChanged;
            if(handler != null){
                handler(this, EventArgs.Empty);
            }
        }

        public bool HasEventSubscriptions{ get { return IsExposedChanged != null; } }
    }

    public class ExposedChangedSubscriber{

        private readonly ExposingWarrior _warrior;

        public ExposedChangedSubscriber(ExposingWarrior warrior){
          _warrior = warrior;
          _warrior.IsExposedChanged += OnExposedChanged;
        }

        public int Counter { get; set; }

        private void OnExposedChanged(object sender, EventArgs args){
            Counter++;            
        }

    }

    public class Ninja : IWarrior{

        private readonly int _id;

        public string Name { get; set; }
        public int Id { get { return _id; } }

        public void Attack(IWarrior target, IWeapon weapon){
            weapon.Attack(target);
        }

        public bool IsKilledBy(IWeapon weapon)
        {
            return weapon.Damage() > 3;
        }
    }

    public class Samurai : IWarrior{

        private readonly int _id;

        public string Name { get; set; }
        public int Id { get { return _id; } }

        public void Attack(IWarrior target, IWeapon weapon){
            weapon.Attack(target);
        }

        public bool IsKilledBy(IWeapon weapon)
        {
            return weapon.Damage() > 5;
        }
    }
}