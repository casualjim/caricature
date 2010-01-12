class DaggerWithClassMembers
  def damage
    2
  end
  def attack(target)
    target.survive_attack_with self
  end
  def self.class_name
    "DaggerWithClassMembers"
  end
end