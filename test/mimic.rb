
module TestUtils

  class Mimic
  
    def initialize(attrs)
      add_attrs attrs
    end
  
    def add_attrs(attrs)
      attrs.each do |var, value|
        (class << self ; self ; end).class_eval { attr_accessor var }
        instance_variable_set "@#{var}", value
      end
    end
  end

end
