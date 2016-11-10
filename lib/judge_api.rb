require 'httparty'
require 'file_manager'
require 'test_case_manager'

class JudgeApi
  API_URL = 'https://api.judge0.com/submissions'

  # Function to submit a code to the API
  # Uses a @submission class variable that is defined in create
  # Return the Ids for the submissions test case. (See GetVeredictJob)
  def sendSubmission(submission)
    fileM = FileManager.new
    code = fileM.get_data_url( submission.url_code.url )
    tcm = TestCaseManager.new
    test_cases = tcm.parsing_test_cases( fileM, tcm.get_test_cases( submission ) )
    api_ids = ""
    test_cases.each do |test_case|
      language = submission.language
      input = test_case[ 0 ]
      output = test_case[ 1 ]
      id = connectAPI(code, language, input, output)
      api_ids = api_ids + id.to_s + ";"
    end
    return api_ids;
  end 

  def connectAPI(code, language, input, output)
    languageId = getLanguageId(language)
    response = HTTParty.post(API_URL, body: { 
        source_code: code,
        language_id: languageId,
        input: input,
        expected_output: output } )
    json = JSON.parse(response.body)
    return json['id']
  end

  # Default values in API
  def getLanguageId(language)
    case language
      when "C++"
        7
      when "Java"
        11
      when "Python"
        15
      else
        1
    end
  end

  def getStatus(submissionId)
    response = HTTParty.get(API_URL + '/' + submissionId.to_s)
    json = JSON.parse(response.body)
    return json
  end

end