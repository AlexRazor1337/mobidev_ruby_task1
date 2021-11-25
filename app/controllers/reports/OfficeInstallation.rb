require_relative '../../../env.rb'

module OfficeInstallation
    def generate office_id
        @result = {}
        @total = {}
        @total_area = 0
        @total_max_people = 0
        if office_id
            @office = CONNECTION.exec("SELECT * FROM offices WHERE id='#{office_id}'").first
            if !@office
                return false
            end

            zones = CONNECTION.exec_params("SELECT DISTINCT zone FROM rooms where office_id = $1;", [office_id])
            zones.each do |zone|
                @result[zone['zone']] = {}
                rooms = CONNECTION.exec_params("SELECT * FROM rooms where office_id = $1 and zone = $2;", [office_id, zone['zone']])
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
        else
            return false
        end
    end
end