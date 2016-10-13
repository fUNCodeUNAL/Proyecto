require 'httparty'

class JudgeApi
  API_URL = 'http://api.judge0.com/submissions'

  def sendSubmission(code, language, input, output)
    languageId = getLanguageId(language)
    response = HTTParty.post(API_URL, body: { source_code: code,
       language_id: languageId,
       input: input,
       expected_output: output})


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