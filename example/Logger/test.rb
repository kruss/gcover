cxx_configuration "Logger" do
  source_lib "Logger",
  	:includes => ['include'],
    :sources => FileList.new('src/**/*.cpp')
end
