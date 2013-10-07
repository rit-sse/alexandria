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
    out += '.%s' % cp[:dclass] unless cp[:dclass].nil?
    out += ' %s ' % cp[:dclass] unless cp[:date].nil?
    out += '.%s' % cp[:c1]
    out += ' %s ' % cp[:c1d] unless cp[:c1d].nil?
    out += ' %s' % cp[:c2] unless cp[:c2].nil?
    out += ' %s' % cp[:e8] unless cp[:e8].nil?
    out += ' %s' % cp[:e9] unless cp[:e9].nil?
    out += ' %s' % cp[:e10] unless cp[:e10].nil?
    out
  end
end
