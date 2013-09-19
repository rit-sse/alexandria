require 'spec_helper'

describe Author do
  it "creates a user properly with create_with_name" do
    author = Author.create_with_name("First Last")
    expect(author.first_name).to eq("First")
    expect(author.last_name).to eq("Last")

    author = Author.create_with_name("First M. Last")
    expect(author.first_name).to eq ("First")
    expect(author.middle_initial).to eq("M")
    expect(author.last_name).to eq("Last")
  end

  it "finds a user properly with find_with_name" do
    first_name = "James"
    middle_initial = "T"
    last_name = "Kirk"

  full_name = "#{first_name} #{middle_initial} #{last_name}"

  author = Author.new(first_name: first_name,
              middle_initial: middle_initial,
              last_name: last_name)
  author.save

    expect(Author.find_with_name(full_name)).to eq author
  end

  it "finds and creates users with find_or_create" do
    first_name = "James"
    middle_initial = "T"
    last_name = "Kirk"

    full_name = "#{first_name} #{middle_initial} #{last_name}"

    expect(Author.find_with_name(full_name)).to eq nil

    author = Author.find_or_create(full_name)

    expect(Author.find_with_name(full_name)).to eq author
    expect(Author.find_or_create(full_name)).to eq author
  end

  it "guarantees the uniqueness of authors in the system" do
    first_name = "James"
    middle_initial = "T"
    last_name = "Kirk"

    full_name = "#{first_name} #{middle_initial} #{last_name}"

    author = Author.create_with_name(full_name)
    author.save

    author = Author.create_with_name(full_name)
    expect(author.valid?).to eq false
  end

end
