class Soldier

  def initialize
    @life = 10
  end

  def name
    "Tommy Boy"
  end

  def to_s
    "I'm a soldier"
  end

  def attack(target, weapon)
    weapon.attack(target)
  end

  def is_killed_by?(weapon)
    weapon.damage > 3
  end

  def survive_attack_with(weapon)
    @life - weapon.damage
  end

end


