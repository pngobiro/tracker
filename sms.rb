# Include the helper gateway class
require './AfricasTalkingGateway'

# Specify your login credentials
username = "pngobiro";
apikey   = "7e6a7c28a6e347199d24bcae67b3d00bfde4ac899279d45b17bb889b2b35f8ca";

# Specify the numbers that you want to send to in a comma-separated list
# Please ensure you include the country code (+254 for Kenya in this case)
to      = "+254718952129";

# And of course we want our recipients to know what we really do
#self.results = results.titleize
#self.dateofresult = date
#self.officer = officer.titleize
#self.remarks= remarks.titleize
#self.station = station.titleize
#message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased #{casefile.parties_names},#{results} on #{date} by #{officer}.#{remarks}"
message = 'Patrick Ngobiro CentOS'
# Create a new instance of our awesome gateway class
gateway = AfricasTalkingGateway.new(username, apikey)

# Any gateway errors will be captured by our custom Exception class below,
# so wrap the call in a try-catch block
begin
  # Thats it, hit send and we'll take care of the rest.
  reports = gateway.send_message(to, message)
  reports.each {|x|
    # Note that only the Status "Success" means the message was sent
#    puts 'number=' + x.number + ';status=' + x.status + ';messageId=' + x.messageId + ';cost=' + x.cost
  }
rescue AfricasTalkingGatewayError => ex
  puts 'Encountered an error: ' + ex.message
end

# DONE!
