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