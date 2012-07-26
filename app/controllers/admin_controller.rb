class AdminController < ActionController::Base
    protect_from_forgery
    before_filter :authenticate_user!

    FILTERS = {
      admin_only: ["global_role = 'admin'"],
      unconfirmed_only: ["confirmed_at IS NULL"],
      no_filter: []
    }


    def apply_filter
      (params.has_key?(:filter) and FILTERS.has_key?(params[:filter].to_sym)) ? FILTERS[params[:filter].to_sym] : []
    end

    def filter_name
      params.has_key?(:filter) and FILTERS.has_key?(params[:filter].to_sym) ? params[:filter] : ''
    end

    def find_user
      (params.has_key? :query) ? ['email LIKE ?', "%#{params[:query]}%"] : []
    end

    def find_community
      (params.has_key? :query) ? ['name LIKE ?', "%#{params[:query]}%"] : []
    end

end