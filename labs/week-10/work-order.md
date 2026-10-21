# WORK ORDER No. 1851-10 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 19 October 1851 — seven weeks to the Exhibition |
| **Due** | **Sunday, October 25, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

Every Engine keeps a Store, and every program believes the Store is its
own and endless. Both beliefs are false, and this week you learn exactly
how false, and how the Engine keeps the lie running so smoothly that no
program ever notices.

A program's addresses are not places in real memory. They are promises.
The Engine keeps a translation table and hands out real pages only as a
program actually reaches for them — so a program may hold a Store of a
thousand pages and have almost nothing real behind it until the moment it
touches a page, and then only that page. When the real pages run out, the
Overseer evicts somebody. You will watch all of this on your own bench,
with your own two programs, in the open.

Then there is the keeper. Something stands on your bench that **no
schedule owns** and that is **not yours**: a process called
`record-keeper`, running under another account entirely. You can see that
it is there, and who owns it, from your own screen. You cannot read its
Store — the Engine walls one account's memory off from another, and the
keeper has walled off a room of its own besides. To look inside you will
need the house keys, and a warrant that says exactly what they open and
what they do not.

Inside is a record. Copy what it says — every word of it — and draw no
conclusion. That is the Guild's work: read the record exactly, and let it
be a record. Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

A running program's memory is not one flat thing and it is not all real.
This week is about the difference between the memory a program *has* and
the memory it is actually *using*, how the Engine keeps that difference
cheap, what you can read about any process's memory from the outside, and
what happens when the real memory runs short.

The fiction is set dressing and the commands are the course; **no task
here requires story knowledge.** By the time you hand this in you will be
able to:

1. **Read and explain a process's address space.** The regions a program
   keeps its belongings in, the columns that describe each one (its range,
   its read/write/execute permissions, its backing), and the difference
   between the Store a process holds (`VmSize`) and the part that is really
   resident (`VmRSS`), read off a real process with `/proc/<pid>/maps`,
   `pmap`, and `/proc/<pid>/status`. *zyBooks Ch 7.*
2. **Demonstrate demand paging and the page fault.** Map a large region
   that costs almost nothing, touch it a page at a time, and watch the
   Engine fill each page on first touch (one **minor** page fault) and do
   nothing at all on the second. *zyBooks Ch 7.*
3. **Show what a memory limit does when a program asks for more than the
   Store holds.** Run a program that never stops asking, under a memory
   governor, and watch the Overseer evict it — the **OOM kill** — and read
   the verdict it files. *zyBooks Ch 7.*
4. **Recover a region from a running process you are authorised to
   inspect.** Find a walled-off room in another account's process by its
   shape, dump it with a debugger under the house keys, and read what it
   held. *zyBooks Ch 7.*

Objective 1 is the one the Guild examines hardest. A map you can read is a
process you can account for.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `gcc` and `make`, **`gdb`** (Week 7),
and **`sudo`** — for the first and only time in this course you will look
inside a process that is not yours, and that needs the house keys. The OOM
demonstration (Task 2) uses `systemd-run --user`, which you met as a
governor in Week 4. If your environment broke,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds it.

**P2 — This folder, open in a Linux terminal.** Run the line that matches
your setup:

```sh
cd ~/comp3100-student/labs/week-10
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-10
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-10
```

**P3 — Report for duty.** One command stages this week's bench: it builds
and launches the keeper, as the account that owns it, and leaves it
standing. It asks for the house keys **once** — it says so, and says what
for, before it asks — and does nothing else with them. Run it now, on
Wednesday:

```sh
bash report-for-duty.sh
```

It will ask for your password once (the staging needs root to launch the
keeper under its own account). When it finishes you will see a duty slip:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-10 :: bench staged and verified
  ------------------------------------------------------------------
   Survey:   ~/enginehouse/survey/record-keeper   (at work now)
             ~/enginehouse/survey/.record-keeper.pid
             ~/enginehouse/survey/survey.gdb

   Something stands on this bench that no schedule owns, and it is
   not yours: the roll owns it. You can see THAT it is there, and
   who owns it, from your own screen -- but its Store is walled off
   to you, and only the house keys will open it. The work order
   shows you where the key turns.
   ...
  ------------------------------------------------------------------
