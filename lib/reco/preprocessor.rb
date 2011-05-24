require 'reco/scanner'
require 'reco/util'

module Reco
  class Preprocessor
    def self.preprocess(source)
      new(source).execute
    end
  
    def initialize(source)
      @scanner = Scanner.new source
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
      @output += @level.times.collect { "  " }.join
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
  
    def indent(capture = nil)
      @level += 1
      if capture
        record "__capture #{capture}"
        @captures.unshift @level
        indent
      end
    end
  
    def dedent
      @level -= 1
      fail "unexpected dedent" if @level < 0
      if @captures[0] == @level
        @captures.shift
        dedent
      end
    end
  
    def fail(message)
      raise Error, message
    end
  
    class Error < Exception; end
  
  end
end
