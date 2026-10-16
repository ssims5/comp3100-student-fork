# Week 9 wax-seal checkpoints. Run from labs/week-09:  make -C check m1
#
# The house rules, all learned the hard way, all non-negotiable:
#
#  1. No backticks anywhere in a recipe's echo. A backtick inside an echo is
#     command substitution, and week 5's build caught one printing a VALID
#     wax seal inside a FAILURE message. There is not a single backtick in
#     this file; keep it that way.
#
#  2. Every numeric answer is parsed the same way, in every seal that reads
#     it:   sed -n 's/^AN://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'
#     This week's figures carry thousands commas (valgrind prints them in
#     the 196,608 style), so the tr -d ',' matters more than ever. Copy the
#     pipeline exactly if you add a seal.
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', exactly as weeks 2-7 do, so a
#     glance at this file spoils nothing. That covers the region order, every
#     figure and line number, both words from the Store, and the mark. The
#     valgrind and gdb commands are not reversed: the work order teaches them
#     openly.
#
#  4. A seal must never be satisfiable on a bench that never did the work.
#     m1 and m2 build the student's own starter with the work order's flags
#     (gcc's errors are let through, because they are the next thing to
#     read). m2 then RUNS the student's clerk, plain and under valgrind, and
#     needs both to come out right. m3 and m4 need the staged source on this
#     bench, and need it to build. That does not make m3 or m4 a test: they
#     check what was copied off the screen, not that the screen was read.
#
#  5. No seal leaves a process behind. Nothing here waits for gdb: m2's
#     valgrind runs the clerk to its end and exits on its own. Nothing is
#     ever killed, because nothing is ever left waiting.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.
#
# Constants that go stale if anybody edits a starter or the staged payload,
# all harvested on the WSL bench on 10 Oct 2026. The week's bench check
# reads the first three by name and fails until they agree with the bench:
#
#  CLERK_SUM         the cksum of starter/store-clerk.c AS SHIPPED, with all
#                    whitespace removed:
#                      tr -d '[:space:]' < starter/store-clerk.c | cksum | cut -d' ' -f1
#                    m2 refuses a file that still matches it. Edit the
#                    starter and this goes stale, and m2 fails OPEN.
#  FAIR_COPY_LINE_R  the source line valgrind gives for the malloc behind the
#                    smaller loss record (A7), reversed.
#  SMALL_RECORD_BYTES_R  the bytes in the smaller loss record, reversed. m3
#                    uses it only to recognise that record alone offered as A5.
#
# The rest are reversed the same way: the clerk's pristine fault lines (A3),
# the totals of the two loss records and of the summary (A5, A6), the larger
# record's malloc line and main's two calling lines (A7's wrong turns), and
# the cap and the block size (A8).
CLERK_SUM        := 2590594019
FAIR_COPY_LINE_R := 56
SMALL_RECORD_BYTES_R := 712

REGIONS_R         := kcats paeh ssb atad txet
CLERK_WRITE_R     := 83 33
CLERK_READ_R      := 76
CLERK_LEAK_R      := 72
TOTAL_BYTES_R     := 528691
TOTAL_BLOCKS_R    := 25
WITHHELD_BYTES_R  := 806691
WITHHELD_BLOCKS_R := 84
SMALLER_BLOCKS_R  := 4
ALLOCS_R          := 35
DRAW_LINE_R       := 35
MAIN_LINES_R      := 68 88
CAP_R             := 84
BLOCK_SIZE_R      := 6904
WORDY_R           := 4
KEY_R             := etelosbo
STRUCK_R          := dedesrepus
MARK_R            := .K.E

SEAL     := bash ../../lib/seal.sh 09
CCFLAGS  := -Wall -Wextra -g -O0
SIPHON_C := $$HOME/enginehouse/src/siphon/store-siphon.c

