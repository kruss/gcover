#ifndef FOOLIB_H_
#define FOOLIB_H_

class Foo {

public:

	Foo(int a, int b)
	{
		this->a = a;
		this->b = b;
	}

	int sum();
	int mul();

private:

	int a;
	int b;
};

#endif /* FOOLIB_H_ */
