module Raumod::BufferMapper
  
  def data_map
  end
  
  def data_entry(ofty)    
    offset = ofty[:offset]
    type = ofty[:type]    
    if type == 's22'
      @data[offset..offset+21].gsub("\000",'')
    elsif type == 'C'
      @data[offset..-1].unpack('C').first
    elsif type == 'v'
      @data[offset..-1].unpack('v').first
    elsif type == 'V'
      @data[offset..-1].unpack('V').first      
    end
  end
  def method_missing(method,*args)      
    if data_map[method]
      data_entry(data_map[method])
    else
      raise "No such method: #{method}"
    end
  end    
end
