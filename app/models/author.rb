class Author < ActiveRecord::Base
  class UniqueAuthorValidator < ActiveModel::Validator
    def validate(record)
      other_authors = Author.where(first_name: record.first_name,
                                   middle_initial: record.middle_initial,
                                   last_name: record.last_name)
      if other_authors.size != 0
        record.errors[:base] << "This author already exists in the system"
      end
    end
  end
  
  attr_accessible :first_name, :last_name, :middle_initial
  has_and_belongs_to_many :book

  validates_length_of :middle_initial, :maximum => 1, :allow_blank => false
  validates_with UniqueAuthorValidator

  def detault_values
    self.middle_initial ||= ""
  end

  ##
  # Creates an Author when given a single string name. It DOES NOT save it.
  #
  # It parses the name, expecting it to be space deliniated into 3 parts.
  # It expects strings in the format "<first> <last>" or "<first> <middle> <last>"
  def self.create_with_name(name)
    return self.new(parse_name(name))
  end

  ##
  # Finds an Author when given a single string name. 
  #
  # It parses the name, expecting it to be space deliniated into 3 parts.
  # It expects strings in the format "<first> <last>" or "<first> <middle> <last>"
  def self.find_with_name(name)
    name_parts = parse_name(name)

    return Author.where(first_name:   name_parts[:first_name],
                        middle_initial: name_parts[:middle_initial],
                        last_name:   name_parts[:last_name])[0]
 end

  ##
  # Finds an author with the given name. If there is no such author, 
  # creates one and returns that. If created, it DOES save it.
  # 
  # Uses the parsing rules: "<first> <last>" or "<first> <middle> <last>"
  def self.find_or_create(name)
    author = find_with_name(name)
    if author == nil
      author = create_with_name(name)
      author.save
    end

    author
 end

  ##
  # Parses the names into expected portions. All methods that parse
  # a name for Author use this.
  def self.parse_name(name)
    name_parts = name.split(' ')

    if name_parts.size == 2
      return {first_name: name_parts[0], 
          middle_initial: '',
          last_name: name_parts[1]}
    elsif name_parts.size == 3
      return {first_name: name_parts[0],
          middle_initial: name_parts[1].sub('.',''),
          last_name: name_parts[2]}
    elsif name_parts.size == 4
      if ["III", "Jr", "Jr."].include? name_parts[3]
        return {first_name: name_parts[0],
          middle_initial: name_parts[1].sub('.',''),
          last_name: name_parts[2]
          }
      else
        return {first_name: name_parts[0],
          middle_initial: "#{name_parts[1]} #{name_parts[2]}".sub('.',''),
          last_name: name_parts[3]
          }
      end
    else
      raise ArgumentError, "Error with #{name} argument should be in the form '<first> <last>' or '<first> <middle> <last>', space deliniated"  
    end
  end
end

