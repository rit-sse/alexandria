require 'spec_helper'
require 'feature_helper'

feature 'Managing Checkouts' do
	before do
    login
    Book.add_by_isbn('9780199273133')
    create(:patron)
  end
  describe 'Check out' do
    scenario 'succesful checkout' do
      visit new_checkout_path

      find('#checkout_book').set '9780199273133'
      find('#checkout_distributor').set '7777'
      find('#checkout_patron').set '5555'
      click_button 'Check out'

      expect(page).to have_text("Checkout for Principles of Computer Hardware")
      expect(page).to have_text("Checked In Not checked in yet")
    end
    scenario 'invalid distributor' do
      visit new_checkout_path

      find('#checkout_book').set '9780199273133'
      find('#checkout_distributor').set '5555'
      find('#checkout_patron').set '5555'
      click_button 'Check out'

      expect(page).to have_text("Distributor is not a distributor or librarian")
    end
  end
end