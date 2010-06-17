#include "Logger.h"
#include "FooLib2.h"

int Foo2::sub()
{
	Logger::log("Foo2::sub()");
	return a - b;
}

int Foo2::div()
{
	Logger::log("Foo2::div()");

	if(a % b == 0){
		return a / b;
	}else{
		return -1;
	}
}
