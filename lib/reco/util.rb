module Reco::Util
  SPECIAL_CHARACTERS = {
    "\\" => '\\\\',
    "\b" => '\\b',
    "\f" => '\\f',
    "\n" => '\\n',
    "\r" => '\\r',
    "\t" => '\\t'
  }
  
  def self.inspect_string(string)
    string.gsub!(/[\x00-\x1f\\]/) do |character|
      if SPECIAL_CHARACTERS[character]
        SPECIAL_CHARACTERS[character]
      else
        code = character.ord.to_s 16
        code = "0#{code}" if code.length == 1
        "\\u00#{code}"
      end
    end
    
    "'" + string.gsub("'", "\\\\'") + "'"
  end
end
