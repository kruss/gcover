cxx_configuration "FooLib2" do
  sources = FileList.new
  sources.include('src/**/*.cpp')
  sources.include('test/**/*.cpp')
  exe "FooLib2",
  	:dependencies => ['Logger', BinaryLibrary.new('cppunit')],
  	:includes => ['include'],
    :sources => sources
end
