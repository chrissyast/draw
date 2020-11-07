Rails.application.routes.draw do
  post 'calculation', to: "result#calculation"
  get 'results/:id', to: "result#load"
end
