cxx_configuration "FooLib" do
  source_lib "FooLib",
  	:dependencies => ['Logger'],
  	:includes => ['include'],
    :sources => FileList.new('src/**/*.cpp')
end
