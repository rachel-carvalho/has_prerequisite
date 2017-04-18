module HasPrerequisite
  class Railtie < Rails::Railtie
    initializer "has_prerequisite.configure_view_controller" do |app|
      ActiveSupport.on_load :action_controller do
        include HasPrerequisite
      end
    end
  end
end
