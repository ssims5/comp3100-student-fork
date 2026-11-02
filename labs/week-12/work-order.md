# WORK ORDER No. 1851-12 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 2 November 1851 — five weeks to the Exhibition |
| **Due** | **Sunday, 8 November, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

From this morning the Exhibition's outbound traffic leaves the wires. The
telegraph exchange has been upgraded for the crowds, and every capsule for
it now goes by pneumatic post: into a tube at the post clerk's desk, along
the line, and out at the exchange. A capsule goes in at one end and comes
out at the other, once. That is all a tube does.

The porters say the new line hisses twice when a capsule passes. They think
nothing of it. A tube has no echo.

Before you walk that line, learn the tubes the Engine gives every program
it runs: three fittings each program is born holding, the pipes that join
one program to the next, the device files under `/dev`, and tubes with
names that you can make yourself. Then walk the post's line, fitting by
fitting, send one capsule of your own down it, and write down exactly what
you find on it and who owns each part.

The line is not yours to mend. Leave every fitting as you found it, and
write down what is there. Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Every running program talks to the world through numbered **file
descriptors**. The shell lets you re-point them before a program starts
(**redirection**) and join one program's output to the next one's input
(a **pipe**). A pipe is a small buffer the kernel keeps between a writer and
a reader. A **FIFO** is the same thing with a name in a directory, so that
two programs that never met can use it. This week is about all of that, and
about what one account can and cannot see of another account's process.

The fiction is set dressing and the commands are the course; **no task
here requires story knowledge.** There is no required reading this week.
zyBooks **Ch 9** is optional; where a section bears on a task it is named
below. By the time you hand this in you will be able to:

1. **Explain descriptors and redirection, and predict where output and
   errors land.** Descriptors 0, 1 and 2; `>`, `>>`, `<`, `2>`, `2>&1`,
   `&>`; and why `2>&1 > file` and `> file 2>&1` are not the same command.
2. **Build pipelines, and say what a pipe's buffer and SIGPIPE do.** A
   writer waits when the buffer is full, a reader waits when it is empty,
   and a writer whose reader has gone is stopped by a signal. *zyBooks
   Ch 9.2 (optional), on buffers.*
3. **Read `/dev`, and tell a character device from a block device.** The
   type letter, and the **major** and **minor** numbers that pick a device
   driver and a device. *zyBooks Ch 9.1 (optional), on device drivers.*
4. **Make and use a FIFO, and show why two readers split a stream.** A
   named tube stores nothing, an open on it waits for the other end, and
   two readers never both hear the same capsule.
5. **Find which process holds a file, and say what you may and may not see
   of another account's process.** `fuser` and `lsof` on your own tubes;
   `ps` and `/proc/<pid>/cmdline` on a process that is not yours, and the
   wall that keeps you out of its open files.

Objective 4 is the one the Guild examines hardest. A line has no echo
unless somebody builds one, and an apprentice who knows that knows where to
look.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `ls`, `stat`, `cut`, `sort`, `uniq`,
`grep`, `wc`, `tee`, `mkfifo`, `timeout`, `ps`, `pgrep`, and two tools for
asking who holds a file: **`fuser`** and **`lsof`**. Every setup path in
this course installs them. Nothing needs a network.

Staging asks for the house keys **once**, and says what for before it
asks. After that, nothing this week needs `sudo`. Task 3 offers one
optional look with `sudo`, in a box that says what it does; no seal needs
it. If your environment broke over the weekend,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds it.

**P2 — This folder, open in a Linux terminal.** Run the line that matches
your setup:

```sh
cd ~/comp3100-student/labs/week-12
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-12
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-12
```

**P3 — Report for duty.** One command stages this week's bench: it builds
the post's line under `~/enginehouse/post/`, starts the line working, and
leaves an empty workshop for your own tubes. It asks for the house keys
**once** — it says so, and says what for, before it asks — and does nothing
else with them. Run it now, on Wednesday:

```sh
bash report-for-duty.sh
```

Expected — first the list of what the keys are for, then (after your
password, if `sudo` asks for it) the duty slip:

```
Before the post can be staged, the house keys are wanted. They are
asked for once, for the whole of the following, and for nothing else:

  * The fittings. Three are made over to uid 1849: the tube
    .listening-tube, the symlink outbound that leads into it, and the
    drop box .drop-box/ with its one file. The rest of the post is yours.
  * The copier. It is launched as a transient unit named 'tube-tee-1000'
    (systemd-run), opens the line's fittings, then drops itself to
    uid 1849 and stands. systemd keeps it alive past this shell;
    its chain tops out at PID 1, so no schedule owns it.
  * The drop box's papers. One test capsule is sent down the line and
    looked for at both ends; the drop box is then emptied in place and
    its papers written in.
  * One look at the copier's open files (only root may read them), to
    confirm it writes to the very drop box you can see.

One prompt covers all of it. sudo may ask for your password now, once,
and everything listed above happens inside that one window.


  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-12 :: bench staged and verified
  ------------------------------------------------------------------
   Post:      ~/enginehouse/post/        the line to the exchange
   Workshop:  ~/enginehouse/tube-shop/   yours -- your own fittings

   The post's line is live: a capsule sent down outbound comes out
   at exchange-line. Not every fitting on it is yours. You can see
   which are, and whose the others are, from your own screen. The
   work order shows you where to look.

   The line's copier is a living process, not a file: it does NOT
   survive `wsl --shutdown`, a reboot, or (on WSL) closing every
   Ubuntu window. Re-run this script to stage it afresh -- that
   rebuilds the post and refills its drop box, and sweeps away
   anything you sent down the line before.
   (bash report-for-duty.sh --reset strikes the post. The house roll
   stays -- later weeks are standing on it.)
  ------------------------------------------------------------------

```

The `1000` in the unit's name is your own uid, so yours may differ. On a
bench that has never staged Week 6 or Week 10, one more item comes first
in the list, **the roll** (one dormant entry restored to the bench's list
of accounts), and the roll office adds a note of its own as it works. It
will not ask you for anything. If you have staged before,
an item **the old post** appears too: the old line is struck so the new one
is built clean.

Two things land under `~/enginehouse/` that are yours to work in:

- `post/` — the post's line, ready to walk in Task 3. You will send a
  capsule down it; you will not change it;
- `tube-shop/` — an empty folder. Tasks 1 and 2 happen here.

(A third, `post-works/`, holds the line's machinery. You will not need to
look in it.)

The line is kept working by a **living process, not a file**: it does not
survive `wsl --shutdown` or a reboot, and on WSL, **closing every Ubuntu
window** can stop it too: WSL shuts Linux down soon after its last window
closes. If Task 3's commands find nothing
working when you come back, run `bash report-for-duty.sh` again to stage
the post afresh. **Re-staging sweeps away any capsule you have sent down
the line** — send yours again afterwards. It leaves `tube-shop/` alone.

