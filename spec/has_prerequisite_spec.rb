require 'spec_helper'
require_relative 'dummy/spec/rails_helper'

describe HasPrerequisite::VERSION do
  it 'has a version number' do
    expect(subject).not_to be nil
  end
end

describe HasPrerequisite, type: :controller do
  it 'has a version number' do
    expect(HasPrerequisite::VERSION).not_to be nil
  end

  controller(ApplicationController) do
      include HasPrerequisite

      prerequisite :prerequisite1, redirection_path: 'path_1'
      prerequisite :prerequisite2, redirection_path: 'path_2', if: :condition

      before_action :perform_checks

      def index
        render text: nil
      end

      private

      def prerequisite1
        true
      end

      def prerequisite2
        true
      end

      def condition
        true
      end
  end

  describe 'redirection' do
    subject { get :index }

    it 'does not interfere when the prerequisite is met' do
      expect(controller).to receive(:prerequisite1) { true }
      expect(controller).to receive(:prerequisite2) { true }
      expect(subject).to be_success
    end

    it 'it redirects to the path when the prerequisite is not met' do
      expect(controller).to receive(:prerequisite1) { true }
      expect(controller).to receive(:prerequisite2) { false }
      expect(subject).to redirect_to 'path_2'
    end
  end

  describe 'conditionnal' do
    subject { get :index }

    it 'it supports an `if` option to skip the check' do
      expect(controller).to receive(:condition) { false }
      expect(controller).to_not receive(:prerequisite2)
      expect(subject).to be_success
    end
  end

  describe 'fulfilling_prerequisite' do
    controller(ApplicationController) do
      include HasPrerequisite

      prerequisite :pre, redirection_path: 'path_1'
      before_action :perform_checks
      fulfilling_prerequisite

      def index
        render text: nil
      end
    end

    subject { get :index }

    it 'skips the checks' do
      expect(controller).to_not receive(:pre)
      expect(subject).to be_success
    end
  end

  describe 'step_fulfilled!' do
    controller(ApplicationController) do
      include HasPrerequisite

      prerequisite :pre, redirection_path: 'path_1'
      before_action :perform_checks
      fulfilling_prerequisite

      def index
        step_fulfilled!
      end
    end

    before { session[:return_to] = 'redirect_back_to' }
    subject { get :index }

    it 'redirects to the stored location' do
      expect(controller).to_not receive(:pre)
      expect(subject).to redirect_to 'redirect_back_to'
    end
  end
end
