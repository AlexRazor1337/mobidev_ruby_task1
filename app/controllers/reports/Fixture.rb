require_relative '../../../env.rb'

module Fixture
    def generate id
        @result = {}
        @fixtures = []
        @count = {}
        @total = {}

        if id
            @office = CONNECTION.exec("SELECT * FROM offices WHERE id='#{id}'").first
            if !@office
                return [404, headers, [render('views/404.erb')]]
            end
            @types = CONNECTION.exec('SELECT DISTINCT type FROM fixtures;')
            @types.each do |type|
                @rooms = CONNECTION.exec_params("SELECT * FROM rooms where office_id = $1;", [id])
                @rooms.each do |room|
                    @fixtures = CONNECTION.exec_params("SELECT * FROM fixtures where room_id = $1 and type = $2;", [room['id'], type["type"]])
                    @fixtures.each do |fixture|
                        if !@result[type["type"]]
                            @result[type["type"]] = []
                            @count[type["type"]] = {}
                        end
                        fixture['room_name'] = room['name']
                        @result[type["type"]] << fixture
                   end
                end
            end

            return true
        else
            @types = CONNECTION.exec('SELECT DISTINCT type FROM fixtures;')
            @types.each do |type|
                @fixtures = CONNECTION.exec_params("SELECT * FROM fixtures where type = $1;", [type["type"]])
                @fixtures.each do |fixture|
                   @rooms = CONNECTION.exec_params("SELECT * FROM rooms where id = $1;", [fixture["room_id"]])
                   @rooms.each do |room|
                        if !@result[type["type"]]
                            @result[type["type"]] = []
                            @count[type["type"]] = {}
                        end

                        office = CONNECTION.exec("SELECT * FROM offices where id = #{room["office_id"]};")
                        @result[type["type"]] << office[0]
                        
                        if @count[type["type"]][office[0]]
                            @count[type["type"]][office[0]] += 1
                        else
                            @count[type["type"]][office[0]] = 1
                        end
                   end
                end

                @total[type["type"]] = @result[type["type"]].length
                @result[type["type"]].uniq!
            end

            return true
        end
    end
end