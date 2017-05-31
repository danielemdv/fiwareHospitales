require 'HTTPClient'
require 'rest-client'

class HospitalController < ApplicationController
  def index
  end

  def procesar
    id = params[:consulta][:id]

    client = HTTPClient.new
    cap = client.get_content('http://130.206.112.201:1026/v2/entities/' + id + '/attrs/capacidad/value')
    camas = client.get_content('http://130.206.112.201:1026/v2/entities/' + id + '/attrs/camas/value')

    if params[:consulta][:accion] == "1"
      res = cap.to_f + (100.0/camas.to_i)
    else
      res = cap.to_f - (100.0/camas.to_i)
    end

    puts 100.0/camas.to_i

    if res < 0
      res = 0
    end

    r = RestClient.put('http://130.206.112.201:1026/v2/entities/' + id + '/attrs/capacidad/value/', res.to_s, content_type: 'text/plain')
  end

end
