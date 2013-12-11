Alexandria::Application.configure do
  # This file contains configuration options for the Alexandria library itself.
  # Be sure to restart your server when you modify this file.

  # The time before a reservation expires.
  config.reservation_period = 1.week

  # The time before a checkout is due.
  config.checkout_period = 1.week

  # The time before a checkout is due when an email warning should be sent to the
  # appropriate patron.
  config.remind_before = 3.days

  # The number of strikes a user must have to be automatically banned.
  #
  # TODO: Start using this setting in the application.
  config.strikes_for_ban = 3

  # The configuration of shelves in the physical library. Only the first and last
  # book codes of each shelf need to be stored here.
  #
  # TODO: Replace this with an Array of the last LCC on each of the Shelves
  config.shelves = ['QA76.73.J38 K57 2002', 'QA76.76.C73 C66 2003', 'QA76.76.T48 P46 2000', 'TK7888.3.M343 1991', 'Z253.4.T47 S64 1992']
end
