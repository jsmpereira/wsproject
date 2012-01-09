Wsproject::Application.routes.draw do
  resources :searches
  
  resources :memories

  resources :videocards

  resources :processors

  resources :motherboards

  match 'sparql' => 'searches#sparql'
  match 'browse' => 'searches#browse'
  match 'rdf' => 'searches#rdf'
  match 'semantic' => 'searches#semantic'
  match 'traverse' => 'searches#traverse'

  root :to => 'searches#index'
end
