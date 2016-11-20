require 'judge_api'
class GetVerdictJob < ApplicationJob
  queue_as :default

  def perform(submissionId)
    judge = JudgeApi.new
    submission = Submission.find(submissionId)
    submission.update(in_queue: false)
    api_ids = submission.api_ids.split(';')
    count = 0
    passedTest = 0
    time = 0
    finalVerdict = 'Accepted'
    flagVerdict = true
    api_ids.each do |id|
        verdict = judge.getStatus(id)
        if flagVerdict and !verdict['status']['description'].eql?('Accepted')
            finalVerdict = verdict['status']['description']
            finalVerdict = 'Runtime Error' if finalVerdict.start_with?('Runtime Error')
            flagVerdict = false
        end
        if verdict['status']['description'] != "In Queue"
            count = count + 1
            if verdict['status']['description'] == "Accepted"
                passedTest = passedTest + 1
                time = [time, verdict['time'].to_f].max
            end
        end
    end

    if count == api_ids.length
        updateVerdict = passedTest.to_s + "/" + count.to_s + " passed test"
    else
        updateVerdict = finalVerdict = "Pending"
        time = '-'
    end

    submission.update({verdict: updateVerdict, final_verdict: finalVerdict, execution_time: time})

  end
end
