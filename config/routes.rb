# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
    get "nogikuis/index"
    get "nogikuis/index", to: "nogikuis#index"
    get "nogikuis/terms", to: "nogikuis#terms"
    get "nogikuis/privacy", to: "nogikuis#privacy"
    get "nogikuis/inquiry", to: "nogikuis#inquiry"
    get "nogikuis/:sort", to: "nogikuis#sort"
    post "nogikuis/:sort", to: "nogikuis#create"
end
