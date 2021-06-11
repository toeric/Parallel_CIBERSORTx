OBJS=main.o 

EXENAME=test

CC=g++ -std=c++11 

ARMA_FL=-I /home/blah/armadillo-10.5.1/include -DARMA_DONT_USE_WRAPPER 

all:
	$(CC) main.cpp -o $(EXENAME) -O2 $(ARMA_FL) -lblas -llapack


.PHONY: clean
clean:
	rm -rf $(OBJS) $(EXENAME)


