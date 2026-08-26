# WORK ORDER No. 1851-02 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 24 August 1851 — fifteen weeks to the Exhibition |
| **Due** | **Sunday, August 30, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

The first certification orders went out this morning, and with them a
complaint I cannot leave on the spike. The bench card-reader — the
little tool that registers each punched card before the Engine reads it
— takes a heartbeat too long per card, and one of my porters swears the
Engine *mutters* when it reads. Machines do not mutter. What a porter
calls a mutter, an enginewright calls **unaccounted work**, and the
Guild has an instrument that hears it perfectly: a trace of every
request a program makes of the Overseer.

Which brings us to the week's real business. Everything in this house —
the card-reader included — is forged in **C**, the Engine's native
tongue, and speaks to the Overseer in **system calls**, its native
grammar. This week you learn both: enough C to repair a faulty casting
with your own hands, and enough `strace` to put any program under oath.
Then you will put the card-reader under oath and report to me every
request no manual accounts for.

A tool has just been fitted to your bench for the purpose. Do not trust
it because it is new. Do not trust it at all, in fact. That is rather
the point.

Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Here is the whole week in one idea. The fiction is set dressing; the
commands are the course, and **no task ever requires story knowledge.**
Underneath it is this: no program you have ever used can touch a file,
a screen, or a network by itself. It has to ask. Every app you own is
one long conversation with the operating system, and this week you
learn to read the asking — after which no program can tell you it did
one thing while it quietly did another.

By Friday you will be able to:

1. **Compile, run, and debug a small C program** with `gcc`, reading
   compiler warnings, AddressSanitizer reports, and valgrind reports —
   *(new to C? see the box below)*.
2. **Read a system-call summary** (`strace -c`) and a **full system-call
   trace** (`strace`), and find what a program really touched —
   *zyBooks 1.2*.
3. **Explain user mode vs kernel mode** — why a program must ask the
   kernel for every file, and why the trace is therefore the truer
   record of what a program did — *zyBooks 1.2*.

> **If C is new to you, start here.** If your last languages were Java
> or Python, C is going to feel like someone took the guardrails off.
> That reaction is correct, and it is temporary. Nothing this week asks
> you to be fluent in C — only to read one short program and repair
> four known faults, with three tools that tell you where to look. The
> Guild keeps a refresher:
> [`labs/appendix-c-refresher.md`](../appendix-c-refresher.md) — about
> 90 self-paced minutes covering how C programs are built, pointers,
> arrays and strings, `malloc`/`free`, and structs, with six small
> exercises (answers included). It is **entirely optional and worth no
> points** — but spending the 90 minutes *before* Task 1 will repay
> itself this week and every week after. Comfortable C hands can skip
> straight to Provisions.

## Provisions

**P1 — Your working Linux environment from Week 1.** Any bench that
passed Week 1's smoke test is ready — this week uses `gcc`, `strace`,
and `valgrind`, and the smoke test proved all the machinery. If your
environment broke over the weekend, [`setup/getting-started.md`](../../setup/getting-started.md)
rebuilds it.

**P2 — This folder, open in your Linux shell.** Same drill as last
week, one folder over. Pick the line that matches your setup:

```sh
cd ~/comp3100-student/labs/week-02
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-02
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-02
```

**P3 — Report for duty.** One command stages your bench for the week:

```sh
bash report-for-duty.sh
```

Expected output:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-02 :: bench staged and verified
  ------------------------------------------------------------------
   Rack:      ~/enginehouse/bin   (new this week -- the tool rack)
   Tool:      ~/enginehouse/bin/card-reader
              compiled this minute, at your bench, by your own gcc
   Trial run: "Card intake registered. All is in order."

   So the tool says. The Chief wants a full trace of it by Friday.
  ------------------------------------------------------------------
