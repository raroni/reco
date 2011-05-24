require 'coffee-script'

module Reco
  class Compiler
    def self.preprocess(source)
      Preprocessor.preprocess source
    end
  
    def self.compile(source)
      javascript = CoffeeScript.compile preprocess(source)
      wrapper % { compiled_javascript: javascript }
    end
  
    def self.wrapper
      File.read File.join(File.dirname(__FILE__), 'wrapper.js')
    end
  end
end
