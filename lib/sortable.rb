module Sortable
  module Controller
    module ClassMethods
      def sort model_name, options={}
        @@sort_class = model_name.to_s.camelize.constantize
        @@sort_options = options
      end

      def get_sort
        @@sort_class
      end

      def get_sort_options
        @@sort_options
      end
    end
    def self.included(base)
      base.class_eval do
        helper_method :sort_column, :sort_direction
      end
      base.extend(ClassMethods)  
    end

    private
      def sort_direction
       %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
      end
     
      def sort_column
        self.class.get_sort.column_names.include?(params[:sort]) ? params[:sort] : default_sort_column.to_s
      end

      def default_sort_column
        options = self.class.get_sort_options
        if options.has_key?(:default_column)
          options[:default_column].respond_to?(:call) ? options[:default_column].call(self) : options[:default_column]
        else 
          self.class.get_sort.column_names.first
        end
      end
  end

  module View
    def sortable(column, title = nil)
      title ||= column.titleize
      direction = (column.to_s == sort_column && sort_direction == "asc") ? "desc" : "asc"
      link_to title, :sort => column, :direction => direction
    end
  end
end