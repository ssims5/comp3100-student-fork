# Week 11 wax-seal checkpoints. Run from labs/week-11:  make -C check m1
#
# The house rules, all learned the hard way, all non-negotiable:
#
#  1. No backticks anywhere in a recipe's echo. A backtick inside an echo is
#     command substitution, and an earlier week's build caught one printing a
#     VALID wax seal inside a FAILURE message. There is not a single backtick
#     in this file; keep it that way.
#
#  2. Every numeric answer is parsed the same way, in every seal that reads
#     it:   sed -n 's/^AN://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'
#     Copy the pipeline exactly if you add a seal. (A4 reads ext2 as a 2;
#     the check only asks that 1024 be among its numbers.)
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', so a glance at this file
#     spoils nothing: the file-system type and block size, the link counts,
#     the struck count, the fd word, and the signer's post and closing line.
#     Paths inside the cabinet are not reversed: the work order teaches every
#     one of them openly.
#
#  4. A seal must never be satisfiable on a bench that never staged the
#     week. Every seal first requires the cabinet image to exist, with a
#     message routing to report-for-duty.sh.
#
# Every DERIVED value is computed at check time from the student's own
# bench, never stored here: the drill's inode number (stat), the shared
# page's and the marker's inode numbers, the five pages' weekdays and the
# latest page's HH:MM (debugfs stat on the image, rendered with date in the
# bench's own zone, as staging wrote them), and the memoranda's and the
# originals' inode numbers (debugfs ls -d). The image is read with debugfs
# and never written (no -w, ever). It is read the same whether or not the
# student has it mounted, and needs no root.
#
# The constants left are canon, written backwards below: ext2 and 1024
# (the image's type and block size), 2 (the shared page's link count), 7
# (lsdel's count), the fd word, and the post and closing line. The
# instructor-side bench check guards them, and the 20:03 and weekday pattern
# the derivations should produce, against drift in report-for-duty.sh.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.

# debugfs lives in /usr/sbin, which is not on every user's PATH.
export PATH := $(PATH):/usr/sbin:/sbin

CABINET := $$HOME/enginehouse/cabinets/cabinet-1848.img
DRILL   := $$HOME/enginehouse/ledger-halls/drill

TYPE_R    := 2txe
BAD_R     := 4txe
BLOCK_R   := 4201
LINKS_R   := 2
STRUCK_R  := 7
FDWORD_R  := deteled
POST_R    := retupmocfeihc
CLOSE_R   := tnavrestnegilidruoy

# The five live pages, in the template's order: the four quarters, then the
# district balances.
PAGES := /ledgers/table-ix-1848-q1.txt /ledgers/table-ix-1848-q2.txt /ledgers/table-ix-1848-q3.txt /ledgers/table-ix-1848-q4.txt /ledgers/district-balances-1848.txt

SEAL := bash ../../lib/seal.sh 11

