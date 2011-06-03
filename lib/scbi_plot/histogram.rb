require 'gnuplot'

# = scbi_plot - Ploting utilities
#
# Plots a graph using gnuplot.
#
# =Usage:
# p=ScbiPlot::Histogram.new('few_strings.png','titulo')
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
module ScbiPlot

  class Histogram < ScbiPlot::Plot


    def initialize(file_name,title=nil)
      super
      @line_width=4
      @show_leyend=false
    end

    def do_graph
      setup_data
      # $VERBOSE=false

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

            if @x_range.empty?
              if @x.min==@x.max
                @x.first.class
                # puts "MISMO MIN MAX"
                xrange="[#{@x.min-1}:#{@x.max+1}]"
              else
                xrange="[#{@x.min}:#{@x.max}]"
              end
              
              
              plot.xrange xrange
              plot.x2range xrange
            else
              plot.xrange @x_range
              plot.x2range @x_range
            end

            if !@y_range.empty?
              plot.yrange @y_range
            end
            
            plot.style "fill  pattern 22  border -1"
            plot.set "boxwidth 0.2" # Probably 3-5.

            plot.data << Gnuplot::DataSet.new( [@x, @y] ) do |ds|
              ds.with=  " imp lw #{@line_width}"
            end

          else #graph with strings in X axis
            # $VERBOSE=true
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



  #   def setup_data
  #     if @x.length != @y.length
  #       raise "Variables x and y have different sizes"
  # 
  #     else
  # 
  #       hash=xy_to_hash(@x,@y)
  #       # puts hash
  #       # sort integer data
  #       if !contains_strings?(@x)
  # 
  #         @x.sort!
  #         @y=[]
  # 
  #         @x.each do |v|
  #           @y.push hash[v].to_i
  #         end
  # 
  # 
  #       else # there are strings in X
  #         @x=[]
  #         @y=[]
  # 
  #         # save quoted values
  #         hash.keys.each do |v|
  #           @x.push "\"#{v.gsub('\"','').gsub('\'','')}\""
  #           @y.push hash[v.to_s]
  #         end
  # 
  #         # check if there is a lot of string data
  #         check_data_limit
  # 
  #       end
  #     end
  #   end
  # 
  # 
    end
end
