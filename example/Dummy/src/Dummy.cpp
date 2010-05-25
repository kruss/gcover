#include "Logger.h"
#include "FooLib.h"
#include <iostream>

using namespace std;

int main() {

	Logger::info("Dummy");

	int a = 4;
	int b = 5;
	Foo f(a, b);
	cout << a << " + " << b << " = " << f.sum() << endl;
	cout << a << " * " << b << " = " << f.mul() << endl;
	return 0;
}