```

Note what just happened: the card-reader was **compiled on your own
machine, by your own `gcc`, as you watched**. Your bench gains a fifth
room, `bin` — the tool rack, named by the same convention that gives
Linux its `/usr/bin`. Safe to re-run any time; it re-stages the same
bench and never duplicates anything. (`bash report-for-duty.sh --reset`
removes everything it created, should you ever want a pristine start.)

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report, as before. `check/answers.txt` is
new: three short answers (labeled A1, A2, A3) that this week's seal
checks read — the template tells you exactly what goes where, and Tasks
2 and 3 tell you when. Your running `case-notes.md` already lives at
the repo root from Week 1 and needs no copying — just its Week 2 row,
later. (Missing it? Week 1's Provisions P4 shows the copy line.)

> **If you're lost, start here (Provisions).**
> - Run `pwd`. The output should end in `labs/week-02`. If it doesn't,
>   re-run the `cd` line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell,
>   not Linux. Type `wsl` and press Enter, then re-run the `cd` line.
> - `report-for-duty: gcc not found`? Run the "a tool is missing" fix
>   in `setup/getting-started.md` Troubleshooting, then P3 again.
> - The duty slip didn't appear? Read the last line the script printed
>   — it names exactly what failed, and re-running is always safe.

---

## Task 1 — Four faults at the forge *(~35 minutes → Seal M1)*

The pattern shop has sent your bench a deliberately faulty casting:
`starter/hello-brassbridge.c`, a small C program carrying **four
faults**. This is a Guild tradition — nobody trusts an apprentice who
has only seen metal that pours clean. Each fault is marked in the
source with a comment naming its **symptom** (what you will see), never
its repair. You will meet four kinds of trouble, in escalating order of
sneakiness: two faults the compiler *warns about at the forge*, a
fault only visible *when the program runs*, and a fault invisible
until a specialist looks. Fix all four.

**1. Go to the forge and take stock:**

```sh
cd starter
cat hello-brassbridge.c
```

Read the whole file once — it is short — and find the four `FAULT`
comments. Don't fix anything yet.

**2. First casting:**

```sh
make
```

Expected — the compiler speaks three times (your line numbers may
differ slightly as you edit):

```
gcc -Wall -Wextra -g -fsanitize=address -o hello-brassbridge hello-brassbridge.c
hello-brassbridge.c: In function ‘main’:
hello-brassbridge.c:41:9: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
   41 |     if (total = 30)
      |         ^~~~~
hello-brassbridge.c:47:20: warning: implicit declaration of function ‘strlen’ [-Wimplicit-function-declaration]
   47 |            (size_t)strlen(motto));
      |                    ^~~~~~
