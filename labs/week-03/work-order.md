# WORK ORDER No. 1851-03 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 31 August 1851 — fourteen weeks to the Exhibition |
| **Due** | **Sunday, September 6, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

The sixth loom in the north bank was running before the porters
unlocked the doors this morning — cards nobody submitted, against
a duty roster with nothing on it. Its spool is filling with arithmetic
tables, and the tables are *flawless*. Not machine-flawless. The other
kind: ruled, checked, and entered fair, the way a hand-computer was
taught to enter figures before this house had figure wheels.

So we shall do what the Guild does when a job appears without paperwork.
We take the **census**.

To take a census of jobs you must first know what a job *is* to the
Overseer, and that is this week's real business. Every running thing in
this house — your shell, your editor, the sixth loom's mystery — is a
**process**, and the Overseer keeps a card on each one: who its parent
is, what it is running, what state it is in, what it was handed when it
started. Learn to make processes with your own hands (the pantograph
desk copies the work as it stands, mid-stroke; the copy is handed a new
card to run; the desk collects the finished work), learn what happens
when a parent *fails* to collect, and then go
and read the Overseer's cards on every job running under your name.

One of them will not have a parent you can find.

Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Every program you have ever run was started by another program. Not by
magic, and not by anything exotic: by an ordinary process making two
ordinary calls — the same two calls you are about to write yourself.
When this week is done the terminal stops being a black box you type
into and becomes a program you can read. The fiction is set dressing
and the commands are the course; **no task ever requires story
knowledge.** By Friday you will be able to:

1. **Say what a process is** and what the operating system records about
   one — pid, parent, state, and the rest of the process control block —
   *zyBooks 2.1*.
2. **Create processes in C** with `fork()`, replace a child's program
   with `execvp()`, and collect its exit status with `waitpid()` —
   *zyBooks 2.3–2.4*.
3. **Read a live process's entry in `/proc`** — its command line, its
   status card, and the environment it was handed.
4. **Explain zombies and orphans** — what makes each, what clears each,
   and which one is actually a problem. *(Not in the zyBook: zombies and
   orphans are Linux specifics, and the text does not use either word.
   The deck and this work order are your sources.)*

> **If C is still new**, the Guild's refresher is still open:
> [`labs/appendix-c-refresher.md`](../appendix-c-refresher.md). This
> week needs what Week 2 needed — `printf`, `if`, and the courage to
> read a compiler message — plus one new character: `&`, meaning "the
> address of". You will type it twice, both times copied straight from
> this page, so nothing here waits on understanding it. If you want to
> know *why*, the refresher's Part 2 explains it in fifteen minutes.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready: this week uses `gcc`, `ps`, `pstree`, and the
`/proc` filesystem, all standard. If your environment broke over the
weekend, [`setup/getting-started.md`](../../setup/getting-started.md)
rebuilds it.

**P2 — This folder, open in your Linux shell.** Same drill, one folder
over. Pick the line that matches your setup:

```sh
cd ~/comp3100-student/labs/week-03
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-03
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-03
```

**P3 — Report for duty.** One command stages your bench for the week:

```sh
bash report-for-duty.sh
```

It pauses six seconds on purpose — it is watching something before it
reports. Expected output:

```
  (watching the spool for a moment -- six seconds)

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-03 :: bench staged and verified
  ------------------------------------------------------------------
   Forge:     labs/week-03/starter   (two castings await your hands)
   Floor:     ONE JOB ALREADY AT WORK on this bench, and the duty
              roster is empty. Nobody on the day shift started it.
   Spool:     ~/enginehouse/spool/loom-tender/tables.out
              3 lines and filling, five seconds at a time
   Register:  ~/enginehouse/.loom-tender.pid

   Take the census before Friday. Something is running here that
   no schedule owns.  (bash report-for-duty.sh --reset stops it.)
  ------------------------------------------------------------------
```

Read that slip twice. **Something is now running on your machine** — a
job that wakes every five seconds, writes one line into a file under
`~/enginehouse/spool`, and goes back to sleep. It touches nothing else:
no network, no sudo, nothing outside your bench folder, and it costs so
little processor time that `ps` will report it as zero.

It stops when you run `bash report-for-duty.sh --reset`. It does **not**
stop when you close your terminal — that is deliberate, and Task 3 will
show you why — but it does not survive a reboot or a full shut-down of
your Linux environment (`wsl --shutdown`, stopping your VM, a
reboot). Re-running the script is safe any time; it never seats
a second one. **Leave it running until Task 3 is finished**, because
Task 3 is the census, and one cannot take a census of an empty floor.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds three
short answers (A1, A2, A3) that the seal checks read; the template says
what goes where, and Tasks 2 and 3 tell you when. Your running
`case-notes.md` is already at the repo root from Week 1.

