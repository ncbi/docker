# the SVNREV is set automatically here for convenience,
# but when actually building we should override it like:
# make all SVNREV=-D\'SVN_REV=\"$VERSION\"\' or use
# a version.txt file
ifeq ($(wildcard version.txt),)
	SVNREV := -D'SVN_REV="$(shell svnversion -n .)"'
else
	SVNREV := -D'SVN_REV="$(shell cat version.txt)"'
endif

CPPFLAGS = -std=gnu++11 \
  -malign-double -fno-math-errno \
  -Wall -Wextra \
  -Wcast-align -Wconversion -Wdeprecated-declarations -Wformat -Winit-self -Wlogical-op \
  -Wmissing-braces -Wmissing-field-initializers -Wmissing-format-attribute -Wmissing-include-dirs \
  -Woverloaded-virtual -pedantic -Wparentheses -Wpointer-arith -Wsequence-point -Wshadow -Wunused \
  -Wsuggest-attribute=format -Wswitch -Wuninitialized -Wsign-conversion -Wuseless-cast \
  -Werror -O3 \
  $(SVNREV)

CXX=g++
COMPILE.cpp= $(CXX) $(CPPFLAGS)  -c 

prefix = /panfs/pan1.be-md.ncbi.nlm.nih.gov/bacterial_pathogens/backup
bindir = $(prefix)/bin
INSTALL_DIR = $(prefix)/packages/amrfinder

.PHONY: all clean install release


all:	amr_report fasta_check gff_check

release: clean
	svnversion -n . > version.txt
	make all

common.o:	common.hpp common.inc
gff.o: gff.hpp common.hpp common.inc

amr_report.o:	common.hpp common.inc gff.hpp
amr_reportOBJS=amr_report.o common.o gff.o
amr_report:	$(amr_reportOBJS)
	$(CXX) -o $@ $(amr_reportOBJS)

fasta_check.o:	common.hpp common.inc 
fasta_checkOBJS=fasta_check.o common.o 
fasta_check:	$(fasta_checkOBJS)
	$(CXX) -o $@ $(fasta_checkOBJS)

gff_check.o:	common.hpp common.inc gff.hpp
gff_checkOBJS=gff_check.o common.o gff.o
gff_check:	$(gff_checkOBJS)
	$(CXX) -o $@ $(gff_checkOBJS)

clean:
	-rm -f *.o
	-rm -f amr_report fasta_check gff_check

install:
	cp amr_report fasta_check gff_check $(INSTALL_DIR)
	perl -pe "s#~brovervv/code/prod#$(INSTALL_DIR)#;s#~brovervv/work/AMR/AMRFinder/\w+#$(INSTALL_DIR)#;" AMRFinder-dna.sh > $(INSTALL_DIR)/AMRFinder-dna.sh
	chmod 755 $(INSTALL_DIR)/AMRFinder-dna.sh
	perl -pe "s#~brovervv/code/prod#$(INSTALL_DIR)#;s#~brovervv/work/AMR/AMRFinder/\w+#$(INSTALL_DIR)#;" AMRFinder-prot.sh > $(INSTALL_DIR)/AMRFinder-prot.sh
	chmod 755 $(INSTALL_DIR)/AMRFinder-prot.sh
