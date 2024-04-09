wrptr:
	make -f WrPtr.mk

rdptr:
	make -f RdPtr.mk

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