```

The keeper is a **living process, not a file**: it does not survive
`wsl --shutdown` or a reboot. If it is gone when you come back, run
`bash report-for-duty.sh` again to stage it afresh. When your paperwork is
in, `bash report-for-duty.sh --reset` stands it down and sweeps the survey.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds eight short
answers — A1 to A8 — that the seal checks read; the template says what goes
where, and each task tells you when. Your running `case-notes.md` is
already at the repo root.

**A note on this week's shape.** Three sessions: **Monday's deck**, then
**Wednesday's and Friday's studios**, no break. Four tasks, four seals,
about an hour and three-quarters at the terminal. Tasks 1 and 2 are your
own programs, in the open; Tasks 3 and 4 are the keeper, and need the house
keys. Claim each seal as soon as its task is done.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-10`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `cd: ... No such file or directory` for `labs/week-10`? Your copy of
>   the repo predates this week. From the repo root: `git pull`.
> - `$'\r': command not found`, or a `syntax error near unexpected token`?
>   The file picked up Windows line endings on the way down. From the repo
>   root: `git checkout -- .` and try again.
> - `report-for-duty: run this as YOURSELF, not as root.`? You typed `sudo`
>   in front of it. The script asks for the keys itself, once, when it needs
>   them; run it again without `sudo`.
> - `report-for-duty: gcc not found` (or `gdb is not on this bench`)? Your
>   bench has lost a tool. Run the *"a tool is missing"* fix in
>   `setup/getting-started.md` (Troubleshooting), then run the script again.
> - The script says it cannot get root? Take it to your instructor rather
>   than working around it; the bench is left exactly as it was found.
> - You ran `--reset` and want the bench back? Run
>   `bash report-for-duty.sh` again.

---

## Task 1 — Your own Store, in the open *(~30 minutes → Seal M1)*

Before you look inside anyone else's Store, read your own. A running
program keeps its belongings in a handful of **regions**, and the kernel
will show you every one of them for any process — starting with the one you
are typing into right now, your shell.

**1. Read your shell's own map.** `$$` is your shell's own process id, so
this asks the kernel to describe your shell's address space:

```sh
cat /proc/$$/maps
```

Expected — a page or two of lines, each one a **region**. Every address is
different on every bench and every run; yours will not match these, and
that is the point. The **shape** is what to read:

```
…-… r-xp … /usr/bin/bash          the program's code (execute)
…-… r--p … /usr/bin/bash          constants (read only)
…-… rw-p … /usr/bin/bash          its initialised globals (read/write)
…-… rw-p 00000000 00:00 0  [heap]  memory asked for while running
…-… rw-p 00000000 00:00 0          an anonymous region (no file behind it)
…-… rw-p 00000000 00:00 0  [stack] the call stack
```

(The notes on the right are this work order's, not the kernel's; your
screen shows only the columns. The map prints its addresses in hexadecimal
**without** a `0x` in front.)

Read the **columns**, left to right: the **address range**; the
**permissions** — four characters, `r` `w` `x` and then `p` for private
(a dash means the flag is off); the file **offset**; the device and inode;
and the **backing** — a file path, a bracketed name like `[heap]` or
`[stack]`, or nothing at all. A region with **no file and no bracket** is
**anonymous**: memory with nothing on disk behind it. The second column —
the `rwxp` one — is the one that says what you may do with each region, and
it is the column this week turns on.

Now the same thing, summed up, with `pmap`:

```sh
pmap $$
```

`pmap` reads the very same regions and totals them. In your logbook, name
the kinds of region you can see — at least **text** (the `r-xp` code),
**heap**, **stack**, and an **anonymous** `rw-p` region with no name — and
say which column carries the read/write/execute flags.

**2. Held, versus resident.** Two numbers in a process's `status` tell the
whole paging story in one line each:

```sh
grep -E '^(VmSize|VmRSS):' /proc/$$/status
```

Expected — two lines of this shape. The figures depend on your bench, your
shell and what it has done so far, so yours will differ; what holds
everywhere is that `VmSize` is the larger:

```
VmSize:	    … kB
VmRSS:	    … kB
```

`VmSize` is the Store the process **holds** — every region added up.
`VmRSS` is the part that is actually **resident** in real memory right now.
`VmSize` is almost always the larger: the rest is promises not yet kept.
Write both down, and one sentence on what the gap between them is.

