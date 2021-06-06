OBJS=main.o 

EXENAME=test

CC=g++ -std=c++11 

all: $(OBJS)
	$(CC) $(OBJS) -o $(EXENAME)
main.o: main.cpp 
	$(CC) -c main.cpp


.PHONY: clean
clean:
	rm -rf $(OBJS) $(EXENAME)


