require 'sinatra'
require 'yaml'
require 'sqlite3'
require 'sinatra/cross_origin'
require  'logger'

configure do
  enable :cross_origin
end

logger = Logger.new('logs/app.log')
config = YAML.load_file('config.yaml')
db = SQLite3::Database.new('users/user.db')

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS stats (
    id VARCHAR PRIMARY KEY,
    last_position INTEGER,
    favorite INTEGER
  );
SQL

db.execute <<-SQL
CREATE TABLE IF NOT EXISTS lists (
   id INTEGER PRIMARY KEY,
   name VARCHAR(50),
   items VARCHAR[]
);

SQL

begin
    api = File.read('media.json')
    parsed = JSON.parse(api)

    parsed.each do |item|
        id = item['id'].to_s 
        existing_record = db.execute('SELECT * FROM stats WHERE id = ?', [id])
      
        if existing_record.empty?
          db.execute('INSERT INTO stats (id, last_position, favorite) VALUES (?, ?, ?)', [id, 0, 0])
        else
         puts 'Values already up to date.'
        end
    end
end



set :bind, '0.0.0.0'
set :port, config['port']

before do
    content_type :json    
    headers 'Access-Control-Allow-Origin' => '*', 
             'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST'],
             'Access-Control-Allow-Headers' => ['Content-Type']
 end

 
options '*' do
  response.headers['Allow'] = 'HEAD, GET, POST, PUT, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'

  200
end




get '/users' do
 folder = Dir.entries("users/").select {|f| File.file? File.join("users", f)}
 "#{folder}"
end

 #initalize client files

get '/' do
   
    html_file_path = 'client/dist/index.html'
    content_type 'text/html'
    send_file html_file_path
   
end    

get '/script' do
    js_file_path = 'client/dist/assets/index-f1ebcb3c.js'
    content_type 'text/javascript'
    send_file js_file_path
end    

get '/style' do
    css_file_path = 'client/dist/assets/index-cda024ea.css'
    content_type 'text/css'
    send_file css_file_path
end    

get '/fonts/:file' do |file|
    content_type 'font/woff'
    send_file "client/node_modules/@mdi/font/fonts/#{file}"
  end

get '/all' do
  
  logger = Logger.new('logs/app.log')
  logger.info("Client #{request.ip} accessed at #{Time.now}")
 

File.read('media.json')
end    

get '/logs' do
  content_type 'text/plain'
  log_file_path = 'logs/app.log'

  # Read the last 100 lines of the log file
  logs = File.readlines(log_file_path).last(100).join

  # Display the last 100 lines of the log file
  logs
end

get '/server_settings' do 
  content_type 'text/html'
  erb "<html>
 <h1>Server settings, modify through 'main.rb'</h1>
 <div style='text-align: center; justify-content: center; align-items: center; display: flex'><strong style='color: green'>✓</strong> <p>Running on port: <strong>#{config['port']}</strong></p></div>
 <p></p><div style='text-align: center; justify-content: center; align-items: center; display: flex'><strong style='color: green'>✓</strong> <p>Exposed to local network: <strong>#{config['expose']}</strong></p></div>
<p></p> <div style='text-align: center; justify-content: center; align-items: center; display: flex'><strong style='color: black'>あ</strong> <p>Language: <strong>#{config['language']}</strong></p></div>
 
 </html>", :layout => false
end

get '/favorites' do
    content_type :json
    
    begin
        favs = db.execute("SELECT * FROM stats WHERE favorite = ?", [1])
      
        # Convert each row array to a hash
        formatted_favs = favs.map { |row| { id: row[0], last_position: row[1], favorite: row[2] } }
      
        # Convert the formatted data to JSON
        formatted_favs.to_json
      rescue SQLite3::Exception => e
        status 500
        { error: "Error: #{e.message}" }.to_json
      end

  
end  

get '/current_watching' do 
  content_type :json
    
  begin
      favs = db.execute("SELECT * FROM stats WHERE last_position > ?", [0])
    
      # Convert each row array to a hash
      formatted_favs = favs.map { |row| { id: row[0], last_position: row[1], favorite: row[2] } }
    
      # Convert the formatted data to JSON
      formatted_favs.to_json
    rescue SQLite3::Exception => e
      status 500
      { error: "Error: #{e.message}" }.to_json
    end


end


get '/watch/:id' do |n|
   api = File.read('media.json')
   parsed = JSON.parse(api)
  result =  parsed.select { |h| h['id'] == n }
  content_type :json 
  "#{result.to_json}"
end

get '/file/:id' do |n|
    api = File.read('media.json')
   parsed = JSON.parse(api)
    result = parsed.select{|a| a['id'] == n }
   thisFile = result[0]['file']
   content_type 'video/mp4'
   
   send_file("public/#{thisFile}")
end

get '/download/file/:id' do |n|
    api = File.read('media.json')
   parsed = JSON.parse(api)
    result = parsed.select{|a| a['id'] == n }
   thisFile = result[0]['file']
   content_type 'video/mp4'
   
  logger = Logger.new('logs/app.log')
  logger.info("Client #{request.ip} downloaded #{thisFile} at #{Time.now}")
 

   send_file("public/#{thisFile}", :disposition => 'attachment', :filename => thisFile)
end


get '/season/:id/:season' do |i, s|
    folder = Dir.entries("public/#{i}/#{s}").select { |f| File.file? File.join("public", i, s, f) }
    "#{folder}"
    
end

get '/episode/:id/:season/:ep' do |i, s, e|
    folder = Dir.entries("public/#{i}/#{s}").select { |f| File.file? File.join("public", i, s, f) }
    content_type 'video/mp4'
    send_file("public/#{i}/#{s}/#{folder[e.to_i - 1]}")
end

get '/all_captions' do
  folder = Dir.entries("public/captions/").select { |f| File.file? File.join("public/captions", f) }
  "#{folder}"
end 

get '/captions/:id' do |i|
    content_type 'text/vtt'
    send_file("public/captions/#{i}.vtt")
end

get '/cover/:id' do |i|
    content_type 'image/jpeg'
    send_file("public/covers/#{i}.jpg")
end

get '/book/:id' do |i|
  content_type 'application/pdf'
  send_file("public/#{i}.pdf")
end


#post methods

post '/add_favorite' do 
  request.body.rewind
  data = JSON.parse(request.body.read)

  id = data['id']

  existing_record = db.execute('SELECT * FROM stats WHERE id = ?', [id])

  if existing_record.empty?
    status 404
    'Record not found'
  else
    db.execute('UPDATE stats SET favorite = 1 WHERE id = ?', [id])
   'Item has been added to your favorites!'
  end
end

post '/remove_favorite' do 
  request.body.rewind
  data = JSON.parse(request.body.read)

  id = data['id']

  existing_record = db.execute('SELECT * FROM stats WHERE id = ?', [id])

  if existing_record.empty?
    status 404
    'Record not found'
  else
    db.execute('UPDATE stats SET favorite = 0 WHERE id = ?', [id])
   'Item has been added to your favorites!'
  end
end



post '/update_progress' do 
  request.body.rewind
  data = JSON.parse(request.body.read)

  id = data['id']
  position = data['position']

  existing_record = db.execute('SELECT * FROM stats WHERE id = ?', [id])

  if existing_record.empty?
    status 404
    'Record not found'
  else
    db.execute('UPDATE stats SET last_position = ? WHERE id = ?', [position, id])
   'Current time updated!'
  end
end