m1:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-09: cp check/answers-template check/answers.txt, fill in A1 and A2, then make -C check m1 again.)"; exit 1; }
	@test -f ../starter/store-plan.c || { echo "  (starter/store-plan.c is missing. From labs/week-09: git checkout -- starter/store-plan.c -- then make -C check m1 again.)"; exit 1; }
	@gcc $(CCFLAGS) -o /dev/null ../starter/store-plan.c || { echo "  (starter/store-plan.c does not build. The errors above are gcc's. Task 1 leaves this file exactly as shipped: from labs/week-09, git checkout -- starter/store-plan.c -- then make -C check m1 again.)"; exit 1; }
	@a1="$$(sed -n 's/^A1://p' answers.txt | tr 'A-Z' 'a-z' | sed -E 's/un-?initiali[sz]ed( data)?/bss/g; s/code/text/g' | grep -oE 'text|data|bss|heap|stack' | uniq | tr '\n' ' ' | sed 's/ $$//')"; \
	if [ -z "$$a1" ]; then echo "  (A1 names none of the five regions. Write them by name -- text, data, bss, heap, stack, in the order YOUR addresses put them -- lowest address first. Task 1 step 4. Then make -C check m1 again.)"; exit 1; fi; \
	d="$$(printf '%s\n' $$a1 | sort -u | wc -l | tr -d ' ')"; \
	if [ "$$d" -lt 5 ]; then echo "  (A1 names $$d of the five regions. Each of the five lines store-plan prints lives in a different region: name all five, one each, lowest address first. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$(printf '%s\n' $$a1 | wc -l | tr -d ' ')" -gt 5 ]; then echo "  (A1 names a region more than once. One list of five, lowest address first, each region once; the reasons go in your logbook. Then make -C check m1 again.)"; exit 1; fi; \
	want="$$(printf '%s' '$(REGIONS_R)' | rev)"; \
	if [ "$$a1" = "$$want" ]; then exit 0; fi; \
	if [ "$$(printf '%s\n' $$a1 | tac | tr '\n' ' ' | sed 's/ $$//')" = "$$want" ]; then echo "  (A1 runs from the highest address down. The slot wants the LOWEST first: turn your list round. Then make -C check m1 again.)"; exit 1; fi; \
	echo "  (A1 has all five regions, but not in address order. Put the five addresses from one run side by side and compare them from the left, one hex digit at a time, as Task 1 step 4 shows: the first digit that differs decides. Then make -C check m1 again.)"; exit 1
	@a2="$$(sed -n 's/^A2://p' answers.txt | tr 'A-Z' 'a-z' | grep -oE '[a-z]+' | head -1)"; \
	if [ -z "$$a2" ]; then echo "  (A2 is still blank -- did the ORDER of the five change between your two runs? yes or no, first on the line. Task 1 step 5. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$a2" = "$$(printf 'sey' | rev)" ]; then echo "  (A2 says yes. The addresses changed between your runs -- every one of them. Did their ORDER? Sort both runs, lowest first, and compare the two lists. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$a2" != "$$(printf 'on' | rev)" ]; then echo "  (A2 wants yes or no as its FIRST word: did the order of the five change between your two runs? The why goes in your logbook. Then make -C check m1 again.)"; exit 1; fi
	@$(SEAL) 1

