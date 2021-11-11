require 'pg'
require 'csv'

CONNECTION = PG.connect(dbname: 'task1', user: 'ruby')