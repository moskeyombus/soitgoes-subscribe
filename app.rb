
class SoItGoesSubscribe < Sinatra::Base
  Dotenv.load
  Plex.configure do |config|
    config.auth_token = ENV['PLEX_AUTH_TOKEN']
  end

  begin
    plex_server = Plex::Server.new(ENV['PLEX_HOST'], ENV['PLEX_PORT'])
    tv_show_library = plex_server.library.sections.find{ |section| section.type == "show" }
    tv_show_list = tv_show_library.all.map{ |show| show.title }
  rescue Exception => e
    puts "Error connecting to Plex - #{ e.message }"
  end

  get '/' do
    # base route should serve JS app
    'SoItGoes Subscribe!'
  end

  get '/shows' do
    # get list of subscribed shows, contains episode name list
    puts '<h1>TV Shows</h1>'
    tv_show_list.each do |show|
      puts show
    end
  end

  post '/shows' do
    # adds a new show
  end

  put '/shows/:id' do
    # updates a show
  end

  delete '/shows/:id' do
    # removes a show
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
