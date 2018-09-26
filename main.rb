require_relative 'framework'

APP = App.new do 
    get '/:foo' do |params|
        params.fetch("foo")
    end 

    get '/users/:username' do |params|
        "this is a #{params.fetch('username')}!"
    end 
    
end 


