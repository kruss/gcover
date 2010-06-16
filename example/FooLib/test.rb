cxx_configuration "FooLib" do
  sources = FileList.new
  sources.include('src/**/*.cpp')
  sources.include('test/**/*.cpp')
  exe "FooLib",
  	:dependencies => ['Logger', BinaryLibrary.new('cppunit')],
  	:includes => ['include'],
    :sources => sources
end