**Never run `report-for-duty.sh` with `sudo`.** The script asks for the
house keys itself, once, exactly when it needs them. Under `sudo` it would
stage **root's** home folder instead of yours, and nothing this week — not
the commands below, not the seals — would find it there. It refuses before
it touches anything, and says so.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds ten short
answers — A1 to A10 — that the seal checks read; the template says what
goes where, and each task tells you when. Your running `case-notes.md` is
already at the repo root.

**What varies, and what does not.** Your screen will differ from this work
order in the places that are your bench's own: your user name and home
folder (written `you` here), your own uid (`1000` on the bench these were
taken from), **process ids** (written `NNNN`), **descriptor numbers** above
2, the number inside a pipe's `pipe:[…]` (written `NNNNN`), your terminal's
name (`/dev/pts/N`), how many devices your `/dev` holds, the counts in
Task 1's account tally, how two readers split Task 2's capsules, and every
date and time a listing prints (written `…`). What does **not** vary: the
type letters, `/dev/null`'s two numbers, the post's fittings and their
owner, and the drop box's papers.

**A note on this week's shape.** Three sessions: **Monday's deck**, then
**Wednesday's and Friday's studios**, no break. Four tasks, four seals,
about two and a quarter hours at the terminal — more than the two studios
hold, so plan on some of it at home. Tasks 1 and 2 are Wednesday's, with
Task 3 begun. **Task 4 is Friday's work**: it ends with one command, and
you want to be at your bench when you type it. Claim each seal as soon as
its task is done.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-12`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `cd: ... No such file or directory` for `labs/week-12`? Your copy of
>   the repo predates this week. From the repo root: `git pull`.
> - `$'\r': command not found`, or a `syntax error near unexpected token`
>   from the script? The file picked up Windows line endings on the way
>   down. From the repo root: `git checkout -- .` and try again.
> - `report-for-duty: run this as YOURSELF, not as root.`? You typed
>   `sudo` in front of it. The script asks for the keys itself, once, when
>   it needs them; run it again without `sudo`.
> - `report-for-duty: gcc not found`, or a note that `lsof` or `fuser` is
>   not on this bench? Your bench has lost a tool. Run the *"a tool is
>   missing"* fix in `setup/getting-started.md` (Troubleshooting), then run
>   the script again.
> - The script says it cannot get root? Take it to your instructor rather
>   than working around it; the bench is left exactly as it was found.
> - You ran `--reset` and want the bench back? Run
>   `bash report-for-duty.sh` again.

---

## Task 1 — The console's own fittings *(~35 minutes → Seal M1)*

Every program the Engine runs is born holding three open files, numbered
**0**, **1** and **2**. Before you look at any tube, look at those.

**1. The three a program is born with.** Ask `ls` to list its own open
files. `/proc/self` always means "the process asking":

```sh
ls -l /proc/self/fd
```

Expected — `N` is your terminal's number, and the last line's number is
`ls`'s own process id:

```
total 0
lrwx------ 1 you you 64 … 0 -> /dev/pts/N
lrwx------ 1 you you 64 … 1 -> /dev/pts/N
lrwx------ 1 you you 64 … 2 -> /dev/pts/N
lr-x------ 1 you you 64 … 3 -> /proc/NNNN/fd
```

Each line is one **file descriptor**: a small number the kernel hands a
program for each file it has open, pointing at the file. Three of them
were open before `ls` did anything at all:

- **0, standard input** — where the program reads from;
- **1, standard output** — where it writes its results;
- **2, standard error** — where it writes its complaints.

All three point at your terminal, `/dev/pts/N`, because your shell started
`ls` that way. (Descriptor 3 is `ls`'s own: the directory it opened to
list. It is gone the moment `ls` ends.) The kernel keeps one such table for
every process — zyBooks's *open file table*, from Week 11 — and Week 2's
`strace` showed you programs writing to descriptor 1 by number.

**2. Re-point a descriptor: redirection.** Work in your tube shop:

```sh
cd ~/enginehouse/tube-shop
echo first > log.txt; echo second >> log.txt; echo third > log.txt; cat log.txt
```

Expected:

```
third
```

`>` points descriptor 1 at a file, **emptying it first**. `>>` points it at
the file's **end**, so writing adds to what is there. The last `>` emptied
the file again, which is why only `third` is left. (`<` does the same job
for descriptor 0: `wc -l < log.txt` reads the file as input.)

Now the two output streams, separately:

```sh
ls /etc/hostname /no-such-fitting > out.txt 2> err.txt; echo "rc=$?"; cat out.txt; echo ---; cat err.txt
```

Expected:

```
rc=2
/etc/hostname
---
ls: cannot access '/no-such-fitting': No such file or directory
```

`> out.txt` re-pointed descriptor 1 and `2> err.txt` re-pointed descriptor
2, so the result and the complaint went to two different files and nothing
reached your screen. `rc=2` is `ls`'s exit status: it found one of the two
and not the other. And when you want a complaint to go nowhere at all:

```sh
ls /no-such-fitting 2> /dev/null; echo "rc=$?"
```

Expected:

```
rc=2
```

`/dev/null` is the Engine's sink: anything written to it is accepted and
thrown away. The error vanished; the exit status still tells you it
happened.

**3. Order matters.** `2>&1` means *"point descriptor 2 wherever descriptor
1 points **right now**"*. The shell reads redirections left to right, so
where you write it changes what it does. Try it the wrong way first:

```sh
ls /no-such-fitting 2>&1 > order.txt
wc -c < order.txt
```

Expected — the complaint lands on your **screen**, and the file is empty:

```
ls: cannot access '/no-such-fitting': No such file or directory
0
```

When the shell read `2>&1`, descriptor 1 still pointed at your terminal,
so descriptor 2 was pointed at your terminal. Only **then** did `>
order.txt` move descriptor 1. Now the right way round:

```sh
ls /no-such-fitting > both.txt 2>&1
wc -c < both.txt; cat both.txt
```

Expected:

```
64
ls: cannot access '/no-such-fitting': No such file or directory
```

Descriptor 1 moved to the file first, and `2>&1` then sent descriptor 2
after it. (`64` is the byte count on the bench these were taken from. A
bench set up in another language prints its complaint in that language,
with a different count. What matters is that this one is **not 0** and the
other one **is**.) Bash also has a shorthand for "both, to one file":

```sh
ls /no-such-fitting &> amp.txt; wc -c < amp.txt
```

Expected — the same count as `both.txt`:

```
64
```

**4. `/dev`: the device files.** Some files are not files at all, but
doors into a device driver. List six of them:

```sh
ls -l /dev/null /dev/zero /dev/full /dev/random /dev/urandom /dev/tty
```

Expected:

```
crw-rw-rw- 1 root root 1, 7 … /dev/full
crw-rw-rw- 1 root root 1, 3 … /dev/null
crw-rw-rw- 1 root root 1, 8 … /dev/random
crw-rw-rw- 1 root tty  5, 0 … /dev/tty
crw-rw-rw- 1 root root 1, 9 … /dev/urandom
crw-rw-rw- 1 root root 1, 5 … /dev/zero
```

Read two things. The **first character** of each line is its **type
letter**. You know `-` (a regular file), `d` (a directory) and `l` (a
symbolic link, Week 11). `c` is a **character device**: one that hands out
or takes in a stream of bytes. And where a file's **size** would be, a
device shows **two numbers**: its **major** number, which picks the
**device driver** in the kernel that answers for it, and its **minor**
number, which tells that driver which of its devices is meant. *zyBooks Ch
9.1 (optional) on device drivers.* Five of these six share major `1`: one
driver, the kernel's own memory devices, answering for all five.

The other type letter you will meet under `/dev` is `b`, a **block
device**: a disk, read and written in fixed-size blocks. On a WSL bench
the first few are the loop devices you met in Week 11:

```sh
ls -l /dev | grep '^b' | head -3
```

Expected (yours may be other devices, or none at all on some benches):

```
brw-rw---- 1 root disk      7,   0 … loop0
brw-rw---- 1 root disk      7,   1 … loop1
brw-rw---- 1 root disk      7,   2 … loop2
```

`ls -l /dev | grep -c '^c'` counts the character devices. The count
differs from bench to bench, so never compare yours with a neighbour's.
`stat` reads the two numbers too, by name:

```sh
stat -c '%n %F %Hr,%Lr' /dev/null /dev/zero /dev/full
```

Expected:

```
/dev/null character special file 1,3
/dev/zero character special file 1,5
/dev/full character special file 1,7
```

Now use three of them. `/dev/zero` gives as many zero bytes as you ask for:

```sh
head -c 16 /dev/zero | od -c
```

Expected:

```
0000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
0000020
```

`/dev/full` refuses every write, as if a disk were full:

```sh
echo "a capsule" > /dev/full
```

Expected:

```
bash: echo: write error: No space left on device
```

And `/dev/null` takes everything without a word:

```sh
echo "into the sink" > /dev/null; echo "rc=$?"
```

Expected:

```
rc=0
```

Last, the three descriptors have names under `/dev` too:

```sh
ls -l /dev/stdin /dev/stdout /dev/stderr /dev/fd
```

Expected:

```
lrwxrwxrwx 1 root root 13 … /dev/fd -> /proc/self/fd
lrwxrwxrwx 1 root root 15 … /dev/stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root 15 … /dev/stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root 15 … /dev/stdout -> /proc/self/fd/1
```

Four symbolic links (Week 11 again) into step 1's table, for whichever
process opens them.

**5. Join two programs: the pipe.** `|` points the first program's
descriptor 1 at the second program's descriptor 0. Commission I's census
read `/etc/passwd` on its standard input and counted names; this is a
census of another field — which shell each account uses — in one line:

```sh
cut -d: -f7 /etc/passwd | sort | uniq -c
```

Expected — the counts are your bench's, so yours will differ; the shape is
the same everywhere:

```
      2 /bin/bash
      1 /bin/false
      1 /bin/sync
     25 /usr/sbin/nologin
