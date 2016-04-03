class FingerItemName < ItemName
  def to_s
    @name ||= [possessive, quality, material, type, suffix].compact.join(' ')
  end

  private

  def material
    I18n.t("items.finger.materials.#{@rarity}").sample
  end

  def quality
    I18n.t("items.finger.qualities.#{@rarity}").sample
  end

  def type
    I18n.t("items.finger.types").sample
  end
end
