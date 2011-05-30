class Raumod::XM::Instrument
  include Raumod::HeaderReader
  attr_accessor :samples
  def header_map 
    {
      :name=>{:offset=>4,:type=>'s22'},
      :instrument_type=>{:offset=>26,:type=>'C'},
      :sample_count=>{:offset=>27,:type=>'v'}
    }
  end
  
  def inspect
    "#<Raumod::XM::Instrument name='#{name}' sample_count='#{sample_count}'>"
  end
  def initialize
      
  end
  
  def load_bin(data)
    header_length= data.unpack('V').first
    puts "Header_length= #{header_length}"
    @header=data[0..header_length]
    off=header_length
    puts "SampleCount:" + sample_count.to_s
    @samples=[]
    sample_count.times do |i|
      sample = Raumod::XM::Sample.new
      off+=sample.load_bin(data[off..-1])
      @samples << sample
    end
    puts "returning with #{off}"
    off
  end
end
