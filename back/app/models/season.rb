class Season < ActiveHash::Base
  SPRING_MONTHS = [3, 4, 5].freeze
  SUMMER_MONTHS = [6, 7, 8].freeze
  AUTUMN_MONTHS = [9, 10, 11].freeze
  WINTER_MONTHS = [12, 1, 2].freeze

  self.data = [
    { id: 1, key: 'spring', name_ja: '春', months: SPRING_MONTHS },
    { id: 2, key: 'summer', name_ja: '夏', months: SUMMER_MONTHS },
    { id: 3, key: 'autumn', name_ja: '秋', months: AUTUMN_MONTHS },
    { id: 4, key: 'winter', name_ja: '冬', months: WINTER_MONTHS }
  ]

  def self.find_by_key(key)
    all.find { |season| season.key == key.to_s }
  end

  def self.current(date = Date.current)
    all.find { |season| season.months.include?(date.month) }
  end
end
