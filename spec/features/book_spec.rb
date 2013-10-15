require 'spec_helper'
require 'feature_helper'

feature 'Managing Books' do
  before do
    login
  end

  scenario 'Can add books to the system' do
    visit '/books/new'

    find('#isbn-add').set '9780321334893'
    find("#isbn-submit").click
    expect(page).to have_text('OpenGL Shading Language')
  end

  scenario 'Invalid submissions goes back to new page' do
    visit '/books/new'
    find("#isbn-submit").click
    expect(page).to have_text('Add book by ISBN')
  end
end