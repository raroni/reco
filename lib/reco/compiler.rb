require 'coffee-script'

module Reco
  class Compiler
    def self.preprocess(source)
      Preprocessor.preprocess source
    end
  
    def self.compile(source, options = {})
      compiled_javascript = CoffeeScript.compile preprocess(source), :noWrap => true
      identifier = options[:identifier] || 'module.exports'
      identifier = "var #{identifier}" unless identifier.include? '.'
      
      wrapper % [identifier, compiled_javascript]
    end
  
    def self.wrapper
      File.read File.join(File.dirname(__FILE__), 'wrapper.js')
    end
    
  end
end
