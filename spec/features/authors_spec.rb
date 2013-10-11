require 'spec_helper'

feature 'author_management' do
  scenario 'Creates a new author' do
    visit '/authors/new'

    fill_in 'First name', with: 'James'
    fill_in 'Middle initial', with: 'T'
    fill_in 'Last name', with: 'Kirk'

    click_button 'Save'

    expect(page).to have_text("Author was successfully created.")
  end

  scenario 'Should display error when bad author is created' do
    visit '/authors/new'

    fill_in 'First name', with: 'James'
    fill_in 'Middle initial', with: 'Tiberius'
    fill_in 'Last name', with: 'Kirk'

    click_button 'Save'

    expect(page).to have_text("Middle initial is too long (maximum is 1 characters)")
  end
end