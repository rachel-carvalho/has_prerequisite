require "has_prerequisite/version"
require "active_support"

module HasPrerequisite
  extend ActiveSupport::Concern

  included do
    class_attribute :prerequisites, :skipping_checks
    self.prerequisites = []
    self.skipping_checks = false

    rescue_from HasPrerequisite::PrerequisiteNotMet, with: :prerequisite_not_met!
  end

  module ClassMethods
    def prerequisite(method, redirection_path: nil, **options)
      before_action :perform_checks

      prerequisites << { method: method, redirection_path: redirection_path, options: options }
    end

    def fulfilling_prerequisite
      self.skipping_checks = true
    end
  end

  def step_fulfilled!
    redirect_to stored_location_for(:user)
  end

  private

  def perform_checks
    return if self.class.skipping_checks
    return unless failing_preriquisite
    store_location_for(:user, request.fullpath)
    raise HasPrerequisite::PrerequisiteNotMet
  end

  def failing_preriquisite
    @failing_preriquisite ||= prerequisites.find do |p|
      !send(p[:method]) if p[:options][:if].nil? || send(p[:options][:if])
    end
  end

  def prerequisite_not_met!
    redirect_to redirect_path
  end

  def redirect_path
    return send(failing_preriquisite[:redirection_path]) if failing_preriquisite[:redirection_path].is_a? Symbol
    failing_preriquisite[:redirection_path]
  end

  class PrerequisiteNotMet < StandardError; end
end
