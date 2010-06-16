cxx_configuration "Dummy" do
  exe "Dummy",
  	:dependencies => ['Logger', 'FooLib'],
  	:includes => [],
    :sources => FileList.new('src/**/*.cpp')
end
