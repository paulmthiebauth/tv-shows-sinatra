require "spec_helper"

feature "user adds a new TV show" do
  # As a TV fanatic
  # I want to add one of my favorite shows
  # So that I can encourage others to binge watch it
  #
  # Acceptance Criteria:
  # * I must provide the title, network, and starting year.
  # * I can optionally provide the final year, genre, and synopsis.
  # * The synopsis can be no longer than 50 characters.
  # * The starting year and ending year (if provided) must be
  #   greater than 1900.
  # * The genre must be one of the following: Action, Mystery,
  #   Drama, Comedy, Fantasy
  # * If any of the above validations fail, the form should be
  #   re-displayed with the failing validation message.

  scenario "successfully add a new show" do
    visit "/television_shows/new"
    fill_in 'Title', with: "Burn Notice"
    fill_in 'Network', with: "USA"
    fill_in 'starting_year', with: "1990"
    fill_in 'ending_year', with: "1995"
    fill_in 'synopsis', with: "Great show, loved it a lot."
    click_button 'Add TV Show'
    visit "http://localhost:4567/television_shows"
    expect(page).to have_content('Burn Notice (USA)')
  end

  scenario "fail to add a show title, network and starting year" do
    visit "/television_shows/new"
    fill_in 'ending_year', with: "1990"
    click_button 'Add TV Show'
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Network can't be blank")
    expect(page).to have_content("Starting year can't be blank")
    expect(page).to have_content("Starting year is not a number")
  end

  scenario "final year, genre and synopsis are optional" do
    visit "/television_shows/new"
    fill_in 'title', with: "The Shield"
    fill_in 'Network', with: "USA"
    fill_in 'starting_year', with: "1990"
    click_button 'Add TV Show'
    expect(page).to have_content('TV Shows')
  end

  scenario "synopsis can be no longer than 5000 characters" do
    visit "/television_shows/new"
    fill_in 'title', with: "House"
    fill_in 'Network', with: "USA"
    fill_in 'starting_year', with: "1990"
    fill_in 'synopsis', with: "z" * 5001
    click_button 'Add TV Show'
    expect(page).to have_content('Synopsis is too long (maximum is 5000 characters) ')
  end

  scenario "starting year must be greater than 1900" do
    visit "/television_shows/new"
    fill_in 'Title', with: "60 Minutes"
    fill_in 'Network', with: "USA"
    fill_in 'starting_year', with: "1880"
    click_button 'Add TV Show'
    expect(page).to have_content('Starting year must be greater than 1900')
  end

  scenario "ending year must be greater than 1900 if provided" do
    visit "/television_shows/new"
    fill_in 'Title', with: "60 Minutes"
    fill_in 'Network', with: "USA"
    fill_in 'starting_year', with: "1880"
    fill_in 'ending_year', with: "1890"
    click_button 'Add TV Show'
    expect(page).to have_content('Starting year must be greater than 1900')
    expect(page).to have_content('Ending year must be greater than 1900')
  end

  scenario "genre must be included in the genres list" do
    visit "/television_shows/new"
    fill_in 'Title', with: "Chris Hansen"
    fill_in 'Network', with: "USA"
    select "Other", :from => "Genre"
    fill_in 'starting_year', with: "1880"
    fill_in 'ending_year', with: "1885"
    click_button 'Add TV Show'
    expect(page).to have_content('Genre is not included in the list')
  end

end
