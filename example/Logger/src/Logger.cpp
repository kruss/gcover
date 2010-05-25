#include "Logger.h"

void Logger::info(string s)
{
	cout << endl << "\t[ " << s << " ]" << endl << endl;
}

void Logger::log(string s)
{
	cout << "> " << s << endl;
}
