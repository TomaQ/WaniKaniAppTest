class UsersController < ApplicationController

  before_action :authenticate_user!

  def apiRequest(text)
    #user_key = "e43fbfacc061aea6adbfda140cc3e752" #put somewhere else

    response_json = HTTParty.get("https://www.wanikani.com/api/v1.2/user/#{current_user.api_key}/#{text}")
    begin
      my_hash = JSON.parse response_json.to_json, symbolize_names: true
    rescue
      redirect_to "/error"
    end
    return my_hash
  end

  def responseCheck(r)
    if r.nil?
      redirect_to "error"
    end
  end

	def index
    response = apiRequest("kanji") #every api call returns user_information
    responseCheck(response)
    @username = response[:user_information][:username]
		@kanjiList = response[:requested_information]

    response = apiRequest("vocabulary")
    responseCheck(response)
    @vocabList = response[:requested_information]
	end

  def error
  end

  def changeApiKey
    current_user.api_key = params[:apiKey]
  end

  #put these helper methods in applicaiton controller
  #put api calls in model to save inormation for later

  #devise
  #rails as api

  #http://stackoverflow.com/questions/26232909/checking-if-a-string-is-valid-json-before-trying-to-parse-it

end


