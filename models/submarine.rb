class Submarine < Entity
  def icon
    :submarine
  end

  def to_hash
    super.merge icon: icon
  end
end
