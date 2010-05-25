#include "Logger.h"
#include "FooLib.h"

int Foo::sum()
{
	Logger::log("Foo::sum()");
	return a + b;
}

int Foo::mul()
{
	Logger::log("Foo::mul()");
	return a * b;
}
