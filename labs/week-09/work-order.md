# WORK ORDER No. 1851-09 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 12 October 1851 — eight weeks to the Exhibition |
| **Due** | **Sunday, October 18, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

The Store audits short.

Every block the Engine draws from its Store is entered in the Store's
books when it goes out and struck off when it comes back. This month the
two columns will not balance. Blocks have been drawn and never returned.

Nothing has failed. Nothing has slowed. The Engine runs exactly as it has
always run, and the auditors, who can count, have counted, and cannot make
the figures agree. They have said so in triplicate.

The auditors did find one thing on the Store's own bench: a routine that
draws blocks and keeps them. It has been recovered whole, as source, and
it is on your bench this week. Do not take my word for what it does, and
do not take its own. You will build it, run it, and make it account for
every block it has drawn, to the byte.

Before you audit the Store, you will learn to audit something smaller. The
Store's counter clerk keeps a ledger of his own, and his ledger reads
correctly every single time. He is wrong three ways all the same, and the
instrument that will tell you so is this week's: **valgrind**.

The Store keeps books, and books can be read. Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Every program you have written keeps its belongings somewhere: its code,
its variables, the memory it asks for while it runs. This week is about
where those places are, how long each thing lives in them, and what goes
wrong with the one kind of memory that lives exactly as long as you say it
does and not a moment less: memory from `malloc`. Forget to give it back
and it is never given back. Give it back twice, or use it after you gave
it back, or write one byte past its end, and the program may well go on
printing the right answer, which is the most dangerous thing a broken
program can do.

The fiction is set dressing and the commands are the course; **no task
here requires story knowledge.** By the time you hand this in you will be
able to:

1. **Map a program's memory regions from its own addresses.** Text, data,
   bss, heap and stack: what lives in each, and the order they sit in
   from low addresses to high, read off a real program's own addresses.
   *zyBooks Ch 6.*
2. **Find and fix heap faults from valgrind's reports.** Read an error the
   way valgrind writes it — the kind, the stack, the block — mend the
   first one first, and keep going until valgrind has nothing to say.
   *zyBooks Ch 6.*
3. **Account for every byte a program withholds.** Read a leak report:
   loss records, definitely and indirectly lost, the line of the `malloc`
   behind each, and make the records add up to the total. *zyBooks Ch 6.*
4. **Read a leaked block's contents from a paused program.** Stop a
   program under valgrind with `gdb` attached, ask valgrind which blocks
   are leaked and where they are, and read what is in them.
   *zyBooks Ch 6.*

Objective 3 is the one the Guild examines hardest. A figure you have
accounted for is a figure you can defend.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `gcc` and `make`, **`valgrind`** (you
met it in Week 2) and **`gdb`** (Week 7), all of which every setup path
in this course installs. Nothing this week needs `sudo` or a network. If
your environment broke, [`setup/getting-started.md`](../../setup/getting-started.md)
rebuilds it.

**Tasks 3 and 4 need two terminals at once** (Task 4 asks for a third, briefly, at the end), both on your Linux bench.
Practise opening the second one now:

- **Windows/WSL2 (Windows Terminal):** click the small **⌄** beside the
  **+** at the top of the window and choose **Ubuntu**. A new tab opens on
  your Linux bench. (If a new tab opens in PowerShell instead, type `wsl`
  and press Enter.)
- **macOS/Multipass:** open a second Terminal window (**⌘N**) and type
  `multipass shell comp3100`.
- **Native Linux:** open a second terminal window.

Type `whoami` in both. They should print the same name: two terminals,
one bench.

**P2 — This folder, open in a Linux terminal.** Run the line that matches
your setup:

```sh
cd ~/comp3100-student/labs/week-09
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-09
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-09
```

**P3 — Report for duty.** One command stages your bench for Tasks 3 and 4.
Run it now, on Wednesday, so Friday starts with everything in place:

```sh
bash report-for-duty.sh
```

It needs no input. Expected output:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-09 :: bench staged and verified
  ------------------------------------------------------------------
   Source:  ~/enginehouse/src/siphon/store-siphon.c
   Also:    ~/enginehouse/src/siphon/.valgrindrc   (one line for valgrind)
            ~/enginehouse/src/siphon/store.gdb     (two settings for gdb)

   The routine the Store's audit turned up, recovered whole and left
   as source. Nothing has been built and nothing is running: you
   build it yourself, with the line in the work order, when the work
   order says to.
   No house keys were wanted this week.
   (bash report-for-duty.sh --reset withdraws all of it, and your
   build of store-siphon with it.)
  ------------------------------------------------------------------
```

Three files land in one new folder, `~/enginehouse/src/siphon/`: the
routine's C source, and two small settings files. If earlier weeks' papers
are still staged under `~/enginehouse/`, leave them exactly where they
are; nothing this week reads or writes them. The script starts nothing and
leaves nothing running, and it is always safe to run it again.

**About `.valgrindrc`.** Two folders this week hold a one-line file named
`.valgrindrc` — `starter/` here, and `~/enginehouse/src/siphon/` once you
have staged — which tells valgrind not to go looking on the network for
debugging information, a search that can add ten seconds to every run on
Ubuntu. Leave it be: its name starts with a dot, so plain `ls` does not
list it (`ls -A` does), and valgrind reads it by itself whenever you run
valgrind from that folder.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds thirteen
short answers — A1 to A11, with A3 in three parts — that the seal checks
read; the template says what goes where, and each task tells you when.
Your running `case-notes.md` is already at the repo root.

**A note on this week's shape.** Two studios. **Wednesday's studio is
Tasks 1 and 2**; whatever of Task 2 is unfinished, finish at home before
Friday. **Friday's studio starts at Task 3 for everyone**, whether or not
Task 2 is done — Tasks 3 and 4 do not depend on it — and you want **two
terminals open** when it starts. Four tasks, four seals, about two hours
and ten minutes at the terminal. Claim each seal as soon as its task is
done.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-09`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `cd: ... No such file or directory` for `labs/week-09`? Your copy of
>   the repo predates this week. From the repo root: `git pull`.
> - `$'\r': command not found`, or `set: -: invalid option`, or a
>   `syntax error near unexpected token`? The file picked up Windows line
>   endings on the way down. From the repo root: `git checkout -- .` and
>   try again.
> - `report-for-duty: valgrind not found` (or `gcc not found`)? Your
>   bench has lost a tool. Run the *"a tool is missing"* fix in
>   `setup/getting-started.md` (Troubleshooting), then run the script
>   again.
> - `report-for-duty: run this as YOURSELF, not as root.`? You typed
>   `sudo` in front of it. Nothing this week needs `sudo`; run it again
>   without it.
> - The second terminal's `whoami` prints a different name, or `root`?
>   It opened on a different machine or as a different user. Close it and
>   open it again the way P1 says for your setup.
> - You ran `--reset` and want the bench back? Run
>   `bash report-for-duty.sh` again.

