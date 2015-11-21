require 'csv'

class Dataset < ActiveRecord::Base
    belongs_to :user
    has_many :columns
    has_many :maps

    # Will read through the filestream to make sure it is valid: 
    # * be parseable CSV
    # * contain every column that the dataset is supposed to contain.
    # * have fewer than 500,000 rows
    # It will then write the filestream to the dataset's existing filepath. 
    # It will return TRUE iff successful, FALSE otherwise
    def consume_raw_file(filestream)
        # TODO: Implement
    end

    def destroy_file!
        File.delete(self.filepath) if File.exist?(self.filepath)
    end

    def after_initialize
        dataset_id = self.id
        filepath = "#{Rails.root}/datasets/#{dataset_id}.csv"
        self.filepath = filepath
    end

    # Takes a string that represents location and returns a 5-digit
    # FIPS code representation of that location, or NULL if unknown
    # Params:
    # location - a string representation of a location of a row. Must conform to one of the known location types.
    # location_type - The way that the given location parameter has been represented. Can have the following types:
    # * state - NJ or New Jersey
    # * statefips - 23 or 23000
    # * countypartial - Bergen
    # * countypartialfips - 234 or 00234
    # * countyfull - Bergen, New Jersey or Bergen, NJ
    # * countyfullfips - 23234
    def convert_to_fips(location, location_type)
        # TODO: Implement
    end

    # Returns a 5-digit FIPS code that represents this row's location as long as the dataset contains the correct columns.
    # Params:
    # row - a CSV row (a hash where keys are column headers)
    # detail_level - a string that is either "STATE" or "COUNTY" that represents what detail to query locations by.
    def get_row_location(row, detail_level)
        # TODO: Implement     
    end

    # Returns a hash containing every single datapoint in this dataset. These should be condensed by some other function.
    # The response format is { 5-digit FIPS code for a location => [list of datapoints belonging to that location]}
    # The format of each datapoint is { display_val: XX, filter_val: YY, weight: ZZ}
    # Params
    # display_val_name - The name of the column to select display values from
    # display_val_name - The name of the column to select filter values from. Can be null.
    # detail_level - The level of location detail to return. Can be "STATE" or "COUNTY".
    def generate_raw_points(display_val_name, filter_val_name, detail_level)
        # TODO: Implement
    end

    # Returns a hash containing a representative set of datapoints from this dataset.
    # The response format is { 5-digit FIPS code for a location => [list of datapoints belonging to that location]}
    # The format of each datapoint is { display_val: XX, filter_val: YY, weight: ZZ}
    # Params
    # num_points_wanted - The maximum number of desired datapoints. This can not be less than the number of unique locations. The number of points returned can be less than this.
    # display_val_name - The name of the column to select display values from
    # display_val_name - The name of the column to select filter values from. Can be null.
    # detail_level - The level of location detail to return. Can be "STATE" or "COUNTY".
    def generate_points(num_points_wanted, display_val_name, filter_val_name, detail_level)
        # TODO: add error checking

        all_points = self.generate_raw_points(display_val_name, filter_val_name, detail_level)
        merged_dups = self.merge_repeats(all_points)

        num_points = merged_dups[:num_points]
        condense_factor = num_points_wanted * 1.0 / num_points

        condensed = self.condense_by_location(condense_factor)

        return condensed
    end

    # If two datapoints have the same exact location, display_val, and filter_val, this method merges them into one point.
    # Params
    # by_location - A hash of datapoints. This has the same format as that returned by generate_raw_points.
    def merge_repeats(by_location)
        # TODO: Implement
    end

    # It decreases the number of points within each location by a scale factor.
    # The minimum size per location is 1 datapoint.
    # 
    # Params
    # by_location - A hash of datapoints. This has the same format as that returned by generate_raw_points.
    # 
    # Example: (Note that the locations are actually 5-digit FIPS codes)
    # by_location = { ... "alabama" => [1000 datapoints] ... }
    # condense_factor = 50
    # Returns { ... "alabama" => [20 datapoints] ... }
    def condense_by_location(by_location, condense_factor)
        # TODO: Implement
    end

end