> **If you're lost, start here (Provisions).** A bench that fights back
> costs you no points — work down this list, and bring whatever is
> still broken to studio.
> - Run `pwd`. The output should end in `labs/week-03`. If it doesn't,
>   re-run the `cd` line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell,
>   not Linux. Type `wsl` and press Enter, then re-run the `cd` line.
> - **A tool is missing** — `gcc: command not found`, `pstree: command
>   not found`, `make: command not found` while you *are* in Linux, or
>   `No manual entry for fork in section 2`? Your bench's first-boot
>   setup did not finish. This one line puts back everything Week 3
>   uses, and it is safe to run even if most of it is already there:
>
>   ```sh
>   sudo apt update && sudo apt install -y build-essential procps psmisc \
>        man-db manpages manpages-dev manpages-posix-dev strace nano
>   ```
>
>   Then run P3 again. (`build-essential` is `gcc` and `make`; `procps`
>   is `ps` and `pgrep`; `psmisc` is `pstree`; the four `man*` packages
>   are the manual pages this week sends you to, including
>   `man 2 fork`.) If more than this is broken —
>   your prompt is wrong, the bench never built at all — go to
>   [`setup/getting-started.md`](../../setup/getting-started.md),
>   Troubleshooting, "A tool is missing", which repairs the whole
>   environment rather than this week's corner of it.
> - Staging said `no attendant took post`? Something stopped the job
>   before it settled. Re-run `bash report-for-duty.sh`; it is always
>   safe, and it never leaves two of anything behind.
> - Rebooted, ran `wsl --shutdown`, or stopped your VM, and Task 3
>   finds nothing? Expected — the job
>   does not survive a shut-down (closing a terminal is fine). Re-run
>   `bash report-for-duty.sh` and it is back, with a new pid.

## How to work this week

Both studio days are yours to work at your own pace. **Everything you
need is on this page** — the explanation, the command, what that command
should print, and a box at the end of every task for when it prints
something else. Nothing in this work order requires you to ask anybody
anything: it is built to be worked start to finish on your own, and that
is how it is meant to go.

I am in the room both days regardless, so if you would rather ask than
dig, ask. Neither one makes you the better student. Here is the shape of
the thing and how to keep yourself moving through it.

**The order, and roughly when.** Tasks 1 and 2 make a Wednesday — about
thirty minutes and twenty. Task 3 is Friday on its own, about
thirty-five, and it needs the job staged in P3 still running, so leave
that job alone until you have finished with it. If Wednesday runs short,
start Task 3 early; nothing breaks.

Those numbers are the **bench** work. Budget about another half hour for
the writing — the three "what it means" notes, the two reflections, and
the case note — and do it while the output is still on your screen,
rather than on Friday night out of memory. The writing is the part that
is graded, and it is much faster when you are looking at the thing you
are describing.

**Every task is built the same way:** a short explanation, a command, and
an **Expected** block showing what that command prints. Run the command
before you read on. The tasks are cumulative inside themselves — Task 1
in particular is meant to be run at each of its three stages, so you can
watch the program change from *broken* to *nearly right* to *right*, and
so that when something goes wrong you know which of the three lines you
just wrote is responsible.

**When something does not match the page,** work it in this order:

1. **Re-read the Expected block** just above the command. Most of the
   time the difference between your output and mine is one word, and
   that word is the lesson.
2. **Go to the "if you're lost" box** at the end of that task. Those
   boxes are indexed by *the message you are staring at*, not by what
   caused it, because the message is what you actually have.

Those two get you through everything this work order can throw at you.
If one of them doesn't, take whichever of these suits you — they are
equally good and neither costs you anything:

- **Write it down and keep going.** The exact command and the exact
  output, into your logbook; then move to the next step or the next task
  and come back to it. A bench that fights you costs you nothing on this
  work order, but an evening spent silently losing to it costs you the
  week — and a written-down error is the fastest thing in the world to
  fix later.
- **Or just ask me.** I am across the room. Ten minutes of trying first
  is plenty; bring the command and the output rather than a theory about
  what is wrong, and you will usually have your answer in about thirty
  seconds.

**What the seals are, and are not.** A seal proves a milestone actually
worked; it is not the grade. What is graded is the prose you write under
each milestone — what you did and what it means. A seal with an honest
*"I got this but I am still fuzzy on why the second run differed"*
underneath it is worth more than a seal with nothing underneath it, and
it tells me exactly where to start.

**Reference while you work.** The back of Monday's deck carries ten
reference cards — every call and command this week uses, one to a card,
with the manual page to read next. If you know what you want and not
what it is called, look there first.

---

## Task 1 — The pantograph desk *(~30 minutes → Seal M1)*

A **pantograph desk** does not copy a card — a card is only a plan. It
copies the draughtsman **mid-stroke**: the work as it stands this
instant, materials drawn, pen where the pen is. One desk becomes two,
both at the same line of the same card. That is exactly what `fork()`
does, and it is the only way this house makes a new process: an existing
process is **copied**.

Three calls do the whole job, and they are the week's core:

| Call | What it does | The desk |
|---|---|---|
| `fork()` | copies the calling process; both continue from the same line | the pantograph traces the desk, mid-stroke |
| `execvp()` | replaces *this* process's program with another | the copy is handed a different card to run |
| `waitpid()` | blocks until a child finishes, and reports how | the desk collects the finished work |

The strange one is `fork()`. **It returns twice** — once in each of the
two processes that now exist. In the copy (the *child*) it returns `0`;
in the original (the *parent*) it returns the child's **pid**. That one
number is the only way each process can tell which one it is.

Your bench has a casting of a pantograph with three parts missing.

**1. Go to the forge and read it:**

```sh
cd starter
cat pantograph.c
```

Three `TODO` blocks, numbered. Every line that *prints* is already
cast — do not change the `printf` lines, because the seal check reads
them.

**2. Cast it as it stands:**

```sh
make
```

