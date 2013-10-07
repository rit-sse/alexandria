require 'zoom'
require 'marc'
require 'stringio'

# The book model class was getting rather large so i'm putting the LCC stuff in
# a concern
module Lccable
  extend ActiveSupport::Concern

  # Regex to match an LCC
  LCC_REGEX = /^(?<aclass>[A-Z]{1,3})(?<nclass>\d{1,4})(\ ?)(\.(?<dclass>\d{1,3}))?(?<date>\ [A-Za-z0-9]{1,4}\ )?([\ \.](?<c1>[A-Z][0-9]{1,4}))(\ (?<c1d>[A-Za-z0-9]{0,4}))?(\.?(?<c2>[A-Z][0-9]{1,4}))?(\ (?<e8>\w*)\ ?)?(\ (?<e9>\w*)\ ?)?(\ (?<e10>\w*)\ ?)?/

  # Gets the LCC for an LCCable object
  def get_lcc
    ZOOM::Connection.open('z3950.loc.gov', 7090) do |conn|
      conn.database_name = 'VOYAGER'
      conn.preferred_record_syntax = 'USMARC'
      conn.search("@attr 1=7 #{isbn}").each_record do |item|
        MARC::Reader.new(StringIO.new(item.raw)).each do |rec|
          set_lcc(rec)
        end
      end
    end
  rescue
    puts 'Connection Lost'
  end

  # Set's and normalizes the lcc
  def set_lcc(rec)
    unless rec['050'].nil?
      if rec['050']['b'] =~ /\..*/
        second_part = rec['050']['b'][1..-1]
      else
        second_part = rec['050']['b']
      end
      self.lcc = normalize("#{rec['050']['a']} #{second_part}").strip
    end
  end

  # Return a normalized version of the lcc
  def normalize(callno)
    cp = LCC_REGEX.match(callno)
    out = cp[:aclass] + cp[:nclass]
    out += '.%s' % cp[:dclass] if cp[:dclass].present?
    out += ' %s ' % cp[:dclass] if cp[:date].present?
    out += '.%s' % cp[:c1]
    out += ' %s ' % cp[:c1d] if cp[:c1d].present?
    out += ' %s' % cp[:c2] if cp[:c2].present?
    out += ' %s' % cp[:e8] if cp[:e8].present?
    out += ' %s' % cp[:e9] if cp[:e9].present?
    out += ' %s' % cp[:e10] if cp[:e10].present?
    out
  end

  # regular compare
  def self.cmp x, y
    x <=> y
  end

  # The compare function for the number classes
  def self.ncmp x, y
    if x.nil? and y.nil?
      return 0
    elsif x.nil?
      return -1
    elsif y.nil?
      return 1
    end
    x = x.to_i
    y = y.to_i
    x <=> y
  end

  # sort function
  def self.sort_it_up x, y
    xp = LCC_REGEX.match(x)
    yp = LCC_REGEX.match(y)
    parts = {
      aclass: :cmp,
      nclass: :ncmp,
      dclass: :ncmp,
      date: :cmp,
      c1: :cmp,
      c1d: :cmp,
      c2: :cmp,
      e8: :cmp,
      e9: :cmp,
      e10: :cmp
    }
    parts.each do |part_key, part_value|
      cr = send(part_value, xp[part_key], yp[part_key])
      if cr != 0
        return cr
      end
    end
    0
  end

  def self.where_to_place(book)
    books = Book.all.sort{ |a,b| sort_it_up(a.lcc,b.lcc) }
    i = books.index(book)
    left = books[i-1]
    right  = books[i+1]
    left = nil if i == 0
    right = nil if i == books.count - 1
    {left: left, right: right}
  end
end
