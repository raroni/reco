require 'strscan'

class Reco::Scanner
  MODE_PATTERNS = {
    :data => /(.*?)(<%%|<%\s*(\#)|<%(([=-])?)|\n|$)/,
    :code => /(.*?)((((:|(->|=>))\s*))?%>|\n|$)/,
    :comment => /(.*?)(%>|\n|$)/
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
      callback.call @mode == :data ? ["print_string", flush] : ["fail", "unexpected end of template"]
    else
      advance
      
      case @mode
      when :data
        scan_data callback
      when :code
        scan_code callback
      when :comment
        scan_comment callback
      end
    end
  end
  
  def advance
    @scanner.scan_until MODE_PATTERNS[@mode]
    @buffer += @scanner[1]
    @tail = @scanner[2]
    @comment = @scanner[3]
    @directive = @scanner[5]
    @arrow = @scanner[6]
  end
  
  def scan_data(callback)
    if @tail == "<%%"
      @buffer += "<%"
      scan callback
    elsif @tail == "\n"
      @buffer += @tail
      scan callback
    elsif @tail
      callback.call ["print_string", flush]
      
      if @comment
        @mode = :comment
      else
        @mode = :code
        callback.call ["begin_code", {:print => !!@directive, :safe => @directive == '-'}]
      end
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
      callback.call ["record_code", code]
      callback.call ["indent", @arrow] if @directive
    end
  end
  
  def scan_comment(callback)
    if @tail == "\n"
      callback.call ['fail', 'unexpected newline in code block']
    elsif @tail
      @mode = :data
      @buffer = ''
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
