class Raumod::XM::Instrument
  require 'buffer_mapper'
  include Raumod::BufferMapper  
  HeaderMap={
    :header_size=>{:offset=>0,:type=>'V'},
    :name=>{:offset=>4,:type=>'A22'},
    :instrument_type=>{:offset=>26,:type=>'C'},
    :sample_count=>{:offset=>27,:type=>'v'}
  }
  ExtendedHeaderMap={
    :sample_header_size=>{:offset=>29,:type=>'V'},
    :note_map => {:offset => 33, :type=> 96.times.map{'C'}.join },
    :volume_points => {:offset => 128, :type=> 48.times.map{'C'}.join },
    :panning_points => {:offset => 177, :type=> 48.times.map{'C'}.join },
    :volume_point_count =>{:offset=>225,:type=>'C'},
    :panning_point_count=>{:offset=>226,:type=>'C'},
    :volume_sustain_point=>{:offset=>227,:type=>'C'},
    :volume_loop_start=>{:offset=>228,:type=>'C'},
    :volume_loop_end=>{:offset=>229,:type=>'C'},
    :panning_sustain_point=>{:offset=>230,:type=>'C'},
    :panning_loop_start=>{:offset=>231,:type=>'C'},
    :panning_loop_end=>{:offset=>232,:type=>'C'},
    :volume_type=>{:offset=>233,:type=>'C'},
    :panning_type=>{:offset=>234,:type=>'C'},
    :vibrato_type=>{:offset=>235,:type=>'C'},
    :vibrato_sweep=>{:offset=>236,:type=>'C'},
    :vibrato_depth=>{:offset=>237,:type=>'C'},
    :vibrato_rate=>{:offset=>238,:type=>'C'},
    :volume_fadeout=>{:offset=>239,:type=>'v'},
    :reserved=>{:offset=>241,:type=>'v'}
  }
  def inspect
    "#<Raumod::XM::Instrument name='#{name}' sample_count='#{sample_count}'>"
  end
  attr_accessor :samples
  def initialize(data)    
    @data=data
    @data_map=HeaderMap
    @data_map=HeaderMap.merge(ExtendedHeaderMap) unless empty?
    #@data=data[0..header_size] #slice off unrelated data.
    
    #load samples
    offset=0
    @samples=[]
    sample_count.times do|i|
      # Map sample header
      shoff= header_size + i*40      
      sample = Raumod::XM::Sample.new(data[shoff..-1])
      # Slice sample data      
      sdoff= header_size + sample_header_size + offset
      sample.sample_data = data[sdoff..sdoff+sample.size-1]
      offset+=sample.size
      @samples << sample
    end
  end  
  
  def empty?
    sample_count == 0
  end
  
  def sample_header_size
    if empty?
      0
    else
      data_entry(:sample_header_size)
    end
  end
  
  def byte_size
    s=header_size+sample_header_size  
    samples.each{|i| s+=i.size}
    s
  end
  Envelope = 0x1
  Sustain = 0x2
  Loop = 0x4
  def volume_type?(mask)
    volume_type & mask == mask
  end
  def volume_envelope_enabled?
    volume_type & 0x1 == 1
  end
  def volume_sustain_enabled?
    (volume_type >> 1) & 0x1 == 1
  end
  def volume_loop_enabled?
    (volume_type >> 2) & 0x1 == 1
  end
  def panning_envelope_enabled?
    panning_type & 0x1 == 1
  end
  def panning_sustain_enabled?
    (panning_type >> 1) & 0x1 == 1
  end
  def panning_loop_enabled?
    (panning_type >> 2) & 0x1 == 1
  end  
end
