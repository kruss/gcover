#!/usr/bin/env ruby

system("gcov -l -p -o build/objects/Logger/src build/objects/Logger/src/Logger.cpp.o")
system("gcov -l -p -o build/objects/FooLib/src build/objects/FooLib/src/FooLib.cpp.o")
system("gcov -l -p -o build/objects/FooLib/test build/objects/FooLib/test/FooLibTest.cpp.o")