**3. Watch the promise get kept.** The starter folder has a small program
that shows demand paging directly. Build it and run it. From `labs/week-10`:

```sh
cd starter
make
./storeroom
```

Expected — the first three figures vary a little from bench to bench and
run to run; the **shape** is fixed:

```
storeroom: 256 pages (1024 KiB) requisitioned, nothing shelved yet.
  resident now: 1476 KiB
first round -- one item onto each of the 256 shelves:
  minor page faults: +266
  resident now:      +1156 KiB
second round -- over the same 256 shelves again:
  minor page faults: +0
  resident now:      +0 KiB
```

`storeroom` asks the Engine for 256 pages and touches nothing: the request
is nearly free. Then it puts one item on each of the 256 pages. The
**first** touch of each page is a **minor page fault** — the Engine fills
the page in and the resident size climbs — so the first round costs roughly
one fault per page (about 256; a few more for the program's own
housekeeping). The resident size climbs with it: about one page (4 KiB)
per shelf, 1024 KiB in all, plus a little of the program's own bookkeeping
— so the figure on your screen will be near 1156 KiB, and varies a little.
The **second** round touches the very same pages, finds them already there,
and faults **zero** times, and the resident size does not move. Run it
twice; the first-round figures wobble by a handful, the second-round ones
are always zero.

**4. File what you found.** Open `check/answers.txt`:

- **`A1:`** — the kinds of region your map shows (at least **heap**,
  **stack** and **anonymous**), and which column carries the
  read/write/execute flags (name it, e.g. *the permissions column, `rw-p`*).
- **`A2:`** — the two fault deltas from `storeroom`, in order: the
  **first-round** minor faults, then the **second-round** minor faults.
  Two numbers.

**Checkpoint.** Before the seal, you should be able to say, without
looking: what an anonymous region is, which column shows read/write/execute,
the difference between `VmSize` and `VmRSS`, and why the second round of
`storeroom` faulted zero times.

**5. Claim the seal** — from `labs/week-10` (you are in `starter/`, so go
up one first):

```sh
cd ..
make -C check m1
```

Expected:

```
  ~~~ WAX SEAL of the Guild: 971F… ~~~
  (Paste this seal into your logbook under Milestone 1.)
```

(The seal code is yours, not this one.) Paste it under **Milestone 1** with
your map's regions named, the `VmSize`/`VmRSS` gap in your own words, and
both runs of `storeroom`.

> **If you're lost, start here (Task 1).**
> - `make: Nothing to be done for 'all'.`? Both programs are already built.
>   Carry on with `./storeroom`.
> - `bash: ./storeroom: No such file or directory`? You are not in
>   `starter/`, or `make` has not run. From `labs/week-10`: `cd starter &&
>   make`.
> - `cat /proc/$$/maps` printed nothing, or `$$` came out literally? Your
>   shell is not bash. Type `bash`, press Enter, and try again.
> - Seal says A1 does not name the regions? It wants at least **heap**,
>   **stack** and **anonymous** by name, and the permissions column. Lower
>   case is fine.
> - Seal says A2's second number is not zero? The **second** round must
>   fault zero times. If yours did not, you ran `storeroom` once and copied
>   the first round twice; run it again and read both rounds of one run.
> - `storeroom`'s first-round count is not exactly 256? Expected — it is
>   roughly one per page plus a little housekeeping, and it wobbles run to
>   run. The seal only asks that it is not zero.

---

## Task 2 — When the Store runs short *(~25 minutes → Seal M2)*

The Store is finite. A program that keeps asking will, in the end, ask for
more than there is — and then something has to give. On a shared machine
the Engine would start evicting pages to swap and, if that is not enough,
the **Overseer** (the OOM killer) picks a process and ends it. You will
make that happen on purpose, safely, inside a **memory governor** — Week 4's
`systemd-run --user --scope`, now metering the Store instead of the engine.

**1. The glutton, ungoverned.** Task 1's `make` already built it. It asks
for 16 MiB at a time, a fifth of a second apart, and — so that it cannot
take your whole bench — it stops of its own accord at 512 MiB. Run it on its
own, from `labs/week-10`:

```sh
./starter/glutton
```

Expected — about seven seconds of climbing, then it stops itself:

