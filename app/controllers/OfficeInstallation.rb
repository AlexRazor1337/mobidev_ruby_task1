require_relative '../../env.rb'

class OfficeInstallation
    def view_file filename
        File.read(filename)
    end

    def render filename
        ERB.new(view_file(filename)).result(get_binding)
    end

    def get_binding
        binding
    end

    def call(env)
        status  = 200
        headers = { "Content-Type" => "text/html" }
        @result = {}
        @total = {}
        @total_area = 0
        @total_max_people = 0
        if env['rack.route_params'][:id]
            @office = CONNECTION.exec("SELECT * FROM offices WHERE id='#{env['rack.route_params'][:id]}'").first
            if !@office
                return [404, headers, [render('views/404.erb')]]
            end
            zones = CONNECTION.exec_params("SELECT DISTINCT zone FROM rooms where office_id = $1;", [env['rack.route_params'][:id]])
            zones.each do |zone|
                @result[zone['zone']] = {}
                rooms = CONNECTION.exec_params("SELECT * FROM rooms where office_id = $1 and zone = $2;", [env['rack.route_params'][:id], zone['zone']])
                rooms.each do |room|
                    @total_area += room['area'].to_i
                    @total_max_people += room['max_people'].to_i
                    materials = CONNECTION.exec_params("SELECT materials.type m_type, materials.name m_name, fixtures.name f_name, fixtures.type f_type
                        FROM ((rooms INNER JOIN fixtures ON rooms.id = fixtures.room_id)
                        INNER JOIN materials ON fixtures.material_id = materials.id)
                        where room_id = $1;", [room['id']])

                    @result[zone['zone']][room['name']] = materials
                end
            end           
        end
        
        body    = [render('views/installation.erb')]
        
        [status, headers, body]
    end
end
