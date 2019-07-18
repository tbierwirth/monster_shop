# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit my item page' do
    before :each do
      # @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      # @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      # @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      # @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      # @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      # @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      #
      @megan1 = User.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80_218, email: 'meg@gmail.com', password: 'fish', role: 2)
      # @megan2 = User.create!(name: 'Megan M', address: '123 Main St', city: 'Denver', state: 'IA', zip: 80218, email: 'meg2@gmail.com', password: 'fish' role: 1)
      # @order_1 = @megan1.orders.create!
      # @order_2 = @megan2.orders.create!
      #
      # @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      # @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2)
      # @order_2.order_items.create!(item: @ogre, price: @hippo.price, quantity: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@megan1)
    end

    describe 'when I visit my items page' do
      it 'has a new item button that leads to the new item form' do
        visit dashboard_items_path

        click_button('Add New Item')
        expect(current_path). to eq new_dashboard_item_path
      end

      it 'I can create a new item' do
        visit new_dashboard_item_path

        fill_in 'Name', with: 'GIJOE'
        fill_in 'Description', with: 'Combat Soldier'
        fill_in 'Price', with: 5.53
        fill_in 'Image', with: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw'
        fill_in 'Inventory', with: 15
        click_button 'Create Item'

        expect(current_path).to eq(new_dashboard_items_path)
        expect(page).to have_link(GIJOE)
        expect(page).to have_content('Combat Soldier')
        expect(page).to have_content(5.53)
        expect(page).to have_content('Active')
        expect(page).to have_content(15)

        expect(new_item.name).to eq('GIJOE')
        expect(new_item.description).to eq('Combat Soldier')
        expect(new_item.price).to eq(5.53)
        expect(new_item.image).to eq('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw')
        expect(new_item.inventory).to eq(15)
        expect(current_path).to eq dashboard_items_path
        expect(page).to have_content("#{new_item.name} has been saved.")

        within("#item-#{new_item.id}-info") do
          expect(page).to have_content("Name: #{new_item.name}")
          expect(page).to have_content("Description: #{new_item.description}")
          expect(page).to have_content("Price: #{new_item.price}")
          expect(page).to have_css("img[src='#{new_item.image}']")
          expect(page).to have_content("Inventory: #{new_item.inventory}")
          expect(page).to have_button('Edit Item')
          expect(page).to have_button('Disable Item')
          expect(page).to have_button('Delete Item')
        end
      end
      describe 'If input is incomplet or incorrect' do
        it 'displays a error message' do
          visit new_merchant_item_path

          fill_in 'Description', with: 'Combat Soldier'
          fill_in 'Price', with: 5.53
          fill_in 'Inventory', with: 15

          click_button 'Create Item'

          expect(current_path).to eq(new_merchant_item_path)
          expect(page).to have_content('Name input required')
        end

        it 'provides an error if I do not fill in price' do
          visit new_merchant_item_path

          fill_in 'Name', with: 'GIJOE'
          fill_in 'Description', with: 'Combat Soldier'
          fill_in 'Inventory', with: 15

          click_button 'Create Item'

          expect(current_path).to eq(new_merchant_item_path)
          expect(page).to have_content('Price input required')
        end

        it 'provides an error if I do not fill in description' do
          visit new_merchant_item_path

          fill_in 'Name', with: 'GIJOE'
          fill_in 'Price', with: 5.53
          fill_in 'Inventory', with: 15

          click_button 'Create Item'

          expect(current_path).to eq(new_merchant_item_path)
          expect(page).to have_content('Description input required')
        end

        it 'provides an error if I do not fill in inventory' do
          visit new_merchant_item_path

          fill_in 'Name', with: 'GIJOE'
          fill_in 'Price', with: 5.53
          fill_in 'Description', with: 'Combat Ready'

          click_button 'Create Item'

          expect(current_path).to eq(new_merchant_item_path)
          expect(page).to have_content('Inventory input required')
        end
      end
    end
  end
end
