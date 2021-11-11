require_relative('env.rb')

table = CSV.read('data.csv', headers: true)
CONNECTION.prepare('create_marketing_mat', 'insert into materials (name, type, cost) values ($1, $2, $3) RETURNING id')
CONNECTION.prepare('create_office', 'insert into offices (title, address, city, state, phone, lob, type) values ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT ON CONSTRAINT title_address DO UPDATE SET title = EXCLUDED.title RETURNING id')
CONNECTION.prepare('create_room', 'insert into rooms (office_id, zone, name, area, max_people) values ($1, $2, $3, $4, $5) ON CONFLICT ON CONSTRAINT room_constraint DO UPDATE SET name = EXCLUDED.name RETURNING id')
CONNECTION.prepare('create_fixture', 'insert into fixtures (room_id, material_id, name, type) values ($1, $2, $3, $4)')

table.each { |row|
    material_data = CONNECTION.exec_prepared('create_marketing_mat', [row[0], row[1], row[2]])
    office_data = CONNECTION.exec_prepared('create_office', [row[9], row[10], row[11], row[12], row[13], row[14], row[15]])
    room_data = CONNECTION.exec_prepared('create_room', [office_data.values[0][0], row[5], row[8], row[6], row[7]])
    CONNECTION.exec_prepared('create_fixture', [room_data.values[0][0], material_data.values[0][0], row[3], row[4].sub(' ', '_')])
}
