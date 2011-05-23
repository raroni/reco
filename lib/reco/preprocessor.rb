require 'reco/scanner'
require 'reco/util'

class Reco::Preprocessor
  def self.preprocess(source)
    new(source).execute
  end
  
  def initialize(source)
    @scanner = Reco::Scanner.new source
    @output = ''
    @level = 0
    @options = {}
    @captures = []
  end
  
  def execute
    @scanner.scan { |token| send token.shift, *token } until @scanner.done?
    @output
  end
  
  def record(line)
    @output += @level.times.collect { ' ' }.join
    @output += "#{line}\n"
  end
  
  def print_string(string)    
    record "__out.push #{Reco::Util.inspect_string(string)}" unless string.empty?
  end
  
  def begin_code(options)
    @options = options
  end
  
  def record_code(code)
    if code != 'end'
      if @options[:print]
        record @options[:safe] ? "__out.push #{code}" : "__out.push __sanitize #{code}"
      else
        record code
      end
    end
  end
  
end
