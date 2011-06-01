module Raumod::BufferMapper
  def data_map;@data_map;end
  def data;@data;end
  def data_entry(method)
    offset = data_map[method][:offset]
    type = data_map[method][:type]    
    d = data[offset..-1].unpack(type)
    if d.count > 1
      d
    else
      d.first
    end
  end
  def method_missing(method,*args)      
    if data_map[method]
      data_entry(method)
    else
      raise "No such method: #{method}"
    end
  end    
end
