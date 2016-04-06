Given /^I am on the '([^"]*)' page$/ do |page| 
  path_for = {
    'Home' => '/'
  }
  visit path_for[page]
end

When /^I fill in '([^"]*)' for '([^"]*)'$/ do |value,field|
  fill_in(field,:with => value)
end

When(/^I fill in 'Duluth, MN' in the 'enter search text' field$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then /^I should see text '([^"]*)'$/ do |text|
  expect(page).to have_content text
end