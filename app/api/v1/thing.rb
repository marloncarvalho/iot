require 'grape'
require 'model/thing'
require 'api/v1/entity/thing'
require 'api/v1/entity/error'
require 'util/dm-wrappers'

module API

  module V1

    class Thing < Grape::API
      format :json

      # Exibir mensagem padrão de erro quando um modelo não é encontrado
      # na base de dados. É retornado o status 404 e mais uma mensagem de erro
      # genérica para esta situação.
      rescue_from DataMapper::ObjectNotFoundError do |e|
        error_response(message: 'Resource not found.', status: 404)
      end

      # Tratar quando ocorrerem erros de validação do DataMapper.
      # O erro é tratado e retornado para o cliente de uma forma mais elegante.
      rescue_from DataMapper::ValidationFailureError do |e|
        error = Entity::Error.new(
            :description => 'Não foi possível processar o recurso enviado. Falha na validação dos atributos.',
            :code => 422,
            :url => 'http://iot.home/errors/422')

        e.resource.errors.each_pair do |k, e|
          error.details << Entity::Error::Detail.new(:cause => k, :messages => e)
        end

        rack_response error.to_json, 422
      end

      resources :things do

        desc 'Listar todas as "Coisas" disponíveis".'
        get do
          present Model::Thing.all, :with => Entity::Thing
        end

        desc 'Obter uma "Coisa" por seu identificador.'
        get ':id' do
          present Model::Thing.get!(params[:id]), :with => Entity::Thing
        end

        desc 'Criar uma "Coisa".'
        post '' do
          thing = Model::Thing.new
          thing.name = params[:name]
          thing.address = params[:address]
          thing.description = params[:description]
          thing.save!

          present thing, :with => Entity::Thing
        end

        desc 'Criar uma ação para uma "Coisa".'
        post ':id/actions' do
          thing = Model::Thing.get params[:id]
          action = Model::Thing::Action.new
          action.name = params[:name]
          action.thing = thing
          action.save

          present thing, :with => Entity::Thing
        end

        desc 'Criar ou atualizar os dados de uma "Coisa".'
        put ':id' do
          thing = Model::Thing.get params[:id]

          if thing.nil?
            status 201
            thing = Model::Thing.new
          end

          thing.name = params[:name] unless params[:name].nil?
          thing.address = params[:address] unless params[:address].nil?
          thing.description = params[:description] unless params[:description].nil?
          thing.save!

          present thing, :with => Entity::Thing
        end

        desc 'Remover uma "Coisa".'
        delete ':id' do
          status 204
          thing = Model::Thing.get! params[:id]
          thing.destroy!
        end

        desc 'Executar uma ação em uma "Coisa".'
        post ':id/actions/:action/execution' do
          thing = Model::Thing.get! params[:id]
          action = Model::Thing::Action.get! params[:action]
          status 200

          begin
            action.execute
            present action, :with => Entity::Action
          rescue
            status 400
            present thing, :with => Entity::Thing
          end

        end

      end

    end

  end

end