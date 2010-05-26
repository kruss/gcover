#ifdef CPPUNIT_MAIN
#include "cppunit/TestListener.h"
#include "cppunit/TestResultCollector.h"
#include "cppunit/XmlOutputter.h"
#include "cppunit/TestSuite.h"
#include "cppunit/TestResult.h"
#include "cppunit/TestFailure.h"
#include "cppunit/SourceLine.h"
#include "cppunit/Exception.h"
//#include "cppunit/NotEqualException.h"
#include "cppunit/extensions/TestFactoryRegistry.h"
#include "cppunit/extensions/TestDecorator.h"
#include "cppunit/ui/text/TestRunner.h"
#include <fstream>

#include <iostream>
#include <sstream>
#include <typeinfo>
#include <vector>

#include <strings.h>
#include <errno.h>
#include <unistd.h>
#include <sys/time.h>

#ifdef _WIN32 // Bugzilla 40710
#include <windows.h>
#include <winbase.h>
#include <winsock.h>
#else
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#endif

static const std::string TRACE_START	= "%TRACES ";
static const std::string TRACE_END	= "%TRACEE ";
static const std::string TEST_RUN_START	= "%TESTC  ";
static const std::string TEST_START	= "%TESTS  ";
static const std::string TEST_END	= "%TESTE  ";
static const std::string TEST_ERROR	= "%ERROR  ";
static const std::string TEST_FAILED	= "%FAILED ";
static const std::string TEST_RUN_END	= "%RUNTIME";
static const std::string TEST_STOPPED	= "%TSTSTP ";
static const std::string TEST_TREE	= "%TSTTREE";


