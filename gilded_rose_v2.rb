def update_quality(items)
  items.each do |item|
    adjust_quality(item)
    adjust_sell_in(item)
  end
end

def adjust_sell_in(item)
  unless is_legendary(item)
    item.sell_in -= 1
  end
end

def adjust_quality(item)
  if is_brie(item)
    item.quality += 1
    if item.sell_in <= 0
      item.quality += 1
    end
  elsif is_backstage_pass(item)
    case item.sell_in
    when 1..5
      item.quality += 3
    when 6..10
      item.quality += 2
    when 11..nil
      item.quality += 1
    when 0
      item.quality = 0
    end
  elsif is_legendary(item)
  else #for normal items and conjured items
    is_conjured(item) ? n = 2 : n = 1
    for i in 1..n
      item.quality -= 1
      item.quality -= 1 if item.sell_in <= 0
    end
  end
  item.quality = 50 if (item.quality > 50) && !is_legendary(item)
  item.quality = 0 if item.quality < 0
end

def is_brie(item)
  true if (item.name.include? "Aged Brie")
end

def is_backstage_pass(item)
  true if (item.name.include? "Backstage")
end

def is_conjured(item)
  true if (item.name.include? "Conjured")
end

def is_legendary(item)
  true if (item.name.include? "Sulfuras")
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)
