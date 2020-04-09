require File.expand_path('..', File.dirname(__FILE__)) + '/app.rb'

DTO_IN = ["affenpinscher", "african", "australian", "basenji", "beagle", "bluetick", "borzoi", "bouvier", "boxer", "buhund", "hound", "spaniel", "terrier", "vizsla", "wolfhound", "setter", "samoyed"]

describe App do
  it "export_breeds" do
     response = App.new.run(DTO_IN)
     expect(response[:status]).to eq 200
     expect(response).to have_key(:output_file)
  end
end
