require File.dirname(__FILE__) + '/test_helper.rb'

require 'scbi_plot/plot'

class TestScbiPlot < Test::Unit::TestCase

  def setup
        
  end
  
  def test_few_strings
    p=ScbiPlot::Histogram.new('few_strings.png','titulo')
    
    p.add_x(['a','b','c'])
    p.add_y([10,20,30])
    
    p.do_graph

    assert(File.exists?('few_strings.png'))
  end
  
  def test_lot_of_strings
    p=ScbiPlot::Histogram.new('lot_of_strings.png','titulo')
    
    p.add_x(('a'..'z').to_a)
    p.add_y((1..p.x.length).to_a)
    
    p.do_graph

    assert(File.exists?('lot_of_strings.png'))
  end
  
  def test_histogram
    p=ScbiPlot::Histogram.new('histogram.png','titulo')
    
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

  def test_lines
    p=ScbiPlot::Lines.new('lines.png','titulo')
    
    x=[]
    y=[]
    y2=[]
    y3=[]
    
    10.times do |i|
      x.push i*10
      y.push i+(rand*50).to_i
      y2.push i+(rand*50).to_i
      y3.push i+(rand*50).to_i
    end
    p.x_range='[0:100]'
    p.add_x(x)
    # p.add_y(y)
    p.add_series('serie0', y)
    p.add_series('serie1', y2, 'points')
    p.add_series('serie2', y3,'impulses',4)
    
    
    p.add_vertical_line('pos',5)
    
    p.do_graph

    assert(File.exists?('lines.png'))
  end

  
  
  def test_sizes
    p=ScbiPlot::Histogram.new('bad.png','titulo')
    
    p.add_x([4,3])
    p.add_y([10,20,30])

    assert_raise( RuntimeError ) { p.do_graph }

    assert(!File.exists?('bad.png'))
    
  end
end
