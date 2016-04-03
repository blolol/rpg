class ArmorItemName < ItemName
  def to_s
    @name ||= [possessive, quality, material, type, suffix].compact.join(' ')
  end

  private

  def material
    I18n.t("items.armor.#{@rarity}").sample
  end
end
