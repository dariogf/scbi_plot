$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'scbi_plot/plot'
require 'scbi_plot/histogram'
require 'scbi_plot/lines'


module ScbiPlot
   VERSION = '0.0.6'
end
