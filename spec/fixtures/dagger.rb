class Dagger

  def damage
    2
  end

  def attack(target)
    target.survive_attack_with self
  end

end
