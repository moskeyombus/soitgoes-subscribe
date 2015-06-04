class Episode
  include Mongoid::Document
  field :title, :type => String
  field :plex_title, :type => String
  field :soitgoes_title, :type => String
end