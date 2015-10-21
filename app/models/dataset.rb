require 'csv'

class Dataset < ActiveRecord::Base
    belongs_to :user
    has_many :columns
    has_many :maps

    def consume_raw_file(filestream, filename)
        # TODO: Process the file. Condense it. 
        outpath = File.join(Rails.root, 'datasets', filename)
        # TODO: Write the file here
        # TODO: Return the filepath and the column names
    end

    def destroy_file!
        File.delete(self.filepath) if File.exist?(self.filepath)
    end

    def generate_points(num_points_wanted, display_val_name, filter_val_name)
        location_column_name = self.location_column
        weight_column_name = self.weight_column
        filepath = self.filepath

        by_location = self.merge_repeats(filepath, location_column_name, weight_column_name, display_val_name, filter_val_name)

        num_condensed = 0
        by_location.each do |location, point_dict|
            num_condensed += point_dict.size
        end

        condense_factor = num_condensed / num_points_wanted

        ans = condense_by_location(by_location, condense_factor)
        return ans
    end

    def merge_repeats(filepath, location_column_name, weight_column_name, display_val_name, filter_val_name)
        line_num = 0
        by_location = Hash.new
        CSV.foreach(filepath, :headers => true) do |row|
            loc = row[location_column_name]

            if not by_location.has_key?(loc)
                by_location[loc] = Hash.new
            end

            display_val = row[display_val_name]
            filter_val = row[filter_val_name] # TODO: or nil if we don't have a filter
            weight = row[weight_column_name].to_i
            key = [display_val, filter_val]

            if not by_location[loc].has_key?(key)
                by_location[loc][key] = 0
            end

            by_location[loc][key] += weight

            if line_num % 10000 == 0
                puts line_num
            end
            
            line_num += 1
        end
        return by_location
    end

    def condense_by_location(by_location, condense_factor)
        

        ans = Array.new
        by_location.each do |location, point_dict|
            target_size = (point_dict.size / condense_factor).to_i
            
            # TODO: figure out a better way to do this than just randomly

            num_to_keep = [1, target_size].max
            keys_to_keep = point_dict.keys.sample(num_to_keep)

            keys_to_keep.each do |key|
                display_val = key[0]
                filter_val = key[1]
                weight = point_dict[key]
                to_add = {"location" => location,
                        "display_val" => display_val,
                        "filter_val" => filter_val,
                        "weight" => weight}
                ans.push(to_add)
            end

        end
        return ans
    end

end