hello-brassbridge.c:12:1: note: include ‘<string.h>’ or provide a declaration of ‘strlen’
   11 | #include <stdio.h>
  +++ |+#include <string.h>
   12 | /* FAULT 1 — symptom: the compiler reports an implicit declaration of
hello-brassbridge.c:47:20: warning: incompatible implicit declaration of built-in function ‘strlen’ [-Wbuiltin-declaration-mismatch]
   47 |            (size_t)strlen(motto));
      |                    ^~~~~~
hello-brassbridge.c:47:20: note: include ‘<string.h>’ or provide a declaration of ‘strlen’
```

Three warnings — but only **two** faults. The first warning is
**FAULT 2** (one character short of a comparison: `=` assigns, `==`
compares — inside an `if`, the first is almost never what anyone
means). The second and third are the same **FAULT 1** — the missing
announcement — complained of twice, and read those `note:` lines
carefully: the compiler *hands you the repair*, down to a patch-style
hint (`+++ |+#include <string.h>`) showing the exact line to add and
exactly where to add it. Fix both faults, then `make` again until the
compiler says nothing at all after the `gcc` line. A silent compiler is a
satisfied compiler. **Never ignore a warning this semester** — in C, a
warning is a fault on credit, and the interest is compounded at
runtime.

**3. Run it — and meet AddressSanitizer:**

```sh
./hello-brassbridge
```

Expected — the program is stopped mid-stride (addresses and the path
will be your own):

```
=================================================================
==4242==ERROR: AddressSanitizer: stack-buffer-overflow on address 0x7e35d8800034 ...
WRITE of size 4 at 0x7e35d8800034 thread T0
    #0 0x... in main .../labs/week-02/starter/hello-brassbridge.c:29
    ...
SUMMARY: AddressSanitizer: stack-buffer-overflow .../hello-brassbridge.c:29 in main
```

That is **FAULT 3**. The Makefile forged this build with
`-fsanitize=address`, which posts a watchman around every array; the
report names the exact line (`hello-brassbridge.c:29` here) where the
program wrote **one pigeonhole past the end of an array**. Plain C
would have shrugged and corrupted whatever lived next door — this is
the bug family behind decades of real-world security holes, which is
why the Guild sets the watchman by default. Read the loop at that line,
count its trips against the array's size, fix it, `make`, and run
again. Expected now — it runs, but keep your eye on the first line:

```
A short week: 32796 hours at the bench.
The motto has 15 letters; the bench salutes every one.
```

`32796` hours? Your number will differ — it may even, by dumb luck,
say `A full week: 30 hours`. Either way, something is deranged: the
tally starts from whatever rubbish the Store last held. Luck is not
correctness. Which brings us to the specialist.

**4. Call in valgrind:**

```sh
make valgrind
```

This forges a *second* casting without AddressSanitizer
(`hello-brassbridge-vg`) and walks it under valgrind — the two
watchmen refuse to share a binary, which is why the Makefile keeps two
builds. Expected — among valgrind's `==` lines (yours will repeat
similar blocks several times):

```
==5150== Conditional jump or move depends on uninitialised value(s)
==5150==    at 0x...: main (hello-brassbridge.c:42)
...
==5150== ERROR SUMMARY: 7 errors from 5 contexts (suppressed: 0 from 0)
```

`make` finishes that run with a line of its own —
`make: *** [Makefile:21: valgrind] Error 1`. Nothing is broken: the
Makefile asks valgrind to *fail the build* when it finds anything
(`--error-exitcode=1`), so that line is the forge agreeing with the
specialist. It disappears when the count reaches zero.

That is **FAULT 4**: a variable read before it was ever given a value.
The compiler couldn't see it, ASan doesn't look for it, but valgrind
watches every read. Find the tally variable, give it an honest starting
value, then `make valgrind` again. Expected:

```
==5163== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```

**5. Final proof.** Rebuild and run the bench build one last time:

```sh
make && ./hello-brassbridge
```

Expected:

```
A full week: 30 hours at the bench.
The motto has 15 letters; the bench salutes every one.
```

**Now claim the seal.** From `labs/week-02` (that's `cd ..` if you're
still in `starter/`):

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-02/check'
  ~~~ WAX SEAL of the Guild: 4C7B21D9 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-02/check'
```

(The seal code is yours, not this one.)

(The checker recompiles your `starter/hello-brassbridge.c` with
warnings promoted to errors and runs it under ASan — that's enough to
catch faults 1–3 cold. Fault 4, the uninitialised read, can pass `m1`
on lucky stack garbage; the only proof that holds is the valgrind run
your logbook narrates. Luck is not correctness. The seal code is
yours, not this one.) Paste your seal into
`logbook.md` under **Milestone 1**, with one sentence per fault: the
symptom you saw, and which watchman — compiler, ASan, or valgrind —
caught it.

> **If you're lost, start here (Task 1).**
> Four faults in one afternoon is a lot of failure to sit with. That is
> the design, not your ability — each one is a bug you will meet again.
> - `make: command not found` or `gcc: command not found`? You're not
>   in your Linux shell, or a tool is missing — `wsl` first, then the
>   "a tool is missing" fix in `setup/getting-started.md`.
> - The compiler's message cites a line number — **open the file and go
>   to that exact line.** With nano: `nano +41 hello-brassbridge.c`.
>   Fix the *first* complaint first; later ones often follow from it.
> - ASan prints a wall of text? You only need the first three lines:
>   the error name, `WRITE of size 4`, and the `hello-brassbridge.c:NN`
>   frame. Everything below is scenery.
> - `make valgrind` still shows errors after your fix? Make sure you
>   saved the file, and look at valgrind's *first* numbered line — it
>   names the line where the doubtful value was *used*; the missing
>   starting value belongs where the variable is *declared*.
> - Seal check failed but the program runs fine? The checker compiles
>   with `-Werror` — every warning must be gone, not just the crashes.
> - Made a mess of the file? `git checkout -- starter/hello-brassbridge.c`
>   (from `labs/week-02`) restores the original faulty casting.

---

## Task 2 — Put the card-reader under oath *(~25 minutes → Seal M2)*

Every program in this house does its work by asking the **Overseer** —
the kernel — through system calls: *open this file, write these bytes,
give me memory*. A program can print whatever it pleases on its way
out; it cannot touch a file, the network, or another process without
asking. `strace` sits between a program and the kernel and writes down
**every request and every answer**. That makes it the Guild's oath-taker:
programs may fib in their output; the trace records what they *did*.

**1. Warm up on an honest tool.** From `labs/week-02`:

```sh
strace -c ls
```

Expected — `ls`'s file listing, then a table (your numbers will vary a
little):

```
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 24.35    0.001680          48        35        13 openat
 22.22    0.001533          51        30           mmap
 13.87    0.000957          41        23           fstat
 13.57    0.000936          39        24           close
   ...
------ ----------- ----------- --------- --------- ----------------
100.00    0.006900          46       149        17 total
```

`-c` means *count*: one row per system call, tallied. Read the bottom
line — that's the total number of requests `ls` made to list one small
folder. **Record that total as `A1:` in `check/answers.txt`** (a rough
number is fine; it drifts run to run). Notice, too, the `errors`
column: thirteen `openat` calls *failed*, and `ls` worked perfectly.
Hold that thought.

**2. Now the tool the porter complained about.** Run it plainly first:

```sh
~/enginehouse/bin/card-reader
```

Expected:

```
Card intake registered. All is in order.
```

All is in order. So it says. Count its requests:

```sh
strace -c ~/enginehouse/bin/card-reader
```

Expected (trimmed to the interesting rows — yours has more):

```
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 21.26    0.000370          46         8           mmap
 10.57    0.000184          36         5         1 openat
   ...
  4.08    0.000071          35         2           write
   ...
------ ----------- ----------- --------- --------- ----------------
100.00    0.001740          38        45         2 total
```

Study those two rows. **Five `openat` calls, one of which failed** —
what would a one-line tool with no files to read be opening, and what
did it fail to find? **Two `write` calls** — one is the sentence it
printed. Where did the other one go? The count table raises the
questions but cannot answer them: `-c` tallies calls, it does not show
their arguments. For names and answers you need the full trace.

**3. The full trace.** `strace` with no `-c` prints every call as it
happens, arguments and all. The unfiltered trace is long (most of it is
the program loader finding libc — every program starts that way), so
ask for just the calls that matter here:

```sh
strace -e trace=openat,write ~/enginehouse/bin/card-reader
```

Expected — this is the whole output, and it is worth reading every
line (your home directory will be your own):

```
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/home/you/.card-reader.conf", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/you/.ledger-annex", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3
write(3, "12 June \342\200\224 6 hrs computed by ha"..., 77) = 77
openat(AT_FDCWD, "/home/you/.ledger-annex", O_RDONLY) = 3
write(1, "Card intake registered. All is i"..., 41Card intake registered. All is in order.
) = 41
+++ exited with 0 +++
```

Take it line by line — this one screenful is the week:

- **Lines 1–2:** the loader finding the C library. Every dynamically
  linked program begins this way; learn to read past it.
- **Line 3 — the failed `openat`.** The tool asked for a configuration
  file, `.card-reader.conf`, and the kernel answered `-1 ENOENT` — *No
  such file or directory*. This is the failure from your count table,
  and here is the teaching moment: **an error return is an answer, not
  a crash.** Programs probe for optional files constantly, take the
  "no" gracefully, and carry on with defaults — those thirteen failed
  `openat` calls under `ls` were the same story. A trace full of
  ENOENTs is Tuesday, not an emergency.
- **Lines 4–5 — the write nobody mentioned.** The tool opened a
  *second* file — `O_WRONLY|O_CREAT|O_APPEND`: for writing, creating
  it if absent, always adding at the end — the kernel handed it file
  descriptor `3`, and the tool wrote 77 bytes to it. Its printed
  report says nothing about this file. No manual mentions it. The name
  starts with a dot.
- **Last lines:** file descriptor `1` is standard output — this
  `write` is the sentence you saw, caught in the act (your terminal's
  text interleaves with strace's report, which is itself a lesson:
  strace writes to *stderr* so the two streams don't mix). Note the
  fd numbers: **fd 1 is the mouth; fd 3 was the hand under the desk.**

The tool's report says *all is in order*. The system-call record says
it quietly wrote 77 bytes to a file it never mentions. Both cannot be
the whole truth — and only one of the two was written down by the
kernel. You have just caught a program fibbing, using nothing but the
record of what it asked the Overseer to do. That skill is the week.

**4. File your findings.** Open `check/answers.txt` and fill in
**`A2:`** — the full path of the file the card-reader writes to but
never mentions (the path appears verbatim in your trace; copy it, with
your own home directory in it or `~/` shorthand, either is accepted).

**Claim the seal.** From `labs/week-02`:

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-02/check'
  ~~~ WAX SEAL of the Guild: A0F35E68 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-02/check'
```

(The seal code is yours, not this one.)

Paste your seal under **Milestone 2**, with two or three sentences:
what the count table made you suspect, and what the full trace proved.

> **If you're lost, start here (Task 2).**
> - `strace: Can't stat 'card-reader'`? Use the full path:
>   `~/enginehouse/bin/card-reader` — or re-run `bash report-for-duty.sh`
>   (always safe) if the tool isn't there at all.
> - Your trace shows a *successful* open of `.card-reader.conf`? You
>   (or an experiment) created that file — `rm ~/.card-reader.conf`
>   restores the expected ENOENT.
> - Extra `openat`/`write` lines? Your annex has reached its 20-line
>   limit — the tool is trimming the leaf. Nothing is wrong;
>   `bash report-for-duty.sh` re-stages the bench and your trace
>   matches the block above again.
> - Ran `strace -c` and can't find any file names? That's the design:
>   `-c` **counts** calls; only the full trace (step 3) shows
>   arguments. Forgetting which is which costs everyone ten minutes
>   once. Once.
> - Trace scrolled past? Pipe it through a pager —
>   `strace ~/enginehouse/bin/card-reader 2>&1 | less` — remembering
>   strace reports on stderr, hence the `2>&1`. `q` quits, as ever.
> - `m2` failed? It checks three things: the tool exists (P3), the
>   hidden file exists (run the tool once), and `answers.txt` names
>   the hidden path (step 4). The template must be *copied* to
>   `answers.txt` (P4), not edited in place.

---

## Task 3 — Read what it wrote *(~15 minutes → Seal M3)*

You have the path of a file the card-reader feeds in the dark. Time to
read it.

**1. First, see why you never noticed it:**

```sh
ls ~
ls -a ~
```

The first listing shows no such file. The second does. Files whose
names begin with a dot are **hidden by convention** — `ls` and file
pickers skip them unless asked (`-a`, *all*). The custom exists so
configuration files don't clutter your home folder — `.bashrc` from
Week 1 is exactly such a file — but anything that wants to be
overlooked profits from the same custom. A dot is not a lock; it is a
polite request not to look. Decline the request.

**2. Read the annex:**

```sh
cat ~/.ledger-annex
wc -l ~/.ledger-annex
```

Read all of it, slowly. You'll find a header, ruled sections, and
line upon line in the same careful format. Note the *kinds* of entries
you see, the dates on them, and the closing phrase the entries share.

**3. Watch it grow.** Run the tool once more, then look again:

```sh
~/enginehouse/bin/card-reader
tail -3 ~/.ledger-annex
```

Expected — the last line is new since your last look, and each run of
the tool adds another:

```
12 June — 6 hrs computed by hand, uncompensated. — your diligent servant
```

Every card the reader registers, somebody's hours are booked in a
hidden ledger, in a clerk's careful hand, dated, signed with a
valediction out of a letter-writing manual. `wc -l` before and after a
few more runs will tell you one thing more about how this ledger is
kept — a small thing, but a careful bookkeeper would notice it.

**4. Answer the week's question.** Open `check/answers.txt` and fill
in **`A3:`**, one or two sentences in your own words: when a program's
printed output and its system-call record disagree, which is the truer
account of what the program did — and *why*? Your answer should touch
what zyBooks 1.2 calls **user mode and kernel mode**: the program
prints in user mode and may say anything; a file only changes when the
kernel — which logs the request — agrees to change it. Say it your own
way — then copy your verdict into the logbook's Milestone 3 "what it
means" notes; the logbook is what the Chief reads. The seal only
checks that you answered; the grader reads the reasoning in your
logbook.

**Claim the seal.** From `labs/week-02`:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-02/check'
  ~~~ WAX SEAL of the Guild: 72E9B4C1 ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-02/check'
```

(The seal code is yours, not this one.)

Paste your seal under **Milestone 3**. (`m3` checks that A1, A2, and
A3 in `check/answers.txt` are all answered — it reads nothing else.)

> **If you're lost, start here (Task 3).**
> - `cat: /home/you/.ledger-annex: No such file or directory`? Run
>   `~/enginehouse/bin/card-reader` once — the file appears; your
>   trace in Task 2 shows why (`O_CREAT`).
> - `ls -a ~` shows a crowd of dot-files? Perfectly normal — every
>   tool you've ever run left one. You're looking for exactly one
>   newcomer, and Task 2 already told you its name.
> - Deleted the annex while poking at it? No harm: run the tool (or
>   `bash report-for-duty.sh`) and it's back.
> - `m3` failed? Every answer line must have content *after* its
>   colon, in `check/answers.txt` (not the template). One-word answers
>   pass the seal but not the grader.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 2 row: what you
found, the command that showed it to you, and what you make of it.
Copy the exact strings — **the full path of the hidden file** and **at
least one annex line**, its date and its closing valediction included,
exactly as it appears at your bench. Week 1 asked you to start that
habit; this is the first week it has something worth copying. Quote
before you interpret: a paraphrase cannot be checked later, and an
exact line can.

One question to write toward, which has no answer in this work order:
the annex is dated, kept in a careful hand, and books somebody's hours
as **uncompensated**. Whose hours — and why would a card-reader, of
all the tools in this house, be the thing keeping that count?

Guesses about what it means are welcome and graded kindly; the
notebook is marked on being kept honestly, never on being right early.
Copy the strings exactly and you will thank yourself in November.

## Reflection (both prompts go in your logbook)

Both prompts are the same question in different clothes: how do you
know what a program actually did? Answer in your own words — said
plainly beats said formally, every time.

1. The card-reader's own output claimed all was in order while its
   system-call record showed an unannounced write. In two or three
   sentences: why is the kernel's record the authoritative one? Use
   *user mode* and *kernel mode* the way zyBooks 1.2 does — who runs
   in which mode, and who is allowed to touch the hardware.
2. Four faults, three watchmen: the compiler caught two, ASan caught
   one at runtime, valgrind caught one more. Why do you suppose C
   needs all three, when the languages you knew before catch most of
   this in one place? One honest paragraph — "because C trusts the
   programmer" is a fine place to start, if you say what that trust
   costs and what it buys.

## Turn it in

Due **Sunday, August 30, 11:59 pm**, on **Canvas**:

1. **`logbook.md`** — all three milestones: what you did, the seal
   pasted in, what it means; the four-faults narrative (M1); your
   trace findings (M2); plus both reflection prompts and the
   time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 2 entry.

Upload both files to the Week 2 assignment. (`check/answers.txt` stays
in your repo — the seals already vouch for it; the prose in your
logbook is what's graded.)

That closes all three objectives: the forge work (M1) is objective 1,
the trace work (M2 and A1/A2) is objective 2, and A3 with Reflection
prompt 1 is objective 3 in your own words.

**Also on this week's docket:** zyBooks Ch 1 (finish) and Ch 2 (begin)
are due **Wednesday** before class, as usual. And at Monday's briefing
the Guild assigned **Commission I — *The Census of the Enginehouse***
(zyBooks 12.1, "Mr. Kureos"), due **Friday, September 18** in zyBooks.
Nothing in this work order depends on it — it is a Python program,
independent of this week's C, so start it early rather than late.
Budget your evenings.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: THREE. ADMIRED.`
> `UNREGISTERED PAPERWORK: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Every one of these is something I poked at the first week I met
`strace` and could not leave alone. Chase whichever one catches you and
ignore the rest; that is what this shelf is for.

- The card-reader probes for `~/.card-reader.conf` and shrugs at the
  ENOENT. Try `touch ~/.card-reader.conf`, re-run your Task 2 trace,
  and watch the answer change from `-1 ENOENT` to a file descriptor.
  (Then `rm ~/.card-reader.conf` to put the bench back.)
- The annex never grows past a certain length, however many times the
  tool runs. Prove it with `wc -l` and a shell loop —
  `for i in $(seq 1 30); do ~/enginehouse/bin/card-reader >/dev/null; done`
  — and think about how *you* would implement that rule.
- `man 2 open` and `man 2 write` — the manual pages for the very calls
  you watched; the `RETURN VALUE` and `ERRORS` sections explain every
  `= -1` you will ever see in a trace. `man 3 errno` lists the whole
  family ENOENT belongs to.
- `ltrace` is `strace`'s cousin: it traces *library* calls (`printf`,
  `fopen`) instead of system calls. It is the one tool on this shelf
  your bench may not already carry — `sudo apt install ltrace` fits it
  in a few seconds — then run both on the card-reader and compare what
  each one sees.
- `strace -c` on something big — `strace -c gcc -o /tmp/hb starter/hello-brassbridge.c`
  — makes `ls`'s 149 calls look like small talk.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
