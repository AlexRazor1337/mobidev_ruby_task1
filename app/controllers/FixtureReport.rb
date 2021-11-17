require_relative '../../env.rb'

class FixtureReport
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
        @fixtures = []
        @count = {}
        @total = {}
        if env['rack.route_params'][:id]
            @types = CONNECTION.exec('SELECT DISTINCT type FROM fixtures;')
            @types.each do |type|
                @rooms = CONNECTION.exec_params("SELECT * FROM rooms where office_id = $1;", [env['rack.route_params'][:id]])
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

            body    = [render('views/fixture_sub.erb')]
        
            return [status, headers, body]
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
        end
       
        body    = [render('views/fixture_count.erb')]
        
        [status, headers, body]
    end
end