#require 'HTTPClient'
require 'httpclient'
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

    compound = lat + ',' + long

    #query = 'http://130.206.112.201:1026/v2/entities?idPattern=.*&type=hospital&georel=near%3BmaxDistance%3A100000&coords=' + compound + '&geometry=point&attrs=capacidad,coordenadas&orderBy=geo%3Adistance&limit=4'
    query = 'http://130.206.112.201:1026/v2/entities?idPattern=.*&type=hospital&georel=near%3BmaxDistance%3A100000&coords=' + compound + '&geometry=point&attrs=capacidad,coordenadas,nombre&orderBy=geo%3Adistance&limit=4'

    queryAmazon = 'http://ataraxia.hopto.org:1026/v2/entities?idPattern=.*&type=hospital&georel=near%3BmaxDistance%3A100000&coords=' + compound + '&geometry=point&attrs=capacidad,coordenadas&orderBy=geo%3Adistance&limit=4'

    client = HTTPClient.new
    response = client.get_content(query)

    puts response

    jasons = JSON.parse response

    lista = Array.new

    #htimes = Hash.new

    for i in 0..3 do
      puts jasons[i]["coordenadas"]["value"]
      lista << jasons[i]["id"]
      puts lista[i]
    end


    #19.435205,-99.1433887

    #Armar las queries
    queries = Array.new
    for i in 0..3 do
      queries << 'https://maps.googleapis.com/maps/api/directions/json?origin=' + compound + '&destination=' + jasons[i]["coordenadas"]["value"] + '&key=AIzaSyCLrYOeMIb8jNP-stoWcN-wrWed7PgDj5k&departure_time=now'
    end

    #ejecutar las queries
    qresults = Array.new
    for i in 0..3 do
      qresults << client.get_content(queries[i])
    end

    #parsear jsons
    rutasData = Array.new
    for i in 0..3 do
      d = JSON.parse qresults[i]
      rutasData << d
    end

    #obtener los tiempos
    tiempos = Array.new
    for i in 0..3 do
      tiempos << rutasData[i]["routes"][0]["legs"][0]["duration_in_traffic"]["value"]
    end

    capacidades = Array.new
    for i in 0..3
      capacidades << jasons[i]["capacidad"]["value"]
    end

    #(100-capacidad)*tiempoAtencion+tiempotraslado
    #tiempoAtencion 25.4 minutos

    ponderaciones = Array.new
    for i in 0..3
      p = (100-capacidades[i])*25.4+(tiempos[i]/60)
      ponderaciones << p
    end

    idMejorHospital = 0
    minActual = 100000
    indice = -1

    for i in 0..3
      if ponderaciones[i] < minActual
        minActual = ponderaciones[i]
        idMejorHospital = jasons[i]["id"]
        indice = i
      end
    end

    puts "Mejor hospital id"
    puts idMejorHospital

    puts "Nombre del mejor hospital"
    puts client.get_content('http://130.206.112.201:1026/v2/entities/' + idMejorHospital + '/attrs/nombre/value')

    #Redirigir al url con las coordenadas del mejor hospital

    coordenadasMejorHospital = client.get_content('http://130.206.112.201:1026/v2/entities/' + idMejorHospital + '/attrs/coordenadas/value')
    coordenadasMejorHospital = coordenadasMejorHospital[1,coordenadasMejorHospital.length].chomp('"')


    mapsURL = 'https://www.google.com/maps/dir/?api=1&origin=' + compound + '&destination=' +coordenadasMejorHospital

    redirect_to(mapsURL)




=begin
https://maps.googleapis.com/maps/api/directions/json?origin=19.344935,-99.199929&destination=19.358603,-99.155045&key=AIzaSyCLrYOeMIb8jNP-stoWcN-wrWed7PgDj5k&departure_time=now

=end



  end

end
