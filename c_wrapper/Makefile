CFLAGS=-g -Wall
EXECUTABLE=memory_manager

all: $(EXECUTABLE)

memory_manager: memory_manager.o
	gcc $(CFLAGS) $^ -o $@

#=================================
memory_manager.o: memory_manager.c
	gcc $(CFLAGS) -c $<

#=================================

clean:
	rm -f *.o $(EXECUTABLE)

.PHONY: clean
