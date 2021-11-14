require 'pg'
require 'csv'
require 'rack'

CONNECTION = PG.connect(dbname: 'task1', user: 'ruby')