m2:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-09: cp check/answers-template check/answers.txt, fill it in, then make -C check m2 again.)"; exit 1; }
	@test -f ../starter/store-clerk.c || { echo "  (starter/store-clerk.c is missing. From labs/week-09: git checkout -- starter/store-clerk.c -- and mend it again, as Task 2 shows.)"; exit 1; }
	@sum="$$(tr -d '[:space:]' < ../starter/store-clerk.c | cksum | cut -d' ' -f1)"; \
	if [ "$$sum" = "$(CLERK_SUM)" ]; then echo "  (starter/store-clerk.c is exactly as it was shipped -- not one character changed. Task 2 has you audit the clerk, write down what valgrind found, and then mend it until make audit is quiet. If you did edit it, your editor saved somewhere else; check with git diff starter/store-clerk.c from labs/week-09.)"; exit 1; fi
	@command -v valgrind > /dev/null 2>&1 || { echo "  (valgrind is not on this bench, and this seal runs your clerk under it. Run the 'a tool is missing' fix in setup/getting-started.md (Troubleshooting), then make -C check m2 again.)"; exit 1; }
	@t="$$(mktemp -d)"; trap 'rm -rf "$$t"' EXIT; \
	gcc $(CCFLAGS) -o "$$t/store-clerk" ../starter/store-clerk.c || { echo "  (starter/store-clerk.c does not build. The errors above are gcc's, and they are the first thing to fix. From labs/week-09: make -C starter store-clerk -- then make -C check m2 again.)"; exit 1; }; \
	out="$$("$$t/store-clerk" 2>&1)"; rc=$$?; \
	if [ "$$rc" -ne 0 ]; then echo "  (Your clerk exits with status $$rc. As shipped it finished its ledger and exited 0, every time; a mended clerk must too. Run it from labs/week-09/starter: ./store-clerk -- then make -C check m2 again.)"; exit 1; fi; \
	want="$$(printf '%s\n' 'Struck from the ledger: 4 blocks returned.' 'Blocks still out:' '  Printing Office    9' '  Ropewalk           7' '  Foundry           12' 'Ledger total: 28 blocks outstanding.')"; \
	if [ "$$out" != "$$want" ]; then echo "  (Your clerk's ledger no longer reads as it did before you mended it. A mend changes how the clerk keeps its slips, never what it reports: every line it printed at the start of Task 2 -- the Struck from the ledger line included -- must still print, exactly. Compare ./store-clerk with Task 2 step 1, put back what went missing, then make -C check m2 again.)"; exit 1; fi; \
	valgrind --enable-debuginfod=no --leak-check=full --error-exitcode=9 --errors-for-leak-kinds=definite,indirect "$$t/store-clerk" > "$$t/audit.txt" 2>&1; rc=$$?; \
	if [ "$$rc" -ne 0 ] || ! grep -q 'All heap blocks were freed' "$$t/audit.txt"; then echo "  (valgrind still finds something in your clerk: an error, or a slip that is never surrendered. From labs/week-09: make -C starter audit -- read the FIRST report it prints, mend that, and audit again, until it says All heap blocks were freed and ERROR SUMMARY: 0 errors. Then make -C check m2 again.)"; exit 1; fi
	@for L in A3a A3b A3c; do \
	  test -n "$$(sed -n "s/^$$L://p" answers.txt | tr -d '[:space:]')" || { echo "  ($$L is still blank. A3a to A3c want the three faults valgrind found in the clerk AS SHIPPED, one to a line: valgrind's name for the fault, then the line number it points to. Task 2 step 3. Then make -C check m2 again.)"; exit 1; }; \
	done
	@seen=" "; \
	for L in A3a A3b A3c; do \
	  v="$$(sed -n "s/^$$L://p" answers.txt | head -n 1 | tr 'A-Z' 'a-z')"; \
	  k=none; \
	  if printf '%s' "$$v" | grep -qE 'lost|leak'; then k=leak; \
	  elif printf '%s' "$$v" | grep -qE 'write|overflow|overrun'; then k=write; \
	  elif printf '%s' "$$v" | grep -qE 'read|free'; then k=read; fi; \
	  if [ "$$k" = none ]; then echo "  ($$L does not name a kind of fault. Open the line with valgrind's own words for it -- the heading of its report, such as Invalid write, or the words before in loss record -- then the line number. Task 2 step 3. Then make -C check m2 again.)"; exit 1; fi; \
	  case "$$seen" in *" $$k "*) echo "  ($$L names the same kind of fault as an earlier A3 line. The clerk is found out three different ways: one to a line. Four reports with the same heading and the same line are ONE fault, met once per bureau. Then make -C check m2 again.)"; exit 1 ;; esac; \
	  seen="$$seen$$k "; \
	  nums=" $$(sed -n "s/^$$L://p" answers.txt | head -n 1 | tr -d ',' | grep -oE '[0-9]+' | tr '\n' ' ')"; \
	  case "$$k" in write) want='$(CLERK_WRITE_R)' ;; read) want='$(CLERK_READ_R)' ;; *) want='$(CLERK_LEAK_R)' ;; esac; \
	  hit=0; \
	  for w in $$want; do case "$$nums" in *" $$(printf '%s' "$$w" | rev) "*) hit=1 ;; esac; done; \
	  if [ "$$hit" -eq 0 ]; then \
	    case "$$k" in \
	      write) echo "  ($$L names the overflow but not the line valgrind points to. Under its Invalid write heading, read down to the first line that names store-clerk.c, and copy the number after the colon. Then make -C check m2 again.)" ;; \
	      read) echo "  ($$L names an Invalid read, but not the line of the fault Task 2 means. One Invalid read comes from inside printf, and it vanishes once the overflow is mended -- an echo, not a fault of its own. The other is in main, 16 bytes inside a block that was already free'd: copy the first store-clerk.c line under THAT one. Then make -C check m2 again.)" ;; \
	      *) echo "  ($$L names the leak but not the line valgrind points to. Under the definitely lost record, read down to the first line that names store-clerk.c -- the malloc whose slip nobody surrendered -- and copy the number after the colon. Then make -C check m2 again.)" ;; \
	    esac; exit 1; \
	  fi; \
	done
	@a4="$$(sed -n 's/^A4://p' answers.txt | tr 'A-Z' 'a-z' | tr -s ' \t' '  ')"; \
	if [ -z "$$(printf '%s' "$$a4" | tr -d ' ')" ]; then echo "  (A4 is still blank -- the line valgrind prints about leaks once your clerk is mended. Copy it whole. Task 2 step 7. Then make -C check m2 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a4" | grep -qF 'all heap blocks were freed'; then echo "  (A4 is not the line a mended clerk earns. Run make -C starter audit from labs/week-09 on your mended clerk and copy, whole, the line under HEAP SUMMARY that says every block came home. Then make -C check m2 again.)"; exit 1; fi
	@$(SEAL) 2

