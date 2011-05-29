class Raumod::XM::Pattern
  attr_accessor :channels
  def initialize(channels=4)
    @channels=channels.times.map{[]}
  end
  def load_bin(data)
    header_length= data.unpack('V').first
    pack_type, rows, data_length = data[4..header_length].unpack('Cvv')
    puts "Pattern header length: #{header_length}"
    puts "ptype: #{pack_type} rows: #{rows} data_length:#{data_length}"
    raise 'Unknown pattern packing type!' unless pack_type == 0    
    if data_length > 0
      @channels.count.times do |c|
        rows.times do |r|
          note_offset = header_length + c*r*5
          note = Raumod::XM::Note.new          
          flags = 0x1f
          if (data[note_offset] & 0x80) != 0 # Some undocumented arbitrary extension?
            flags = data[note_offset]
            note_offset+=1
          end
          nbin= data[note_offset..note_offset+4].map do |b|
            c=(flags & 1) > 0 ? b : 0
            flags=flags>>1            
          end
          puts "Notebin: #{nbin.class}:#{nbin}"
          note.key , note.instrument, note.volume,
          note.volume_column ,note.effect, note.param = nbin.flatten!.unpack('CCCCC')        
          
          @channels[c] << note
        end
      end
    end
    header_length+data_length
  end
end
