# encoding: UTF-8
#
module Captcha

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods

    def has_captcha
      send(:include, InstanceMethods)
    end

  end

  module InstanceMethods

    attr_accessor :captcha_code, :captcha_form_result

    NUMBERS         = (1..9).to_a
    OPERATIONS      = ['+', '-', '*']

    def captcha_code
      @@captcha_code.to_s ||= raise 'Captcha undefined error.'
    end

    def initialize(params={}, &block)
      initialize_kaptcha params
      super(params, &block)
    end

    def validate
      if new_record?
        unless captcha_form_result == captcha_code
          initialize_kaptcha
          errors.add(:captcha_code, I18n.t('view.captcha.error_code')) 
        end
      end
      true
    end

    def captcha_desc
      @@captcha_desc
    end

    def human_captcha_desc
      @@human_captcha_desc
    end

  private

    def initialize_kaptcha(params={})
      begin
        captcha_a = params[:captcha_code].split[0].to_i
      rescue NoMethodError
        captcha_a ||= NUMBERS[rand(NUMBERS.size)]
      end

      begin
        captcha_b = params[:captcha_code].split[2].to_i
      rescue NoMethodError
        captcha_b ||= NUMBERS[rand(NUMBERS.size)]
      end

      begin
        captcha_operation = params[:captcha_code].split[1]
      rescue NoMethodError
        captcha_operation ||= OPERATIONS[rand(OPERATIONS.size)]
      end

      case captcha_operation.to_s
      when '-'
        human_captcha_operation = I18n.t('view.captcha.operations.minus')
      when '+'
        human_captcha_operation = I18n.t('view.captcha.operations.plus')
      when '*'
        human_captcha_operation = I18n.t('view.captcha.operations.multiply_by')
      end

      @@captcha_desc = "#{captcha_a} #{captcha_operation} #{captcha_b}"
      @@human_captcha_desc = I18n.t('view.captcha.human_line', :num_a => captcha_a, :operation => human_captcha_operation, :num_b => captcha_b)

      @@captcha_code = captcha_a.send(captcha_operation, captcha_b)
    end

  end

end