---

## Task 1 — The Store's floor plan *(~25 minutes → Seal M1)*

A running program keeps its belongings in five regions of memory, and
every program on your bench lays them out in the same order. You will find
that order yourself, from a program's own addresses.

**1. Build it.** The starter folder holds two small programs. From
`labs/week-09`:

```sh
cd starter
make store-plan
```

Expected:

```
gcc -Wall -Wextra -g -O0 -o store-plan store-plan.c
```

**2. Run it, twice.**

```sh
./store-plan
./store-plan
```

Expected — five lines a run, ten in all, shaped exactly like this:

```
slip         (asked for while running)    0x…
main         (the program's own routine)  0x…
on_hand      (a variable inside main)     0x…
tally_kept   (set before the start)       0x…
spare_slips  (never set at all)           0x…
slip         (asked for while running)    0x…
main         (the program's own routine)  0x…
on_hand      (a variable inside main)     0x…
tally_kept   (set before the start)       0x…
spare_slips  (never set at all)           0x…
```

Each `0x…` on your screen is a real **address**: a number, in hexadecimal,
saying where in the program's memory that thing lives. This work order
writes them `0x…` because they are different on every bench and, as you
will see, on every run. Copy both runs into your logbook under
**Milestone 1**, exactly as your bench printed them.

The five lines are deliberately **not** in address order. Open
`store-plan.c` if you want to see the five things it owns; leave it
exactly as it is.

**3. Name each line's region.** These are the five regions, as the deck
and zyBooks Ch 6 describe them:

| Region | What lives there |
|---|---|
| **text** | the program's own machine code — every function, `main` included |
| **data** | global variables given a starting value in the source |
| **bss** | global and `static` variables that start at zero; the system sets them to zero when the program starts |
| **heap** | memory asked for while the program runs, with `malloc` |
| **stack** | the local variables of the function calls in progress |

Each of `store-plan`'s five lines lives in a different one. In your
logbook, beside each line, write its region and one sentence saying how
you know.

**4. Put them in order.** Now sort one run's five addresses from the
**lowest** to the **highest**, and write down the regions in that order.

Comparing two long hexadecimal numbers is easier than it looks. If one has
more digits than the other (ignoring the `0x`), it is the bigger. If they
have the same number of digits, read them **from the left, one digit at a
time**, and the first digit that differs decides; in hexadecimal the
digits run `0 1 2 3 4 5 6 7 8 9 a b c d e f`, smallest to biggest. Two
addresses may share their first eight or nine digits; keep going.

**5. Compare the two runs.** Do the same for your second run. Then answer
two questions in your logbook:

- Did the **addresses** change between the two runs? (Look at every one.)
- Did the **order** of the five regions change?

The addresses change because the system deliberately starts each region at
a different place every time a program runs: **address space layout
randomisation**, or **ASLR**. It is a defence — an attacker cannot rely on
anything being where it was last time — and next week takes it further.
What it never shuffles is the order.

**6. What the file itself knows.** Three of the five regions are settled
before the program ever runs. Ask the file:

```sh
size store-plan
```

Expected — the figures depend on your compiler, so yours may differ:

```
   text    data     bss     dec     hex filename
      …       …       …       …       … store-plan
```

`size` reads the **text**, **data** and **bss** sizes, in bytes, out of the
built file. There is no column for heap or stack, and in your logbook say
why, in one sentence: what is it about those two that the file on disk
cannot know?

**Checkpoint.** Before you claim the seal you should be able to say,
without looking: the five regions in order from low to high, which of
`store-plan`'s five lines lives in each, what changed between your two
runs and what did not, and why `size` has three columns and not five.

**7. File what you found.** Open `check/answers.txt`:

- **`A1:`** — the five regions, by name, **lowest address first**.
- **`A2:`** — did the **order** change between your two runs? `yes` or
  `no`, first on the line.

**8. Claim the seal** — from `labs/week-09` (you are in `starter/`, so go
up one first):

```sh
cd ..
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-09/check'
  ~~~ WAX SEAL of the Guild: 31791FF4 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-09/check'
```

(The seal code is yours, not this one.)

Paste your seal under **Milestone 1** with both runs, the region of each
line and how you knew it, your order, the answers to step 5's two
questions, and the sentence from step 6.

> **If you're lost, start here (Task 1).**
> - `make: *** No rule to make target 'store-plan'.  Stop.`? You are not
>   in `starter/`. From `labs/week-09`: `cd starter`.
> - `make: 'store-plan' is up to date.`? It is already built. Carry on.
> - Every address looks the same length and you cannot see where to
>   start? Line two up, one under the other, and read them from the left
>   until the first column where they differ.
> - Seal says A1 names some of the five regions? It wants all five, by
>   name: text, data, bss, heap, stack, in your order. Case does not
>   matter, and so on; *uninitialised data* is read as bss.
> - Seal says A1 runs from the highest address down? Turn the list round:
>   lowest first.
> - Seal says A1 is not in address order? Redo step 4 for one run, one
>   pair of addresses at a time.
> - Seal says A2 wants yes or no first? Put the word first on the line;
>   anything after it is yours.

---

## Task 2 — The clerk's ledger, audited *(~45 minutes → Seal M2)*

