Gem::Specification.new do |s|
  s.name = "reco"
  s.version = "0.1.0"
  s.summary = "Ruby port of the Eco templating."
  s.description = "Reco lets you compile Eco templates into Javascript through Ruby."

  s.files = Dir["LICENSE", "lib/**/*.rb"]

  s.add_dependency "coffee-script", "~> 2.0"

  s.authors = ["Rasmus Rønn Nielsen"]
  s.email = "rasmusrnielsen@gmail.com"
end
