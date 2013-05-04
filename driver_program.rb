# have to install nokogiri gem, ruby installer for windows, the devkit for the rubyinstaller

require_relative 'sitespider'
require 'yaml'

visit_site = Sitespider.new("www.yahoo.com")

# use httpwatch and then return times into Sitespider instance variables
visit_site.start_test

# creates yaml persistent storage to store time of tests and response times
# want to use different yaml files for each different site visited
visit_site.create_graph("yahoo")

puts "graph will be in file_name.browsing.html"


###########################################################################################################

anotherSite = Sitespider.new("www.google.com")
anotherSite.start_test
anotherSite.create_graph("google")

# store datetimes and previous response times using yaml

############################################################################################################

cnnSite = Sitespider.new("www.cnn.com")
cnnSite.start_test
cnnSite.create_graph("cnn")

# store datetimes and previous response times using yaml



