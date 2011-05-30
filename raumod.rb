module Raumod
  module XM; end; # http://16-bits.org/xm/
  
 
  
  module Raumod::HeaderReader
    
    def header_map
    end
    def header_entry(ofty)
      
      offset = ofty[:offset]
      type = ofty[:type]
      
      if type == 's22'
        @header[offset..offset+21].gsub("\000",'')
      elsif type == 'C'
        @header[offset..-1].unpack('C').first
      elsif type == 'v'
        @header[offset..-1].unpack('v').first
      elsif type == 'V'
        @header[offset..-1].unpack('V').first      
      end
    end
    def method_missing(method,*args)      
      if header_map[method]
        header_entry(header_map[method])
      else
        raise "No such method: #{method}"
      end
    end    
  end
  require 'xm/module'
end

def reload!
  load 'raumod.rb'
  Dir['xm/*.rb'].each do |f|
    load f
  end
end
def loadmod!
  File.open('morbcastle.xm','rb') do |f|
    @mod = f.read
  end
  nil
end
