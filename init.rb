require 'redmine'
require 'dispatcher'
require 'bitly'
Bitly.use_api_version_3

Dispatcher.to_prepare do
  require_dependency 'bitly_host/patches/application_controller_patch'
end

Redmine::Plugin.register :bitly_host do
  name 'Bitly Host'
  author 'Gregor Schmidt'
  description 'A plugin to make your ChiliProject instance a bitly host'
  version '0.0.1'

  settings(:partial => 'settings/bitly_host',
           :default => {'username' => '',
                        'api_key'  => ''}
          )
end