m3:
	@test -f "$(SIPHON_C)" || { echo "  (There is no recovered source on this bench, so nothing has been staged to seal. From labs/week-09: bash report-for-duty.sh -- then make -C check m3 again.)"; exit 1; }
	@gcc $(CCFLAGS) -o /dev/null "$(SIPHON_C)" || { echo "  (The recovered source no longer builds. Stage it afresh -- from labs/week-09: bash report-for-duty.sh -- and build it exactly as Task 3 step 2 shows. Then make -C check m3 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-09: cp check/answers-template check/answers.txt, fill it in, then make -C check m3 again.)"; exit 1; }
	@for L in A5 A6 A7 A8; do \
	  n="$$(sed -n "s/^$$L://p" answers.txt | tr -d ',' | grep -oE '[0-9]+' | sort -u | wc -l | tr -d ' ')"; \
	  if [ "$$n" -eq 0 ]; then echo "  ($$L is still blank. A5 to A8 want one number each, read off your own bench in Task 3. Then make -C check m3 again.)"; exit 1; fi; \
	  if [ "$$n" -gt 1 ]; then echo "  ($$L carries more than one number. Put the ONE figure the slot asks for alone on the line -- valgrind's commas are fine, and so is a word after it, but no second number. Then make -C check m3 again.)"; exit 1; fi; \
	done
	@r() { printf '%s' "$$1" | rev; }; \
	x="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$x" = "$$(r '$(TOTAL_BYTES_R)')" ]; then :; \
	elif [ "$$x" = "$$(r '$(WITHHELD_BYTES_R)')" ] || [ "$$x" = "$$(r '$(SMALL_RECORD_BYTES_R)')" ]; then echo "  (A5 is the bytes of ONE loss record. The slot wants every byte definitely lost, both records together: the definitely lost line under LEAK SUMMARY. Do the sum yourself too -- the two records should add up to it. Then make -C check m3 again.)"; exit 1; \
	else echo "  (A5 is not the bytes definitely lost. Under LEAK SUMMARY, at the end of valgrind's report on store-siphon, the definitely lost line: its first figure is the bytes. Not the in use at exit line, and not total heap usage. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A6://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$x" = "$$(r '$(TOTAL_BLOCKS_R)')" ]; then :; \
	elif [ "$$x" = "$$(r '$(WITHHELD_BLOCKS_R)')" ] || [ "$$x" = "$$(r '$(SMALLER_BLOCKS_R)')" ]; then echo "  (A6 is the blocks of ONE loss record. The slot wants every block definitely lost, both records together: the definitely lost line under LEAK SUMMARY. Then make -C check m3 again.)"; exit 1; \
	elif [ "$$x" = "$$(r '$(ALLOCS_R)')" ]; then echo "  (A6 is the allocs count from total heap usage. That counts every malloc, including one block that WAS surrendered at exit. The slot wants the blocks definitely lost, under LEAK SUMMARY. Then make -C check m3 again.)"; exit 1; \
	else echo "  (A6 is not the blocks definitely lost. Under LEAK SUMMARY, the definitely lost line: the figure after in is the blocks. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$x" = "$$(r '$(FAIR_COPY_LINE_R)')" ]; then :; \
	elif [ "$$x" = "$$(r '$(DRAW_LINE_R)')" ]; then echo "  (A7 is the malloc line behind the LARGER loss record. The slot wants the smaller one: valgrind sorts records by size, smallest first, so it is record 1. Then make -C check m3 again.)"; exit 1; \
	else \
	  for m in $(MAIN_LINES_R); do if [ "$$x" = "$$(r "$$m")" ]; then echo "  (A7 is a line in main, where the routine is CALLED. The slot wants the line of the malloc itself: the first line under the record that names store-siphon.c. Then make -C check m3 again.)"; exit 1; fi; done; \
	  echo "  (A7 is not the line valgrind gives for the smaller record's malloc. Under loss record 1, read down past malloc to the first line that names store-siphon.c, and copy the number after the colon. Then make -C check m3 again.)"; exit 1; \
	fi; \
	x="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$x" = "$$(r '$(CAP_R)')" ]; then :; \
	elif [ "$$x" = "$$(r '$(BLOCK_SIZE_R)')" ]; then echo "  (A8 is the size of each block, in bytes. The cap is how MANY: the figure the drawing loop stops at, as the source sets it near the top of the file. Then make -C check m3 again.)"; exit 1; \
	else echo "  (A8 is not the cap as the source sets it. Proofread the top of store-siphon.c: the cap is a #define, and the drawing loop in main stops at it. Then make -C check m3 again.)"; exit 1; fi
	@$(SEAL) 3

