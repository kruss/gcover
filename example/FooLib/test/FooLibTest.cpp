#include "cppunit/extensions/HelperMacros.h"
#include "FooLib.h"

class FooLibTest : public CppUnit::TestFixture
{
public:

	void setUp()
	{
		a = 4;
		b = 5;
		pFoo = new Foo(a, b);
	}

	void tearDown()
	{
		delete pFoo;
	}

	void testSum()
	{
		CPPUNIT_ASSERT_EQUAL(9, pFoo->sum());
	}

	void testMul()
	{
		CPPUNIT_ASSERT_EQUAL(20, pFoo->mul());
	}

	CPPUNIT_TEST_SUITE(FooLibTest);

		CPPUNIT_TEST(testSum);
		CPPUNIT_TEST(testMul);

	CPPUNIT_TEST_SUITE_END();

private:

	int a;
	int b;
	Foo* pFoo;
};

CPPUNIT_TEST_SUITE_REGISTRATION(FooLibTest);
