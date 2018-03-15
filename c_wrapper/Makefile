CFLAGS=-g -Wall
EXECUTABLE=memory_manager_test

all: $(EXECUTABLE)

memory_manager_test: memory_manager_test.o memory_manager.o
	gcc $(CFLAGS) $^ -o $@


memory_manager: memory_manager.o
	gcc $(CFLAGS) $^ -o $@

#=================================
memory_manager_test.o: memory_manager_test.c
	gcc $(CFLAGS) -c $<

memory_manager.o: memory_manager.c memory_manager.h
	gcc $(CFLAGS) -c $<

#=================================

clean:
	rm -f *.o $(EXECUTABLE)

.PHONY: clean
