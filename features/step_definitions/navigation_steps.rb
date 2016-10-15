Given /^I am on the '([^"]*)' page$/ do |page| 
  path_for = {
    'Home' => '/'
  }
  visit path_for[page]
end

Given(/^I select the 'Filter' button$/) do
  click_button 'Filter'
end

When /^I fill in ([^"]*) for '([^"]*)'$/ do |value,field|
  fill_in(field,:with => value)
end

When /^I select ([^"]*) for '([^"]*)'$/ do |value,field|
  page.select value, from:field if value.length > 0
end

Then /^I should see text '([^"]*)'$/ do |text|
  expect(page).to have_content text
end

Then /^The result set should have ([^"]*) records$/ do |number|
  expect(page).to have_content "Showing 1 to #{number} of #{number} entries"
end