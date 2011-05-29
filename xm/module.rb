class Micromod::XM::Module
  attr_accessor :song_name, :num_channels,:num_instruments, :num_patterns,
  :sequence_length, :restart_pos, :default_speed, :default_tempo, :linear_periods,
  :sequence, :patterns, :instruments
  def initialize(data=nil)
    @song_name = "Blank"
		@num_channels = 4
		@num_instruments = 1
		@num_patterns = 1
		@sequence_length = 1
		@default_speed = 6
		@default_tempo = 125
		@sequence = []		
		@patterns = [] #[Pattern.new]
		#@pattern.num_rows = 64
		#@pattern.data = [] #[ pattern.num_rows * num_channels * 5 ]
		@instruments =[]#[Instrument.new]# new Instrument[ num_instruments + 1 ];
		#instruments[ 0 ] = instruments[ 1 ] = new Instrument(); 
		load_mod data if data
  end
  
  def load_mod(data)
    raise 'Not an XM file!' unless data[0..16].match(/^Extended Module: /)
    raise 'XM format version must be 0x0104' unless ushort(data,58) == 0x104
    delta_env = data[38..57] == 'DigiBooster Pro'
    header = data[60..79].unpack('Vvvvvvvvv')
    offset = 60 + header[0]    
    @sequence_length ,@restart_pos,@num_channels,@num_patterns,@num_instruments,
    @linear_periods, @default_speed,@default_tempo= header[1..-1]
    @sequence = []
    @sequence_length.times do |i|
      entry = data[80+i] & 0xff
      @sequence[i] = entry < num_patterns ? entry : 0      
    end
    @patterns=[]
    @num_patterns.times do |i|
      pattern = @patterns[i] = Module::XM::Pattern.new
      raise 'Unknown pattern packing type!' unless data[offset+4] = 0
      pattern.num_rows = ushort(data,offset+5)
      patlen = urshort(data,offset+7)
      num_notes = pattern.num_rows * @num_channels
      offset += intle(data,offset)
      if patlen > 0
      end
    end
  end
  private
  
  def ushort(data,offset)
    data[offset..offset+1].unpack('v')[0]
  end
  
  def intle(data,offset)
    data[offset..offset+3].unpack('V')[0]
  end
  
end