class RemoteTestRunner: public CppUnit::TestListener
{
private:
	CppUnit::TestResult *fTestResult;
	int fClientSocket;
	char *fHost;
	int fPort;
	int fDebugMode;
	int fKeepAlive;
public:
	RemoteTestRunner()
	{
		fTestResult=0;
		fClientSocket=-1;
		fHost=(char *)malloc(255);
		strcpy(fHost,"");
		fPort=0;
		fDebugMode=0;
		fKeepAlive=0;
	}
	int run()
	{
		if(connect()==-1)
			return(-1);
		if(connect()==-1)
			return(-1);
		fTestResult=new CppUnit::TestResult();
		fTestResult->addListener(this);
		runTests();
		fTestResult->removeListener(this);
		if(fTestResult!=NULL)
		{
			fTestResult->stop();
			fTestResult= NULL;
		}
		shutDown();
		return(0);
	}
	void init(int n,char *args[])
	{
		for(int i=0;i<n;i++)
		{
			std::string arg(args[i]);
			std::string portOption("-port=");
			int pos=arg.find(portOption);
			if(pos>-1)
			{
				std::string v=arg.substr(pos+portOption.length(),arg.length());
				fPort=atoi(v.c_str());
			}
			std::string debugOption("-debug");
			pos=arg.find(debugOption);
			if(pos>-1)
			{
				fDebugMode=1;
			}
		}
		int ret=gethostname(fHost,255);
		if(ret==-1)
		{
			strcpy(fHost,"localhost");
		}
	}
	int connect()
	{
#ifdef _WIN32 // Bugzilla 40710
		WSADATA   WSAData;
		if(WSAStartup (MAKEWORD (1, 1), &WSAData) != 0)
		{
			std::cerr << "WSAStartup failed ! " <<std::endl;
			return(-1);
		}
#endif
		struct sockaddr_in name;
		if (fDebugMode)
		{
			std::cerr << "RemoteTestRunner: trying to connect to "<<fHost<<":"<<fPort<<std::endl;
		}
		fClientSocket=socket(AF_INET, SOCK_STREAM,0);
		if(fClientSocket==-1)
		{
			std::cerr << "socket failed "  << std::endl;
			return(-1);
		}
//Bugzilla 40710		bzero((char *)&name,sizeof(struct sockaddr_in));
		memset((void *)&name,0,sizeof(struct sockaddr_in));
		name.sin_family=AF_INET;
		name.sin_port=htons(fPort);
		struct hostent *h=gethostbyname(fHost);
		if(h==NULL)
		{
			std::cerr << "Cannot find host address for " << fHost<<std::endl;
			fClientSocket=-1;
			return(-1);
		}
//Bugzilla 40710		bcopy(h->h_addr,&name.sin_addr,h->h_length);
		memcpy(&name.sin_addr,h->h_addr,h->h_length);
		int ret=0;
		for(int j=0;j<3;j++)
		{
			ret=::connect(fClientSocket, (struct sockaddr *) &name, sizeof(struct sockaddr_in));
    		    if(ret==-1)
    		    {
			if(fDebugMode)
    		    	std::cerr<<"Waiting for the VM to listen"<<std::endl;
    		    	private_sleep(1000); // Martin Sleep for 1000 ms
    		    }
    		    else
    		    {
    		    	j=20;
    		    }
		}
		if(ret==-1)
       		{
	 		std::cerr << "Error connecting socket: "<<errno<<std::endl;
			fClientSocket=-1;
		   	    return(-1);
		}
		return(0);
	}
	void runTests()
	{

		CppUnit::TestFactoryRegistry &registry=CppUnit::TestFactoryRegistry::getRegistry();
		CppUnit::Test *suite=registry.makeTest();
		int count=suite->countTestCases();
		notifyTestRunStarted(count);
		if(count==0)
		{
			notifyTestRunEnded(0);
		}
		long startTime=currentTimeMillis();
		if(fDebugMode)
		{
			std::cerr <<"start send tree..."<<std::endl;
		}
		sendTree(suite);
		if (fDebugMode)
			std::cerr<<"done send tree - time(ms): "<<currentTimeMillis()-startTime<<std::endl; //$NON-NLS-1$
		long testStartTime=currentTimeMillis();
		suite->run(fTestResult);
		if (fTestResult == NULL || fTestResult->shouldStop())
			notifyTestRunStopped(currentTimeMillis() - testStartTime);
		else
			notifyTestRunEnded(currentTimeMillis() - testStartTime);

	}
	void shutDown()
	{
		if(fClientSocket!=-1)
		{
#ifdef _WIN32 // Bugzilla 40710
			closesocket(fClientSocket);
			WSACleanup ();
#else
			close(fClientSocket);
#endif
			fClientSocket=-1;
		}
	}
	void stop()
	{
		if (fTestResult != NULL)
		{
			fTestResult->stop();
		}
	}
	void sendTree(CppUnit::Test *test)
	{
		if(typeid(*test)==typeid(CppUnit::TestDecorator))
		{
			class TmpClass:public CppUnit::TestDecorator {
				public:
					TmpClass(Test *t):CppUnit::TestDecorator(t){}
					CppUnit::Test *getTest() {return(m_test);}
					~TmpClass() {} // Bugzilla 39894
			};
			TmpClass *t=(TmpClass *)test;
			sendTree(t->getTest());
		}
		else if(typeid(*test)==typeid(CppUnit::TestSuite))
		{
			CppUnit::TestSuite *suite=(CppUnit::TestSuite *)test;
			const std::vector<CppUnit::Test *> &x=suite->getTests();

			std::ostringstream os;
			os << suite->getName() << ",true," << x.size();
			notifyTestTreeEntry(os.str());

			for(unsigned int i=0; i < x.size(); i++)
			{
				sendTree(x[i]);
			}
		}
		else
		{
			std::ostringstream os;
			os << test->getName() << ",false," << test->countTestCases();
			notifyTestTreeEntry(os.str());
		}
	}
	void sendMessage(std::string msg)
	{
		if(fClientSocket==-1) return;
#ifdef _WIN32 // Bugzilla 40710
		send (fClientSocket, msg.c_str(), msg.length(), 0);
		send (fClientSocket, "\n", 1, 0);
#else
		write(fClientSocket,msg.c_str(),msg.length());
		write(fClientSocket,"\n",1);
#endif
	}

