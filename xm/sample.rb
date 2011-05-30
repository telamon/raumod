class Raumod::XM::Sample
  def initialize
  end
  def load_bin(data)
    header_length= data.unpack('V').first
    @header=data[0..header_length]
    sample_length=data[header_length..-1].unpack('V').first
    header_length+sample_length
  end
end
