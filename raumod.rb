module Raumod
  module XM; end; # http://16-bits.org/xm/
  require 'buffer_mapper'
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