```

`cut` takes the seventh colon-separated field of each line (the account's
shell), `sort` puts like with like, and `uniq -c` counts each run. Three
programs, two pipes, and none of the three knows the others exist: each
reads descriptor 0 and writes descriptor 1.

Between each pair the kernel keeps a **buffer**: on Linux, 64 KiB by
default. The writer puts bytes in, the reader takes them out. If the
reader is slow and the buffer fills, the writer **waits**; if the buffer is
empty, the reader **waits**. That is the book's buffer between a producer
and a consumer. *zyBooks Ch 9.2 (optional).* Linux keeps a pipe's buffer as
a ring of page-sized slots — close kin to the book's *circular buffer*.

**6. When the reader leaves: SIGPIPE.** `yes` prints `y` forever. `head -1`
reads one line and leaves. What happens to `yes`?

```sh
yes | head -1; echo "PIPESTATUS: ${PIPESTATUS[*]}"
```

Expected:

```
y
PIPESTATUS: 141 0
```

`PIPESTATUS` is bash's list of every exit status in the last pipeline, in
order: `yes` first, then `head`. `head` ended normally (0). `yes` did not
end on its own: its next write went into a pipe with no reader left, and
the kernel stopped it with the signal **SIGPIPE**. A shell reports death by
signal as 128 plus the signal's number, and SIGPIPE is 13. One more, to see
the list's order:

```sh
true | false | true; echo "${PIPESTATUS[@]}"
```

Expected:

```
0 1 0
```

**7. File what you found.** Open `check/answers.txt`:

- **`A1:`** — the type letter of `/dev/null`, then its major and minor
  numbers, major first, **with a space between them** (not a comma — the
  template says why).
- **`A2:`** — the two byte counts from step 3: `order.txt`'s first, then
  `both.txt`'s.
- **`A3:`** — the two `PIPESTATUS` figures for `yes | head -1`, in the order
  bash printed them, then the count beside `/usr/sbin/nologin` in **your
  own** step 5 tally. Three numbers.

**Checkpoint.** Before the seal, you should be able to say, without
looking: which descriptor is which; why `2>&1 > order.txt` left the
complaint on your screen; what `c` and `b` mean and what a major number
picks; and why `yes` ended with 141.

**8. Claim the seal** — from `labs/week-12` (you are in the tube shop, so
go back first with the P2 `cd` line that matches your setup):

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-12/check'
  ~~~ WAX SEAL of the Guild: 5B79A45C ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-12/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 1** with
your `ls -l /proc/self/fd`, both of step 3's runs and what each did, and
the `PIPESTATUS` line.

> **If you're lost, start here (Task 1).**
> - `cd: /home/you/enginehouse/tube-shop: No such file or directory`? The
>   bench is not staged (or you ran `--reset`). From `labs/week-12`:
>   `bash report-for-duty.sh`.
> - `wc -c < order.txt` printed 64, not 0? You typed `> order.txt 2>&1`.
>   The order is the whole point: run step 3's first line again exactly as
>   printed.
> - `PIPESTATUS:` printed one number, or none? Your shell is not bash, or
>   you ran another command in between. Type `bash`, press Enter, and run
>   the line exactly as printed, all on one line.
> - `stat: unrecognized … %Hr`? Your `stat` is older than this bench's. Read
>   the two numbers from the `ls -l` line instead.
> - `bash: /dev/full: Permission denied` rather than `No space left on
>   device`? You are inside a container with a short `/dev`. Read step 4's
>   expected output; the seal does not depend on `/dev/full`.
> - Seal says A1 reads as ONE number? You wrote `1,3`. A comma joins the
>   two digits into thirteen; write them with a space.
> - Seal says A2 has the counts the wrong way round? `order.txt` first,
>   then `both.txt`.
> - Seal says A3's third number is not this bench's? Read the count beside
>   `/usr/sbin/nologin` in **your** tally, not this page's. Benches differ.

---

## Task 2 — A tube of your own *(~35 minutes → Seal M2)*

Every pipe in Task 1 was a tube with no name: the shell made it, joined two
programs with it, and threw it away. This task makes one with a name.

**1. The tube with no name.** Look at one while it exists. Inside a
pipeline, descriptor 0 of the second program is the pipe:

```sh
echo x | ls -l /proc/self/fd/0
```

Expected — the number in brackets is different every time:

```
lr-x------ 1 you you 64 … /proc/self/fd/0 -> 'pipe:[NNNNN]'
```

(On a terminal, `ls` puts the target in quotes because of its brackets.
The quotes are `ls`'s, not part of the name.)

Where Task 1 showed `/dev/pts/N`, this shows `pipe:[NNNNN]`: a pipe the
kernel made, with a number and no name in any directory. The number is the
kernel's own, and changes every run; the word before it does not.

**2. A tube with a name.** `mkfifo` makes a **FIFO** — a *named pipe*:
first in, first out, with a name in a directory like any other file:

```sh
mkfifo ~/enginehouse/tube-shop/tube
ls -l ~/enginehouse/tube-shop/tube
```

Expected:

```
prw-r--r-- 1 you you 0 … /home/you/enginehouse/tube-shop/tube
```

A new type letter, `p`, for **pipe**. And a size of **0**, which it keeps
forever: whatever goes through a FIFO passes through the kernel's buffer
and is never stored in the file. `stat` says the same in words:

```sh
stat -c '%F %s %a' ~/enginehouse/tube-shop/tube
```

Expected:

```
fifo 0 644
```

(Watch the word *FIFO*: zyBooks uses it for the order of a queue — in
scheduling, page replacement and disk scheduling. A FIFO file is that same
order, kept by a tube.)

**3. An open waits for the other end.** Try to read from the tube when
nobody is writing to it. `timeout 2` gives up after two seconds, so you do
not have to:

```sh
timeout 2 cat ~/enginehouse/tube-shop/tube; echo "rc=$?"
```

Expected — nothing at all for two seconds, then:

```
rc=124
```

`cat` never got as far as reading: **opening** a FIFO for reading waits
until something opens it for writing (and opening it for writing waits for
a reader). `124` is `timeout`'s own status, meaning *"I had to stop it"*.

Now give it both ends. Open a **second terminal** (WSL: a new Ubuntu tab;
Multipass: a second `multipass shell`). In the **first**:

```sh
cat ~/enginehouse/tube-shop/tube
```

It waits. In the **second**:

```sh
echo "hello down the tube" > ~/enginehouse/tube-shop/tube
```

The first terminal prints:

```
hello down the tube
```

and returns to its prompt: once the writer closed its end, the reader saw
the end of the stream. `ls -l` the tube again: still size 0.

**4. Who holds a tube?** Two tools answer that from the file's side. In the
**second** terminal, open the tube and keep it open, on a descriptor you
choose, 3, for reading and writing both (`<>`):

```sh
exec 3<> ~/enginehouse/tube-shop/tube
```

`exec` with only a redirection changes your **shell's own** table: your
shell now holds the tube on descriptor 3. Ask who holds it:

```sh
fuser -v ~/enginehouse/tube-shop/tube
```

Expected:

```
                     USER        PID ACCESS COMMAND
