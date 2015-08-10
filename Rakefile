desc 'Build the slide show'
task :build do
  exec('slideshow build slides.md --template=deck.js --h2 --output=build ; cp -rf i/ build/')
end

task default: :build
