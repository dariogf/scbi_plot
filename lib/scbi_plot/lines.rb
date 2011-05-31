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

  class Lines < ScbiPlot::Plot


    def initialize(file_name,title=nil)
      super
      @series=[]
      @line_width=2
      @show_leyend=true
      @vertical_lines=[]



    end

    def add_series(title, y_data, graph_type ='lines',line_width=nil)
      @series << {:title => title, :data=> y_data, :graph_type=>graph_type, :line_width=>(line_width || @line_width)}
    end

    def add_vertical_line(title,x_value)
      @vertical_lines << {:title => title, :x_value=> x_value}
    end

    def do_graph
      setup_data
      $VERBOSE=true

      Gnuplot.open do |gp|
        # histogram
        Gnuplot::Plot.new( gp ) do |plot|

          if !title
            title=file_name
          end

          plot.title "#{@title}"
          plot.xlabel @x_label
          plot.ylabel @y_label
          plot.xrange "[#{@x.min}:#{@x.max}]"
          plot.x2range "[#{@x.min}:#{@x.max}]"
          # plot.x2range "auto"

          if !@show_leyend
            plot.set "key off" #leyend
          end

          # x values are integers
          if contains_strings?(@x)
            raise "Line plots cannot have strings in x axis"
          end

          # plot.style "fill pattern 22 border -1"
          # plot.set "boxwidth 0.2" # Probably 3-5.
          if !@vertical_lines.empty?
            x2ticks =[]
            @vertical_lines.each do |v_line|

              x2ticks << "'#{v_line[:title]} (#{v_line[:x_value]})' #{v_line[:x_value]}"
            end

            plot.set "x2tics (#{x2ticks.join(', ')})"
            plot.set 'grid noxtics x2tics lt rgb "green"'
          end

          @series.each do |series|
            plot.data << Gnuplot::DataSet.new( [@x, series[:data]] ) do |ds|

              ds.with =  series[:graph_type]
              ds.linewidth = series[:line_width]
              ds.title = series[:title]

            end

          end

          if !file_name.nil?
            plot.terminal "png size 800,600"
            plot.output "#{@file_name}"
          end
        end
      end
    end



    def setup_data
      @series.each do |series|
        if @x.length != series[:data].length
          raise "Variables x and y have different sizes in serie #{series[:name]}"
        end
      end
    end


  end
end