/home/you/enginehouse/tube-shop/tube:
                     you        NNNN F.... bash
```

```sh
lsof ~/enginehouse/tube-shop/tube
```

Expected:

```
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF  NODE NAME
bash    NNNN    you    3u  FIFO    …        0t0     … /home/you/enginehouse/tube-shop/tube
```

Both name your shell (`echo $$` prints its pid: the same number). `lsof`
also gives the descriptor, `3`, and how it is open: `u`, for both reading
and writing. Now let go of it, in the same terminal — **this matters**: a
tube still held open never tells its readers that the stream has ended, and
step 5's readers would wait forever:

```sh
exec 3<&-
```

It prints nothing. `fuser -v` on the tube now prints nothing either.

**5. Two readers on one tube.** Back in the **first** terminal. If two
readers wait on the same tube and twenty capsules go down it, does each
reader hear all twenty? Run this block as written — it starts two readers
in the background, `a` and `b`, sends twenty one-line capsules a little
apart, then counts what each heard:

```sh
cd ~/enginehouse/tube-shop
rm -f a.txt b.txt
(cat tube > a.txt &); (cat tube > b.txt &)
sleep 0.3
for i in $(seq 1 20); do echo "capsule $i"; sleep 0.05; done > tube
sleep 0.5
echo "a=$(wc -l < a.txt) b=$(wc -l < b.txt)"
```

Expected — two numbers, each different on every bench and every run:

```
a=NN b=NN
```

The two counts always add up to **20**, and usually neither is 20. Every capsule
reached **one** reader, never both: the readers took turns at the tube, and
whichever was waiting took the next capsule. Run the block two or three
times and the split usually moves (on some benches it comes out the same
each time); the total never does. (Now and then one reader
takes the lot. Run it again.)

That is the week's central fact: **a line has no echo.** Two readers on
one tube split the traffic between them. Nobody can listen in on a tube by
standing beside it.

**6. Building an echo.** To hear everything that goes down a tube, you
have to stand **in** it: take every capsule out, and put it back in on the
far side, keeping a copy as it passes. `tee` does exactly that — one input,
two outputs:

```sh
rm -f heard.txt copy.txt
(cat tube | tee copy.txt > heard.txt &)
sleep 0.3
printf "a\nb\nc\n" > tube
sleep 0.5
wc -l heard.txt copy.txt
```

Expected:

```
 3 heard.txt
 3 copy.txt
 6 total