m4:
	@test -f "$(SIPHON_C)" || { echo "  (There is no recovered source on this bench, so nothing has been staged to seal. From labs/week-09: bash report-for-duty.sh -- then make -C check m4 again.)"; exit 1; }
	@gcc $(CCFLAGS) -o /dev/null "$(SIPHON_C)" || { echo "  (The recovered source no longer builds. Stage it afresh -- from labs/week-09: bash report-for-duty.sh -- and build it exactly as Task 3 step 2 shows. Then make -C check m4 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-09: cp check/answers-template check/answers.txt, fill it in, then make -C check m4 again.)"; exit 1; }
	@n="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sort -u | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A9 wants ONE number: how many of the leaked blocks hold words. Nothing else on the line that looks like a number. Then make -C check m4 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$x" != "$$(printf '%s' '$(WORDY_R)' | rev)" ]; then echo "  (A9 is not how many leaked blocks hold words. Count the blocks x/s read back as words in Task 4. And the other record's blocks: read draw_block in the source -- what does it put in every block it draws? Then make -C check m4 again.)"; exit 1; fi
	@a10="$$(sed -n 's/^A10://p' answers.txt | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	key="$$(printf '%s' '$(KEY_R)' | rev)"; struck="$$(printf '%s' '$(STRUCK_R)' | rev)"; \
	if [ -z "$$a10" ]; then echo "  (A10 is still blank. The second and third blocks of record 1 differ by one word: which word does block 3 use? Task 4 step 8. Then make -C check m4 again.)"; exit 1; fi; \
	k=0; s=0; \
	printf '%s' "$$a10" | grep -qF "$$key" && k=1; \
	printf '%s' "$$a10" | grep -qF "$$struck" && s=1; \
	if [ "$$k" -eq 1 ] && [ "$$s" -eq 1 ]; then echo "  (A10 carries two words: block 2's and block 3's. Put block 3's word alone on the line. Then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$s" -eq 1 ]; then echo "  (That is block 2's word -- which does block 3 use? Then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$k" -eq 0 ]; then echo "  (A10 is not a word the blocks hold. The second and third blocks that monitor block_list 1 printed differ by one word: block 3's word goes on the line. Task 4 step 8. Then make -C check m4 again.)"; exit 1; fi
	@a11="$$(sed -n 's/^A11://p' answers.txt | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	mark="$$(printf '%s' '$(MARK_R)' | rev | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	if [ -z "$$a11" ]; then echo "  (A11 is still blank -- the mark the source's comments are signed with, copied exactly. Task 4 step 1. Then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$a11" = "$$mark" ]; then exit 0; fi; \
	if [ "$$a11" = "$$(printf '%s' "$$mark" | rev)" ]; then echo "  (A11 has the right letters the wrong way round. Copy the mark exactly as the comments write it, letters and dots, in their order. Then make -C check m4 again.)"; exit 1; fi; \
	if printf '%s' "$$a11" | grep -qF "$$mark"; then echo "  (A11 carries the mark and more besides. The slot wants the mark alone, exactly as written -- letters and dots, nothing else. Then make -C check m4 again.)"; exit 1; fi; \
	echo "  (A11 is not the mark the comments are signed with. Read the comments again, as Task 4 step 1 shows: the signed ones all end the same way. Copy that ending exactly, letters and dots. Then make -C check m4 again.)"; exit 1
	@$(SEAL) 4

.PHONY: m1 m2 m3 m4
