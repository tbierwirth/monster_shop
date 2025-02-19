require 'rails_helper'

RSpec.describe Item do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many :order_items}
    it {should have_many(:orders).through(:order_items)}
    it {should have_many :reviews}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :image}
    it {should validate_presence_of :inventory}
    it {should validate_presence_of :price}
  end

  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 5 )
      @review_1 = @ogre.reviews.create(title: 'Great!', description: 'This Ogre is Great!', rating: 5)
      @review_2 = @ogre.reviews.create(title: 'Meh.', description: 'This Ogre is Mediocre', rating: 3)
      @review_3 = @ogre.reviews.create(title: 'EW', description: 'This Ogre is Ew', rating: 1)
      @review_4 = @ogre.reviews.create(title: 'So So', description: 'This Ogre is So so', rating: 2)
      @review_5 = @ogre.reviews.create(title: 'Okay', description: 'This Ogre is Okay', rating: 4)
      @alex = User.create!(name: "Alex Hennel", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, email: "straw@gmail.com", password: "fish", role: 0)
      @order_1 = @alex.orders.create!
      @order_1.order_items.create(item: @ogre, quantity: 50, price: @ogre.price)
      @order_1.order_items.create(item: @giant, quantity: 49, price: @giant.price)
    end

    it '.sorted_reviews()' do
      expect(@ogre.sorted_reviews(3, :desc)).to eq([@review_1, @review_5, @review_2])
      expect(@ogre.sorted_reviews(3, :asc)).to eq([@review_3, @review_4, @review_2])
      expect(@ogre.sorted_reviews).to eq([@review_3, @review_4, @review_2, @review_5, @review_1])
    end

    it '.average_rating' do
      expect(@ogre.average_rating.round(2)).to eq(3.00)
    end

    it ".all_active" do
      expect(Item.all_active.count).to eq(1)
    end

    it '.popular_items' do
      desc = Item.popular_items(2,'DESC')
      expect(desc.first.name).to eq('Ogre')
      expect(desc.last.name).to eq('Giant')
      asc = Item.popular_items(2,'ASC')
      expect(asc.first.name).to eq('Giant')
      expect(asc.last.name).to eq('Ogre')
    end

    it '.get_order_item' do
      expect(@ogre.get_order_item(@order_1)).to eq(@order_1.order_items.first)
    end

    it '.fulfillable?' do
      expect(@ogre.fulfillable?(1)).to eq(true)
      expect(@ogre.fulfillable?(11)).to eq(false)
    end

    it '.fulfilled?' do
      expect(@ogre.fulfilled?(@order_1.id)).to eq(false)
    end
  end
end
