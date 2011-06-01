class Raumod::XM::Sample
  require 'buffer_mapper'
  include Raumod::BufferMapper
  LoopTypes= [:noloop,:forward,:pingpong,:noloop]  
  HeaderMap={
    :size=>{:offset=>0,:type=>'V'},
    :loop_start=>{:offset=>4,:type=>'V'},
    :loop_end=>{:offset=>8,:type=>'V'},
    :volume=>{:offset=>12,:type=>'C'},
    :fine_tune=>{:offset=>13,:type=>'C'},
    :sample_type=>{:offset=>14,:type=>'C'},
    :panning=>{:offset=>15,:type=>'C'},
    :relative_note=>{:offset=>16,:type=>'c'},
    :reserved=>{:offset=>17,:type=>'C'},
    :name=>{:offset=>18,:type=>'A22'}
    
  }
  
  attr_accessor :sample_data
  
  def initialize(data)
    @data=data
    @data_map=HeaderMap
    @data=data[0..39]
  end
  
  def inspect
    "#<Raumod::XM::Sample name='#{name}' size='#{size}'>"
  end
  def bitrate
    ((sample_type >> 2) & 0x1) == 1 ? 16 : 8 
  end
  def loop
    LoopTypes[sample_type & 0x3]
  end
end