The Store's counter clerk keeps a ledger as a chain of slips, one per
bureau that has drawn blocks, each slip rented from the heap with `malloc`.
His program prints the right ledger every time. It also breaks three of
the rules you know from Appendix C, and nothing on the screen says so. This
task is how you find out anyway.

**1. Run it plain.** From `labs/week-09/starter`:

```sh
make store-clerk
./store-clerk
```

Expected — in full, and the same on every bench, every run:

```
gcc -Wall -Wextra -g -O0 -o store-clerk store-clerk.c
Struck from the ledger: 4 blocks returned.
Blocks still out:
  Printing Office    9
  Ropewalk           7
  Foundry           12
Ledger total: 28 blocks outstanding.
```

No warnings from `gcc`, the right total, exit status 0. Run it a few more
times if you like; it will not falter. Keep this output in front of you:
when you have mended the clerk, it must print **exactly** this, still.

**2. Audit it.**

```sh
make audit
```

That runs the clerk under valgrind. The line it runs is printed first:

```
valgrind --enable-debuginfod=no --leak-check=full --error-exitcode=1 ./store-clerk
```

**Valgrind** runs your program on a simulated processor and watches every
byte it reads and writes, every `malloc` and every `free`. It is slow, and
it sees almost everything that goes wrong on the heap: a write past a
block's edge, a read from a block already freed, a block never freed.
`--leak-check=full` asks it to report,
at the end, the blocks never surrendered, and where each was rented; `--error-exitcode=1` makes
it fail if it found anything, which is why `make` reports an error at the
end.

Expected — a long report. Here is how it starts, with the first error in
full:

```
==…== Memcheck, a memory error detector
==…== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==…== Using Valgrind-3.22.0 and LibVEX; rerun with -h for copyright info
==…== Command: ./store-clerk
==…== 
==…== Invalid write of size 1
==…==    at 0x…: strcpy (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==…==    by 0x…: enter (store-clerk.c:38)
==…==    by 0x…: main (store-clerk.c:58)
==…==  Address 0x… is 0 bytes after a block of size 7 alloc'd
==…==    at 0x…: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==…==    by 0x…: enter (store-clerk.c:33)
==…==    by 0x…: main (store-clerk.c:58)
==…== 
...
```

and here is how it ends:

```
...
==…== LEAK SUMMARY:
==…==    definitely lost: 24 bytes in 1 blocks
==…==    indirectly lost: 78 bytes in 5 blocks
==…==      possibly lost: 0 bytes in 0 blocks
==…==    still reachable: 0 bytes in 0 blocks
==…==         suppressed: 0 bytes in 0 blocks
==…== 
==…== For lists of detected and suppressed errors, rerun with: -s
==…== ERROR SUMMARY: 9 errors from 7 contexts (suppressed: 0 from 0)
make: *** [Makefile:25: audit] Error 1
```

The middle is yours to read on your own screen. The clerk's own six
lines come out in the middle of valgrind's, which is normal: both are
writing to the same terminal.

**What varies, and what does not.** Every valgrind line starts with
`==…==`: on your screen that is a number, valgrind's process ID, different
on every run. Every `0x…` is an address, different from bench to bench.
On a Mac (Multipass), `amd64` in the library name reads `arm64`. The
kinds of error, the function names, the **line numbers after
`store-clerk.c:`**, the block sizes and the leak figures are the same on
every bench.

**3. Read the reports — and write them down before you change anything.**
Every error report has the same parts. Take the first one above:

- **The heading** names the kind of fault: `Invalid write of size 1` —
  the program wrote one byte (a `char`) somewhere it had no right to.
- **The stack** under it, innermost call first: `strcpy` did the writing,
  called **by** `enter` at line 38 of `store-clerk.c`, called by `main` at
  line 58. The first line that names `store-clerk.c` is the line in *your*
  code to look at.
- **The `Address` line** says where the write landed: *0 bytes after a
  block of size 7*. The program rented a block of 7 bytes and wrote one
  byte past its end.
- **`alloc'd`**, and the stack under it, says where that block was
  rented: by `enter`, at line 33.

A leak report has a heading of its own, `... bytes in ... blocks are
definitely lost in loss record N of M`, and the stack under it says where
the lost block was rented.

Now read all of yours. There are seven reports (*7 contexts* — a context is
one distinct place an error happened, however often), and they come from
**three** faults in the clerk. Four reports share a heading and a line:
that is **one** fault, met once for each bureau. And one report is an
**echo**: an error that happens only because an earlier one did.

In your logbook, under **Milestone 2**, write down every report: its
heading, the first `store-clerk.c` line under it, and the block it
mentions. Then the three faults: for each, its kind and the line it points
to. Do it now, while the clerk is as shipped. Once you start mending, the
reports change.

**4. Fix the first error first.** The rule that saves the most time with
valgrind: **mend the first error it reports, then audit again.** Later
errors are often echoes of earlier ones, and an echo vanishes with its
cause.

Open the clerk in your editor (`nano store-clerk.c`, or the editor you
use). Look at line 33 and line 38 together. Line 38 copies a name into the
block line 33 rented. The name `Foundry` is 7 letters, and the block is 7
bytes. What does `strcpy` copy after the last letter of every string, and
where does it go? Mend line 33 so the block is big enough.

Save, and audit again:

```sh
make audit
```

(`make audit` rebuilds the clerk first whenever the source has changed,
so you will see the `gcc` line again.) The four writes are gone. Look for
the report that came from inside `printf`: it has gone too, without your
touching it. That was the echo. Write in your logbook which report it was
and why it went.

**Checkpoint.** You should be able to say why `Foundry` needs a block of
8 bytes and not 7, and which report vanished with the overflow although
you never touched the line it pointed to. If `make audit` still shows an
`Invalid write`, the block is still one byte short.

**5. The next one.** The first report now is an `Invalid read of size 4`,
*16 bytes inside a block of size 24 free'd*. Read its three stacks: where
the read happened, where the block was freed, and where it was rented. The
clerk hands a slip back to the Store and then reads from it. A slip, once
surrendered, is stale: the block may already be someone else's. Mend it so
the clerk reads what it needs **before** it surrenders the slip. Audit
again.

