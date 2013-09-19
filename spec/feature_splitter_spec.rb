require 'spec_helper'

describe FeatureSplitter do 

    before :each do
        @sample_dir = File.join(File.join(File.expand_path(File.dirname(__FILE__)), 'samples'))
        @splitter = FeatureSplitter.new
    end

    it "should parse a simple scenario" do

        content = File.read(@sample_dir + '/simple_scenario.feature')
        
        scenarios = @splitter.extract_scenarios(content)

        expect(scenarios.size).to be(1)
        expect(scenarios[0].feature.strip).to include "Feature: Y! Mail ViewMastr App"
        expect(scenarios[0].tags).to include "@smoke"
        expect(scenarios[0].name.strip).to eq "Scenario: Clicking email subject in Attachments should open email in new tab"
        expect(scenarios[0].background).to eq ""
        expect(scenarios[0].mount.strip).to eq(content)
    end

    it "should parse a scenario with a background" do
        content = File.read(@sample_dir + '/scenario_with_background.feature')

        scenarios = @splitter.extract_scenarios(content)

        expect(scenarios.size).to be(1)
        expect(scenarios[0].feature.strip).to include "Feature: Y! Mail ViewMastr App"
        expect(scenarios[0].tags).to include "@smoke"
        expect(scenarios[0].name.strip).to eq "Scenario: Clicking email subject in Attachments should open email in new tab"
        expect(scenarios[0].background).to include "Given I am logged in MintyFresh with: User1"
        expect(scenarios[0].background).to include "And I wait for 3 seconds"
        expect(scenarios[0].mount.strip).to eq(content)
    end

    it "parsing a feature with background and more than 1 scenario, all the scenarios should have background block" do
        content = File.read(@sample_dir + '/scenarios_with_background.feature')

        scenarios = @splitter.extract_scenarios(content)

        expect(scenarios.length).to be(2)

        expect(scenarios[0].name).to include "Clicking email subject in Attachments should open email in new tab"
        expect(scenarios[0].background).to include "Given I am logged in MintyFresh with: User1"
        expect(scenarios[0].background).to include "And I wait for 3 seconds"

        expect(scenarios[1].name).to include "Dummy Scenario"
        expect(scenarios[1].background).to include "Given I am logged in MintyFresh with: User1"
        expect(scenarios[1].background).to include "And I wait for 3 seconds"
        expect(scenarios[1].body).to include "And I finish the test"
    end

end
