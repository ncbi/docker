CPP=g++
CPPFLAGS=-I. -std=c++11 -malign-double -O3
DEPS = common.inc common.hpp graph.hpp
OBJ = amr_report.o graph.o common.o 

%.o: %.cpp $(DEPS)
	$(CPP) $(CPPFLAGS) -c -o $@ $<

amr_report: $(OBJ)
	$(CPP) $(CPPFLAGS) -o $@ $^

.PHONY: clean

clean:
	rm -f *.o *~ core amr_report
