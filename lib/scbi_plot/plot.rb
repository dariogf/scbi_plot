require 'gnuplot'

# = scbi_plot - Ploting utilities
# 
# Plots an histogram using gnuplot.
# 
# =Usage:
# p=Plot.new('few_strings.png','titulo')
# 
# p.add_x(['a','b','c'])
# p.add_y([10,20,30])
# 
# p.do_graph
# 
# =Tips
# * scbi_plot can handle integer and string values in x row
# * If x and y are integer values, the graph is sorted by x (ascendent values from left to right)
# * When x contains strings:
#     -if number of elements in x is greater than x_limit (by default 20), values are sorted in descendant order, and only @x_limit values are plotted 
#     -if number of elements is below x_limit, then values are shown as an histogram

class Plot

  attr_accessor :title,:file_name,:x_label,:y_label,:x_limit,:x, :y

  def initialize(file_name,title=nil)

    @x=[]
    @y=[]
    @x_label='x'
    @y_label='y'

    @title=title
    @file_name=file_name

    if @title.nil?
      @title=file_name
    end
    
    @x_limit=20

  end

  def add_x(x)
    @x=x
  end
  
  def add_y(y)
    @y=y
  end


  def add_xy(data)
    @x=[]
    @y=[]
    
    if data.is_a?(Array)
      
      data.each do |e|
        @x.push e[0]
        @y.push e[1]
      end
      
    elsif data.is_a?(Hash)
      
      data.each do |k,v|
        @x.push k
        @y.push v
      end
      
    end
  end


  def do_graph
    setup_data
    $VERBOSE=false

    Gnuplot.open do |gp|
      # histogram
      Gnuplot::Plot.new( gp ) do |plot|

        if !title
          title=file_name
        end

        plot.title "#{@title}"
        plot.xlabel @x_label
        plot.ylabel @y_label

        if !@show_leyend
          plot.set "key off" #leyend
        end

        # x values are integers
        if !contains_strings?(@x)
          plot.style "fill  pattern 22  border -1"
          plot.set "boxwidth 0.2" # Probably 3-5.

          plot.data << Gnuplot::DataSet.new( [@x, @y] ) do |ds|
            ds.with=  " imp lw 4"
          end

        else #graph with strings in X axis
          plot.xlabel ""

          plot.set "style fill solid 1.00 border -1"
          plot.set "style histogram clustered gap 1 title offset character 0, 0, 0"
          plot.set "style data histogram"
          plot.set "boxwidth 0.2 absolute"

          if @x.count>4 then
            plot.set "xtics offset 0,graph 0 rotate 90"
          end

          plot.data << Gnuplot::DataSet.new( [@x,@y] ) do |ds|
            ds.using = "2:xticlabels(1)"   #show the graph and use labels at x
          end

        end

        if !file_name.nil?
          plot.terminal "png size 800,600"
          plot.output "#{@file_name}"
        end
      end
    end
  end


  def xy_to_hash(x,y)
      h={}
      
      x.each_with_index do |x1,i|
        h[x1]=y[i]
      end
      
      return h
      
  end

  def check_data_limit
    # if more than 20 strings, then keep greater ones
    if @x.count>@x_limit
      h = xy_to_hash(@x,@y)

      @x=[]
      @y=[]

      @x_limit.times do
        ma=h.max_by{|k,v| v}
        if ma
          @x.push ma[0]
          @y.push ma[1]
          h.delete(ma[0])
        end
      end
      
    end
    
  end

  def setup_data
    if @x.length != @y.length
      raise "Variables x and y have different sizes"
      
    else
      
      hash=xy_to_hash(@x,@y)
      # puts hash
      # sort integer data 
      if !contains_strings?(@x)
      
        @x.sort!
        @y=[]
      
        @x.each do |v|
          @y.push hash[v].to_i
        end
        
      
      else # there are strings in X
        @x=[]
        @y=[]
      
        # save quoted values 
        hash.keys.each do |v|
          @x.push "\"#{v.gsub('\"','').gsub('\'','')}\""
          @y.push hash[v.to_s]
        end

        # check if there is a lot of string data
        check_data_limit
      
      end
    end
  end

  def contains_strings?(x)
    contains_strings=false

    x.each do |v|
      begin
        r=Integer(v)
      rescue
        contains_strings=true
        break
      end
    end

    return contains_strings
  end


end
