require 'rubygems'
require 'thor'
require 'json'
require 'httparty'
require 'json_to_csv/messages'

class JsonToCsv < Thor

  ACCEPTED_FILETYPES = ['.json']

  desc 'convert to csv', 'Convert JSON file to csv file'
  method_options :file => String
  def convert_to_csv
    filename = options[:file]
    if filename
      if File.exists?(filename) && ACCEPTED_FILETYPES.include?(File.extname(filename))
        file = File.open(filename)
        votes = file.read
        begin
          votes_to_post = JSON.parse(votes).to_json
          error = false
          message = JSON_PARSE_SUCCESS
          # response = HTTParty.post('http://citizen40.com/api/v1/vote', body: { votes: votes_to_post })
          server_message = response.code == 200 ? SERVER_UPLOAD_SUCCESS : SERVER_UPLOAD_FAILURE
          message += server_message
        rescue
          error = true
          error_message = JSON_PARSE_ERROR
        end
      elsif File.exists?(filename)
        error = true
        error_message = FILE_NOT_JSON
      else
        error = true
        error_message = FILE_NOT_FOUND
      end
    else
      error = true
      error_message = FILENAME_NOT_SPECIFIED
    end

    if error
      puts 'Voting unsuccessful.'
      puts "Error Message: #{error_message}"
    else
      puts message
    end
  end
end
