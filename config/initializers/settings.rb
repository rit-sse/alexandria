# Be sure to restart your server when you modify this file.

Rails.configuration.reservation_period = 1.week
Rails.configuration.checkout_period    = 1.week
Rails.configuration.remind_before      = 3.days
Rails.configuration.strikes_for_ban    = 3

# TODO: Replace this with an Array of Ranges of Strings. Each Range should
# represent the first and last book codes for the given shelf.
Rails.configuration.shelves = []
