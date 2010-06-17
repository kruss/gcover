#include "cppunit/extensions/HelperMacros.h"
#include "FooLib2.h"

class FooLib2Test : public CppUnit::TestFixture
{
public:

	void setUp()
	{
		a = 20;
		b = 5;
		pFoo = new Foo2(a, b);
	}

	void tearDown()
	{
		delete pFoo;
	}

	void testSub()
	{
		CPPUNIT_ASSERT_EQUAL(15, pFoo->sub());
	}

	void testDiv()
	{
		CPPUNIT_ASSERT_EQUAL(4, pFoo->div());
	}

	CPPUNIT_TEST_SUITE(FooLib2Test);

		CPPUNIT_TEST(testSub);
		CPPUNIT_TEST(testDiv);

	CPPUNIT_TEST_SUITE_END();

private:

	int a;
	int b;
	Foo2* pFoo;
};

CPPUNIT_TEST_SUITE_REGISTRATION(FooLib2Test);
