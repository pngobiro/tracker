class Movement < ActiveRecord::Base
before_save :insert_createdby, :if => :new_record? 
after_save :send_sms,:unless => :empty_phone
  belongs_to :casefile
  #validates :takenby,:presence => true
 validates :to,:presence => true  
 validates :officer,:presence => true
 validates :reason,:presence => true
 validates :category,:presence => true,:length => { :minimum => 5 }


 attr_accessible :casestatusaftermovement, :date, :datein, :dateofresult, :from, :category,:officer, :reason,:result_reason,:reasonforadjournment, :recordcreatedby, :recordupdatedby, :remarks, :tel,:results, :station, :takenby, :time, :to

scope :none, lambda { where(:id => -1)}
def insert_createdby
self.recordcreatedby = User.current_user.username
end
def empty_phone
 casefile.mobile_num.blank?
end

def update_case_status
@casefile.casestatus = self.casestatusaftermovement
end

def self.options_for_officers
self.uniq.pluck(:officer)
end

def self.options_for_category
self.uniq.pluck(:category)
end

def self.options_for_destination
self.uniq.pluck(:to)
end
# Categories in Batch Form
def self.categories
['Approvals','Signing of Grants','Gazettement','Certifications']
end

def self.reasons
['Going for Matter Approval','Going for Signing of Grant','Going for Gazettement','Going for Certification']
end

def self.outcome
['Matter Approved','Matter Not Approved','Grant Signed','Matter Gazzeted', 'Matter Certified']
end

def self.options_for_category
Movement.pluck(:category).uniq
end


def send_sms
# Include the helper gateway class
require_relative './AfricasTalkingGateway'

# Specify your login credentials
username = "pngobiro";
apikey   = "7e6a7c28a6e347199d24bcae67b3d00bfde4ac899279d45b17bb889b2b35f8ca";

# Specify the numbers that you want to send to in a comma-separated list
# Please ensure you include the country code (+254 for Kenya in this case)
to      = casefile.mobile_num

# And of course we want our recipients to know what we really do
self.results = results.titleize
self.officer = officer.titleize
self.remarks= remarks.titleize
self.station = station.titleize
collection_message = 'Kindly Collect It'
correction_message = 'Kindly Make The Necessary Corrections'
case self.category
when "Gazzetment"
if results.blank?
 message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase},Matter taken to Goverment Printers for Gazzetment."
else
message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase},#{self.results} on #{self.dateofresult}"
end
when "Signing of Grants"
if result_reason.empty?
message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase},#{self.results} on #{self.dateofresult} by  #{officer}. #{collection_message}"
else
message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase},#{self.results}.Reason for Rejection: #{result_reason.titleize}. #{correction_message}"
end
when "Approvals" 
if results.empty?
message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase},#{self.results} Your Matter is pending Approval by Deputy Registrar"
else
message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase},#{self.results}"
end
if  result_reason.present? 
message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase},#{self.results}.Reason for Rejection: #{result_reason.titleize}. #{correction_message}"
end
else 
message = "#{station} Division ,Case Number #{casefile.casenumber},Deceased: #{self.casefile.parties_names.upcase}. Taken for #{self.reason} on #{self.date} . #{self.results}  #{self.dateofresult}"
end


# Create a new instance of our awesome gateway class
gateway = AfricasTalkingGateway.new(username, apikey)

# Any gateway errors will be captured by our custom Exception class below,
# so wrap the call in a try-catch block
begin
from = "HIGH_COURT"
  # Thats it, hit send and we'll take care of the rest.
  reports = gateway.send_message(to, message,from)
  reports.each {|x|
    # Note that only the Status "Success" means the message was sent
#    puts 'number=' + x.number + ';status=' + x.status + ';messageId=' + x.messageId + ';cost=' + x.cost

  }
Sm.new do |c|
c.station = self.station
c.sentmessage = message
c.number = to
c.save
end

rescue AfricasTalkingGatewayError => ex
  puts 'Encountered an error: ' + ex.message
end

# DONE!
end
end