```
taken: 16 MiB
taken: 32 MiB
taken: 48 MiB
…
taken: 512 MiB
glutton: stopped at its own cap, 512 MiB. Nobody stopped it.
```

Nobody did: with no governor, your bench simply handed over half a
gigabyte. A real program with no cap of its own would have kept going.
(If you are impatient, **Ctrl-C** stops it at any point.)

**2. The governor.** Now run the same glutton in a **scope** with a hard
memory ceiling. Both flags matter:

```sh
systemd-run --user --scope -p MemoryMax=64M -p MemorySwapMax=0 ./starter/glutton
```

- `MemoryMax=64M` caps the scope at 64 MiB of real memory.
- `MemorySwapMax=0` forbids it swap. **Without this flag the demo does not
  fire** on a bench that has swap (WSL ships several gigabytes of it): the
  glutton would be paged out to swap and run on. Zero swap forces the
  question the moment the glutton crosses 64 MiB.

Expected — it climbs to the ceiling and the Overseer ends it:

```
Running as unit: run-….scope; invocation ID: …
taken: 16 MiB
taken: 32 MiB
taken: 48 MiB
Killed
```

```sh
echo $?
```

Expected:

```
137
```

**137** is how a shell reports a process killed by signal 9 (128 + 9): the
Overseer did not ask the glutton to stop, it stopped it. The unit name and
invocation id are different every run.

**3. Read the verdict.** The Overseer files what it did in the journal:

```sh
journalctl --user -n 20 --no-pager | grep -i oom
```

Expected — the wording is stable; the timestamps, host and unit id vary:

```
… run-….scope: A process of this unit has been killed by the OOM killer.
… run-….scope: Failed with result 'oom-kill'.
```

Copy the `Failed with result 'oom-kill'` line, and note the limit that
provoked it (**64 MiB**).

> **No systemd `--user` on your bench? (the fallback.)** Some minimal VMs
> and hand-built installs have no user systemd, and `systemd-run --user`
> will say `Failed to connect to bus` or `command not found`. You cannot
> fire the governor there. Instead, read the demonstration on **Monday's
> deck** (the same glutton, the same `MemoryMax=64M -p MemorySwapMax=0`).
> Copy the deck's verdict line, `Failed with result 'oom-kill'`, **and** the
> 64 MiB limit into `A3`, in place of your own journal line, and note in
> your logbook that `MemorySwapMax=0` is required and why. The ungoverned
> run in step 1 still works on every bench; do that part either way.

**4. File what you found.** In `check/answers.txt`:

- **`A3:`** — the Overseer's verdict (the `oom-kill` result) **and** the
  limit that provoked it (the `MemoryMax` figure). One line, e.g.
  *Failed with result 'oom-kill'; MemoryMax=64M*.

**Checkpoint.** You should be able to say why `MemorySwapMax=0` is needed,
what exit status 137 means, and the difference between the governor capping
memory here and capping CPU in Week 4.

**5. Claim the seal** — from `labs/week-10`:

```sh
make -C check m2
```

Paste the seal under **Milestone 2** with the governed run, the exit
status, and the verdict line.

> **If you're lost, start here (Task 2).**
> - The glutton reached its own 512 MiB cap under the governor, with no
>   kill? You left out `-p MemorySwapMax=0`. Add it; a bench with swap
>   needs it.
> - `Failed to connect to bus`, or `systemd-run: command not found`? Your
>   bench has no user systemd — use the **fallback** box above.
> - `echo $?` printed `0`, not `137`? You read the status of a later command,
>   not the glutton's. Run the governed line again and `echo $?`
>   immediately, nothing in between.
> - `journalctl: command not found` or an empty journal? Read the verdict
>   from the governed run's own last line (`Killed`) and the deck; the
>   `oom-kill` wording is on the slide.
> - Seal says A3 has no limit? Put the `MemoryMax` figure (64) on the line
>   with the verdict.

---

## Task 3 — The keeper no schedule owns *(~30 minutes → Seal M3)*

Now the process that is not yours. It runs under another account, and the
Engine walls one account's Store off from another: you can learn a great
deal about it from the outside and read nothing of its memory — until you
produce the house keys. This task finds it, confirms you are locked out,
and then surveys it **with a warrant**.