```

Three capsules in, three out the far side (`heard.txt`), and three copies
kept (`copy.txt`). The reader at the far end got everything, unchanged;
nothing about what it received says a copy was taken.

**7. File what you found.** In `check/answers.txt`:

- **`A4:`** — your tube's type letter (step 2), then the word `ls -l`
  printed after the arrow for descriptor 0 inside a pipeline (step 1).
- **`A5:`** — the two counts from **one** run of step 5's block: `a`, then
  `b`.

**Checkpoint.** You should be able to say why the tube's size stays 0; why
`cat` on a tube nobody writes to waits rather than ending; what `exec 3<&-`
did and why step 5 needed it; and why a tube cannot be overheard, only
stood in.

**8. Claim the seal** — from `labs/week-12`:

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-12/check'
  ~~~ WAX SEAL of the Guild: F8D8DAE5 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-12/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 2** with
the two-terminal exchange, your `fuser`/`lsof` lines, two or three runs of
step 5, and the `tee` count.

> **If you're lost, start here (Task 2).**
> - `mkfifo: cannot create fifo '…/tube': File exists`? You made it
>   already. Carry on; `ls -l` it to be sure its letter is `p`.
> - Step 3's `cat` printed something, or returned at once? Something else
>   is writing to the tube — perhaps a second terminal you left mid-step.
>   Look at both terminals.
> - Step 4's `lsof` printed nothing? The shell that ran `exec 3<>` is not
>   the one you asked from, or you already let go with `exec 3<&-`. Run the
>   `exec 3<>` line and `lsof` in the **same** terminal.
> - Step 5 printed nothing, or the prompt never came back? A shell still
>   holds the tube open (step 4), so the readers never hear the end. In
>   every terminal you used, type `exec 3<&-`; then, in the first,
>   `pkill -u "$USER" -x cat` to clear any reader still waiting, and run the
>   block again.
> - Step 5 says `a=0 b=20` (or `a=20 b=0`)? One reader took every capsule
>   that run. It happens; run the block again.
> - Seal says your tube is not there? It looks for exactly
>   `~/enginehouse/tube-shop/tube`. `--reset` sweeps the tube shop; make it
>   again (step 2).
> - Seal says A4's second word names your terminal? You ran `ls -l
>   /proc/self/fd/0` without `echo x |` in front. With nothing piped in,
>   descriptor 0 is your terminal.
> - Seal says A5 has one reader that heard nothing? Run the block again and
>   copy a run where both heard something.

---

## Task 3 — Walk the line, fitting by fitting *(~35 minutes → Seal M3)*

Now the post's line. Your work in this task is to walk it and write down
what is there: each fitting, what kind of file it is, and who owns it.
Draw no conclusion. Send one capsule of your own; change nothing.

**1. The fittings.** List the post, with owners as **numbers** (`-n`) and
nothing hidden (`-a`):

```sh
ls -lan ~/enginehouse/post/
```

Expected (`1000` is the bench user's uid on the bench these were taken
from; yours may differ, and so may the `..` line's permissions, which are
your own folder's, e.g. `drwxrwxr-x`):

```
total 12
drwxr-xr-x  3 1000 1000 4096 … .
drwxr-xr-x  … 1000 1000 4096 … ..
drwxr-xr-x  2 1849  100 4096 … .drop-box
prw--w--w-  1 1849  100    0 … .listening-tube
prw-r--r--  1 1000 1000    0 … exchange-line
lrwxrwxrwx  1 1849  100   15 … outbound -> .listening-tube
```

Four fittings, and three of the type letters from Tasks 1 and 2. Read them
in the order a capsule meets them, which is not the order `ls` lists them:

- **`outbound`** is where the post clerk puts a capsule in. Its letter is
  `l`: it is a **symbolic link**, and the arrow says where it leads — to
  `.listening-tube`.
- **`.listening-tube`** is a FIFO (`p`). Its name begins with a dot, so a
  plain `ls` would not show it. Others may write to it (`-w--w-`).
- **`exchange-line`** is a FIFO too: the exchange's end of the line.
- **`.drop-box`** is a directory (`d`), with a dot in front as well.

And the two numbers after the link count are the **owner** and the
**group**, by number. Some fittings are yours (`1000` here). Three are owned
by uid **`1849`**, group `100`. `getent passwd 1849` on your own screen
shows that account's entry on your bench's roll; read it, and write down
the number. Look inside the directory too:

```sh
ls -lan ~/enginehouse/post/.drop-box/
```

Expected:

```
total 12
drwxr-xr-x 2 1849  100 4096 … .
drwxr-xr-x 3 1000 1000 4096 … ..
-rw-r--r-- 1 1849  100 2938 … outbound-copy.txt
```

One regular file, owned by the same account, readable by anyone. Leave it
for Task 4.

**2. Send one capsule.** First, how long is that file now?

```sh
wc -l ~/enginehouse/post/.drop-box/outbound-copy.txt
```

Expected (on a freshly staged post; more, if you have sent capsules
already):

```
53 /home/you/enginehouse/post/.drop-box/outbound-copy.txt
```

Now put a capsule in at `outbound`, exactly as written — `$USER` is your
own user name, filled in by the shell — and take it out at the exchange
end:

```sh
echo "TEST CAPSULE from $USER" > ~/enginehouse/post/outbound
timeout 3 cat ~/enginehouse/post/exchange-line; echo "rc=$?"
```

Expected — your capsule, then three seconds later the status:

```
TEST CAPSULE from you
rc=124
```

It came out at the far end, once, as you sent it. The `124` is `timeout`
stopping `cat` after three seconds: this line's exchange end never reports
the end of the stream, because something holds it open at both ends. That
is why every read at `exchange-line` in this work order uses `timeout 3
cat`. (Never `head`: `head` reads a whole buffer's worth at once and keeps
what it does not print, so a capsule it swallowed is gone from the line.)

Now the file again:

```sh
wc -l ~/enginehouse/post/.drop-box/outbound-copy.txt
```

Expected:

```
54 /home/you/enginehouse/post/.drop-box/outbound-copy.txt
```

One line longer. Look at its last line:

```sh
tail -n 1 ~/enginehouse/post/.drop-box/outbound-copy.txt
```

Expected:

```
TEST CAPSULE from you
```

The capsule reached the exchange end, and a copy of it reached the drop
box. Write that down exactly as you saw it. (The porters' word for it is
that the line hissed twice.)

**3. Find what makes the copy.** A file does not copy itself; some
process is doing it. You know whose files these are, so ask for that
account's processes:

```sh
pgrep -u 1849 -l
```

Expected — a process id and a command name:

```
NNNN tube-tee
```

If Week 10's keeper is still at work on your bench, another line,
`NNNN record-keeper`, appears too, before or after this one: it runs under
the same account. The one
for this week is `tube-tee`. `ps` gives the whole of its line (`-ww`: never
cut it to the terminal's width):

```sh
ps -ww -o user,uid,pid,args -C tube-tee
```

Expected:

```
USER       UID     PID COMMAND
computa+  1849    NNNN /home/you/enginehouse/post-works/tube-tee /home/you/enginehouse/post/.listening-tube /home/you/enginehouse/post/exchange-line /home/you/enginehouse/post/.drop-box/outbound-copy.txt
```

The `USER` column is eight characters wide and the account's name is
longer, so `ps` cuts it short with a `+`. The `UID` column is the whole
number: `1849`, the same account that owns the fittings. Keep its process
id:

```sh
PID=$(pgrep -u 1849 -x tube-tee)
echo "$PID"
```

One number. (On a bench shared by several users, more than one may
print; pick the one whose line in `ps` names **your** home.)

**4. Read its card — the Card-Room Drill.** Week 3's drill, and Week 10's,
once more, on a process that is not yours:

```sh
tr '\0' ' ' < /proc/$PID/cmdline; echo
grep -E '^(Name|State|PPid|Uid|Gid):' /proc/$PID/status
```

Expected:

```
/home/you/enginehouse/post-works/tube-tee /home/you/enginehouse/post/.listening-tube /home/you/enginehouse/post/exchange-line /home/you/enginehouse/post/.drop-box/outbound-copy.txt
Name:	tube-tee
State:	S (sleeping)
PPid:	1
Uid:	1849	1849	1849	1849
Gid:	100	100	100	100
```

Its **command line** — public to anyone on the bench — names three files:
the hidden tube, the exchange end, and the drop box. Check that every path
in it is under **your** home. `S (sleeping)` means it is waiting, as `cat`
waits on an empty tube. `PPid: 1` means no shell of yours started it and no
schedule owns it (a few benches show another number there; it is the top
of the chain on yours).

**5. The wall.** Try to see which files it actually holds open:

```sh
ls -l /proc/$PID/fd
```

Expected:

```
ls: cannot open directory '/proc/NNNN/fd': Permission denied
```

```sh
lsof -l -p "$PID"
```

Expected (`-l` prints owners as numbers):

```
COMMAND   PID     USER   FD      TYPE DEVICE SIZE/OFF NODE NAME
tube-tee NNNN     1849  cwd   unknown                      /proc/NNNN/cwd (readlink: Permission denied)
tube-tee NNNN     1849  rtd   unknown                      /proc/NNNN/root (readlink: Permission denied)
tube-tee NNNN     1849  txt   unknown                      /proc/NNNN/exe (readlink: Permission denied)
tube-tee NNNN     1849 NOFD                                /proc/NNNN/fd (opendir: Permission denied)
```

And from the files' side, on the line's far end — a FIFO that is **yours**:

```sh
lsof ~/enginehouse/post/exchange-line; echo "rc=$?"
```

Expected:

```
rc=1
```

`lsof` found nobody. In Task 2 it found your shell at once. The difference
is the owner: you may read another account's **command line** and
**status**, but its table of open files is that account's own, and the
Engine will not show it to you. `lsof` and `fuser` see only your own
processes' descriptors — so a process of another account can hold your
own file open and your `lsof` will report no one. Everything you know about
what `tube-tee` holds, you read from its command line, which it was started
with, and from what you watched it do in step 2.

> **THE OPTIONAL LOOK — `sudo`, and no seal needs it.**
> *What it does:* `sudo lsof -l -p "$PID"` reads the copier's table of open
> files as root, which is above the wall. It **reads**; it does not stop,
> change or signal the process.
> *The exact command, and no other:* `sudo lsof -l -p "$PID"`
> *How it ends:* it prints and exits; nothing is left running.
> *Why it is optional:* step 4's command line and step 2's capsule already
> tell you what this view confirms. If you would rather not use the house
> keys, skip this box; nothing below depends on it.
>
> ```sh
> sudo lsof -l -p "$PID"
> ```
>
> Expected — among a dozen lines, the last three (the numbers in the `FD`,
> `DEVICE`, `SIZE/OFF` and `NODE` columns vary, written `…`):
>
> ```
> tube-tee NNNN     1849    …u  FIFO   …      0t0     … /home/you/enginehouse/post/.listening-tube
> tube-tee NNNN     1849    …u  FIFO   …      0t0     … /home/you/enginehouse/post/exchange-line
> tube-tee NNNN     1849    …w   REG   …        …     … /home/you/enginehouse/post/.drop-box/outbound-copy.txt
> ```
>
> Both tubes open for reading and writing (`u`), and the drop box open for
> writing (`w`).

The line, as you have walked it, ends here. Do **not** try to take it
apart: it is not yours, and the house keys do not make it yours. Record it.

**6. File what you found.** In `check/answers.txt`:

- **`A6:`** — the type letters of the four fittings **in the order a
  capsule meets them** (`outbound`, the tube it leads into,
  `exchange-line`, the drop box), then the name of that hidden tube, as
  `ls -lan` prints it.
- **`A7:`** — the uid that owns the post's other fittings, then the
  copier's command name.
- **`A8:`** — how many lines the drop box grew by for the **one** capsule
  you sent. One number.

**Checkpoint.** You should be able to say which fittings are yours and
which are not, and how you know; what `outbound` really is; how you found
the process making the copy without root; and what you could not see of it,
and why.

**7. Claim the seal** — from `labs/week-12`:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-12/check'
  ~~~ WAX SEAL of the Guild: 7AFD0197 ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-12/check'
```

