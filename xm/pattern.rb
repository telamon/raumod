class Raumod::XM::Pattern
  require 'buffer_mapper'
  include Raumod::BufferMapper
  
  HeaderMap = {
    :header_size=> {:offset=>0,:type=>'V'},
    :packing_type=> {:offset=>4,:type=>'C'},
    :row_count=>{:offset=>5,:type=>'v'},
    :data_size=>{:offset=>7,:type=>'v'}
  }
  def initialize(data)
    @data=data
    @data_map=HeaderMap
    @data=data[0..byte_size] #slice off unecessary data.
  end
  def byte_size
    header_size+data_size
  end
  
  def inspect
    %Q{#<Raumod::XM::Pattern rows="#{row_count}">}
  end
#  def load_bin(data)
#    header_length= data.unpack('V').first
#    pack_type, rows, data_length = data[4..header_length].unpack('Cvv')
#    puts "Pattern header length: #{header_length}"
#    puts "ptype: #{pack_type} rows: #{rows} data_length:#{data_length}"
#    raise 'Unknown pattern packing type!' unless pack_type == 0    
#    off=header_length
#    if data_length > 0
#      @channels.count.times do |c|
#        rows.times do |r|
#          
#          note = Raumod::XM::Note.new          
#          flags = 0x1f
#          if (data[off] & 0x80) != 0 # pattern compression?
#            flags = data[off]
#            off+=1
#          end
#          nbin=''
#          5.times do |b|
#            if (flags & 1) > 0
#              nbin << data[off]
#              off+=1
#            else
#              nbin << [0x0].pack('C')
#            end
#            flags=flags>>1            
#          end          
#          note.key , note.instrument, note.volume,
#          note.volume_column ,note.effect, note.param = nbin.unpack('CCCCC')                  
#          @channels[c] << note
#        end
#      end
#    end
#    header_length+data_length
#  end
end