> **THE WARRANT — this task uses `sudo`.**
> *What it does:* `sudo cat /proc/<pid>/maps` and `sudo pmap` (and, in Task
> 4, `sudo gdb -p`) read another account's process. Root is needed for two
> reasons at once: the process belongs to **another user**, and the kernel
> setting `kernel.yama.ptrace_scope` (1 by default on Ubuntu/WSL) lets a
> debugger attach only to processes it started itself. Root is above both.
> *Why it is safe:* reading `maps`, `pmap`, and a `dump memory` **read** the
> process; they do not stop it, change it, or write to it. The keeper keeps
> running, untouched, after you detach — Task 4 has you confirm it.
> *How to leave cleanly:* the dump in Task 4 runs in **batch** mode and
> detaches itself the instant it is done. If you ever open `gdb` on the
> keeper by hand, leave with `detach` then `quit` (or just `quit`, and
> answer `y`). Detaching leaves the keeper exactly as you found it.
> *The debuginfod prompt:* the staged `survey.gdb` turns off gdb's offline
> symbol fetch, so no prompt appears. If one ever does
> (`Enable debuginfod for this session? (y or [n])`), press **Enter** — the
> default, *n*, is right.

**1. Find it, and read its card — the Card-Room Drill.** You met this drill
in Week 3, on a process you owned, and were promised it would return. Here
it is, on a process you do not own. First, find the keeper and remember its
pid (yours will differ; it changes every staging, so never write it down as
a fixed number):

```sh
PID=$(pgrep -x record-keeper)
echo "$PID"
```

Then read who and what it is:

```sh
ps -o pid,user,comm -p "$PID"
```

Expected — the owner is **not you**:

```
    PID USER     COMMAND
    …   computa+ record-keeper
```

The `USER` column is eight characters wide and the owner's name is longer,
so `ps` prints it truncated with a `+`. Now the drill proper, reading the
kernel's own card on the process:

```sh
tr '\0' ' ' < /proc/$PID/cmdline; echo      # 1. what it was started as
grep -E '^(Name|Uid|PPid|VmSize|VmRSS):' /proc/$PID/status   # 2. who and what it is
tr '\0' '\n' < /proc/$PID/environ           # 3. what it was handed
```

Steps 1 and 2 answer:

```
/home/…/enginehouse/survey/record-keeper
Name:	record-keeper
Uid:	1849	1849	1849	1849
PPid:	…
VmSize:	    3580 kB
VmRSS:	     288 kB
```

Your `VmSize` and `VmRSS` figures will differ a little from these: they
depend on your bench's C library and kernel. What every bench shows is the
gap between them.

`PPid` is the keeper's parent: the top of the chain on your bench (PID 1 on
most benches), not anything you or a schedule started — which is what "no
schedule owns it" means. Do not expect a particular number there.

Two things to write down. The **owner's uid is `1849`** — a real account on
this bench (`getent passwd 1849` on your own screen shows its full roll
entry; read it, and record the uid). And `VmSize` is far larger than
`VmRSS`: the keeper **holds** much more Store than it has **resident** —
most of it mapped and unbacked, exactly Task 1's lesson, on a stranger's
process. But step 3 — the environment — does not answer. Because the file
is opened by your shell's `<`, it is bash that reports the refusal:

```
bash: /proc/…/environ: Permission denied
```

That is the wall. You may read the public card (`cmdline`, `status`); you
may not read what is private to the account (`environ`, and, next, its
memory).

**2. Try to read its Store, as yourself.** Prove the wall is really there:

```sh
cat /proc/$PID/maps
pmap $PID
```

Expected:

```
cat: /proc/…/maps: Permission denied
```

```
…:   /home/…/enginehouse/survey/record-keeper
```

`maps` is flatly denied, and `pmap` prints only the header line — the one
fact it can get without reading the process — and no regions at all. As
yourself, you are locked out of its Store.

**3. Survey it, with the warrant.** Read the box above, then look. The
keeper has one region the ordinary blueprints omit — a **walled-off,
anonymous** room. You find it by its **shape**, never by a pinned address:
its permissions are `---p` (no read, no write, no execute — private), and
it has **no file behind it**. That combination is unique in the map:

```sh
sudo cat /proc/$PID/maps | grep ' ---p '
```