**6. The leak.** Now only the leak is left:
`... bytes in 1 blocks are definitely lost`, with its line. Read the
leak summary too: **definitely lost** is a block nothing points to any
more; **indirectly lost** is a block that only a lost block pointed to,
so it went down with it. One slip in the ledger was rented and never
surrendered, and everything hanging off it went with it.

The ledger's slips are still on the chain when `main` finishes, and
nothing ever hands them back. Before `main` returns, walk the chain and
strike each slip — the clerk already has a routine that surrenders one
slip properly. Careful: once a slip is struck you may not read its `next`
any more (that is step 5's fault again). Take the next slip's address
first, then strike.

**7. A clean bill.** When you think you are done:

```sh
make
./store-clerk
make audit
```

Expected — `gcc` runs if the source changed (if it has not, `make` says
`make: Nothing to be done for 'all'.` instead), and then:

```
Struck from the ledger: 4 blocks returned.
Blocks still out:
  Printing Office    9
  Ropewalk           7
  Foundry           12
Ledger total: 28 blocks outstanding.
valgrind --enable-debuginfod=no --leak-check=full --error-exitcode=1 ./store-clerk
==…== Memcheck, a memory error detector
==…== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==…== Using Valgrind-3.22.0 and LibVEX; rerun with -h for copyright info
==…== Command: ./store-clerk
==…== 
Struck from the ledger: 4 blocks returned.
Blocks still out:
  Printing Office    9
  Ropewalk           7
  Foundry           12
Ledger total: 28 blocks outstanding.
==…== 
==…== HEAP SUMMARY:
==…==     in use at exit: 0 bytes in 0 blocks
==…==   total heap usage: 9 allocs, 9 frees, … bytes allocated
==…== 
==…== All heap blocks were freed -- no leaks are possible
==…== 
==…== For lists of detected and suppressed errors, rerun with: -s
==…== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```

Nine rentals, nine surrenders (one of them the C library's own, for
`printf`), no errors — and the clerk's own
output **exactly** as it was in step 1. (The bytes allocated depend on
where the output goes, so this work order writes them `…`.) If any line
of the ledger changed, the mend changed what the clerk reports, and that
is not a mend.

**Checkpoint.** You should be able to say, without looking: the three
faults by valgrind's names, the line each one pointed to in the clerk as
shipped, which report was an echo and why it vanished, and what
*indirectly lost* meant in this program.

**8. File what you found.** In `check/answers.txt`:

- **`A3a:`** to **`A3c:`** — the three faults you wrote down in step 3,
  one to a line, any order: valgrind's name for each, then the line it
  points to.
- **`A4:`** — the line about leaks from your clean audit. Copy it whole.

**9. Claim the seal** — from `labs/week-09`:

```sh
cd ..
make -C check m2
```

The seal builds your mended clerk itself, runs it, and audits it under
valgrind before it reads your answers, so it takes a moment. Expected:

```
make: Entering directory '.../labs/week-09/check'
  ~~~ WAX SEAL of the Guild: 55A4AE75 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-09/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 2** with the reports you wrote down in step 3,
the three faults, which report was the echo, each mend in a sentence, and
the clean audit's last six lines.

> **If you're lost, start here (Task 2).**
> - `make audit` sat silent for ten seconds before printing anything?
>   Valgrind went looking on the network for debugging information. The
>   `.valgrindrc` in `starter/` stops that; check it is there with
>   `ls -A`, and if it is not, from `labs/week-09`:
>   `git checkout -- starter/.valgrindrc`.
> - `make: *** [Makefile:25: audit] Error 1` at the end? That is valgrind
>   reporting errors, as `--error-exitcode=1` asks it to. It goes away
>   when the clerk is mended.
> - Never used `malloc` and `free` in C? Appendix C's refresher,
>   [`labs/appendix-c-refresher.md`](../appendix-c-refresher.md), is
>   fifteen minutes and has the rules this task leans on.
> - You mended something and the clerk now crashes (`Segmentation fault`)?
>   Read the first report `make audit` gives you now: valgrind will say
>   exactly where.
> - The ledger now prints in a different order, or a line is missing? The
>   mend changed what the clerk does. Compare your source with
>   `git diff starter/store-clerk.c` (from `labs/week-09`) and put back
>   what was not part of a mend.
> - You want the clerk as shipped, to start again? From `labs/week-09`:
>   `git checkout -- starter/store-clerk.c`.
> - Seal says the clerk is exactly as shipped? It refuses an unmended
>   clerk. Mend it first; if you did, your editor saved somewhere else.
> - Seal says the ledger no longer reads as it did? Run `./store-clerk`
>   and compare it, line by line, with step 1.
> - Seal says valgrind still finds something? `make audit`, and read the
>   first report.
> - Seal says an A3 line names the same kind as another? Three different
>   faults, one to a line: the four writes are one fault.
> - Seal says an A3 line has the wrong line number? Use the **first**
>   line under that report that names `store-clerk.c`. For an Invalid
>   read, make sure it is not the echo.

---

## Task 3 — The Store audits short *(~25 minutes → Seal M3)*

Friday starts here, for everyone. Have your two terminals open. This task
uses one of them; Task 4 uses both.

**1. The bench.** If you have not staged yet, do P3 now. Then:

```sh
cd ~/enginehouse/src/siphon
ls -A
```

Expected:

```
.valgrindrc  store-siphon.c  store.gdb
```

`store-siphon.c` is the routine the auditors recovered, in C. The other
two are settings files: `.valgrindrc` you met in the Provisions, and
`store.gdb` is for Task 4.

**2. Build it, exactly like this:**

```sh
gcc -g -O0 -Wall -Wextra -o store-siphon store-siphon.c
```

Expected: nothing at all. No warnings; just your prompt back. `-g` puts
the line numbers in, so valgrind and gdb can name a line; `-O0` builds it
exactly as written.

**3. Run it plain.**

```sh
./store-siphon
```

Expected — two lines, of which this work order blanks one figure:

```
store-siphon: … blocks drawn from the Store; none returned.
store-siphon: the cap is reached. Resting.
```

Your bench prints a number where this shows `…`. Write both lines in your
logbook under **Milestone 3**. That is the routine's own account of
itself. Now check it.

**4. Audit it.**

```sh
valgrind --leak-check=full ./store-siphon
```

(No `--enable-debuginfod=no` needed here: the `.valgrindrc` in this folder
says it for you.) Expected — the shape of the report, with every figure
and every source line number blanked. Your bench prints them all:

```
==…== Memcheck, a memory error detector
==…== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==…== Using Valgrind-3.22.0 and LibVEX; rerun with -h for copyright info
==…== Command: ./store-siphon
==…== 
store-siphon: … blocks drawn from the Store; none returned.
store-siphon: the cap is reached. Resting.
==…== 
==…== HEAP SUMMARY:
==…==     in use at exit: … bytes in … blocks
==…==   total heap usage: … allocs, … frees, … bytes allocated
==…== 
==…== … bytes in … blocks are definitely lost in loss record 1 of 2
==…==    at 0x…: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==…==    by 0x…: fair_copy (store-siphon.c:…)
==…==    by 0x…: main (store-siphon.c:…)
==…== 
==…== … bytes in … blocks are definitely lost in loss record 2 of 2
==…==    at 0x…: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==…==    by 0x…: draw_block (store-siphon.c:…)
==…==    by 0x…: main (store-siphon.c:…)
==…== 
==…== LEAK SUMMARY:
==…==    definitely lost: … bytes in … blocks
==…==    indirectly lost: 0 bytes in 0 blocks
==…==      possibly lost: 0 bytes in 0 blocks
==…==    still reachable: 0 bytes in 0 blocks
==…==         suppressed: 0 bytes in 0 blocks
==…== 
==…== For lists of detected and suppressed errors, rerun with: -s
==…== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
```

It takes about a second. **What varies:** the `==…==` process numbers
and the `0x…` addresses, as in Task 2; and the *total heap usage* bytes,
which depend on whether the output went to a terminal or a file. The two
loss records, their figures, and the line numbers are the same on every
bench.

**5. Account for every byte.** No errors of the Task 2 kind this time:
the two errors in the summary *are* the two loss records. The routine does
nothing wrong with any block it has; it simply never gives one back.

Valgrind sorts loss records by size, smallest first. In your logbook,
copy and answer, for **each** record:

- how many bytes, in how many blocks;
- which routine rented them, and the source line of its `malloc` (the
  first line under the record that names `store-siphon.c`);
- how big **one** block is, on average: bytes divided by blocks.

Then add the two records' bytes together, and their blocks, and compare
with the `definitely lost` line under **LEAK SUMMARY**. They must agree
exactly. Compare the blocks, too, with what the routine said of itself in
step 3. When all three agree, every byte is accounted for.

**6. Proofread the source.** Open it to read, not to change:

```sh
less store-siphon.c
```

(Space goes down a page, `b` back a page, `q` quits. `cat -n
store-siphon.c` prints it with line numbers instead.) Read it through
once, top to bottom. Then find three things, and write each down with its
line number:

- **The cap.** The routine draws blocks in a loop in `main`, and the loop
  stops at a limit set near the top of the file. What is it?
- **Where the blocks are drawn.** The two `malloc` lines valgrind named.
  Do they match what you wrote in step 5?
- **Where any of it is given back.** Look for yourself, and then ask
  `grep`:

  ```sh
  grep -c free store-siphon.c
  ```

  Expected:

  ```
  0
  ```

  Not one `free` anywhere in the file.

Do not edit the file. If you change it by accident, `bash
report-for-duty.sh` from `labs/week-09` puts it back as it was.

**Checkpoint.** You should be able to say, without looking: how many bytes
and blocks the routine leaves definitely lost, how those split between its
two loss records, which line rented each, and what the cap is and where
the source sets it.

**7. File it.** In `check/answers.txt`, one number each:

- **`A5:`** — definitely lost, total **bytes**.
- **`A6:`** — definitely lost, total **blocks**.
- **`A7:`** — the source line of the `malloc` behind the **smaller** loss
  record.
- **`A8:`** — the cap, as the source sets it.

Copy valgrind's figures with their commas or without; both are read the
same.

**8. Claim the seal** — from your work-order folder, with the `cd` line
from P2 that matches your setup (for most of you,
`cd ~/comp3100-student/labs/week-09`). Then:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-09/check'
  ~~~ WAX SEAL of the Guild: B3BAA385 ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-09/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 3** with the routine's two lines, both loss
records with your working, the sum, and the three things you found by
proofreading.

> **If you're lost, start here (Task 3).**
> - `cd: /home/.../enginehouse/src/siphon: No such file or directory`?
>   Your bench is not staged, or you reset it. From `labs/week-09`:
>   `bash report-for-duty.sh`.
> - `gcc` printed a warning or an error? The file is not as it was
>   staged. From `labs/week-09`: `bash report-for-duty.sh` (it rewrites
>   the source and leaves your own build alone), then build again.
> - `bash: ./store-siphon: No such file or directory`? You have not built
>   it yet, or built it under another name. Step 2, exactly as printed.
> - Valgrind sat silent for ten seconds before printing anything? You ran
>   it from another folder, where there is no `.valgrindrc`. `cd
>   ~/enginehouse/src/siphon` and run it again, or add
>   `--enable-debuginfod=no` after `valgrind`.
> - The records do not add up? Copy each figure again, digit by digit;
>   valgrind's commas are thousands separators, as in 1,000.
> - `make: *** check: No such file or directory.  Stop.`? You are still
>   in `~/enginehouse/src/siphon`. Go back to `labs/week-09` with the `cd`
>   line from P2.
> - Seal says A5 or A6 is one loss record? The slot wants both together:
>   the `definitely lost` line under LEAK SUMMARY.
> - Seal says A7 is the larger record's line, or a line in `main`? The
>   smaller record is record 1; its `malloc` line is the first under it
>   that names `store-siphon.c`, and it is not in `main`.
> - Seal says A8 is the size of each block? The cap counts blocks; it is
>   not their size.

---

## Task 4 — What the Store was holding *(~35 minutes → Seal M4)*

Valgrind told you how many bytes the routine keeps and where it rented
them. It did not tell you what is **in** them. To read a leaked block you
need two things at once: valgrind, which knows where every leaked block
is, and gdb, which can read memory. This task runs them together, in your
two terminals:

- **Terminal A** runs the routine under valgrind, paused before its
  first instruction, waiting for gdb.
- **Terminal B** runs gdb, which connects to the waiting valgrind through
  a small relay called **`vgdb`**, stops the routine at the right moment,
  and asks valgrind questions.

**Before you run anything, read this: the safe way out.** A valgrind
waiting for gdb waits for ever, and it does not answer the usual keys.

- **To let it finish:** in Terminal B, type `detach`, or `continue`.
  (If the routine has not reached its breakpoint yet, `continue` runs on
  to the breakpoint and stops there; type `continue` once more.) The
  routine runs to its end, Terminal A prints its full leak report and
  gives you your prompt back. Then `quit` in Terminal B; once the routine
  has finished it asks nothing. (`quit` while gdb is still connected asks
  `Quit anyway? (y or n)`; `y` lets the routine finish, just as `detach`
  does.)
- **To stop it at once:** in Terminal B, type `kill`, answer `y`, then
  `quit`. Terminal A prints `==…== Gdb request to kill this process`
  and gives you your prompt back.
- **Ctrl-C does not end a valgrind that is waiting for gdb**, and
  neither does `pkill` without `-KILL` from another prompt. If Terminal
  A is stuck waiting and no gdb is attached — you quit gdb some other
  way, or closed the window — go to any other terminal on your bench
  and type:

  ```sh
  pkill -KILL -f vgdb-error
  ```

  That ends every valgrind of yours that is waiting for gdb, and nothing
  else. Terminal A prints `Killed` and gives you your prompt back.
- **Exactly one waiting valgrind at a time.** If an old one is still
  waiting from an earlier try, gdb cannot tell which one you mean; if
  none is waiting at all, there is nothing to connect to. Either way,
  connecting fails with exactly this:

  ```
  Remote communication error.  Target disconnected: error while reading: Connection reset by peer.
  ```

  The cure is the same for both: `quit` gdb, run
  `pkill -KILL -f vgdb-error` from any terminal (it ends every waiting
  valgrind of yours, the new one too), and start again from step 2 with
  one valgrind.

**1. How the source is signed.** In Terminal B, before anything else:

```sh
cd ~/enginehouse/src/siphon
grep -n '/\*' store-siphon.c
```

That prints every comment in the source, with its line number. This work
order does not print them; your bench does. In your logbook, under
**Milestone 4**, copy every comment, exactly, and then write down how the
comments are signed: the mark, **exactly as written**, letters and dots.

**2. Terminal A: start the routine, waiting.** In Terminal A:

```sh
cd ~/enginehouse/src/siphon
valgrind --leak-check=full --vgdb-error=0 ./store-siphon
```

`--vgdb-error=0` means *wait for gdb before running anything*. Expected:

```
==…== Memcheck, a memory error detector
==…== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==…== Using Valgrind-3.22.0 and LibVEX; rerun with -h for copyright info
==…== Command: ./store-siphon
==…== 
==…== (action at startup) vgdb me ... 
==…== 
==…== TO DEBUG THIS PROCESS USING GDB: start GDB like this
==…==   /path/to/gdb ./store-siphon
==…== and then give GDB the following command
==…==   target remote | /usr/bin/vgdb --pid=…
==…== --pid is optional if only one valgrind process is running
==…== 
```

And then nothing: it waits. **Leave Terminal A alone** from here until
the end of the task. Everything you type, you type in Terminal B.

**3. Terminal B: connect.** You are already in `~/enginehouse/src/siphon`
from step 1:

```sh
gdb -q -x store.gdb ./store-siphon
```

then, at the `(gdb)` prompt:

```
target remote | vgdb
```

Expected — on some benches the line beginning
`Reading symbols from /usr/lib/debug/` is not there, and that is fine:

```
Reading symbols from ./store-siphon...
(gdb) target remote | vgdb
Remote debugging using | vgdb
relaying data between gdb and process …
warning: remote target does not support file transfer, attempting to access files from local filesystem.
Reading symbols from /lib64/ld-linux-x86-64.so.2...
Reading symbols from /usr/lib/debug/.build-id/…
0x… in _start () from /lib64/ld-linux-x86-64.so.2
(gdb)
```

The `warning:` is **expected**: gdb and the routine share one bench, so
there is nothing to transfer. `_start` is the very first instruction of
the program, before `main`: that is where `--vgdb-error=0` stopped it.
`-x store.gdb` runs two settings you met in Week 7: no debuginfod
question, and no paging of long output.

**4. Stop it at rest.** The routine has a function named `siphon_rests`,
which it calls once all its drawing is done and before it prints
anything. Stop there:

```
(gdb) break siphon_rests
Breakpoint 1 at 0x…: file store-siphon.c, line 78.
(gdb) continue
Continuing.

Breakpoint 1, siphon_rests () at store-siphon.c:78
78      }
(gdb)
```

Terminal A has printed nothing new: the routine has drawn every block it
will ever draw, and has not yet said a word.

**5. Ask valgrind what is lost, now.** `monitor` passes the rest of the
line to valgrind instead of to gdb:

```
(gdb) monitor leak_check full definiteleak
```

Expected — the same two records as Task 3, mid-run, with the figures
blanked here:

```
==…== … (+…) bytes in … (+…) blocks are definitely lost in new loss record 1 of 2
==…==    at 0x…: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==…==    by 0x…: fair_copy (store-siphon.c:…)
==…==    by 0x…: main (store-siphon.c:…)
==…== 
==…== … (+…) bytes in … (+…) blocks are definitely lost in new loss record 2 of 2
==…==    at 0x…: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==…==    by 0x…: draw_block (store-siphon.c:…)
==…==    by 0x…: main (store-siphon.c:…)
==…== 
==…== LEAK SUMMARY:
==…==    definitely lost: … (+…) bytes in … (+…) blocks
==…==    indirectly lost: 0 (+0) bytes in 0 (+0) blocks
==…==      possibly lost: 0 (+0) bytes in 0 (+0) blocks
==…==    still reachable: 0 (+0) bytes in 0 (+0) blocks
==…==         suppressed: 0 (+0) bytes in 0 (+0) blocks
==…== 
```

The `(+…)` figures are the change since the last time you asked; this
being the first, they equal the figures before them. Check the figures
against Task 3: the same, before the routine has even finished.

**Checkpoint.** Terminal B is stopped at `siphon_rests`, Terminal A has
printed nothing since its banner, and valgrind's figures match the ones
you wrote down in Task 3. If any of those is not so, read the lost box
at the end of this task before you go on.

**6. Where are record 1's blocks?**

```
(gdb) monitor block_list 1
```

Expected — the record's heading again, and then **one line per block**,
each an address with the block's size in square brackets:

```
==…== … (+…) bytes in … (+…) blocks are definitely lost in new loss record 1 of 2
==…==    at 0x…: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==…==    by 0x…: fair_copy (store-siphon.c:…)
==…==    by 0x…: main (store-siphon.c:…)
==…== 0x…[…]
...
```

Your bench prints every block's line. Copy them all into your logbook, in
the order printed. They are listed lowest address first, which here is
also the order they were rented in.

**7. Read each block.** `x/s` is gdb's *examine as string*: it prints the
bytes at an address as text, up to the first zero byte. Take the first
address `block_list` printed — just the `0x` and its digits, not the
`[size]` — and type it after `x/s`. (Select it with the mouse and paste,
rather than typing it.)

```
(gdb) x/s 0x…
0x…:  "[ your bench prints a line here ]"
```

gdb repeats the address in small letters, then prints what the block
holds. Do the same for **every** address on your list, in order, and copy
each line into your logbook, **exactly**, character for character.

And the other record's blocks? Read `draw_block` in the source (Task 3
step 6): what does it put in every block it draws? (*For the curious*
shows you how to look.)

**8. Write down what you read.** Under **Milestone 4**: how many of the
leaked blocks hold words, and what each one holds, in order. Number the
blocks in the order `monitor block_list 1` printed them: block 1, block
2, and so on. Blocks 2 and 3 differ by one word; note which word block 3
uses. Record; do not explain. What you make of it belongs in your case
notes.

**Checkpoint.** You should be able to say, without looking at your
notes: how you got from a waiting valgrind to the contents of a block,
command by command; how many leaked blocks hold words and what the rest
hold; the word block 3 uses where it differs from block 2; and how the
source's comments are signed.

**9. File it — from a third terminal.** Leave Terminals A and B exactly as
they are. Open a third terminal the way you opened the second (P1), go to
your work-order folder with the `cd` line from P2, and in
`check/answers.txt`:

- **`A9:`** — how many of the leaked blocks hold words. One number.
- **`A10:`** — blocks 2 and 3 differ by one word: the word block 3
  uses.
- **`A11:`** — the mark the comments are signed with: copy it exactly,
  letters and dots.

**10. Claim the seal** — in that third terminal:

```sh
make -C check m4
```

Expected:

```
make: Entering directory '.../labs/week-09/check'
  ~~~ WAX SEAL of the Guild: FCF1D44F ~~~
  (Paste this seal into your logbook under Milestone 4.)
