cxx_configuration "FooLib2" do
  source_lib "FooLib2",
  	:dependencies => ['Logger'],
  	:includes => ['include'],
    :sources => FileList.new('src/**/*.cpp')
end
