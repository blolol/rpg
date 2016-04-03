class WeaponItemName < ItemName
  def to_s
    @name ||= [possessive, quality, type, suffix].compact.join(' ')
  end
end
