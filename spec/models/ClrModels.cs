using System;

namespace ClrModels{
    public interface IWeapon{
        int Attack(IWarrior warrior);
        int Damage();
    }

    public interface IWarrior
    {

        int Id { get; }
        string Name { get; set; }
        bool IsKilledBy(IWeapon weapon);
        int Attack(IWarrior target, IWeapon weapon);
        int SurviveAttackWith(IWeapon weapon);
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

        public int Attack(IWarrior target, IWeapon weapon){
            return weapon.Attack(target);
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

        private int _life = 10;
        public int SurviveAttackWith(IWeapon weapon){
            return _life - weapon.Damage();
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

        private readonly IExposingWarrior _warrior;

        public ExposedChangedSubscriber(IExposingWarrior warrior){
          _warrior = warrior;
          _warrior.IsExposedChanged += OnExposedChanged;
        }

        public int Counter { get; set; }

        private void OnExposedChanged(object sender, EventArgs args){
            Counter++;            
        }

    }

    public class Sword : IWeapon{

        public int Attack(IWarrior warrior){
            return warrior.SurviveAttackWith(this);
        }

        public int Damage(){
            return 4;
        }
    }

    public class SwordWithStatics : Sword{

        public void AnotherMethod(){}
        public static void AStaticMethod(){}
        public static string ClassNaming { get; set; }
        public string SwordName{get; set;}
    }

    public class Ninja : IWarrior{

        public Ninja(){
            Name = "Tony the Ninja";
            _id = 1;
        }

        private readonly int _id;

        public string Name { get; set; }
        public int Id { get { return _id; } }

        public int Attack(IWarrior target, IWeapon weapon){
            return weapon.Attack(target);
        }

        public bool IsKilledBy(IWeapon weapon)
        {
            return weapon.Damage() > 3;
        }

        private int _life = 10;
        public virtual int SurviveAttackWith(IWeapon weapon){
            return _life - weapon.Damage();
        }


    }

    public sealed class Samurai : IWarrior{

        private readonly int _id;

        public string Name { get; set; }
        public int Id { get { return _id; } }

        public int Attack(IWarrior target, IWeapon weapon){
            return weapon.Attack(target);
        }

        public bool IsKilledBy(IWeapon weapon)
        {
            return weapon.Damage() > 5;
        }

        private int _life = 10;
        public int SurviveAttackWith(IWeapon weapon){
            return _life - weapon.Damage();
        }


    }

    public class MyClassWithAStatic{

        public string HelloWorld(){
            return "Hello World!";
        }

        public static string GoodByeWorld(){
            return "Goodbye world!";
        }
    }



    public class StaticCaller{

        public string CallsStatic(){
            return MyClassWithAStatic.GoodByeWorld();
        }
    }
}
