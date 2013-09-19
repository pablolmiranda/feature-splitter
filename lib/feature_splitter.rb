class FeatureSplitter

    def initialize
        @file_counter = 1
    end

    def run(features_folder, destination_folder)
        features_files = get_files(features_folder)
        features_files.each do | feature_file |
            content = File.read(feature_file)
            scenarios = extract_scenarios(content)
            scenarios.each do | scenario |
                save_scenario scenario, destination_folder if not scenario.tags.include?('@disabled')
            end
        end
    end

    def get_files(features_folder)
        files = []
        Dir[File.join(features_folder, '**', '*')].keep_if do | file, value |
            files << file if File.file?(file)
        end
    end

    def extract_scenarios(content)
        counter = 0
        scenarios = []
        background_block = ""
        is_background = false
        is_feature_content = false
        scenario = nil
        feature_name = ''
        tags = ''

        content.each_line do | line |
            if line.match(/^Feature:/)
                feature_name = line
                is_feature_content = true

            elsif line.match(/^Background/)
                is_background = true
                is_feature_content = false
                background_block << line

            elsif line.match(/^\@/)
                tags = line
                is_background = false
                is_feature_content = false

            elsif line.match(/^Scenario:/)
                is_background = false
                is_feature_content = false

                counter = counter + 1
                if scenario.nil?
                    scenario = create_scenario(feature_name, background_block, tags, line)
                else
                    scenarios << scenario
                    scenario = create_scenario(feature_name, background_block, tags, line)
                end

            else
                if is_background
                    background_block << line if not line.strip.empty?

                elsif is_feature_content
                    feature_name << line if not line.strip.empty?

                else
                    scenario.body << line if not scenario.nil? || line.strip.empty?    
                end
                
            end

        end
        scenarios << scenario if not scenario.nil?
        scenarios
    end

    def create_scenario(feature_name, background_block, tags, scenario_name)
        scenario = Scenario.new
        scenario.feature = feature_name
        scenario.background = background_block
        scenario.tags = tags
        scenario.name = scenario_name
        scenario
    end

    def save_scenario(scenario, destination_folder)
        new_line = "\n"
        scenario_file = "#{destination_folder}/#{@file_counter}.feature"
        file = File.new(scenario_file, 'w')
        file.write( scenario.mount )
        file.close();
        @file_counter = @file_counter + 1
    end

    class Scenario
        attr_accessor :feature, :name, :body, :tags, :background

        def initialize
            @feature = ""
            @tags = ""
            @name = ""
            @body = ""
        end

        def mount
            output = ""
            new_line = "\n"
            output << @feature
            output << new_line
            output << @background
            output << new_line if not @background.empty?
            output << @tags
            output << @name
            output << @body
            output << new_line
            output
        end

    end

end