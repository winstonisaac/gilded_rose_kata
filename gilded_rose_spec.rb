require_relative './gilded_rose_v2'

RSpec.describe "GildedRose" do
  let!(:items) do
    [
     Item.new("+5 Dexterity Vest", 10, 20),
     Item.new("Aged Brie", 2, 0),
     Item.new("Elixir of the Mongoose", 5, 7),
     Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
     Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
     Item.new("Conjured Mana Cake", 3, 6),
    ]
  end

  context "Normal items" do
    it "Should decrease sell_in by 1 after 1 day" do
      update_quality(items)
      expect(items[0].sell_in).to eq 9
      expect(items[2].sell_in).to eq 4
    end
    it "Should decrease in quality by 1 after 1 day" do
      update_quality(items)
      expect(items[0].quality).to eq 19
      expect(items[2].quality).to eq 6
    end
    it "Should decrease in quality twice as fast after sell_in days" do
      item = [Item.new("Broadsword", 1, 50)]
      for i in 1..5
        update_quality(item)
      end
      expect(item[0].quality).to eq 41
    end
    it "Should never have a negative quality" do
      for i in 1..100
        update_quality(items)
      end
      expect(items[0].quality).to eq 0
      expect(items[2].quality).to eq 0
    end
  end

  context "Sulfuras, Hand of Ragnaros" do
    it "Should not decrease in quality or sell_in" do
      for i in 1..10
        update_quality(items)
      end
      expect(items[3].quality).to eq 80
      expect(items[3].sell_in).to eq 0
    end
  end

  context "Aged Brie" do
    it "Should increase in quality by 1 after 1 day" do
      update_quality(items)
      expect(items[1].quality).to eq 1
    end
    it "Should increase in quality by 2 after expiration day" do
      brie = [Item.new("Aged Brie", 0, 3)]
      update_quality(brie)
      expect(brie[0].quality).to eq 5
    end
    it "Should never exceed quality of 50" do
      brie = [Item.new("Aged Brie", 0, 3)]
      for i in 1..100
        update_quality(brie)
      end
      expect(brie[0].quality).to eq 50
    end
  end

  context "Backstage passes" do
    it "Should increase quality by 2 if there are 10 days or less before event" do
      for i in 1..6
        update_quality(items)
      end
      expect(items[4].quality).to eq 27
    end
    it "Should increase quality by 3 if there are 5 days or less before event" do
      for i in 1..11
        update_quality(items)
      end
      expect(items[4].quality).to eq 38
    end
    it "Should drop quality to 0 if event has passsed" do
      for i in 1..16
        update_quality(items)
      end
      expect(items[4].quality).to eq 0
    end
    it "Should never exceed quality of 50" do
      item = [Item.new("Backstage passes to a TAFKAL80ETC concert", 20, 45)]
      for i in 1..15
        update_quality(item)
      end
      expect(item[0].quality).to eq 50
    end
  end

  context "Conjured items" do
    it "Should decrease in quality twice as fast as normal items i.e. decrease by 2 every day" do
      update_quality(items)
      expect(items[5].quality).to eq 4
    end
    it "Should likewise decrease in quality twice as fast when expired i.e. decrease by 4 after sell_in days" do
      item = [Item.new("Conjured Ek-ek", 2, 20)]
      for i in 1..3
        update_quality(item)
      end
      expect(item[0].quality).to eq 12
    end
  end
end
