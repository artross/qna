Rails.application.routes.draw do
  devise_for :users

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: :commentable do
    resources :answers, concerns: :commentable, shallow: true do
      post 'best_answer', on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :votes, only: [:create, :destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