(The seal code is yours, not this one.) The seal looks for your test
capsule in the drop box, so it needs step 2 done since you last staged.
Paste it under **Milestone 3** with the `ls -lan` of the post, your
capsule's two arrivals, the copier's command line and status, and the
denials that met you.

> **If you're lost, start here (Task 3).**
> - `pgrep -u 1849 -l` prints nothing, or `ps -C tube-tee` shows only its
>   header? The line's process is gone — a `wsl --shutdown`, a reboot, or
>   (on WSL) closing every Ubuntu window takes it. From `labs/week-12`: `bash report-for-duty.sh`, then send
>   your capsule again (step 2).
> - `echo … > ~/enginehouse/post/outbound` never returns? The line's process
>   is gone and nothing is reading the tube. Press Ctrl-C, then re-stage as
>   above.
> - `timeout 3 cat …exchange-line` printed nothing, then `rc=124`? Your
>   capsule was already taken: a second terminal, or an earlier `cat`, read
>   it first. Send another and read it straight after.
> - `wc -l` grew by more than one? You sent more than one capsule, or a
>   capsule of more than one line. Count the lines you sent.
> - `PID=$(pgrep …)` gave two numbers? You are on a shared bench. Use the
>   one whose line in `ps -ww -o user,uid,pid,args -C tube-tee` names **your**
>   home.
> - `grep: /proc//status: No such file or directory`, or `lsof` printing
>   screens of every process on the machine? `$PID` is empty —
>   re-run the `PID=$(pgrep -u 1849 -x tube-tee)` line (a new terminal does
>   not keep it).
> - `ls -l /proc/$PID/fd` worked **without** `sudo`? Then that process is
>   running as **you** — you started a copy of the binary by hand. Stand
>   the bench down (`bash report-for-duty.sh --reset`) and stage it with
>   the script.
> - Seal says the drop box holds no test capsule? Send one exactly as step
>   2 shows. If you re-staged since, staging swept it away.
> - Seal says A6 lists the fittings in the order `ls` prints them? A6 wants
>   the order a capsule meets them: `outbound` first.

