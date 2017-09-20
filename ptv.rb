# Using some of the features in the past couple of problems, start thinking about it coding a basic PTV app (like our public transport app, if you aren't familiar). I'm happy to give hints, or you can get together and help each other. You need to simplify things, so only dummy up one or at most two lines at first (or at last). The final product (coded, or just pseudo-coded) would take a user input of an origin station, and a destination station, and return a data structure that contains the stops to pass through, and the line changes if required. Perhaps restrict the user input so there cannot be an error returned (the only stations they choose are valid - or assume this, but say if that's your choice). Start with one train line, represented by an array. If you extend it to two lines, you need to think about how to represent the lines as data, and this might be a complex object. Think through all the options before coding, and even perhaps pen and paper. You will need some way to carry the user data through the method/s, and some way to represent the MTR. You will likely need several small methods, and will likely have to employ a full range of data types, such as hashes and arrays (and possibly arrays of arrays). I am more than happy to help out anyone stuck, particularly if they have a specific question where they are stuck, and have thought about it. I'm also happy to look through any code people would like examined.

def ride_ptv(data)
    # List of available lines
    ptv_lines = ["Lilydale", "Belgrave"]
    # ptv_line_count = data[:ptv_line].size

    # Determine the Origin Station and which Line is it
    origin = nil
    origin_ptv_line = -1
    while origin.nil?
        origin_ptv_line += 1
        origin = find_string_in_array(data[:ptv_line][origin_ptv_line],data[:origin])
    end

    # Determine the Destination Station and which Line is it
    destination = nil
    destination_ptv_line = -1
    while destination.nil?
        destination_ptv_line += 1
        destination = find_string_in_array(data[:ptv_line][destination_ptv_line],data[:destination])
    end
    
    # If the origin station is not on the same line as the destination
    if origin_ptv_line != destination_ptv_line
        # Determine first possible station to change line
        change_station = (data[:ptv_line][origin_ptv_line] & data[:ptv_line][destination_ptv_line]).first

        change_station_index_from_origin = find_string_in_array(data[:ptv_line][origin_ptv_line],change_station)
        
        stops1 = Array.new
        if origin <= change_station_index_from_origin
            origin.upto(change_station_index_from_origin) { |stop|
                stops1 << data[:ptv_line][origin_ptv_line][stop]
            }
        else
            origin.downto(change_station_index_from_origin) { |stop|
                stops1 << data[:ptv_line][origin_ptv_line][stop]
            }
        end
        
        

        # Determine index of change station in destination line
        change_station_index_to_dest = find_string_in_array(data[:ptv_line][destination_ptv_line],change_station)
        stops2 = Array.new
        if change_station_index_to_dest <= destination
            change_station_index_to_dest.upto(destination) { |stop|
                stops2 << data[:ptv_line][destination_ptv_line][stop]
            }
        else
            change_station_index_to_dest.downto(destination) { |stop|
                stops2 << data[:ptv_line][destination_ptv_line][stop]
            }
        end
        # In change line, don't include first station as a stop
        stops2[0] = nil
        stops2.compact!
        


        result = {
            origin: origin.to_s+" of #{ptv_lines[origin_ptv_line]} line",
            destination: destination.to_s+" of #{ptv_lines[destination_ptv_line]} line",
            stops: stops1+stops2
        }

    else
        # On the same PTV line

        # Determine if going to the city or going back from the city
        stops = Array.new
        if origin <= destination
            origin.upto(destination) { |stop|
                stops << data[:ptv_line][origin_ptv_line][stop]
            }
        else
            origin.downto(destination) { |stop|
                stops << data[:ptv_line][origin_ptv_line][stop]
            }
        end

        result = {
            origin: origin,
            destination: destination,
            stops: stops
        }
    end
    
end

def find_string_in_array(array, str)
    array.index(str)
end

lilydale_to_city_loop = [
    "Lilydale", "Mooroolbark", "Croydon", "Ringwood East", "Ringwood", "Heatherdale", "Mitcham", "Nunawading", "Blackburn", "Laburnum", "Box Hill", "Mont Albert", "Surrey Hills", "Chatham", "Canterbury", "East Camberwell", "Camberwell", "Auburn", "Glenferrie", "Hawthorn", "Burnley", "East Richmond", "Richmond", "Flagstaff", "Melbourne Central", "Parliament", "Flinders Street","Southern Cross"
]

belgrave_to_city_loop = [
    "Belgrave", "Tecoma", "Upwey", "Upper Ferntree Gully", "Ferntree Gully", "Boronia", "Bayswater", "Heathmont", "Ringwood", "Heatherdale", "Mitcham", "Nunawading", "Blackburn", "Laburnum", "Box Hill", "Mont Albert", "Surrey Hills", "Chatham", "Canterbury", "East Camberwell", "Camberwell", "Auburn", "Glenferrie", "Hawthorn", "Burnley", "East Richmond", "Richmond", "Flagstaff", "Melbourne Central", "Parliament", "Flinders Street", "Southern Cross"
]

ptv_journey = {
    # origin: "Auburn",
    # destination: "Southern Cross",
    # origin: "Southern Cross",
    # destination: "Auburn",
    origin: "Belgrave",
    destination: "Lilydale",
    ptv_line: [lilydale_to_city_loop, belgrave_to_city_loop]
}

train_ride = ride_ptv(ptv_journey)

puts "You begin at station #{train_ride[:origin]}"
puts "You end at station #{train_ride[:destination]}"
puts "These are all your train stops:"
train_stop = 1
train_ride[:stops].each { |stop|
    puts "#{train_stop} - #{stop}"
    train_stop += 1
}