Expected — one line, and only one. The two addresses (printed in
hexadecimal, without `0x`) are different every run:

```
…-… ---p 00000000 00:00 0
```

See it summed, with sizes, in `pmap`:

```sh
sudo pmap -x $PID
```

Expected — the walled-off room is the one sizeable region in mode `-----`
with `[ anon ]` as its mapping and almost nothing resident:

```
…:   /home/…/enginehouse/survey/record-keeper
Address           Kbytes     RSS   Dirty Mode  Mapping
0000…               1024       4       4 -----   [ anon ]
…
---------------- ------- ------- -------
total kB            3580     288      …
```

Your `total` figures will differ a little from these, for the same reason;
the room's own line is the one to match.

On a 4 KiB-page bench the room is **1024 KiB** (256 pages); on a bench with
16 KiB pages it is 4096 KiB. The size and the `---p` perms are the stable
shape; the addresses are not. Record the room's **perms** and its **size**.

**4. File what you found.** In `check/answers.txt`:

- **`A4:`** — the keeper's owner, as the uid you read from its `status` (or
  from `getent passwd`). The number.
- **`A5:`** — the walled-off room's **shape**: its permissions (`---p`) and
  its size, and one sentence on why you could not read it as yourself.

**Checkpoint.** You should be able to say how you found the room without
knowing its address, what `---p` means, why `VmSize` dwarfs `VmRSS` on this
process, and why reading its memory needed the keys.

**5. Claim the seal** — from `labs/week-10`:

```sh
make -C check m3
```

Paste the seal under **Milestone 3** with the owner's uid, the room's
shape, and the denied commands that proved the wall.

> **If you're lost, start here (Task 3).**
> - `pgrep -x record-keeper` printed nothing, or `$PID` is empty? The keeper
>   is not staged (a reboot or `--reset` may have taken it). From
>   `labs/week-10`: `bash report-for-duty.sh`, then set `PID` again.
> - `grep: /proc//status: No such file or directory`? `$PID` did not get
>   set — re-run the `PID=$(pgrep -x record-keeper)` line and `echo "$PID"`.
> - `cat /proc/$PID/maps` worked **without** `sudo`? Then the keeper is
>   running as **you**, not uid 1849 — you ran its binary by hand. Stand the
>   bench down (`bash report-for-duty.sh --reset`) and stage it with the
>   script.
> - `sudo cat … | grep ' ---p '` printed nothing? Mind the spaces around
>   `---p`; copy the command exactly. The room is there.
> - `sudo: command not found` or it will not take your password? Take it to
>   your instructor; do not work around the keys.
> - Seal says A5 is not the right perms? It wants the `---p` room, not a
>   `rw-p` one. The walled-off room is the one with no read, write or
>   execute.

---

## Task 4 — Open the wing *(~25 minutes → Seal M4)*

The room is walled off even to the keeper itself (`---p` — the keeper
cannot read it either). But a debugger attached under the keys reads
**through** the wall: the protection stops the process touching the page,
not a debugger from dumping it. You will dump the room to a file, read it,
and record what it holds — and draw no conclusion.

**1. Dump the room.** Work from the survey folder. You need the two
addresses from the `---p` line you found in Task 3. **The map prints them
without `0x`; gdb needs it, so put `0x` in front of each.** A line reading
`7a1b2c000000-7a1b2c100000 ---p …` gives `0x7a1b2c000000` as START and
`0x7a1b2c100000` as END (yours are different):

```sh
cd ~/enginehouse/survey
PID=$(pgrep -x record-keeper)
sudo gdb -q -p "$PID" -x survey.gdb -batch \
  -ex "dump memory $HOME/enginehouse/survey/wing.dump 0xSTART 0xEND"
```

Two things about that command. It is **batch** (`-batch`): gdb attaches,
runs the one `dump memory`, detaches, and exits — no `(gdb)` prompt, nothing
left waiting. And the path is written `$HOME/…` so **your** shell fills in
your home folder *before* `sudo` runs; do not write a `~` inside the gdb
string. gdb runs as root and reads a `~` as root's home, so the dump fails
with an error about a path under `/root`, something like
`/root/enginehouse/survey/wing.dump: No such file or directory.`, and no
`wing.dump` is written.

Expected — gdb's notes as it attaches, a benign line about the keeper's
innards, then a clean detach (the address and pid vary):