---

## Task 4 — What the drop box holds *(~35 minutes → Seal M4)*

The drop box was not empty when you arrived: Task 3's first `wc -l` found
53 lines in it before you sent a thing. Read them with pipelines — counts
first, then the one that stands apart. Copy what it says; draw no
conclusion.

The file's path is long. Put it in a shell variable for this task (a new
terminal needs this line again):

```sh
DROP=~/enginehouse/post/.drop-box/outbound-copy.txt
```

**1. How many capsules?** Every capsule the box held when it was staged
begins with a header line, and every header begins with the word
`CAPSULE` and a space:

```sh
grep -c '^CAPSULE ' "$DROP"
```

Expected:

```
NN
```

Your bench prints a number there: write it down. `^` **anchors** the
pattern to the start of the line. Without it:

```sh
grep -c 'CAPSULE' "$DROP"
```

this counts **every** line with `CAPSULE` anywhere in it — including your
own `TEST CAPSULE` from Task 3, and any others you sent — so it prints a
larger number, larger by one for every test capsule aboard. The anchored
count is the box as it was staged.

**2. The headers.** Print just the header lines:

```sh
grep '^CAPSULE ' "$DROP"
```

Expected — one line per capsule, in the order they arrived; the first three
are:

```
CAPSULE 01 -- Fri 30 Oct 1851 -- FROM THE TELEGRAPH EXCHANGE TO THE BOARD OF THE ENGINEHOUSE
CAPSULE 02 -- Fri 30 Oct 1851 -- FROM THE EXHIBITION OFFICE TO THE BOARD OF THE ENGINEHOUSE
CAPSULE 03 -- Fri 30 Oct 1851 -- FROM THE PORTERS' LODGE TO THE TELEGRAPH EXCHANGE
…
```

Each header gives the capsule's number, its date, who sent it and to whom.
Read every one.

**3. By date.** The fourth to seventh words of a header are its date. Cut
them out with `cut` (`-d' '`: words are separated by spaces) and count the
runs:

```sh
grep '^CAPSULE ' "$DROP" | cut -d' ' -f4-7 | uniq -c
```

Expected:

```
      5 Fri 30 Oct 1851
      2 Sat 31 Oct 1851
      2 Sun 1 Nov 1851
      3 Mon 2 Nov 1851
```

(`uniq -c` counts **runs** of identical lines, so it needs like lines next
to each other. The capsules are already in date order; in step 4 they are
not, which is why step 4 sorts first.)

**4. By sender.** From the ninth word on, a header says who sent it. Cut
that out, drop everything from ` TO ` onward with `sed`, then sort and
count, most frequent first:

```sh
grep '^CAPSULE ' "$DROP" | cut -d' ' -f9- | sed 's/ TO .*//' | sort | uniq -c | sort -rn
```

Expected — one line per sender, each with its count; your bench prints
them:

```
[ your bench prints the tally here: a count, then FROM and a sender ]
```

Count the capsules that came **from** the Board of the Enginehouse. You can
read it off the tally, or ask `grep` for it directly, anchored:

```sh
grep -c '^CAPSULE .*FROM THE BOARD' "$DROP"
```

`.*` matches anything, so this counts the headers that have `FROM THE
BOARD` somewhere after `CAPSULE `. Write the number down.

**5. The one that names no sender.** Every header in the tally names its
sender after `FROM THE` — every header but one. Find it by asking for the
headers that do **not** (`-v`) contain ` FROM THE `:

```sh
grep '^CAPSULE ' "$DROP" | grep -v ' FROM THE '
```

Expected:

```
[ your bench prints one header here ]
```

Read its number — the two digits after `CAPSULE` — and print that capsule
whole: its header and the eight lines after it (`-A 8`). Put its two
digits where this line has `NN`, and keep the space after them:

```sh
grep -A 8 '^CAPSULE NN ' "$DROP"
```

Expected:

```
[ your bench prints the capsule here. Read it through. Record in your
  logbook, exactly as written: whom it is addressed to, its date, and
  its closing line. Draw no conclusion -- it is a capsule, not a verdict. ]
```

Copy its address line and its closing line **exactly**, character for
character, into your case notes. The Guild grades the copy, not a theory
about it.

**6. File what you found.** If you file your answers from a second terminal,
or an editor that takes over this one, that is fine — but come back to
**this** terminal afterwards: step 8 is the last command of the lab, typed
here. In `check/answers.txt`:

- **`A9:`** — how many capsules the drop box held when it was staged (the
  **anchored** count, step 1), then how many of them came **from** the
  Board (step 4). Two numbers.
- **`A10:`** — how many cities the capsule with no sender addresses,
  **in digits**, and its closing line, exactly as written, both on the one
  line.

**7. Claim the seal** — from `labs/week-12`:

```sh
make -C check m4
```

Expected:

```
make: Entering directory '.../labs/week-12/check'
  ~~~ WAX SEAL of the Guild: 304DF696 ~~~
  (Paste this seal into your logbook under Milestone 4.)
make: Leaving directory '.../labs/week-12/check'
```

(The seal code is yours, not this one.) Paste it under **Milestone 4** with
the two counts and how you got each, the date tally, the sender tally, and
the capsule with no sender as you recorded it in step 5.

> **If you're lost, start here (Task 4).**
> - `grep: : No such file or directory`? `$DROP` is empty — this is a new
>   terminal. Run the `DROP=…` line again.
> - `grep: …outbound-copy.txt: No such file or directory`? The post is not
>   staged (or you ran `--reset`). From `labs/week-12`:
>   `bash report-for-duty.sh` — then send a test capsule again, because the
>   seal for Task 3 wants one.
> - The tally in step 4 lists one sender twice? You left out the first
>   `sort`: `uniq -c` counts only runs of identical lines.
> - `grep -A 8 '^CAPSULE NN '` printed nothing? Put the capsule's own two
>   digits where `NN` is, and keep the space before the closing quote.
> - Seal says A9 counts every line with CAPSULE in it? Your count included
>   your own test capsules. Use the anchored count from step 1.
> - Seal says A9's second number counts capsules sent TO the Board? The
>   sender is the office straight after `FROM`.
> - Seal says A10 does not carry the closing line? Copy the capsule's last
>   line again, word for word, onto the A10 line after the number.

