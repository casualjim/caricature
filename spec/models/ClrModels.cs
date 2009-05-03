public interface IWeapon{
    void Attack(IWarrior warrior);
    int Damage();
}

public interface IWarrior
{
    bool IsKilledBy(IWeapon weapon);
    void Attack(IWarrior target, IWeapon weapon);
}

public class Ninja : IWarrior{

    public void Attack(IWarrior target, IWeapon weapon){
        weapon.Attack(target);
    }

    public bool IsKilledBy(IWeapon weapon)
    {
        return weapon.Damage() > 3;
    }
}