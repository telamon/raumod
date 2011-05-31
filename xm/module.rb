class Raumod::XM::Module
  #require 'xm/pattern'
  #require 'xm/instrument'
  require 'buffer_mapper'
  
  include Raumod::BufferMapper
  
  def data_map
    { 
      :id_text=>{ :offset=> 0, :type=>'s17'},
      :name=>{:offset=>17,:type=>'s20'},
      :'1a' => {:offset=> 37, :type=>'C'},
      :tracker_name=>{:offset=>38,:type=>'s20'},
      :version=> {:offset=> 58, :type=> 'v'},
      :header_size=>{:offset=> 60,:type=>'V'},
      :song_length=>{:offset=> 64,:type=>'v'},
      :restart_position=>{:offset=> 66 ,:type=>'v'},
      :channel_count=>{:offset=> 68 ,:type=>'v'},
      :pattern_count=>{:offset=> 70 ,:type=>'v'},
      :instrument_count =>{:offset=> 72 ,:type=>'v'},
      :flags =>{:offset=> 74 ,:type=>'v'},
      :default_tempo=>{:offset=> 76 ,:type=>'v'},
      :default_bpm=>{:offset=> 78 ,:type=>'v'}
      
      
    }
  end
  
  def initialize(data=nil)
    @data= data || "Extended Module: "
    raise 'Not an XM file!' unless data[0..16].match(/^Extended Module: /)
    
  end
  
  
  
  ## VÄCK! 
  def load_mod(data)
    
    @song_name = data[17..36].gsub("\000",'')
    raise 'XM format version must be 0x0104' unless ushort(data,58) == 0x104
    delta_env = data[38..57] == 'DigiBooster Pro'
    header = data[60..79].unpack('Vvvvvvvvv')
    data_offset = 60 + header[0]    
    @sequence_length ,@restart_pos,@num_channels,@num_patterns,@num_instruments,
    @linear_periods, @default_speed,@default_tempo= header[1..-1]
    @sequence = []
    @sequence_length.times do |i|
      entry = data[80+i] & 0xff
      @sequence[i] = entry < num_patterns ? entry : 0      
    end
    @patterns=[]
    bytes_read=data_offset
    @num_patterns.times do |i|      
      pattern = Raumod::XM::Pattern.new
      puts "Loading pattern @#{bytes_read}"
      bytes_read+=pattern.load_bin(data[bytes_read..-1])
      @patterns << pattern      
    end
    @instruments=[]
    @num_instruments.times do |i|
      instrument = Raumod::XM::Instrument.new
      puts "Loading Instrument @#{bytes_read}"
      bytes_read+=instrument.load_bin(data[bytes_read..-1])
      @instruments << instrument
    end
    nil
  end
  private
  
  def ushort(data,offset)
    data[offset..offset+1].unpack('v')[0]
  end
  
  def intle(data,offset)
    data[offset..offset+3].unpack('V')[0]
  end
  
end
