class ApplicationController < ActionController::Base
	protect_from_forgery
	
	def rdf_to_mongo_model(s)
		s.to_s.split("#")[1].split("/")[0].capitalize.constantize
	end
	
	def rdf_to_mongo_id(s)
		s.to_s.split("#")[1].split("/")[1]
	end
	
	def mongo_model_to_spira_model(m)
	 "#{m.capitalize}Rdf".constantize.type
	end
end
