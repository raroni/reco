require 'strscan'

class Reco::Scanner
  MODE_PATTERNS = {
    data: /(.*?)(<%%|<%(([=-])?)|\n|$)/,
    code: /(.*?)(((:|(->|=>))\s*)?%>|\n|$)/
  }  
  
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
  
  def scan(&block)
    if @scanner.eos?
      @done = true
      yield @mode == 'data' ? ["printString", flush] : ["fail", "unexpected end of template"]
    else
      advance
      @mode == :data ? scan_data(block) : scan_code(block)
    end
  end
  
  def advance
    @scanner.scan_until MODE_PATTERNS[@mode]
    @buffer += @scanner[1]
    @tail = @scanner[2]
    @directive = @scanner[4]
    @arrow = @scanner[5]
  end
  
  def scan_data(block)
    if @tail == "\n"
      @buffer += @tail
      scan block
    elsif @tail
      @mode = :code
      block.call ["printString", flush]
      block.call ["beginCode", print: !!@directive, safe: @directive == '-']
    end
  end
  
  def scan_code(block)
    
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
