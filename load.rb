require_relative('env.rb')

def load(filename)
    CONNECTION.exec('TRUNCATE materials, fixtures, rooms, offices CASCADE;')

    table = CSV.read(filename, headers: true)
    table.each { |row|
        material_data = CONNECTION.exec_prepared('create_marketing_mat', [row[0], row[1], row[2]])
        office_data = CONNECTION.exec_prepared('create_office', [row[9], row[10], row[11], row[12], row[13], row[14], row[15]])
        room_data = CONNECTION.exec_prepared('create_room', [office_data.values[0][0], row[5], row[8], row[6], row[7]])
        CONNECTION.exec_prepared('create_fixture', [room_data.values[0][0], material_data.values[0][0], row[3], row[4].sub(' ', '_')])
    }
end
