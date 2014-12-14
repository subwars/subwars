class Seaserpent < Entity
  def icon
    :seaserpent
  end

  def to_hash
    super.merge icon: icon
  end
end
