cxx_configuration "Dummy" do
  exe "Dummy",
  	:dependencies => ['Logger', 'FooLib', 'FooLib2'],
  	:includes => [],
    :sources => FileList.new('src/**/*.cpp')
end
