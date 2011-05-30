class Raumod::XM::Sample
  include Raumod::HeaderReader
  def header_map
    {
      :sample_length => {:offset=>0,:type=>'V'}
    }
  end
  def initialize
  end
  def load_header_bin(data)
    header_length =18 #= data.unpack('V').first
    @header=data[0..header_length]    
    header_length
  end
  def load_data_bin(data)
    sample_length
  end
end
