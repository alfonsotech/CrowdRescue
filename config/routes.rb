Rails.application.routes.draw do
  devise_for :users

  root to: 'disasters#index', as: :root

  scope '/admin' do
    scope '/roles' do
      root to: 'roles#index', as: :admin_roles
      post 'add', to: 'roles#add_role', as: :admin_add_role
      post 'remove', to: 'roles#remove_role', as: :admin_remove_role
    end
  end

  scope '/disasters' do
    root to: 'disasters#index', as: :disasters
    get 'new', to: 'disasters#new', as: :new_disaster
    post 'new', to: 'disasters#create', as: :create_disaster

    get 'requests', to: 'rescue_requests#index', as: :global_requests
    scope ':disaster_id' do
      scope 'requests' do
        root to: 'rescue_requests#disaster_index', as: :disaster_requests
        get 'new', to: 'rescue_requests#new', as: :new_disaster_request
        post 'new', to: 'rescue_requests#create', as: :create_disaster_request
        post 'update', to: 'rescue_requests#update', as: :update_disaster_request
        get ':num/edit', to: 'rescue_requests#edit', as: :edit_disaster_request
        get ':num', to: 'rescue_requests#show', as: :disaster_request
        get ':num/status', to: 'rescue_requests#triage_status', as: :request_triage_status
        get ':num/auth', to: 'rescue_requests#authorizations', as: :request_authorizations
        get ':num/assignee', to: 'rescue_requests#assignee', as: :change_request_assignee
        post ':num/assignee', to: 'rescue_requests#apply_assignee', as: :apply_request_assignee
        post ':num/status', to: 'rescue_requests#apply_triage_status', as: :request_apply_status
        post ':num/medical_status', to: 'rescue_requests#apply_medical_triage_status', as: :request_apply_medical_status
        post ':num/safe', to: 'rescue_requests#mark_safe', as: :request_rescue_safe
      end
    end
  end

  scope '/requests' do
    scope ':request_id' do
      scope 'notes' do
        get 'new', to: 'case_notes#new', as: :new_case_note
        post 'new', to: 'case_notes#create', as: :create_case_note
        get ':id/edit', to: 'case_notes#edit', as: :edit_case_note
        patch ':id/edit', to: 'case_notes#update', as: :update_case_note
        delete ':id', to: 'case_notes#destroy', as: :destroy_case_note
      end
    end
  end

  scope '/statuses' do
    scope '/rescue_request' do
      root to: 'request_status#index', as: :request_status_index
      patch ':num/update', to: 'request_status#update', as: :request_status_update
      get ':num/edit', to: 'request_status#edit', as: :request_status_edit
      get 'new', to: 'request_status#new', as: :request_status_new
      post 'create', to: 'request_status#create', as: :request_status_create
    end

    scope '/medical' do
      root to: 'medical_status#index', as: :medical_status_index
      get ':num/edit', to: 'medical_status#edit', as: :medical_status_edit
      patch ':num/update', to: 'medical_status#update', as: :medical_status_update
      get 'new', to: 'medical_status#new', as: :medical_status_new
      post 'create', to: 'medical_status#create', as: :medical_status_create
    end
  end

  scope '/queues' do
    scope 'dedupe' do
      root to: 'queues#dedupe', as: :dedupe_queue
      post 'complete', to: 'queues#dedupe_complete', as: :dedupe_complete
    end
    scope 'spam' do
      root to: 'queues#spam', as: :spam_queue
      post 'complete', to: 'queues#spam_complete', as: :spam_complete
    end
  end

  scope '/api' do
    scope 'requests' do
      get 'geojson', to: 'api#geojson', as: :api_geojson
      get 'csv', to: 'api#csv', as: :api_csv
    end
  end

  scope '/users' do
    scope 'authorizations' do
      post 'new', to: 'user_authorizations#create', as: :create_authorization
      delete ':id', to: 'user_authorizations#destroy', as: :destroy_authorization
    end
  end
end
