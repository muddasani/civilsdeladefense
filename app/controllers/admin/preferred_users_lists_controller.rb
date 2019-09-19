# frozen_string_literal: true

class Admin::PreferredUsersListsController < Admin::InheritedResourcesController
  layout 'admin/pool'

  def new
    render layout: request.xhr? ? false : 'admin/pool'
  end

  def create
    resource.administrator ||= current_administrator
    create! do |success, failure|
      success.html do
        render json: {}.to_json, status: :created, location: [:admin, resource]
      end
      failure.html do
        layout_choice = request.xhr? ? false : 'admin/pool'
        render action: 'new', status: :unprocessable_entity, layout: layout_choice
      end
    end
  end

  def show
    @users = @preferred_users_list.users
    @q = @users.ransack(params[:q])
    @users_filtered = @q.result.yield_self do |relation|
      if params[:s].present?
        relation.search_full_text(params[:s])
      else
        relation
      end
    end.yield_self do |relation|
      relation.includes(:personal_profile, :preferred_users).paginate(page: params[:page])
    end

    render action: :show, layout: 'admin/pool'
  end

  protected

  def begin_of_association_chain
    current_administrator
  end
end