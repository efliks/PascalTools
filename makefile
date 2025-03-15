
TARGETS = b_bin b_kalk b_kod b_lidosk b_pierw b_totek b_trojk fxx macierze
FPC = fpc -Mtp

all : $(TARGETS)

b_bin : b_bin.pas
	$(FPC) $^
b_kalk : b_kalk.pas
	$(FPC) $^
b_kod : b_kod.pas
	$(FPC) $^
b_lidosk : b_lidosk.pas
	$(FPC) $^
b_pierw : b_pierw.pas
	$(FPC) $^
b_totek : b_totek.pas
	$(FPC) $^
b_trojk : b_trojk.pas
	$(FPC) $^
fxx : fxx.pas
	$(FPC) $^
macierze : macierze.pas
	$(FPC) $^

.PHONY: clean
clean :
	rm -f $(TARGETS) *.o
