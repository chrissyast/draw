Rails.application.routes.draw do
  post 'calculation', to: "result#calculation"
  get 'results', to: "result#load"
end
