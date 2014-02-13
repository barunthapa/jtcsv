# require 'spec_helper'
require 'citizen/citizen'
require 'citizen/messages'

require 'stringio'

def capture(*streams)
  streams.map! { |stream| stream.to_s }
  begin
    result = StringIO.new
    streams.each { |stream| eval "$#{stream} = result" }
    yield
  ensure
    streams.each { |stream| eval("$#{stream} = #{stream.upcase}") }
  end
  result.string
end

describe Citizen do 

  let (:citizen) { Citizen.new }
  subject { cli }

  it 'should have accepted file type list' do
    Citizen::ACCEPTED_FILETYPES.should include('.json')
  end

  context '.vote' do

    let(:vote_file) { "test_file.txt" }
    let(:output) { capture(:stdout) { citizen.vote } }
    let(:success_response) { OpenStruct.new(code: 200) }
    let(:failure_response) { OpenStruct.new(code: 500) }

    context 'when file not specified' do
      it 'should return error if file not specified' do
        output.should match FILENAME_NOT_SPECIFIED
      end
    end

    context 'when file not found' do
      it 'should display file not found error message' do
        citizen.stub(:options) { { votefile: vote_file } }
        output.should match FILE_NOT_FOUND
      end
    end

    context 'when filetype not json' do
      it 'should display invalid file type error message' do
        citizen.stub(:options) { { votefile: vote_file } }
        File.stub(:exists?) { true }
        output.should match FILE_NOT_JSON
      end
    end

    context 'when file parsing successful' do
      it 'should display the success message' do
        citizen.stub(:options) { { votefile: 'spec/vote_file.json' } }
        HTTParty.should_receive(:post).and_return(success_response)
        output.should match JSON_PARSE_SUCCESS
      end
    end

    context 'when votes json successfully uploaded to server'do
      it 'should display success response message' do
        citizen.stub(:options) { { votefile: 'spec/vote_file.json' } }
        HTTParty.should_receive(:post).and_return(success_response)
        output.should match SERVER_UPLOAD_SUCCESS
      end
    end

    context 'when error code returned from server' do
      it 'should display server error message' do
        citizen.stub(:options) { { votefile: 'spec/vote_file.json' } }
        HTTParty.should_receive(:post).and_return(failure_response)
        output.should match SERVER_UPLOAD_FAILURE
      end
    end

  end
end
