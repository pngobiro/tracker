class TrackerPdf < Prawn::Document
	def initialize(casefile)
   	super()

	header
	case_details
	end
def header
	text "Generated on #{Time.now}", size: 12, style: :bold ,:align => :right,:color => "00FF00"
        move_down 15
 	text "HIGH COURT OF KENYA", size: 20, style: :bold ,:align => :center,:color => "00FF00"
        text "current_user.station", size: 15, style: :bold ,:align => :center,:color => "0000FF"
        text  "#{@casefile.casenumber}", size: 12, style: :bold,:align => :center,:color => "0000FF"
end
def case_details
text "case Number \##@casefile.casenumber"

end
     
end

