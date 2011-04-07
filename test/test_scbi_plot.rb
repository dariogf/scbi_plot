require File.dirname(__FILE__) + '/test_helper.rb'

require 'scbi_plot/plot'

class TestScbiPlot < Test::Unit::TestCase

  def setup
        
  end
  
  def test_few_strings
    p=Plot.new('few_strings.png','titulo')
    
    p.add_x(['a','b','c'])
    p.add_y([10,20,30])
    
    p.do_graph

    assert(File.exists?('few_strings.png'))
  end
  
  def test_lot_of_strings
    p=Plot.new('lot_of_strings.png','titulo')
    
    p.add_x(('a'..'z').to_a)
    p.add_y((1..p.x.length).to_a)
    
    p.do_graph

    assert(File.exists?('lot_of_strings.png'))
  end
  
  def test_histogram
    p=Plot.new('histogram.png','titulo')
    
    x=[]
    y=[]
    
    1000.times do |i|
      x.push i
      y.push i+(rand*50).to_i
    end
    
    p.add_x(x)
    p.add_y(y)
    
    p.do_graph

    assert(File.exists?('histogram.png'))
  end
  
  
  def test_sizes
    p=Plot.new('bad.png','titulo')
    
    p.add_x([4,3])
    p.add_y([10,20,30])

    assert_raise( RuntimeError ) { p.do_graph }

    assert(!File.exists?('bad.png'))
    
  end
end
