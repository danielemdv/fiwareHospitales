require 'HTTPClient'

class HospitalController < ApplicationController
  def index
  end

  def procesar
    id = params[:consulta][:id]



    client = HTTPClient.new
    cap = client.get_content('http://130.206.112.201:1026/v2/entities/' + id + '/attrs/capacidad/value')

    if params[:consulta][:accion] == "1"
      res = cap.to_i + 1
    else
      res = cap.to_i - 1
    end

    puts res
  end

end
