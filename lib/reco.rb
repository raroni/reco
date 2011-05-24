module Reco
  VERSION = '0.1.0'
  
  autoload :Compiler, "reco/compiler"
  autoload :Scanner, "reco/scanner"
  autoload :Preprocessor, "reco/preprocessor"
  
  def self.compile(source, options = {})
    Compiler.compile source, options
  end
end
