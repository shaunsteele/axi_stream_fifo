wrptr:
	make -f WrPtr.mk

rdptr: $1
	make -f RdPtr.mk $1

fifo:
	make -f FifoCore.mk

.PHONY: lint
lint:
	make -f WrPtr.mk lint
	make -f RdPtr.mk lint
	make -f FifoCore.mk lint

.PHONY: waves
	make 

.PHONY: clean
clean:
	make -f WrPtr.mk clean
	make -f RdPtr.mk clean
	make -f FifoCore.mk clean