require "active_record"

require File.join(File.dirname(__FILE__), 'core/kaptcha')

if defined? ActiveRecord::Base
  ActiveRecord::Base.send :include, Captcha
end

if defined? I18n
  I18n.load_path += Dir.glob(File.expand_path('../config/locales/kaptcha.en.yml', __FILE__))
end

