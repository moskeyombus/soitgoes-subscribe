
class SoItGoesSubscribe < Sinatra::Base
  Dotenv.load
  Plex.configure do |config|
    config.auth_token = ENV['PLEX_AUTH_TOKEN']
  end

  Mongoid.load!("./mongoid.yml", :development)
  Mongoid.raise_not_found_error = false

  begin
    plex_server = Plex::Server.new(ENV['PLEX_HOST'], ENV['PLEX_PORT'])
  rescue Exception => e
    puts "Error connecting to Plex - #{ e.message }"
  end

  get '/' do
    # base route should serve JS app
    'SoItGoes Subscribe!'
  end

  get '/shows' do
    # get list of subscribed shows, contains episode name list
    Show.all.map{ |show| show.title }
  end

  post '/shows' do
    # adds a new show
    # Use some kind of autocomplete from SoItGoes to ensure valid show na,e
  end

  put '/shows/:id' do
    # updates a show
  end

  delete '/shows/:id' do
    # removes a show
  end

  put '/library' do
    if params[:action]
      if params[:action] == "plex_sync"
        # Syncs PLEX library with Show list
        current_plex_list = []
        tv_show_library = plex_server.library.sections.find{ |section| section.type == "show" }
        tv_show_library.all.map do |show|
          Show.create({ title: show.title, plex_title: show.title }) if Show.find_by({ plex_title: show.title }).nil?
          current_plex_list << show.title
          # Get a list of all Episodes, update DB
        end

        Show.all.map do |show|
          Show.find(show.id).destroy unless current_plex_list.include? show.title
          # Also remove all episodes when destroying a show

          # Check Episodes for show, remove from DB if not in Plex
        end

      end

      if params[:action] == "soitgoes_sync"
        # Syncs PLEX library with Show list
        current_plex_list = []
        tv_show_library = plex_server.library.sections.find{ |section| section.type == "show" }
        tv_show_library.all.map do |show|
          Show.create({ title: show.title, plex_title: show.title }) if Show.find_by({ plex_title: show.title }).nil?
          current_plex_list << show.title
        end

        Show.all.map do |show|
          Show.find(show.id).destroy unless current_plex_list.include? show.title
        end
      end
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
