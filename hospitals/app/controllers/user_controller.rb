require 'HTTPClient'
require 'rest-client'


class UserController < ApplicationController
  def entry
  end

  def magia
    @coords = params[:uploadLocation][:coordinates]
    puts "ahi van las coordenadas"
    puts @coords

    arrCoords = @coords.split(',')
    lat = arrCoords[0]
    long = arrCoords[1]

    compound = lat + ',%20' + long

    query = 'http://130.206.112.201:1026/v2/entities?idPattern=.*&type=hospital&georel=near%3BmaxDistance%3A100000&coords=' + compound + '&geometry=point&attrs=capacidad,coordenadas&orderBy=geo%3Adistance&limit=5'

    queryAmazon = 'http://ataraxia.hopto.org:1026/v2/entities?idPattern=.*&type=hospital&georel=near%3BmaxDistance%3A100000&coords=' + compound + '&geometry=point&attrs=capacidad,coordenadas&orderBy=geo%3Adistance&limit=5'

    client = HTTPClient.new
    response = client.get_content(queryAmazon)

    puts response

    jasons = JSON.parse response

    for i in 0..4 do
      puts jasons[i]["coordenadas"]["value"]
    end


  end

end
