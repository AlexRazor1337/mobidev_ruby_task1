require_relative '../../../env.rb'

module MaterialCost
    def generate
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

        return true
    end
end