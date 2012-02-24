# Adding CORS / XHR2 / XDR support to Rails 2.3.x

# In Ubuntu the original file is found at
#/var/lib/gems/1.8/gems/actionpack-2.3.3/lib/action_controller/resources.rb

# The patch should be placed in your rails project in
#./config/initializers/resources.rb

module ActionController
  module Resources
    class Resource #:nodoc:
      DEFAULT_ACTIONS = :index, :create, :new, :edit, :show, :update, :destroy, :options #Options Patch
    end

    private
      def map_default_collection_actions(map, resource)
        index_route_name = "#{resource.name_prefix}#{resource.plural}"

        if resource.uncountable?
          index_route_name << "_index"
        end
        map_resource_routes(map, resource, :index, resource.path, index_route_name)
        map_resource_routes(map, resource, :create, resource.path, index_route_name)
        map_resource_routes(map, resource, :options, resource.path, index_route_name) #Options Patch
      end

      def map_member_actions(map, resource)
        resource.member_methods.each do |method, actions|
          actions.each do |action|
            [method].flatten.each do |m|
              action_path = resource.options[:path_names][action] if resource.options[:path_names].is_a?(Hash)
              action_path ||= Base.resources_path_names[action] || action

              map_resource_routes(map, resource, action, "#{resource.member_path}#{resource.action_separator}#{action_path}", "#{action}_#{resource.shallow_name_prefix}#{resource.singular}", m, { :force_id => true })
            end
          end
        end

        route_path = "#{resource.shallow_name_prefix}#{resource.singular}"
        map_resource_routes(map, resource, :show, resource.member_path, route_path)
        map_resource_routes(map, resource, :update, resource.member_path, route_path)
        map_resource_routes(map, resource, :destroy, resource.member_path, route_path)
        map_resource_routes(map, resource, :options, resource.member_path, route_path) #Options Patch
      end

      def action_options_for(action, resource, method = nil, resource_options = {})
        default_options = { :action => action.to_s }
        require_id = !resource.kind_of?(SingletonResource)
        force_id = resource_options[:force_id] && !resource.kind_of?(SingletonResource)

        case default_options[:action]
          when "index", "new"; default_options.merge(add_conditions_for(resource.conditions, method || :get)).merge(resource.requirements)
          when "create";       default_options.merge(add_conditions_for(resource.conditions, method || :post)).merge(resource.requirements)
          when "show", "edit"; default_options.merge(add_conditions_for(resource.conditions, method || :get)).merge(resource.requirements(require_id))
          when "update";       default_options.merge(add_conditions_for(resource.conditions, method || :put)).merge(resource.requirements(require_id))
          when "destroy";      default_options.merge(add_conditions_for(resource.conditions, method || :delete)).merge(resource.requirements(require_id))
          when "options";      default_options.merge(add_conditions_for(resource.conditions, method || :options)).merge(resource.requirements) #Options Patch
          else                 default_options.merge(add_conditions_for(resource.conditions, method)).merge(resource.requirements(force_id))
        end
      end
  end
end
