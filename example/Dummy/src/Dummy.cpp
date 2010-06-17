#include "Logger.h"
#include "FooLib.h"
#include "FooLib2.h"
#include <iostream>

using namespace std;

int main() {

	Logger::info("Dummy");

	int a = 4;
	int b = 5;

	Foo f(a, b);
	cout << a << " + " << b << " = " << f.sum() << endl;
	cout << a << " * " << b << " = " << f.mul() << endl;

	Foo2 f2(a, b);
	cout << a << " - " << b << " = " << f2.sub() << endl;
	cout << a << " / " << b << " = " << f2.div() << endl;

	return 0;
}