	void notifyTestRunStarted(int testCount)
	{
		std::ostringstream os;
		os<<TEST_RUN_START<<testCount;
		sendMessage(os.str());
	}
	void notifyTestRunEnded(long elapsedTime)
	{
		std::ostringstream os;
		os << TEST_RUN_END << elapsedTime;
		sendMessage(os.str());
		//shutDown();
	}
	void notifyTestRunStopped(long elapsedTime)
	{
		std::ostringstream os;
		os << TEST_STOPPED << elapsedTime;
		sendMessage(os.str());
		//shutDown();
	}
	void notifyTestTreeEntry(std::string treeEntry)
	{
		sendMessage(TEST_TREE + treeEntry);
	}
	void notifyTestStarted(std::string testName)
	{
		sendMessage(TEST_START + testName);
	}
	void notifyTestEnded(std::string testName)
	{
		sendMessage(TEST_END + testName);
	}
	void notifyTestFailed(std::string status, std::string testName, std::string trace)
	{
		sendMessage(status + testName);
		sendMessage(TRACE_START);
		sendMessage(trace);
		sendMessage(TRACE_END);
	}

	// From TestListener
	void startTest(CppUnit::Test *test)
	{
		 notifyTestStarted(test->getName());
	}
	// From TestListener
	void addFailure(const CppUnit::TestFailure &failure)
	{
		if(failure.isError())
       		{
		       notifyTestFailed(TEST_ERROR,failure.failedTestName(),getTrace(failure));
		}
		else
		{
		       notifyTestFailed(TEST_FAILED,failure.failedTestName(),getTrace(failure));
		}
	}
	// From TestListener
	void endTest(CppUnit::Test *test)
	{
		notifyTestEnded(test->getName());
	}

	std::string getTrace(const CppUnit::TestFailure &failure)
	{
		std::ostringstream os;

		CppUnit::Exception *e=failure.thrownException();
		if(e->sourceLine().lineNumber()!=-1)
		{
			os << "File " << e->sourceLine().fileName() << ":" << e->sourceLine().lineNumber() << "\n";
		}
		else
		{
			os << "File Unknown:1\n";
		}
/* Martin TBC
		if(typeid(*e)==typeid(CppUnit::NotEqualException))
		{
			CppUnit::NotEqualException *ne=(CppUnit::NotEqualException *)e;

			os << "Expected Value: " << ne->expectedValue() << "\n";
			os << "Actual Value: " << ne->expectedValue() << "\n";
			os << "Additional Message: " << ne->additionalMessage() << "\n";
		}
		else
		{
End		*/
			os << "Message: " << std::string(e->what()) << "\n";
/*		} */
		return(os.str());
	}
	long currentTimeMillis()
	{
#ifdef _WIN32 // Bugzilla 40710
		unsigned long long p;
		  __asm__ __volatile__ ("rdtsc" : "=A" (p));
		return (unsigned long)p;
#else
		struct timeval tv;
		gettimeofday(&tv,NULL);
		return((long)(tv.tv_sec*1000)+(tv.tv_usec/1000));
#endif
	}
	void private_sleep(int millisecs)
	{
		struct timeval delta;
		delta.tv_sec = (millisecs * 1000L) / 1000000L;
		delta.tv_usec = (millisecs * 1000L) % 1000000L;
		select (0, NULL, NULL, NULL, &delta);
	}
};

int CPPUNIT_MAIN(int n,char *arg[])
{
	RemoteTestRunner *testRunServer=new RemoteTestRunner();
	testRunServer->init(n,arg);
	int ret=testRunServer->run();
	if(ret==-1)
	{
		CppUnit::TextUi::TestRunner *r;
		CppUnit::TestFactoryRegistry &registry=CppUnit::TestFactoryRegistry::getRegistry();
		CppUnit::Test *suite=registry.makeTest();

		r=new CppUnit::TextUi::TestRunner();
		r->addTest(suite);
		r->run();
	}
	exit(0);
}
#endif
