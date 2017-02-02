Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }

  resources :questions do
    resources :answers do
      post 'best_answer', on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :votes, only: [:create, :destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