```
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
0x… in __libc_pause () at ../sysdeps/unix/sysv/linux/pause.c:29

warning: 29	../sysdeps/unix/sysv/linux/pause.c: No such file or directory
[Inferior 1 (process …) detached]
```

The `warning` about `pause.c` is expected and harmless: gdb is saying it
has no source for a C-library function the keeper happens to be sitting in.
The dump still succeeds. Check it:

```sh
ls -l wing.dump
```

Expected — one megabyte on a 4 KiB-page bench (on a bench with 16 KiB
pages it is 4194304 bytes, as in Task 3), owned by root, and readable by
you (`-rw-r--r--`):

```
-rw-r--r-- 1 root root 1048576 … wing.dump
```

The warrant box promised that reading the room changes nothing. Confirm the
keeper is still at work after gdb let go:

```sh
pgrep -u 1849 -x record-keeper
```

Expected — its pid, the same one as before:

```
…
```

**2. Read the record.** Read what the room held:

```sh
strings wing.dump
```

Expected — the record prints here. **Read it, and record in your case
notes exactly what it says:**

```
[ the record prints on your screen. Copy it whole into your case notes,
  word for word. Record, side by side and in the record's own words: both
  surnames the record attaches to the one desk; every year it carries;
  and one plain, neutral word from its opening lines, as proof you opened
  the room. Draw no conclusion -- it is a record, not a verdict. ]
```

Copy it **exactly**, character for character, into your case notes. The
Guild grades the copy, not a theory about it.

**3. File what you found.** You are still in the survey folder, so go
back to the lab folder first. `cd -` means "back to the folder I was in
before the last `cd`": step 1's `cd` took you from `labs/week-10`, so this
takes you back there, and prints where it landed:

```sh
cd -
```

If what it prints does not end in `labs/week-10`, re-run the P2 `cd` line
that matches your setup instead. Then, in `check/answers.txt`:

- **`A6:`** — one neutral word from the record's opening lines, copied
  exactly (proof you opened the room). Not the name of the city or the
  works — a word only the record itself uses, one that appears nowhere
  else in the course's files.
- **`A7:`** — **every year** the record carries, and the **desk** the
  record names. Every year and the desk, on the one line.
- **`A8:`** — the **two surnames** the record attaches to that desk,
  **side by side, in either order, with no verdict**. The record names two;
  write both.

**4. Claim the seal** — from `labs/week-10`:

```sh
make -C check m4
```

Paste the seal under **Milestone 4** with the whole record copied in, and
your A6–A8 as you read them.

> **If you're lost, start here (Task 4).**
> - `No such process`, or `ptrace: Operation not permitted` even with
>   `sudo`? `$PID` is stale or empty. Re-run `PID=$(pgrep -x record-keeper)`
>   from `~/enginehouse/survey`, and stage the bench if `pgrep` is empty.
> - `Cannot access memory at address 0x…`, or the dump is the wrong size?
>   You copied one address wrong. Take both from the `---p` line again
>   (Task 3): `0x` and the digits, the first address then the second.
> - gdb asks `Enable debuginfod for this session? (y or [n])`? You left out
>   `-x survey.gdb`. Press **Enter** (the default, *n*) and carry on, or
>   re-run with the flag.
> - The dump failed with an error about a path under `/root`, and
>   `ls -l wing.dump` finds no file? A `~` went inside the gdb string, and
>   gdb, running as root, read it as root's home. Use
>   `$HOME/enginehouse/survey/wing.dump`, exactly as printed, and dump again.
> - `make: *** check: No such file or directory`? You are still in
>   `~/enginehouse/survey`. Go back to `labs/week-10` (step 3's `cd`), then
>   `make -C check m4` again.
> - Seal says there is no `wing.dump` yet? Step 1 makes it; the seal looks
>   for it in `~/enginehouse/survey/`.
> - `strings: command not found`? It ships with binutils; run the *"a tool
>   is missing"* fix in `setup/getting-started.md`.
> - Seal says A8 names only one? The record names **two**. Write both,
>   side by side, and check the spelling against the record; the slot will
>   not take one alone.

**5. The closing command.** You have filed your answers and claimed M4. One
command left. If you opened an editor or a second terminal to fill
`answers.txt`, come back to this one — this is the last command of the
lab. From anywhere:

```sh
strings ~/enginehouse/survey/wing.dump | grep seconded
```

```
[ your bench prints a line here ]
```

Leave it on your screen.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 10 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, character for character — do not paraphrase:

- The keeper's `status` card: its `Name`, its `Uid`, its `VmSize` and
  `VmRSS`.
- The `---p` line from `sudo cat /proc/$PID/maps`.
- The whole record, as `strings wing.dump` printed it.

Three questions to write toward, none of which has an answer in this work
order:

1. The record names two people against one desk, and gives years. Write down
   what each line says, in the record's own words, and nothing more. What
   does the record state, and what does it leave unstated?
2. Why would anyone keep a record walled off inside a running process
   rather than in a file on disk?
3. What would you want to know next, and which command might show it?

Write a plain account of what the record says. The notebook is marked on
being kept honestly and quoting exactly, never on drawing the cleverest
conclusion — least of all about people.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the keeper's.

1. In a paragraph: a process can hold a Store far larger than the real
   memory behind it. Explain, using **virtual address**, **page**, **page
   fault** and **resident** correctly at least once each, how `storeroom`
   could request 256 pages almost for free and why the first touch of each
   cost a fault and the second cost nothing. *zyBooks Ch 7.*
2. In two or three sentences: the governor ended the glutton by the
   Overseer's hand, not the glutton's. Was that the right thing for the
   Engine to do? What would you want a real server to do instead of killing
   a process outright, and what would that cost? (There is no answer key.)

## Turn it in

Due **Sunday, October 25, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)).

