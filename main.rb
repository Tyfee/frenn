require 'cli/ui'
require 'net/http'
require 'yaml'
require 'uri'
require 'json'
require 'mechanize'
require 'open-uri'


puts CLI::UI.fmt "{{green: Frenn Media v0.1 CLI}}"



def start_server
    config = YAML.load_file('config.yaml')    
    system("ruby server.rb")
    CLI::UI::SpinGroup.new do |spin_group|
        spin_group.add("Starting your server on port #{config['port']}...") { |spinner| sleep 3.0; spinner.update_title("Server app and running on port #{config['port']}"); sleep 3.0 }
      end
end

def show_settings
    config = YAML.load_file('config.yaml')    
    puts CLI::UI.fmt "{{red: PORT}}: #{config['port']}"
    puts CLI::UI.fmt "{{red: EXPOSING}}: #{config['expose']}"
end

def manage_files
    files = Dir.entries("public").select {|f| File.file? File.join('public', f)}
    puts CLI::UI.fmt "{{red: All your media we could find: }}"
    puts files
end

def fetch_items
    items = [{}]
    i = 0
    files = Dir.entries("public").select {|f| File.file? File.join('public', f)}
    url = URI.parse('https://api.simkl.com/search/file')
   
    for file in files do
    i += 1

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    request = Net::HTTP::Post.new(url.path)
    request.body = { 'file' => file }.to_json
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    response = http.request(request)
    body_ = JSON.parse(response.body)

    puts "Response Body: #{body_}"

    if body_ != []
      # Check if the nested arrays exist
        if body_['movie'] && body_['movie']['ids']
        moviedbid = body_['movie']['ids']['moviedb'] if body_['movie']['ids']['moviedb']
        imdbid = body_['movie']['ids']['imdb'] if body_['movie']['ids']['imdb']
        ltrslg = body_['movie']['ids']['letterslug'] if body_['movie']['ids']['letterslug']
        p moviedbid + ' ' + ltrslg
   
     output_folder = "public/test"

  
     agent = Mechanize.new
     agent.user_agent_alias = 'Windows Chrome' 
   
     begin
       page = agent.get("https://www.themoviedb.org/movie/#{moviedbid}-#{ltrslg}")
       
       page2 = agent.get("https://www.imdb.com/title/#{imdbid}/")
     
       poster_element = page2.search('img')
       paragraph = page.at('p')
  
       

         if poster_element && poster_element['src']
       
           relative_path = poster_element['src']
           # full_url = "#{base_url}/#{relative_path}"
         #image = agent.get_file(full_url)
          # File.open("M0#{i}.jpg", 'wb') { |file| file.write(image) }
        
            # Download the image
                  puts "Downloaded poster image. #{relative_path}"
                if paragraph
                   description = paragraph.text.strip
                    p "Description: #{description}"
                
                else
                    p "No description found for this entry. You might want to add it MANUALLY."
                end
          
          else
             puts "Poster image source not found You might want to add it MANUALLY."

       end
         rescue Mechanize::ResponseCodeError => e
       puts "Error: #{e.response_code} - #{e.message}"
     end
  
     
    else 
      p "nahh #{"https://www.themoviedb.org/movie/#{moviedbid}-#{ltrslg}"}"
    end
   
    #push data to array
    
    if body_.is_a?(Hash) && body_['movie'].is_a?(Hash) && body_['movie']['title']
      items << {
        "id": "M0#{i}",
        "title": "#{body_['movie']['title']}",
        "file": file,
        "desc": description
      }
    elsif body_ == []
      items << {
        "id": "M0#{i}",
        "title": file,
        "file": file,
        "desc": "N/A"
      }
    else
      items << {
        "id": "M0#{i}",
        "title": file,
        "file": file,
        "desc": "N/A\nNo data found on the movie, you might want to add it MANUALLY."
      }
    end
  end

    #show progressbar
    CLI::UI::Progress.progress do |bar|
        100.times do
          bar.tick
        end

      end

      File.open('media_test.json', 'w') do |file|
        file.puts JSON.pretty_generate(items)
      end
    end
    welcome
end

def welcome
CLI::UI::Prompt.ask('What would you like to do?') do |handler|
    handler.option('Start Server')  { |selection| start_server }
    handler.option('Stop Server')     { |selection| selection }
    handler.option('Settings')   { |selection| show_settings }
    handler.option('All Files') { |selection| manage_files }
    handler.option('Fetch Media Info (From Simkl)') { |selection| fetch_items }
  end
end
  CLI::UI::Prompt.instructions_color = CLI::UI::Color::YELLOW
  welcome