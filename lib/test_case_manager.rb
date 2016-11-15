require 'file_manager'

class TestCaseManager
  def get_test_cases( submission )
    test_cases = Problem.find_by( id: submission.problem_id ).test_cases
    return test_cases
  end

  def parsing_test_cases( file_manager, tc )
    test_cases = [ ]
    tc.each do |test_case|
      test_cases.push( [ file_manager.get_data_url( test_case.url_input.url ), file_manager.get_data_url(test_case.url_output.url) ] )
    end
    return test_cases
  end
end