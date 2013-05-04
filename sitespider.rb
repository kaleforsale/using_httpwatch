require 'win32ole'	# used to drive HttpWatch
require 'watir' 		# the WATIR framework
require 'yaml'


class Sitespider
	attr_accessor :url, :totalTime, :receivedBytes, :compressionSavings, :roundTrips, :numberErrors

	def initialize(url)
		@url=url
		
		puts @url
		if @url.empty?
			exit
		end

	
	end


	def start_test
		# Create HttpWatch
		control = WIN32OLE.new('HttpWatch.Controller')
		httpWatchVer = control.Version
		if httpWatchVer[0...1] == "4" or httpWatchVer[0...1] == "5"
			puts "\nERROR: You are running HttpWatch #{httpWatchVer}. This sample requires HttpWatch 6.0 or later. Press Enter to exit...";  $stdout.flush
	gets
		end  #end of if statement
 
	# Use WATIR to start IE
	ie = Watir::Browser.new :ie
	#ie.logger.level = Logger::ERROR

	# Attach HttpWatch to IE
	plugin = control.ie.Attach(ie.ie)

	# Start Recording HTTP traffic
	plugin.Clear()
	plugin.Log.EnableFilter(false)
	plugin.Record()

	# go to the site

	ie.goto(@url)
	#stop recording http data in HttpWatch
	plugin.Stop()

	#display summary statistics

	summary = plugin.Log.Entries.Summary

    @totalTime = summary.Time
    @receivedBytes = summary.BytesReceived
    @compressionSavings = summary.CompressionSavedBytes
    @roundTrips = summary.RoundTrips
    @numberErrors = summary.Errors.Count





	#close down ie
	plugin.Container.Quit()

		
	end



  ########################

def create_graph(file_name)



  currentTime = Time.now
  monthDayYear = currentTime.strftime("%b-%d-%Y")
  hourMinute = currentTime.strftime("%I:%M%p")

  dateTimes = []
  if File.exists?("#{file_name}.times.yaml")
    dateTimes = YAML.load_file("#{file_name}.times.yaml")
  end

  File.open("#{file_name}.times.yaml", 'w') do |out|
    dateTimes << hourMinute
    YAML.dump dateTimes, out
  end

  responses = []
  if File.exists?("#{file_name}.responsetimes.yaml")
    responses = YAML.load_file("#{file_name}.responsetimes.yaml")
  end

  File.open("#{file_name}.responsetimes.yaml", 'w') do |out|
    responses << @totalTime
    YAML.dump responses, out
  end

  categoryString = "categories:["
  dateTimes.each do |testTime|
    categoryString= categoryString + "'#{testTime}',"
  end
  categoryString = categoryString + "]"
  puts categoryString


  responseTimes = "data: ["
  responses.each do |response|
    responseTimes = responseTimes + "#{response},"
  end
  responseTimes = responseTimes + "]"
  puts responseTimes



#categoryString = "categories: ['', '10:10pm', '10:10pm', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
#data: [29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
#only works for paid software
#printf "Time for dns lookups:		%d\n", timingsummary.DNSLookup $


#create html using jquery highcharts library

  newfile = File.new("#{file_name}.browsing.html", 'w')
  newfile.puts("<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js\"></script>")
  newfile.puts("<script src=\"http://code.highcharts.com/highcharts.js\"></script>")

  newfile.puts("<div id=\"container\"></div>")

  newfile.puts("<script>$(function () {
  $('#container').highcharts({
                                title: { text: 'HTTP Synthetic Transactions for #{@url}'},
                                 chart: {
                                 },
                                yAxis:{
                                  title: {text: 'Seconds'},
                                  gridLineWidth: 1,
                                  labels:{
                                      formatter: function() {
                                        return this.value + ' sec';
                                      }
                                },
                                },
                                 xAxis: {
                                     title: {text: 'Time'},
                                    #{categoryString}
                                 },

                                 series: [{
                                              name: '#{@url}',
                                              #{responseTimes}
                                          }]
                             });
});</script>"         );






  newfile.close



=begin
    puts "Current Month: #{monthDayYear}"
    puts "Current Time: #{hourMinute}"
    printf "Total time to load page (secs):      %.3f\n", visit_site.totalTime
    printf "Number of bytes received on network: %d\n", visit_site.receivedBytes
    printf "HTTP compression saving (bytes):     %d\n", visit_site.compressionSavings
    printf "Number of round trips:               %d\n",  visit_site.roundTrips
    printf "Number of errors:                    %d\n", visit_site.numberErrors

=end



end

end



