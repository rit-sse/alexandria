require 'people'

# Author model class
class Author < ActiveRecord::Base
  @@parser = People::NameParser.new

  after_initialize :default_values
  # Unique author validator class
  class UniqueAuthorValidator < ActiveModel::Validator
    def validate(record)
      other_authors = Author.where(first_name: record.first_name,
                                   middle_initial: record.middle_initial,
                                   last_name: record.last_name)
      other_authors.delete_if { |x| x.id == record.id }
      if other_authors.size != 0
        record.errors[:base] << 'This author already exists in the system'
      end
    end
  end

  has_many :author_books
  has_many :books, through: :author_books

  validates :middle_initial, length: { maximum: 1 }
  validates_with UniqueAuthorValidator

  def default_values
    self.middle_initial ||= ''
  end

  ##
  # Creates an Author when given a single string name. It DOES NOT save it.
  #
  # It parses the name, expecting it to be space deliniated into 3 parts.
  # It expects strings in the format "<first> <last>" or "<first> <middle> <last>"
  def self.create_with_name(name)
    new(parse_name(name))
  end

  ##
  # Finds an Author when given a single string name.
  #
  # It parses the name, expecting it to be space deliniated into 3 parts.
  # It expects strings in the format "<first> <last>" or "<first> <middle> <last>"
  def self.find_with_name(name)
    name = parse_name(name)

    Author.where(first_name:   name[:first_name],
                 middle_initial: name[:middle_initial],
                 last_name:   name[:last_name])[0]
  end

  ##
  # Finds an author with the given name. If there is no such author,
  # creates one and returns that. If created, it DOES save it.
  #
  # Uses the parsing rules: "<first> <last>" or "<first> <middle> <last>"
  def self.find_or_create(name)
    author = find_with_name(name)
    if author.nil?
      author = create_with_name(name)
      author.save
    end

    author
  end

  ##
  # Parses the names into expected portions. All methods that parse
  # a name for Author use this.
  def self.parse_name(name)
    parsed_name = @@parser.parse name

    {
      first_name:     parsed_name[:first],
      middle_initial: parsed_name[:middle],
      last_name:      parsed_name[:last]
    }
  end

  def full_name
    "#{first_name} #{middle_initial} #{last_name}"
  end
end
