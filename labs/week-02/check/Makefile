# Week 2 wax-seal checkpoints. Run from labs/week-02:  make -C check m1
# (Answers are checked spelled backwards below, so a glance here spoils nothing.)
SEAL := bash ../../lib/seal.sh 02
TMP  := /tmp/wo02-$(shell id -un)

m1:
	@gcc -Wall -Wextra -Werror -g -fsanitize=address -o $(TMP)-hb ../starter/hello-brassbridge.c
	@$(TMP)-hb >$(TMP)-hb.out 2>$(TMP)-hb.err
	@! grep -q 'AddressSanitizer' $(TMP)-hb.err
	@grep -q 'A full week: 30 hours' $(TMP)-hb.out
	@rm -f $(TMP)-hb $(TMP)-hb.out $(TMP)-hb.err
	@$(SEAL) 1

m2:
	@test -x $$HOME/enginehouse/bin/card-reader
	@test -f "$$HOME/$$(printf 'xenna-regdel.' | rev)"
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-02: cp check/answers-template check/answers.txt)"; exit 1; }
	@grep -qF "$$(printf 'xenna-regdel' | rev)" answers.txt
	@$(SEAL) 2

m3:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-02: cp check/answers-template check/answers.txt)"; exit 1; }
	@grep -Eq '^A1:.*[^[:space:]]' answers.txt
	@grep -Eq '^A2:.*[^[:space:]]' answers.txt
	@grep -Eq '^A3:.*[^[:space:]]' answers.txt
	@$(SEAL) 3

.PHONY: m1 m2 m3
