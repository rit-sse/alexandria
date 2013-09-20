require 'zoom'
require 'marc'
require 'stringio'

# The book model class was getting rather large so i'm putting the LCC stuff in
# a concern
module Lccable
  extend ActiveSupport::Concern

  LCC_REGEX = /^(?<aclass>[A-Z]{1,3})(?<nclass>\d{1,4})(\ ?)(\.(?<dclass>\d{1,3}))?(?<date>\ [A-Za-z0-9]{1,4}\ )?([\ \.](?<c1>[A-Z][0-9]{1,4}))(\ (?<c1d>[A-Za-z0-9]{0,4}))?(\.?(?<c2>[A-Z][0-9]{1,4}))?(\ (?<e8>\w*)\ ?)?(\ (?<e9>\w*)\ ?)?(\ (?<e10>\w*)\ ?)?/

  def get_lcc
    ZOOM::Connection.open('z3950.loc.gov', 7090) do |conn|
      conn.database_name = 'VOYAGER'
      conn.preferred_record_syntax = 'USMARC'
      conn.search("@attr 1=7 #{self.ISBN}").each_record do |item|
        MARC::Reader.new(StringIO.new(item.raw)).each do |rec|
          if not rec['050'].nil?
            if rec['050']['b'] =~ /\..*/
              second_part = rec['050']['b'][1..-1]
            else
              second_part = rec['050']['b']
            end
            self.LCC = normalize("#{rec['050']['a']} #{second_part}")
          end
        end
      end
    end
  end

  def normalize callno
    cp = LCC_REGEX.match(callno)
    out = cp[:aclass] + cp[:nclass]
    if not cp[:dclass].nil?
      out += ".#{cp[:dclass]}"
    end
    if not cp[:date].nil?
      out += " #{cp[:dclass]} "
    end
    out += ".#{cp[:c1]}"
    if not cp[:c1d].nil?
      out += " #{cp[:c1d]} "
    end
    if not cp[:c2].nil?
      out += " #{cp[:c2]}"
    end
    if not cp[:e8].nil?
      out += " #{cp[:e8]}"
    end
    if not cp[:e9].nil?
      out += " #{cp[:e9]}"
    end
    if not cp[:e10].nil?
      out += " #{cp[:e10]}"
    end
    out
  end
end