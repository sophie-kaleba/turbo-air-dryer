CXX := g++
FLAGS := -Wall -Wvla -g

EXECUTABLES := Jit

SOURCES := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(SOURCES))

all: $(EXECUTABLES)

.cpp.o:
	$(CXX) $(FLAGS) -c $<

Jit: Jit.o
	$(CXX) $(FLAGS) -o $@