1. **`logbook.md`** — all four milestones: what you did, the seal pasted in,
   what it means. M1 wants your map's regions named, the `VmSize`/`VmRSS`
   gap, and both `storeroom` runs; M2 wants the governed run, the exit
   status and the verdict; **M3 wants the keeper read in full** — its owner,
   the wall that kept you out, and the walled-off room's shape found by
   perms and size — which is the graded centre of the week; M4 wants the
   whole record copied in and your A6–A8. Plus both reflection prompts and
   the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 10 entry.

Upload both files to the Week 10 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.)

**When your paperwork is in,** you may stand the bench down:

```sh
bash report-for-duty.sh --reset
```

It stops the keeper, sweeps the survey and your `wing.dump` with it, and
leaves every other week's papers exactly where they are.

**The usual late window applies.** Late work is accepted for two calendar
days at a flat 20%, so this order's window closes on **Tuesday,
October 27**. Hand it in on Sunday.

How the tasks cover the four objectives: Task 1 is objective 1; Task 2 is
objective 3; Task 3 is objective 1 again, on a process you do not own; Task
4 is objective 4; and `storeroom` in Task 1 is objective 2. The reflections
cover them in your own words.

**Also on this week's docket.** One date, and nothing else:

- zyBooks **Ch 7** — virtual memory — due **before class on Wednesday,
  October 21**. Readings have no late window. It is the reading behind all
  four tasks; do it first.
- No commission is due this week.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: FOUR. THREE SESSIONS. NO BREAK.`
> `THE STORE: READ, AND THE WALL WITH IT. THIS PORTER LOOKED AWAY.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap.

- **The fuller map.** `/proc/<pid>/smaps` (with `sudo`, for the keeper)
  breaks every region down line by line, and its `Rss` and `Pss` rows say
  how much of each is resident — `Pss` sharing a shared page's cost across
  the processes that hold it. `sudo pmap -XX $PID` prints much the same in a
  table.
- **See the denial plainly.** `cat /proc/$PID/maps` without `sudo` is the
  wall itself: `Permission denied`, because the process is another
  account's. That one line is the whole access-control lesson.
- **Another way to dump.** `sudo gcore -o /tmp/keeper $PID` writes a full
  core file of the process, from which `gdb` can read any region — a
  heavier instrument than one `dump memory`, useful when you want
  everything at once.
- **Naming an anonymous region.** A program can label its own anonymous
  mappings with `prctl(PR_SET_VMA_ANON_NAME, …)`, and then the bracketed
  name shows up in `maps` beside `[heap]` and `[stack]`. Most do not
  bother, which is why a walled-off room shows no name at all — and why you
  found this one by its shape.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"A map you can read is a process you can account for."*