make: Leaving directory '.../labs/week-09/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 4** with the comments and their mark, every
block's address and what `x/s` read from it, and the command sequence that
got you there.

> **If you're lost, start here (Task 4).**
> - `Remote communication error. ... Connection reset by peer.`? Either
>   no valgrind is waiting (Terminal A's has finished, or never started),
>   or two are. `quit` gdb, `pkill -KILL -f vgdb-error` from any terminal,
>   then steps 2 and 3 again, with one.
> - You pressed Ctrl-C in Terminal A and it printed `^C` and went on
>   waiting? That is expected; it ignores Ctrl-C. See *the safe way out*,
>   above step 1.
> - gdb asks `Enable debuginfod for this session? (y or [n])`? You left
>   out `-x store.gdb`. Press **Enter** (the default, *n*) and carry on.
> - gdb starts with `./store-siphon: No such file or directory.` and
>   `store.gdb: No such file or directory.`, and `break siphon_rests`
>   says `No symbol table is loaded.` and asks about a pending breakpoint?
>   gdb was started in another folder. Answer `n`, `quit`, then
>   `cd ~/enginehouse/src/siphon && gdb -q -x store.gdb ./store-siphon`.
> - `continue` ran straight to the end — Terminal A printed the leak
>   report and gdb says `exited normally` — with no breakpoint stop? The
>   breakpoint was not set. `quit` gdb (it asks nothing; the routine has
>   finished), then start again from step 2, and type `break siphon_rests`
>   before `continue`.
> - `monitor block_list 1` says
>   `Can't print block list : no valid leak search result`? Ask
>   `monitor leak_check full definiteleak` first (step 5); `block_list`
>   lists from the last leak search.
> - `x/s` printed `<error: Cannot access memory at address 0x…>`? A digit
>   went astray. Copy the address again, from `0x` to the last digit before
>   the `[`.
> - `x/s` says ``cannot subscript something of type `int'``? You copied
>   the `[size]` as well. Copy the address only, up to the `[`.
> - `x/s` printed `""`? That block holds a zero first: it is not one of
>   record 1's. Check you listed record **1**.
> - Typed `clear` in gdb to tidy the screen? In gdb, `clear` deletes your
>   breakpoint, it does not clear the screen. Press **Ctrl-L** for that.
> - The terminal will not answer at all? *The safe way out*, above step 1:
>   `pkill -KILL -f vgdb-error` from another terminal.

**11. The closing command.** Back in Terminal B, at the `(gdb)` prompt,
press **Ctrl-L** to clear the screen. Then one command: `x/s` on the
**third** address `monitor block_list 1` printed.

```
(gdb) x/s 0x…
0x…:  "[ your bench prints a line here ]"
```

Leave it on your screen.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 9 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, character for character — do not paraphrase:

- The two lines `store-siphon` printed about itself.
- Every line `x/s` read from the leaked blocks, in order.
- Every comment in the source, and the mark they are signed with.

Three questions to write toward, none of which has an answer in this work
order:

1. Read the blocks in order: what do they amount to, and why might
   anyone keep them where nobody frees them?
2. The routine stops at a cap its own source sets. What difference does
   that cap make to the Engine, and to the Store's books?
3. What would you want to know next, and which command might show it?

Write a plain guess rather than a careful hedge. The notebook is marked on
being kept honestly, never on being right early.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not valgrind's.

1. In a paragraph: the routine leaks every block it draws, and the Engine
   is none the worse. Explain why a leak in a program that runs for a
   second and exits costs almost nothing, why a leak in a program that
   runs for months can bring a machine down, and what the cap changes.
   Use the words *heap*, *leak*, *definitely lost* and *indirectly lost*
   correctly at least once each. *zyBooks Ch 6.*
2. The clerk printed the right ledger every time you ran it, and was
   wrong three ways. In two or three sentences: is a program that always
   prints the right answer a correct program? What would you want to see
   before you said so? (There is no answer key. I am asking what you would
   defend in a code review.)

## Turn it in

Due **Sunday, October 18, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)).

1. **`logbook.md`** — all four milestones: what you did, the seal pasted
   in, what it means. M1 wants both runs, each line's region, the order,
   what changed and what did not, and why `size` has three columns; M2
   wants every report from the first audit, the three faults, the echo,
   and each mend; **M3 wants every byte accounted for** — both loss
   records, their lines, the sum against the summary, and what
   proofreading found — which is the graded centre of the week; M4 wants
   the comments and their mark, every block and what it holds, and the
   commands that read them. Plus both reflection prompts and the
   time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 9 entry.

Upload both files to the Week 9 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.)

**Before you close your terminals,** end Task 4's session: in Terminal B,
`continue` (Terminal A prints the routine's two lines and its full leak
report, and gives you your prompt back), then `quit`. A valgrind left
waiting gets in the way of the next one; if you ever find one, *the safe
way out* in Task 4 has the cure. When your paperwork is in, you may
`bash report-for-duty.sh --reset`. It takes the source, its two settings
files and your build of `store-siphon` away, and leaves every other
week's papers exactly where they are.

**The usual late window applies.** Late work is accepted for two calendar
days at a flat 20%, so this order's window closes on **Tuesday,
October 20**. Hand it in on Sunday.

How the tasks cover the four objectives: Task 1 is objective 1; Task 2 is
objective 2; Task 3 is objective 3; Task 4 is objective 4; and the
reflections cover all four in your own words.

**Also on this week's docket.** Four dates:

- zyBooks **Ch 6** — memory — due **before class on Wednesday,
  October 14**. Readings have no late window. It is the reading behind all
  four tasks; do it first.
- **Guild Examination I** papers come back in **Wednesday's** studio.
- **Commission II — *The Speaking-Tube Console*** (zyBooks 12.2, "HUSH")
  is due **Friday, October 16, 11:59 pm, in zyBooks** — not Canvas.
- **Commission III — *The Pattern Loom*** (zyBooks 12.3, regular
  expressions) is assigned **Monday, October 12** and due **Friday,
  November 6, 11:59 pm, in zyBooks** — not Canvas. The cover is at
  [`commissions/03-the-pattern-loom.md`](../../commissions/03-the-pattern-loom.md).

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: FOUR. TWO STUDIOS. ADMIRED.`
> `THE STORE: STILL SHORT. THIS PORTER COUNTED TWICE.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap.

- **Look inside a withheld block.** At the breakpoint in Task 4, ask for
  the other record — but only two of its blocks, or the list runs on for
  a while:

  ```
  (gdb) monitor block_list 2 limited 2
  ==…== … (+…) bytes in … (+…) blocks are definitely lost in new loss record 2 of 2
  ==…==    at 0x…: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
  ==…==    by 0x…: draw_block (store-siphon.c:…)
  ==…==    by 0x…: main (store-siphon.c:…)
  ==…== 0x…[…]
  ==…== 0x…[…]
  (gdb) x/8xb 0x…
  0x…:  0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x00
  ```

  `x/8xb` examines eight bytes, in hex. Every one is zero, and `x/s` on
  the same address prints `""`. Those blocks were rented, filled with
  zeros, and never used for anything: **withheld**, not used.
- **Week 2's two watchmen, on the clerk.** Build the clerk as shipped with
  AddressSanitizer instead of running it under valgrind (from
  `labs/week-09/starter`; the first command takes the clerk as shipped
  out of git, so your mended copy is not touched:
  `git show HEAD:./store-clerk.c > /tmp/clerk-shipped.c`, then
  `gcc -g -fsanitize=address -o /tmp/clerk-asan /tmp/clerk-shipped.c && /tmp/clerk-asan`).
  ASan stops the program at the **first** fault, the overflow at line 38,
  and reports nothing else; valgrind went on and found all three.
  ASan is built in by the compiler and is fast enough to leave on while
  you develop; valgrind needs no special build and tells the whole story.
  The Guild keeps both.
- **A very large request.** Every block in this week's evidence is 4,096
  bytes or smaller, and every one came from the heap. Ask `malloc` for a
  great deal at once — 200 KiB, say — and it is served from somewhere
  else entirely, the gap between heap and stack the deck pointed at; that
  is next week.
- **How much is out?** `man 3 mallinfo2` describes a C library call that
  reports how much heap is rented right now. A long-running program can
  call it every so often and watch for a figure that only ever grows.
- **valgrind's own manual** is `man 1 valgrind`, and `monitor help` at a
  connected `(gdb)` prompt lists every question valgrind will answer
  mid-run, `leak_check` and `block_list` among them.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"The Store keeps books, and books can be read."*
