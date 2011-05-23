require 'strscan'

class Reco::Scanner
  MODE_PATTERNS = {
    data: /(.*?)(<%%|<%(([=-])?)|\n|$)/,
    code: /(.*?)(((:|(->|=>))\s*)?%>|\n|$)/
  }
  DEDENTABLE_PATTERN = /^(end|when|else|catch|finally)(?:\W|$)/
  
  def self.scan(source)
    tokens = []
    scanner = new source
    scanner.scan { |token| tokens << token } until scanner.done?
    tokens
  end
  
  def initialize(source)
    @source = source
    @scanner = StringScanner.new source
    @mode = :data
    @buffer = ''
    @done = false
  end
  
  def scan(callback = nil, &block)
    callback ||= block
    
    if @scanner.eos?
      @done = true
      yield @mode == :data ? ["printString", flush] : ["fail", "unexpected end of template"]
    else
      advance
      @mode == :data ? scan_data(callback) : scan_code(callback)
    end
  end
  
  def advance
    @scanner.scan_until MODE_PATTERNS[@mode]
    @buffer += @scanner[1]
    @tail = @scanner[2]
    @directive = @scanner[4]
    @arrow = @scanner[5]
  end
  
  def scan_data(callback)
    if @tail == "<%%"
      @buffer += "<%"
      scan callback
    elsif @tail == "\n"
      @buffer += @tail
      scan callback
    elsif @tail
      @mode = :code
      callback.call ["printString", flush]
      callback.call ["beginCode", print: !!@directive, safe: @directive == '-']
    end
  end
  
  def scan_code(callback)
    if @tail == "\n"
      callback.call ["fail", "unexpected newline in code block"]
    elsif !@tail.empty?
      @mode = :data
      code = flush.strip
      code += " #{@arrow}" if @arrow
      
      callback.call ["dedent"] if is_dedentable?(code)
      callback.call ["recordCode", code]
      callback.call ["indent", @arrow] if @directive
    end
  end
  
  def is_dedentable?(code)
    code.match DEDENTABLE_PATTERN
  end
  
  def flush
    buffer = @buffer
    @buffer = ''
    buffer
  end
  
  def done?
    @done
  end
  
end
