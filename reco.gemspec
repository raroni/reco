Gem::Specification.new do |s|
  s.name = "reco"
  s.version = "0.1.2"
  s.summary = "Ruby port of the Eco template compiler."
  s.description = "Reco let you compile Eco templates into Javascript through Ruby."

  s.files = Dir["README.md", "LICENSE", "lib/**/*.rb", "lib/reco/wrapper.js"]

  s.add_dependency "coffee-script", "~> 2.0"
  
  s.add_development_dependency "rake"
  
  s.homepage = 'https://github.com/rasmusrn/reco'
  s.authors = ["Rasmus Rønn Nielsen"]
  s.email = "rasmusrnielsen@gmail.com"
end
