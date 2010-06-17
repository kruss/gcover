################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../test/FooLib2Test.cpp \
../test/RemoteTestRunner.cpp 

OBJS += \
./test/FooLib2Test.o \
./test/RemoteTestRunner.o 

CPP_DEPS += \
./test/FooLib2Test.d \
./test/RemoteTestRunner.d 


# Each subdirectory must supply rules for building sources it contributes
test/%.o: ../test/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cygwin C++ Compiler'
	g++ -DCPPUNIT_MAIN=main -I"../include" -I"../../Logger/include" -O0 -g3 -Wall -c -fmessage-length=0 -fprofile-arcs -ftest-coverage -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


