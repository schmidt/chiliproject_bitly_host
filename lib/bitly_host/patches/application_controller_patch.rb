require_dependency 'application_controller'

module BitlyHost::Patches::ApplicationControllerPatch
  def self.included(base)
    base.class_eval do
      unloadable

      include InstanceMethods
      alias_method_chain :render_404, :bitly_host
    end

    base.subclasses.each do |subclass|
      subclass.send(:include, BitlyHost::Patches::ApplicationControllerPatch)
    end
  end

  module InstanceMethods
    def render_404_with_bitly_host(options = {})
      render_404_without_bitly_host unless bitly_redirect?(self)
    end

    def render_optional_error_file(status_code)
      case status_code
      when 404
        super unless bitly_redirect?(controller)
      else
        super
      end
    end

    def bitly_redirect?(controller)
      hash = controller.request.path[1..-1]

      return false if hash.include?('/')

      client = BitlyHost.client

      return false if client.nil?

      info = client.expand(hash)

      return false if info.long_url.blank?

      redirect_to info.long_url, :status => :moved_permanently
      true
    end
  end
end

ApplicationController.send(:include, BitlyHost::Patches::ApplicationControllerPatch)