m1:
	@test -f "$(CABINET)" || { echo "  (There is no cabinet on this bench, so nothing has been staged to seal. From labs/week-11: bash report-for-duty.sh -- then make -C check m1 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-11: cp check/answers-template check/answers.txt, fill in A1 to A3, then make -C check m1 again.)"; exit 1; }
	@test -f "$(DRILL)/register.txt" || { echo "  (The drill page ~/enginehouse/ledger-halls/drill/register.txt has no name just now. Task 1 step 6 gives it its name back with mv. If the page is lost altogether, bash report-for-duty.sh from labs/week-11 lays a fresh one -- under a new number, so read ls -li again. Then make -C check m1 again.)"; exit 1; }
	@n="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A1 wants ONE number: the inode number of the drill page register.txt, the first column of ls -li. Nothing else on the line that looks like a number. Task 1 step 1. Then make -C check m1 again.)"; exit 1; fi; \
	a1="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	want="$$(stat -c %i "$(DRILL)/register.txt")"; \
	if [ "$$a1" -eq "$$want" ] 2>/dev/null; then exit 0; fi; \
	if [ -L "$(DRILL)/pointer" ] && [ "$$a1" -eq "$$(stat -c %i "$(DRILL)/pointer")" ] 2>/dev/null; then echo "  (A1 is the number of pointer, the symbolic link. A symbolic link is a file of its own, with a number of its own. A1 wants the page's number: ls -li in the drill, on the register.txt line. Then make -C check m1 again.)"; exit 1; fi; \
	echo "  (A1 is not the number register.txt carries now. Run ls -li in ~/enginehouse/ledger-halls/drill and read the first column of the register.txt line. If you staged the bench again since, the page may have a new number: copy the one ls -li shows today. Then make -C check m1 again.)"; exit 1
	@n="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A2 wants ONE number: the page's link count straight after your ln, the number just after the permissions in ls -li. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	a2="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	want="$$(printf '%s' '$(LINKS_R)' | rev)"; \
	if [ "$$a2" -eq "$$want" ] 2>/dev/null; then exit 0; fi; \
	if [ "$$a2" -eq 1 ] 2>/dev/null; then echo "  (A2 says 1. That is the count of a page with one name -- before your ln, or after your rm. A2 wants the count straight after ln, before any name is struck: ls -li in Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	echo "  (A2 is not the link count ls -li showed straight after your ln. Read the number just after the permissions on either name's line, before you rm anything. Task 1 step 3. Then make -C check m1 again.)"; exit 1
	@a3="$$(sed -n 's/^A3://p' answers.txt | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	if [ -z "$$a3" ]; then echo "  (A3 is still blank -- the word ls -l printed in brackets after the target of fd 3, once page.txt had been removed. Task 1 step 7. Then make -C check m1 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a3" | grep -qF "$$(printf '%s' '$(FDWORD_R)' | rev)"; then echo "  (A3 does not carry the word ls -l printed in brackets after the target of fd 3. Open the page, remove it, and run the ls -l on fd 3 exactly as Task 1 step 7 shows; the word is at the very end of the line. Then make -C check m1 again.)"; exit 1; fi
	@$(SEAL) 1

m2:
	@test -f "$(CABINET)" || { echo "  (There is no cabinet on this bench, so there is nothing to examine. From labs/week-11: bash report-for-duty.sh -- then make -C check m2 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-11: cp check/answers-template check/answers.txt, fill it in, then make -C check m2 again.)"; exit 1; }
	@command -v debugfs >/dev/null 2>&1 || { echo "  (This seal reads the cabinet with debugfs, and debugfs is not on this bench. Run the a-tool-is-missing fix in setup/getting-started.md (Troubleshooting), then make -C check m2 again.)"; exit 1; }
	@a4="$$(sed -n 's/^A4://p' answers.txt | tr 'A-Z' 'a-z' | tr -d ' \t')"; \
	if [ -z "$$a4" ]; then echo "  (A4 is still blank -- the cabinet's file-system type and its block size. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	if printf '%s' "$$a4" | grep -qF "$$(printf '%s' '$(BAD_R)' | rev)"; then echo "  (A4 names a type the cabinet is not. Your home folder's file system is very likely that type -- but A4 asks about the cabinet. Ask the cabinet itself: stat -f on its mount point, or blkid on the image file, as Task 2 step 4 shows. Then make -C check m2 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a4" | grep -qF "$$(printf '%s' '$(TYPE_R)' | rev)"; then echo "  (A4 does not name the cabinet's file-system type as stat -f, findmnt or blkid reports it. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi; \
	want="$$(printf '%s' '$(BLOCK_R)' | rev)"; hit=0; big=0; \
	for x in $$(sed -n 's/^A4://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); do \
	  if [ "$$x" -eq "$$want" ] 2>/dev/null; then hit=1; fi; \
	  if [ "$$x" -eq 4096 ] 2>/dev/null; then big=1; fi; \
	done; \
	if [ "$$hit" -eq 0 ] && [ "$$big" -eq 1 ]; then echo "  (A4 carries 4096. That is the block size stat reports for files in your home folder, not for the cabinet. Read Block size from stat -f on the cabinet's mount point, or from debugfs stats on the image. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$hit" -eq 0 ]; then echo "  (A4 does not carry the cabinet's block size, in bytes, as stat -f or debugfs stats prints it. Task 2 step 4. Then make -C check m2 again.)"; exit 1; fi
	@n="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A5 wants ONE number: the inode number the page filed under two names carries. Task 2 step 6. Then make -C check m2 again.)"; exit 1; fi; \
	img="$(CABINET)"; \
	ino() { debugfs -R "stat $$1" "$$img" 2>/dev/null | sed -n 's/^Inode: *\([0-9][0-9]*\).*/\1/p' | head -n 1; }; \
	want="$$(ino /ledgers/table-ix-1848-q2.txt)"; sym="$$(ino /current-quarter)"; \
	if [ -z "$$want" ] || [ -z "$$sym" ]; then echo "  (debugfs could not read the cabinet on this bench, so this seal cannot check A5. From labs/week-11: bash report-for-duty.sh builds it afresh -- detach it first if it is mounted -- then make -C check m2 again.)"; exit 1; fi; \
	a5="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$a5" -eq "$$want" ] 2>/dev/null; then exit 0; fi; \
	if [ "$$a5" -eq "$$sym" ] 2>/dev/null; then echo "  (A5 is the number of the cabinet's symbolic link. A symbolic link is a file of its own; which name shares the page's number? Look for one number printed beside two different names in ls -lai, or debugfs ls -l. Then make -C check m2 again.)"; exit 1; fi; \
	echo "  (A5 is not the number the page's two names share. Walk the cabinet's folders with ls -lai, or debugfs ls -l, and look for one inode number printed beside two different names. Task 2 step 6. Then make -C check m2 again.)"; exit 1
	@n="$$(sed -n 's/^A6://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A6 wants ONE number: the link count of the inode in A5, as stat prints it after Links. Task 2 step 7. Then make -C check m2 again.)"; exit 1; fi; \
	a6="$$(sed -n 's/^A6://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	want="$$(printf '%s' '$(LINKS_R)' | rev)"; \
	if [ "$$a6" -eq "$$want" ] 2>/dev/null; then exit 0; fi; \
	if [ "$$a6" -eq 1 ] 2>/dev/null; then echo "  (A6 says 1. That is the count of a page filed under one name. Read Links in stat for the page in A5 -- by either of its names. Task 2 step 7. Then make -C check m2 again.)"; exit 1; fi; \
	echo "  (A6 is not the link count stat gives for the page in A5. Read the number after Links: in stat, or in debugfs stat. Task 2 step 7. Then make -C check m2 again.)"; exit 1
	@$(SEAL) 2

m3:
	@test -f "$(CABINET)" || { echo "  (There is no cabinet on this bench, so there are no pages to read. From labs/week-11: bash report-for-duty.sh -- then make -C check m3 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-11: cp check/answers-template check/answers.txt, fill it in, then make -C check m3 again.)"; exit 1; }
	@command -v debugfs >/dev/null 2>&1 || { echo "  (This seal reads the cabinet with debugfs, and debugfs is not on this bench. Run the a-tool-is-missing fix in setup/getting-started.md (Troubleshooting), then make -C check m3 again.)"; exit 1; }
	@img="$(CABINET)"; \
	ep() { e="$$(debugfs -R "stat $$1" "$$img" 2>/dev/null | sed -n 's/^ *mtime: *0x\([0-9a-fA-F][0-9a-fA-F]*\).*/\1/p' | head -n 1)"; [ -n "$$e" ] && printf '%d' "0x$$e"; }; \
	want=""; for p in $(PAGES); do \
	  e="$$(ep "$$p")"; if [ -z "$$e" ]; then echo "  (debugfs could not read the cabinet on this bench, so this seal cannot check A7. From labs/week-11: bash report-for-duty.sh builds it afresh -- detach it first if it is mounted -- then make -C check m3 again.)"; exit 1; fi; \
	  want="$$want$$(LC_ALL=C date -d "@$$e" +%a | tr 'A-Z' 'a-z') "; \
	done; \
	got="$$(sed -n 's/^A7://p' answers.txt | tr 'A-Z' 'a-z' | grep -oE '(mon|tue|wed|thu|fri|sat|sun)[a-z]*' | cut -c1-3 | tr '\n' ' ')"; \
	if [ -z "$$got" ]; then echo "  (A7 carries no weekday. It wants the weekday each of the five pages was last written, one per page, in the template's order: q1, q2, q3, q4, then the district balances. Task 3 step 2. Then make -C check m3 again.)"; exit 1; fi; \
	case " $$got" in *" sat "*) echo "  (A7 carries a Saturday. Saturday is when the cabinet itself was sealed for the audit: its docket, its folders and its marker all read it. A7 wants each of the five PAGES, read one by one -- ls -l with the time style on the ledgers folder, or debugfs stat on each page. Then make -C check m3 again.)"; exit 1 ;; esac; \
	n="$$(printf '%s' "$$got" | wc -w | tr -d ' ')"; \
	if [ "$$n" -ne 5 ]; then echo "  (A7 carries $$n weekdays. It wants FIVE, one for each live page, in the template's order: q1, q2, q3, q4, then the district balances. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$got" = "$$want" ]; then exit 0; fi; \
	lsord="$$(printf '%s' "$$want" | awk '{ print $$5, $$1, $$2, $$3, $$4 }') "; \
	if [ "$$got" = "$$lsord" ]; then echo "  (A7 has the five weekdays in the order ls lists the files, which puts the district balances first. The template's order is q1, q2, q3, q4, then the district balances. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A7 has the wrong weekday for at least one page. Read each page's own line: the weekday is the first thing after the size in ls -l with the time style, or the start of the date in debugfs stat. Task 3 step 2. Then make -C check m3 again.)"; exit 1
	@img="$(CABINET)"; \
	ep() { e="$$(debugfs -R "stat $$1" "$$img" 2>/dev/null | sed -n 's/^ *mtime: *0x\([0-9a-fA-F][0-9a-fA-F]*\).*/\1/p' | head -n 1)"; [ -n "$$e" ] && printf '%d' "0x$$e"; }; \
	max=0; for p in $(PAGES); do e="$$(ep "$$p")"; if [ -n "$$e" ] && [ "$$e" -gt "$$max" ]; then max="$$e"; fi; done; \
	if [ "$$max" -eq 0 ]; then echo "  (debugfs could not read the cabinet on this bench, so this seal cannot check A8. From labs/week-11: bash report-for-duty.sh builds it afresh -- detach it first if it is mounted -- then make -C check m3 again.)"; exit 1; fi; \
	wh="$$(date -d "@$$max" +%H)"; wm="$$(date -d "@$$max" +%M)"; \
	a8="$$(sed -n 's/^A8://p' answers.txt | tr 'A-Z' 'a-z')"; \
	n="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -eq 0 ]; then echo "  (A8 is still blank -- the time of day the latest-written page was last written, as HH:MM. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$n" -lt 2 ] || [ "$$n" -gt 3 ]; then echo "  (A8 wants a time alone, written HH:MM, with no date beside it. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	h="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	m="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	if [ "$$h" -eq "$$wh" ] 2>/dev/null && [ "$$m" -eq "$$wm" ] 2>/dev/null && ! printf '%s' "$$a8" | grep -qE '(^|[^a-z])[ap][.]?m([^a-z]|$$)'; then exit 0; fi; \
	if printf '%s' "$$a8" | grep -qE '(^|[^a-z])[ap][.]?m([^a-z]|$$)' || { [ "$$(expr "$$h" + 12)" -eq "$$wh" ] 2>/dev/null && [ "$$m" -eq "$$wm" ] 2>/dev/null; }; then echo "  (A8 reads like a 12-hour clock. The Guild keeps the 24-hour clock, as stat and ls print it: copy the hour exactly as your bench shows it, HH:MM, with no am or pm. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A8 is not the time the latest-written page was last written. Of the five pages, which carries the latest date? Copy that page's time, HH:MM, as ls -l with the time style or debugfs stat prints it. Task 3 step 3. Then make -C check m3 again.)"; exit 1
	@$(SEAL) 3

m4:
	@test -f "$(CABINET)" || { echo "  (There is no cabinet on this bench, so nothing has been struck from it. From labs/week-11: bash report-for-duty.sh -- then make -C check m4 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-11: cp check/answers-template check/answers.txt, fill it in, then make -C check m4 again.)"; exit 1; }
	@command -v debugfs >/dev/null 2>&1 || { echo "  (This seal reads the cabinet with debugfs, and debugfs is not on this bench. Run the a-tool-is-missing fix in setup/getting-started.md (Troubleshooting), then make -C check m4 again.)"; exit 1; }
	@img="$(CABINET)"; \
	struck() { debugfs -R "ls -d $$1" "$$img" 2>/dev/null | grep -oE '<[0-9]+>' | tr -d '<>' | sort -n | tr '\n' ' '; }; \
	memo="$$(struck /correspondence/memoranda-1848)"; orig="$$(struck /ledgers)"; \
	if [ -z "$$memo" ] || [ -z "$$orig" ]; then echo "  (debugfs could not read the cabinet on this bench, so this seal cannot check A9. From labs/week-11: bash report-for-duty.sh builds it afresh -- detach it first if it is mounted -- then make -C check m4 again.)"; exit 1; fi; \
	nums="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+')"; \
	if [ -z "$$nums" ]; then echo "  (A9 is still blank -- how many deleted inodes lsdel found, then the inode numbers of the three memoranda. Task 4 steps 1 and 2. Then make -C check m4 again.)"; exit 1; fi; \
	count="$$(printf '%s' '$(STRUCK_R)' | rev)"; seen=0; rest=""; \
	for x in $$nums; do \
	  if [ "$$seen" -eq 0 ] && [ "$$x" -eq "$$count" ] 2>/dev/null; then seen=1; else rest="$$rest$$(expr "$$x" + 0) "; fi; \
	done; \
	if [ "$$seen" -eq 0 ]; then echo "  (A9 does not carry how many deleted inodes lsdel found. The count is on lsdel's last line. Put it first, then the three memoranda's numbers. Task 4 step 2. Then make -C check m4 again.)"; exit 1; fi; \
	for x in $$rest; do \
	  case " $$orig" in *" $$x "*) echo "  (A9 carries the number of a struck ledger page. lsdel lists every struck inode; which of these are letters? ls -d on the memoranda folder shows the numbers that were filed there. Task 4 step 1. Then make -C check m4 again.)"; exit 1 ;; esac; \
	done; \
	hit=0; for w in $$memo; do case " $$rest" in *" $$w "*) hit=$$(($$hit + 1)) ;; esac; done; \
	extra=0; for x in $$rest; do case " $$memo" in *" $$x "*) : ;; *) extra=1 ;; esac; done; \
	if [ "$$extra" -eq 1 ]; then echo "  (A9 carries a number that is neither lsdel's count nor a memorandum's inode. It wants the count, then the three numbers ls -d shows struck in the memoranda folder, and nothing else that looks like a number -- no dates, no sizes. Then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$hit" -lt 3 ]; then echo "  (A9 carries $$hit of the three memoranda's inode numbers. Each struck name in ls -d on the memoranda folder has its number in angle brackets beside it: all three go on the line. Then make -C check m4 again.)"; exit 1; fi
	@a10="$$(sed -n 's/^A10://p' answers.txt | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	if [ -z "$$a10" ]; then echo "  (A10 is still blank -- the signer's post and the closing line of the memoranda, exactly as written. Task 4 step 5. Then make -C check m4 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a10" | grep -qF "$$(printf '%s' '$(POST_R)' | rev)"; then echo "  (A10 does not carry the signer's post as the memoranda write it -- the office the signature line gives after the name. Read the foot of any of the three letters again and copy it exactly. Then make -C check m4 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a10" | grep -qF "$$(printf '%s' '$(CLOSE_R)' | rev)"; then echo "  (A10 does not carry the closing line, exactly as written: the line the letters close with, just above the signature. Copy it word for word. Then make -C check m4 again.)"; exit 1; fi
	@$(SEAL) 4

.PHONY: m1 m2 m3 m4