Expected — silence from the compiler, twice (the second program is
Task 2's):

```
gcc -Wall -Wextra -g -o pantograph pantograph.c
gcc -Wall -Wextra -g -o zombie-maker zombie-maker.c
```

Run the unfinished casting to see it fail honestly:

```sh
./pantograph echo test
```

Expected:

```
pantograph: fork: Success
```

An odd complaint, and worth ten seconds of your attention: the
placeholder sets `child` to `-1`, the code reads that as "the fork
failed", and `perror` faithfully reports the last error the system
recorded — which, since nothing actually failed, is `Success`. **A fork
that never happened has nothing to report.** Now make it happen.

**3. TODO 1 — copy the desk.** Replace the placeholder so `child` holds
what `fork()` returns:

```c
pid_t child = fork();
```

`make` again; run it again. Expected — three lines now, and your pid
numbers will be your own:

```
pantograph: desk copied -- the copy is 4210, and it runs 'echo'
pantograph: copy 4210 finished -- exit status 0
pantograph: execvp: Success
```

Two processes are talking. The first two lines are the parent; the
third is **the copy**, which fell straight through the empty child
branch to the failure message below it and reported the same cheerful
non-error you saw a moment ago. There are two processes now, and
neither of them has run `echo`.

**4. TODO 2 — hand the copy its card.** In the child branch, add the
`execvp` call the comment describes:

```c
execvp(argv[1], &argv[1]);
```

`argv[1]` is the command name, looked up on `PATH` exactly as your
shell would look it up; `&argv[1]` is the argument list, starting with
that same name. **`execvp` does not return when it succeeds** — this
process stops being `pantograph` and becomes `echo`, same pid, new
program. That is why the `perror` line below it runs only on failure.

`make`, then:

```sh
./pantograph echo test
```

Expected — the copy runs `echo` at last, and note *where* its output
lands:

```
pantograph: desk copied -- the copy is 4231, and it runs 'echo'
pantograph: copy 4231 finished -- exit status 0
test
```

Read that order again. The parent announced the copy, declared it
*finished*, exited — and only then did `echo` print. Your prompt may
even come back before the word `test` does. Nobody is waiting for
anything; the parent is guessing. (Run it a few times. On most benches
the order comes out the same every time — the copy has to be scheduled
and then load a whole new program before it can say anything, so it
loses that race nearly always. But nothing *promises* you that order,
and that is the lesson: you are reading a race that happens to be
lopsided, not a rule.)

Now try a command that fails:

```sh
./pantograph false
```

Expected:

```
pantograph: desk copied -- the copy is 4237, and it runs 'false'
pantograph: copy 4237 finished -- exit status 0
```

`false` is a program whose entire purpose is to exit with status 1, and
your desk just reported 0 — because it never asked. Find the line just
above TODO 3 that reads `int status = 0;`. Nothing has changed it
since: the parent is reporting the number it started with and calling
it a result. Fix that.

**5. TODO 3 — collect the finished work.** In the parent, before the
`WIFEXITED` block:

```c
if (waitpid(child, &status, 0) < 0) {
    perror("pantograph: waitpid");
    return 1;
}
```

`waitpid` blocks until that child finishes and fills `status` with a
packed account of *how* it finished — which is why you unpack it with
`WIFEXITED` (did it exit normally?) and `WEXITSTATUS` (with what
number?) rather than printing `status` itself.

`make`, and prove both cases:

```sh
./pantograph echo test
./pantograph false
```

Expected:

```
pantograph: desk copied -- the copy is 4302, and it runs 'echo'
test
pantograph: copy 4302 finished -- exit status 0
pantograph: desk copied -- the copy is 4304, and it runs 'false'
pantograph: copy 4304 finished -- exit status 1
```

Try it on anything: `./pantograph ls -l /etc/hostname`,
`./pantograph sleep 3`, `./pantograph no-such-tool` (which reports
`execvp: No such file or directory` and exit status 127 — the same 127
your shell gives for a command it cannot find, and now you know where
that number comes from). You have written, in about a dozen lines, the
mechanism every shell in the world uses to run every command you have
ever typed.

**Now claim the seal.** From `labs/week-03` (that's `cd ..` if you're
still in `starter/`):

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-03/check'
  ~~~ WAX SEAL of the Guild: 1D6A8F30 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-03/check'
```

(The checker recompiles your `pantograph.c` with warnings promoted to
errors, runs it against `echo test`, and then against `false` — so a
desk that does not really wait cannot pass. The seal code is yours, not
this one.) Paste your seal under **Milestone 1** with one sentence per
TODO: what `fork` handed each process, what `execvp` replaced, and what
`waitpid` brought back.

> **If you're lost, start here (Task 1).**
> - Not sure how to open the file? `nano pantograph.c` works on every
>   bench (Ctrl-O saves, Ctrl-X exits). VS Code users: `code .` from
>   inside `starter/` — see `setup/getting-started.md`. Any editor is
>   fine; just save before you `make`.
> - `make: command not found`? You're not in your Linux shell — `wsl`
>   first, then Provisions P2.
> - The seal fails, but the forge said nothing — or said
>   `make: Nothing to be done for 'all'.`?
>   The check compiles with `-Werror`, which is stricter than the forge.
>   From `labs/week-03`, run this yourself and read the first message —
>   it is exactly what the seal saw:
>   `gcc -Wall -Wextra -Werror -g -o /tmp/pg starter/pantograph.c`
> - `make: *** check: No such file or directory`? You are not standing
>   in `labs/week-03` — most often you are still in `starter/`, but the
>   repo root gives the identical message. Run `pwd`; if it does not end
>   in `labs/week-03`, go there and run the line again.
> - `make: *** No rule to make target 'm1'`? You left out the
>   `-C check`. The whole line is `make -C check m1`, from
>   `labs/week-03`.
> - Ran it with `sudo` and got a seal that doesn't match a second run
>   without? Seals are keyed to the name you work under, so `sudo` mints
>   root's seal, not yours. Nothing this week needs `sudo`. Run it
>   plainly and paste that one.
> - `error: 'child' undeclared` after editing? You replaced the whole
>   `pid_t child = -1;` line instead of just the `-1`. Restore it with
>   `git checkout -- starter/pantograph.c` (from `labs/week-03`) and
>   start again — the file is a casting, not a treasure.
> - Output appears in a strange order (the copy's words before the
>   parent's)? Two processes are writing to one terminal; the parent's
>   `fflush(stdout)` keeps it tidy in the normal case, but ordering
>   between processes is never promised. Not a fault. (One thing to know
>   if you add your own `printf` while debugging: put a `\n` on the end.
>   Without one the line sits in a buffer, and a buffer still full when
>   `fork` copies the process gets copied too — which is how one
>   `printf` prints twice and costs somebody an evening.)
> - `./pantograph` with no arguments prints a usage line and exits 2 —
>   that's the casting, not a bug.
> - Seal fails on the `false` check? Your `waitpid` line is missing,
>   commented out, or placed *after* the `WIFEXITED` block.
> - `./pantograph echo test` prints `echo test` instead of `test`? You
>   handed `execvp` the whole of `argv` instead of `&argv[1]`, so `echo`
>   was told its own name was `./pantograph` and the word `echo` became
>   just another thing to print. The list must **start at the command
>   name**: `execvp(argv[1], &argv[1])`.
> - The `desk copied` line vanished, and you see `execvp: Success`
>   first? Your `execvp` is sitting *outside* the `if (child == 0)`
>   block, so the **parent** became `echo` and never lived to report
>   anything. It goes inside the braces, directly above the `perror`.

---

## Task 2 — The zombie safari *(~20 minutes → Seal M2)*

Your pantograph now collects its children. This task shows you what the
Overseer does when a parent *doesn't*.

When a process ends, it does not vanish. Its program is gone — memory
released, files closed — but the Overseer must keep the **entry**: the
pid and the exit status, because somebody is entitled to ask how it
went. The entry clears the moment the parent calls `wait`. Until then
the process is finished but not filed away, and `ps` marks it with the
state letter **`Z`**: a **zombie**.

`starter/zombie-maker.c` makes one on purpose. It is complete — read it,
don't repair it: the child finishes at once, and the parent sits for
two minutes before collecting.

**1. Read it, then run it in the background** (the `&` is the point —
it keeps your prompt free while the program waits):

```sh
cd starter
./zombie-maker &
```

Expected (pids yours):

```
[1] 4501
zombie-maker: I am 4501; my child was 4503 and has already finished.
zombie-maker: I shall not collect it for two minutes. Go and look.
```

**2. Go and look.** `ps -C <name>` selects processes by program name —
no `grep` needed:

```sh
ps -C zombie-maker -o pid,ppid,stat,cmd
```

Expected:

```
    PID    PPID STAT CMD
   4501    4478 S    ./zombie-maker
   4503    4501 Z    [zombie-maker] <defunct>
```

There it is. Read the second line across: pid `4503`, parent `4501`
(the program still sitting on its hands), state **`Z`**, and a command
column that `ps` prints in brackets with `<defunct>` after it — the
brackets mean *there is no command line left to print*. The program is
gone; only the entry remains. (If you launched with `&` as instructed,
your letters will read `S` and `Z` like mine. If you started it in the
foreground instead — or ran the task from a script rather than typing it
— you may see `S+` and `Z+`. The `+` only means the process belongs to
its own terminal's foreground group; it says nothing about zombiehood,
and it does not change with the terminal you look from.)

**3. Capture the sighting for the Chief.** From `starter/`, with the
zombie still standing:

```sh
ps -C zombie-maker -o pid,ppid,stat,cmd | tee ../check/zombie-sighting.txt
```

`tee` prints to your screen *and* writes the file — the seal check
reads `check/zombie-sighting.txt`, so it must contain a real `Z` line
from your own bench.

**4. Ask the Overseer directly.** Every process has a folder under
`/proc` named for its pid, and the zombie is no exception. Use the pid
from *your* `ps` output:

```sh
grep -E '^(Name|State|PPid)' /proc/4503/status
```

Expected:

```
Name:	zombie-maker
State:	Z (zombie)
PPid:	4501
```

The Overseer says it plainly. Look at one more thing:

```sh
wc -c < /proc/4503/cmdline
```

Expected: `0`. A living process's `cmdline` holds the words it was
started with; a zombie's is empty, because the program that owned those
words is already gone. **A zombie costs no memory and no processor
time. It costs one row in a finite table** — which is why ten thousand
of them is an outage and one of them is a lesson.

**5. Watch it clear.** Two ways, and both are worth seeing.

Either wait out the two minutes — the parent's `waitpid` fires and prints:

```
zombie-maker: collected 4503 at last (exit status 0). It is gone now.
```

— or hurry it along by killing the *parent* (use your parent's pid):

```sh
kill 4501
ps -C zombie-maker -o pid,ppid,stat,cmd
```

Expected: nothing but the header, or no output at all. Killing the
parent did not kill the zombie; it **orphaned** it, and an orphan is
adopted at once by the Overseer's household — which, unlike the sleeping
parent, always collects. Hold on to that word: *orphan*. Task 3 is
about one.

(And if you tried killing the zombie itself first — most people do —
nothing happened, and nothing ever will. `kill` delivers a signal to a
**running** program, and this one's program is already gone. There is
nobody home to receive it. You clear a zombie by making its parent
collect, or by taking the parent away.)

**6. File your answer.** Back up one floor first — `cd ..` if you are
still in `starter/` — then open `check/answers.txt` and fill in
**`A1:`** — the state letter you saw, and the name of the call a parent
must make to clear it. (One line; the template shows the shape.)

**Claim the seal.**

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-03/check'
  ~~~ WAX SEAL of the Guild: E5C204B7 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-03/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 2**
with two or three sentences: what the
`Z` line said, what `/proc/<pid>/status` added, and why your Task 1
pantograph never makes one.

> **If you're lost, start here (Task 2).**
> - `ps -C zombie-maker` shows nothing? Either the two minutes ran
>   out (the parent collected; just run `./zombie-maker &` again) or
>   the program isn't built — `make` in `starter/`.
> - You ran it *without* `&` and your prompt is stuck for a minute?
>   Press Ctrl-C, then run it again with the `&`. (Or open a second
>   terminal — an equally good habit.)
> - `ps: unknown option -C`? You're on a `ps` from another family
>   (rare here). Use `ps -eo pid,ppid,stat,cmd | grep zombie-maker`
>   instead and capture *that* into `check/zombie-sighting.txt`.
> - `cat /proc/<pid>/environ` **on a zombie you own** says `Permission
>   denied`? Correct and interesting: there is nothing left to read.
>   (If you meet the same refusal in Task 3, on a job that is still
>   running, that is a different fault with a different cure — see that
>   task's box.)
> - `m2` failed on the sighting? The file must hold a line with state
>   `Z` **and** the word `defunct` — capture it while the zombie is
>   still standing, not after the window has closed.
> - `[1]+ Done` appeared and you lost the pid? `ps -C zombie-maker`
>   after a fresh launch prints both pids again.

---

## Task 3 — The census of running looms *(~35 minutes → Seal M3)*

Now the floor itself. A census asks one question of every job: **who
started you?**

Everything below runs from `labs/week-03` (`cd ..` if you are still in
`starter/`), though the commands themselves work from anywhere.

**1. Take the muster roll of everything running under your name:**

```sh
echo $$
ps -u $(id -un) -o pid,ppid,stat,etime,cmd
```

`echo $$` prints your own shell's pid — memorize it for the next
minute. `ps -u <you>` lists every process the system is running on your
behalf; `etime` is how long each has been alive. Expected — yours will
have a few entries mine doesn't, but it will read like this:

```
    PID    PPID STAT     ELAPSED CMD
    342       1 Ss    1-10:18:09 /usr/lib/systemd/systemd --user
    343     342 S     1-10:18:09 (sd-pam)
  24864   24859 Ss         00:07 -bash
  24897   24859 S          00:06 /home/you/enginehouse/machinery/loom-tender
  24923   24864 R+         00:00 ps -u you -o pid,ppid,stat,etime,cmd
```

Read the **PPID** column, because that is the census. `ps` itself was
started by your shell (`24864` here) — so is everything else you run
today. And then there is `loom-tender`: running under your name, out of
your own bench folder, and its parent is **not your shell**. (Its
`ELAPSED` is however long ago you reported for duty — six seconds here,
half a week if you staged on Monday and censused on Thursday.)

**2. Find it properly and keep its pid to hand:**

```sh
tender=$(pgrep -x -u "$(id -un)" loom-tender)
echo $tender
```

`pgrep -x` finds processes whose name matches *exactly* — no `grep`
line cluttering the result — and `-u "$(id -un)"` keeps the search to
jobs running under **your own** name, so you get one pid and not a list.
From here on, `$tender` means "that pid".

**3. Draw its parentage.** `pstree -p -s <pid>` prints the chain of
ancestors from the top of the house down to one process:

```sh
pstree -p -s $tender
```

Expected (on a WSL2 bench; the middle of the chain differs per machine):

```
systemd(1)---init-systemd(Ub(2)---SessionLeader(24858)---Relay(24864)(24859)---loom-tender(24897)
```

One reading note: `pstree` prints each process as `name(pid)`, and
WSL's relay processes have parentheses in their *names* — so
`Relay(24864)(24859)` is a process **named** `Relay(24864)` whose
**pid** is `24859`. The pid is always the last parenthesis.

And the number *inside* the name is a shell's pid — WSL names each relay
after the shell it relays for. So a relay named `Relay(24864)` is **not**
your shell; it is the plumbing that carried one. If you run `echo $$` and
see your own shell's pid staring back at you from inside an ancestor's
*name*, nothing is wrong and nothing is shared: compare the **pid**
column, never the name. (Plain `ps -o comm` prints only the name, with no
last-parenthesis rule to save you — so on that command especially, read
the `PID` column.)

Compare it with the chain for something you started yourself:

```sh
pstree -p -s $$
```

Expected:

```
systemd(1)---init-systemd(Ub(2)---SessionLeader(24858)---Relay(24864)(24859)---bash(24864)---pstree(24926)
```

The two chains are the same until the final step — and that final step
is everything. Yours passes through **your shell** (`bash(24864)`),
because your shell starts what you run. **The tender's chain contains
no shell at all**: it hangs directly off the system's own plumbing, the
same place a job lands when the process that started it has *exited*.

And if you notice that both chains pass through the *same* relay — good
eye, and it is not a contradiction. It makes the tender your shell's
**sibling**, not its descendant: two children of the same piece of
plumbing, which is a very different thing from one starting the other.
Your shell did not start it. Nothing you started did.

**4. Climb the ancestry by hand**, because a census wants numbers, not
an impression. Start from the tender's own card:

```sh
grep -E '^(Name|State|PPid)' /proc/$tender/status
```

Expected:

```
Name:	loom-tender
State:	S (sleeping)
PPid:	24859
```

Now climb, one rung per command: look up that `PPid`, read the parent's
own `PPID` off the result, and **repeat with each new number until the
answer is `1`.** On my bench the climb ran (yours will have different
numbers, and very possibly fewer rungs):

```sh
ps -o pid,ppid,comm -p 24859
```
```
    PID    PPID COMMAND
  24859   24858 Relay(24864)
```
```sh
ps -o pid,ppid,comm -p 24858
```
```
    PID    PPID COMMAND
  24858       2 SessionLeader
```
```sh
ps -o pid,ppid,comm -p 2
```
```
    PID    PPID COMMAND
      2       1 init-systemd(Ub
```
```sh
ps -o pid,ppid,comm -p 1
```
```
    PID    PPID COMMAND
      1       0 systemd
```

Three rungs, and look at what they are: a relay, a session-keeper, the
subsystem's own init — system plumbing, every one, **and not a shell
among them**. The top is PID 1. **How many rungs you climb depends on
your bench**: WSL2 benches take between one and three depending on how
the session was opened; in a container or on plain Linux the very first
look usually reads `PPid: 1` and there is no climb at all. Both are
correct censuses of different floors — record what *your* bench says
(A3 wants the tender's own `PPid` number, wherever the climb goes from
there).

**PID 1 is the first process the kernel starts and the last one
standing** — the Overseer's own household. When a process's parent
exits, the kernel hands the orphan upward to be looked after, and the
top of that ladder is always PID 1: that is precisely what has happened
here. Whoever started this job **exited on purpose, immediately**,
leaving the tender to be adopted. However many rungs your own climb
took, the reading at the top is the same, and it is the only reading
available:

> **This job's parent is gone, and nothing that any person at this
> bench started is anywhere in its ancestry.**

**5. The Card-Room Drill.** Three files, one habit. Keep this
box — you will run this drill again in Weeks 6 and 10, on other
mysteries.

> **THE CARD-ROOM DRILL** — reading the Overseer's card on a
> living process. `/proc/<pid>/` is not a folder on any disk; it is the
> kernel answering questions in the shape of files.
>
> ```sh
> tr '\0' ' ' < /proc/$tender/cmdline; echo      # 1. what it was started as
> grep -E '^(Name|State|PPid)' /proc/$tender/status   # 2. who and what it is
> tr '\0' '\n' < /proc/$tender/environ           # 3. what it was handed
> ```
>
> **Why `tr`?** `cmdline` and `environ` separate their entries with the
> **NUL byte** (`\0`), not with newlines — a NUL can never appear inside
> a filename or a variable, so it is the one safe separator. Your
> terminal prints NUL as nothing at all, which is why `cat environ`
> looks like one long run-together word, or like an empty file. `tr`
> translates each NUL into a space (for the command line) or a newline
> (for the environment) and the record becomes readable. **The file was
> never empty. You were reading it wrong.**

Run the drill on the tender now. Steps 1 and 2 you have; expected:

```
/home/you/enginehouse/machinery/loom-tender
```

```
Name:	loom-tender
State:	S (sleeping)
PPid:	24859
```

And then step 3 — the environment the job was handed when it started:

```sh
tr '\0' '\n' < /proc/$tender/environ
```

Expected — **four lines**, of which this work order prints three:

```
HOME=/home/you
PATH=/usr/bin:/bin
PWD=/home/you
PATRON=[ your bench prints a value here ]
```

The fourth line is the one I will not copy into a work order. Read it
off your own bench.

Then read it again, and ask the question an enginewright asks: your
shell has an environment too, twenty-odd entries of it. Does *it* carry
that line?

```sh
printenv PATRON
echo $?
```

Expected: no output, and `1` — meaning "no such entry". Nothing in your
session set that variable. Nothing in this repository sets it in your
shell. It was put into that job's hands by whoever started it, and
whoever started it exited before you arrived.

**6. Read what it is producing.** The job's work is piling up in the
spool — but read it the way a clerk reads a ledger, from the top. A
clerk rules and *heads* a page before entering a single figure:

```sh
head -1 ~/enginehouse/spool/loom-tender/tables.out
```

Expected:

```
TABLE OF PRODUCTS -- computed by hand, entered fair, in ink
```

Read that heading twice, and copy it into your case notes exactly. The
heading is the tell: looms do not head their pages, and looms do not
rule them. Somebody opened this page the way a person was taught to open
one.

Now the first three entries the tender ever made:

```sh
head -4 ~/enginehouse/spool/loom-tender/tables.out
```

Expected — the heading again, then:

```
    17 x   28 =       476   checked by casting out nines -- agrees
    24 x   35 =       840   checked by casting out nines -- agrees
    31 x   42 =      1302   checked by casting out nines -- agrees
```

(If you staged this bench for the first time only moments ago — or
re-staged it after a `--reset` — the third row may still be a few
seconds out. Wait for it: the tender rules one line every five seconds,
and it has never once skipped.)

And only now, what has been entered *since*:

```sh
tail -3 ~/enginehouse/spool/loom-tender/tables.out
```

Expected — the same shape, much further down the page. **Yours will
differ**; these are the rows about half an hour in:

```
  2698 x   39 =    105222   checked by casting out nines -- agrees
  2705 x   46 =    124430   checked by casting out nines -- agrees
  2712 x   53 =    143736   checked by casting out nines -- agrees
```

Wait six seconds and run it again: a new line each time, five seconds
apart. (Your serials will be larger than the first three you just read —
the spool has been ruling a line every five seconds since you reported
for duty, and it is never truncated. The shape of the line, not the
numbers, is what should match.)

(`tail -f ~/enginehouse/spool/loom-tender/tables.out` watches them
arrive live; `Ctrl-C` when you have seen enough.) Check one of the
products by hand, and check the check: "casting out nines" is a clerk's
verification, taught in the Computing Room, older than this building.
Every line is correct. Every line is *ruled*, and headed, and entered
fair. This is not what a loom's output looks like. It is what a
**person's** output looks like — made by a process with no parent, at
five-second intervals, all night.

**7. File the census.** Open `check/answers.txt`:

- **`A2:`** — the patron line, copied exactly as your `environ` gave it.
- **`A3:`** — the number on the `PPid` line of `/proc/$tender/status`.

**Claim the seal.** From `labs/week-03`:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-03/check'
  ~~~ WAX SEAL of the Guild: 93B7D51E ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-03/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 3**
with three or four sentences: how you found the job, what its parentage
says, and what the drill turned up.

> **If you're lost, start here (Task 3).**
> - `$tender` is empty **in a terminal you just opened**? A shell
>   variable does not survive a new terminal, but the job does. Re-run
>   `tender=$(pgrep -x -u "$(id -un)" loom-tender)` in this terminal
>   first. (`pstree -p -s $tender` printing the *whole machine* is the
>   same fault in a different hat: with `$tender` empty the command
>   collapses to a plain `pstree -p`, and a path like `/proc//status`
>   with two slashes is the same thing again.)
> - `pgrep` itself prints nothing? *Now* the job really is gone: you
>   rebooted, shut the environment down, or ran `--reset`. `bash
>   report-for-duty.sh` from `labs/week-03` brings it back (and the pid
>   will be a new one — note the new number).
> - `cat /proc/<pid>/environ` prints a run-together jumble, or looks
>   empty? That is the NUL-separated format doing exactly what the
>   drill's box warns about. Use the `tr '\0' '\n'` form.
> - `environ` says `Permission denied`, but `status` and `cmdline` read
>   perfectly well? The job is running under **another user** — almost
>   always because it was staged with `sudo`. Check with `ps -o user= -p
>   $tender`; if it says `root`, that is the whole story. A card is the
>   owner's to read. Strike the bench and stage it as yourself: `sudo
>   bash report-for-duty.sh --reset`, then `bash report-for-duty.sh`
>   with no `sudo`. The pid will be a new one, so re-read A3.
>   **Nothing in this house needs `sudo` this week.**
> - `bash: /proc/24897/environ: No such file or directory`? The pid
>   moved on — re-run `tender=$(pgrep -x -u "$(id -un)" loom-tender)`.
> - `pstree: command not found`? It lives in the `psmisc` package — see
>   the **"A tool is missing"** bullet in Provisions for the one-line
>   fix. You do not have to stop and wait for it, though:
>   `ps -eo pid,ppid,cmd --forest` draws the same tree, and Appendix IV
>   of Monday's deck has that form on a card.
> - Your `PPid` reads `1` with no relay in between? Perfectly correct —
>   see the container box below. Record the `1`.
> - `m3` failed? A2 must contain the patron line as printed (copy and
>   paste it, don't retype from memory), and A3 must be the number
>   itself, not a sentence about it.
> - The job's pid changed halfway through your work? You restaged.
>   Nothing is wrong; just re-run the drill and use the new number in
>   A3.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 3 row the usual way:
short — what you found, the command that showed it to you, what you make
of it. A table row is a table row.

Then, because this week the notebook earns its keep, take **a full
paragraph underneath, in the "Current suspicions" section**, and copy
the exact strings there where there is room for them: the patron line,
the pid, the `PPid`, and the first line of the spool.

Two questions to write toward, neither of which has an answer in this
work order:

1. **A card was run with no clerk at the desk.** What does it take to
   arrange that on purpose — and what did the person who arranged it
   have to do, deliberately, to make the parentage read the way it
   does?
2. **Every job in this house names its patron** — old Computing Room
   practice, according to the oldest porter on the floor. So who is the
   patron on that job card?

Nobody is expected to have this solved in September. Write down what
you actually suspect, say plainly which part you are unsure of, and
leave it there — the notebook is marked on being kept honestly, never
on being right early. Copy the strings exactly and you will thank
yourself in November.

Nothing is due on that question this week, and no seal turns on it. Put
your answer, your best guess, or your honest *"no idea yet"* in the case
notes, and let the term do the rest.

> **Entered in the case book, Friday evening, with the cohort's censuses
> in hand:**
>
> The Overseer has adopted somebody's orphan.
>
> A job with no submitter, no line on any roster, and no parent left
> alive to be asked — and yet it names its patron, the way every job in
> this house has named its patron since before we had figure wheels.
> Forty benches read that name off their own screens this afternoon. It
> is not written in this order, and it will not be.
>
> So. Who is it?
>
> — *B. Marlowe, Chief Enginewright*

## Reflection (both prompts go in your logbook)

This is where the week's mechanics turn into judgment, so answer in
your own words rather than the manual's. Rough and honest reads better
here than polished and borrowed.

1. `fork()` copies a process; `execvp()` replaces the program inside
   one. Most languages you have used offer a single "run this command"
   call instead. In a paragraph: what does splitting the job into two
   steps let a shell do between them that a single call would not? (You
   built the seam yourself in Task 1 — everything your shell does with
   redirection and pipes happens *in that gap*.) *zyBooks 2.3–2.4.*
2. A **zombie** has finished but has not been collected; an **orphan**
   is still running but its parent is gone. You met one of each this
   week. In two or three sentences: which resources does each one hold,
   who is responsible for clearing each, and why is the zombie the one
   that can bring a machine down?

## Turn it in

Due **Sunday, September 6, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)):

1. **`logbook.md`** — all three milestones: what you did, the seal
   pasted in, what it means; the three-TODO narrative (M1); the zombie
   sighting (M2); the census and the drill (M3); plus both reflection
   prompts and the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 3 entry.

Upload both files to the Week 3 assignment. (`check/answers.txt` and
`check/zombie-sighting.txt` stay in your repo — the seals already vouch
for them; the prose in your logbook is what's graded.)

That closes all four objectives: Task 1 is objectives 1 and 2, Task 2
is objective 4, Task 3 is objective 3, and the reflections are all four
in your own words.

**Also on this week's docket:** zyBooks **Ch 2 (finish)** is due
**Wednesday** before class. And **Commission I — *The Census of the
Enginehouse*** (zyBooks 12.1, "Mr. Kureos") is due **Friday,
September 18** — eighteen days out, and the sort of thing that is
pleasant in September and grim in the small hours of the 18th.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: THREE. ADMIRED.`
> `JOBS WITHOUT PAPERWORK: DISAPPROVED OF.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Nothing below is required and nothing below is graded. It is here
because most of what I know about this subject came from things nobody
assigned me. Pull one thread that interests you and let the rest wait.

- **A warning before you improvise.** `fork()` inside a loop, or a
  `fork` whose child does not `exit`, makes processes faster than you
  can count them and will wedge your Linux environment. If a terminal
  goes unresponsive after an experiment, close it, open a new one, and
  run `pkill -u $(id -un) -x <yourprogram>`. If that will not take,
  `wsl --shutdown` from PowerShell (or stopping your VM) always works —
  you lose nothing but the loom-tender, and `report-for-duty.sh` puts it
  back.

- **The fragment in your inbox.** Week 1 left an unstamped punched card
  at `~/enginehouse/inbox/punch-card-fragment.txt` and said an
  apprentice with a pencil needn't wait. Here is the scheme the looms
  use, and no more than the scheme. A card is read **by column**, left
  to right; a column with no holes is a blank space; and the **number of
  holes punched in a column** is the character, counting `A`=1 through
  `Z`=26. Figures are punched the same way and are told apart only by
  sense — the card does not mark which is which, so you will have to
  decide what reads like a word and what reads like a year. Count by
  eye with `cat`, or make the shell count for you:

  ```sh
  CARD=~/enginehouse/inbox/punch-card-fragment.txt
  for c in $(seq 1 20); do
    printf 'column %2d: %s holes\n' "$c" "$(cut -c$c "$CARD" | grep -c O)"
  done
  ```

  `cut -c$c` slices one column out of every row; `grep -c O` counts the
  rows that had a hole there. (Card not there? `bash
  ../week-01/report-for-duty.sh` puts Week 1's inbox back.) Decode it
  yourself and put it in your case notes — no seal, no points, and
  nobody will confirm it for you.
- `man 2 fork`, `man 2 execve`, `man 2 wait` — the pages for the three
  calls you used. The `wait` page's macro list (`WIFEXITED` and
  friends) is the definitive account of what is packed into `status`.
  (`No manual entry for fork in section 2`? The section-2 pages are a
  separate package and your bench is missing it — the **"A tool is
  missing"** bullet up in Provisions installs it in one line. It is
  worth doing: these are the pages the rest of the course leans on.)
- `man 5 proc` — the manual for the whole `/proc` filesystem, and one
  of the longest pages on the system. Skim the `/proc/[pid]/` section
  and see how much of a process is legible: `fd/`, `maps`, `limits`,
  `stat`. Weeks 6, 9 and 10 all come back here.
- `cat /proc/self/status` — every process can read its own card, and
  `self` is the shortcut. Run it twice and watch the pid change: `cat`
  is a new process each time.
- `ps -eo pid,ppid,cmd --forest` — the whole house as a tree, in `ps`'s
  own hand. Or `pstree -p | less` and go looking for the oldest
  processes on the machine.
- `strace -f ./pantograph echo test` — Week 2's oath-taker, with `-f`
  to follow the child too. You can watch `clone` (which is what `fork`
  becomes underneath), then `execve`, then `wait4`, in that order. Best
  of all, you can watch `execvp` **search `PATH` one folder at a time**:
  `/usr/local/sbin/echo` → `ENOENT`, `/usr/local/bin/echo` → `ENOENT`,
  and so on until one works. That is the whole of "command not found",
  in the record, with no mystery left in it.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
