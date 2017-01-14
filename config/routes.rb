Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers do
      post 'best_answer', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"
end