**8. The closing command.** You have filed your answers and claimed M4. One
command left. If you opened an editor or a second terminal to fill
`answers.txt`, come back to this one — this is the last command of the
lab. From anywhere:

```sh
grep -h 'opening morning' ~/enginehouse/post/.drop-box/outbound-copy.txt
```

```
[ your bench prints a line here ]
```

Leave it on your screen.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 12 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, character for character — do not paraphrase:

- The `ls -lan` of the post, all four fittings with their owners.
- The copier's command line, as `/proc/<pid>/cmdline` gave it.
- The capsule with no sender: its header, its address line and its
  closing line, as written.

Three questions to write toward, none of which has an answer in this work
order:

1. Your capsule came out at the exchange end exactly as you sent it, and a
   copy of it went into the drop box. What does that let you say about the
   post's other traffic — and what does it leave unsaid?
2. A capsule went down this line with no sender given. What on the bench
   could tell you who sent it, and what could not?
3. What would you want to know next, and which command might show it?

Write a plain account of what the line carries and what the drop box
holds. The notebook is marked on being kept honestly and quoting exactly,
never on drawing the cleverest conclusion — least of all about people.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the line's.

1. In a paragraph: explain to someone who has never used a terminal why
   `ls /no-such-fitting 2>&1 > order.txt` left the complaint on the screen
   and `ls /no-such-fitting > both.txt 2>&1` did not, and what happens to
   `yes` in `yes | head -1`. Use **file descriptor**, **redirection**,
   **pipe** and **buffer** correctly at least once each. *zyBooks Ch 9.2
   (optional).*
2. In two or three sentences: you could read the copier's command line but
   not its table of open files. Is that the right place for the Engine to
   draw the wall between one account and another? What would you want a
   shared machine to show everyone about a process, and what should it keep
   to the process's owner? (There is no answer key.)

## Turn it in

Due **Sunday, 8 November, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)).

1. **`logbook.md`** — all four milestones: what you did, the seal pasted
   in, what it means. M1 wants the three descriptors, both of the
   redirection-order runs explained, the `/dev` type letters and numbers,
   and the `PIPESTATUS` line; M2 wants the two-terminal exchange, who held
   your tube, the split runs and the `tee` count; **M3 wants the line
   walked in full** — every fitting's type and owner, your capsule's two
   arrivals, the process found by its command line, and the wall that kept
   you out of its open files — which is the graded centre of the week; M4
   wants the counts, both tallies, and the capsule with no sender as
   written. Plus both reflection prompts and the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 12 entry.

Upload both files to the Week 12 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.)

**When your paperwork is in,** you may stand the bench down. From
`labs/week-12`:

```sh
bash report-for-duty.sh --reset
```

It asks for the house keys once more (the line's process and the drop box
are not yours, so only root can strike them), stops the line, and removes
the post, the tube shop with everything you made in it, and the line's
machinery. It leaves every other week's papers exactly where they are.

**The usual late window applies.** Late work is accepted for two calendar
days at a flat 20%, so this order's window closes on **Tuesday, 10
November**. Hand it in on Sunday.

How the tasks cover the five objectives: Task 1 is objectives 1, 2 and 3;
Task 2 is objectives 4 and 5 (on your own tube); Task 3 is objective 5 on a
process you do not own, and objective 4 on a line you did not build; Task 4
is objective 2 at work. The reflections cover them in your own words.

**Also on this week's docket.**

- **No required reading this week.** zyBooks **Ch 9** (I/O systems) is
  optional; 9.1 and 9.2 are the sections nearest this week's work.
- **Commission III — *The Pattern Loom*** (zyBooks 12.3, regular
  expressions) is due **Friday, 6 November, 11:59 pm, in zyBooks** — not
  Canvas.
- **Commission IV — *The Revision Registry*** (zyBooks 12.5, "Simple
  Versioning System") is due **Friday, 20 November, 11:59 pm, in zyBooks**
  — not Canvas. With no reading this week, it is the week's other work;
  the cover is at
  [`commissions/04-the-revision-registry.md`](../../commissions/04-the-revision-registry.md).
- **Commission V — *The Exchange Audit*** (zyBooks 12.4, "A Good Sport") is
  assigned next **Monday, 9 November**.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: FOUR. THREE SESSIONS. NO BREAK.`
> `THE LINE: WALKED, AND LEFT AS FOUND. THIS PORTER HEARD IT HISS.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap.

- **The buffer's size, measured.** Python can ask the kernel how big a new
  pipe's buffer is: `python3 -c "import fcntl,os; r,w=os.pipe(); print(fcntl.fcntl(w, 1032))"`
  prints `65536` — 64 KiB (1032 is `F_GETPIPE_SZ`). A program may ask for
  more, up to `/proc/sys/fs/pipe-max-size`.
- **Why a slow pipeline seems to stall.** Run a program whose output goes
  into a pipe, and the C library stops writing a line at a time and saves
  up a whole block first, so the next program sees nothing for a while.
  `stdbuf -oL` asks a program to write a line at a time again, and `grep`
  has its own `--line-buffered`. Try
  `(for i in 1 2 3; do echo "capsule $i"; sleep 1; done) | grep capsule | cat`,
  then the same with `grep --line-buffered`, and watch when the lines
  appear.
- **Your own descriptors.** `exec 4> ~/enginehouse/tube-shop/notes.txt`
  opens a file on descriptor 4 of your shell; `echo hi >&4` writes to it;
  `exec 4>&-` closes it. `ls -l /proc/$$/fd` shows your shell's table as
  you go — including a descriptor numbered 255, which bash keeps for
  itself.
- **A tube as a log.** `mkfifo` plus `tee`, on a long command:
  `long-command | tee run.log` keeps a copy while you watch.
- **How a descriptor is doing.** `/proc/<pid>/fdinfo/<n>` holds a
  descriptor's position and flags — for any of your own processes. Try
  `cat /proc/self/fdinfo/0`.
- **Watch the shell build a pipe.** Week 2's `strace`, one more time:
  `strace -f -e trace=pipe2,dup2 bash -c 'ls | wc -l'` shows bash asking
  for a pipe (`pipe2`) and then pointing each child's descriptor 1 or 0 at
  one end of it (`dup2`).
- **Build one in C.** Week 3's `fork()` again: a program that calls
  `pipe()`, then `fork()`, and in the child `dup2()`s the pipe's write end
  onto descriptor 1 before `exec`ing `ls`, while the parent reads the other
  end. That is all a shell's `|` is. No starter is shipped: `man 2 pipe`
  has a worked example.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"A line has no echo, unless somebody builds one."*
