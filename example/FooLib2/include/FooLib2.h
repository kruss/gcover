#ifndef FOOLIB2_H_
#define FOOLIB2_H_

class Foo2 {

public:

	Foo2(int a, int b)
	{
		this->a = a;
		this->b = b;
	}

	int sub();
	int div();

private:

	int a;
	int b;
};

#endif /* FOOLIB2_H_ */
