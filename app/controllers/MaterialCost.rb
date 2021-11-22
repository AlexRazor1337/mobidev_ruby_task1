require_relative '../../env.rb'

class MaterialCost
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
        CONNECTION.exec('SELECT DISTINCT * FROM offices;').each do |office|
            @result[office['title']] = CONNECTION.exec_params('SELECT * FROM materials WHERE id IN (SELECT material_id FROM fixtures WHERE room_id IN (SELECT DISTINCT id FROM rooms WHERE office_id = $1));', [office['id']])

            total_material = {}
            @result[office['title']].each do |materials|
                if total_material[materials['type']]
                    total_material[materials['type']] += materials['cost'].to_i
                else
                    total_material[materials['type']] = materials['cost'].to_i
                end
            end

            @total[office['title']] = total_material.values.reduce(:+)
            @result[office['title']] = total_material
        end

        body    = [render('views/material_cost.erb')]
        
        [status, headers, body]
    end
end