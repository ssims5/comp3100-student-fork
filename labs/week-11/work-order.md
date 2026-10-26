# WORK ORDER No. 1851-11 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 26 October 1851 — six weeks to the Exhibition |
| **Due** | **Sunday, 1 November, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

The Exhibition ledger audit has begun, and the audit office has sent up
from the cellars a card cabinet of the Waterworks series, 1848. It has
been docketed as found and put on your bench.

It is not as it was. A cross-index points at pages, and a clerk's marker
points at the quarter in hand, but the correspondence drawer is empty, and
the docket says its memoranda were struck from the record. Some of the
ledger pages do not look right.

Struck is not the same as burned. A cabinet keeps a page in two parts:
the **name** on the drawer, and the **card** that holds what the page is
and where its words are kept. Strike the name and the card may still be
there, and the words with it, until somebody files something new on top
of them. This week you learn the difference, in your own folder first and
then in the cabinet, and you get back what was struck without changing a
single thing in the cabinet itself.

A cabinet under audit is evidence. You will read it, and you will not
write to it — not once, not by accident. Every page you take out of it
goes into a folder of your own.

Read every date on every page, the way a magistrate would, and write
down what you find. Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

A file is not one thing. It is a **name** in a directory, an **inode** that
says what the file is, and **blocks** that hold its bytes. Most of the
time you never see the joins between them. This week you look straight at
them: you give a file a second name, take a name away and watch the file
survive, attach a whole disk image to your tree without letting anything
write to it, and bring back files that were deleted, because deleting a
file mostly means deleting its name.

The fiction is set dressing and the commands are the course; **no task
here requires story knowledge.** By the time you hand this in you will be
able to:

1. **Explain what a name, an inode and a block each are.** A directory
   maps names to inode numbers. The inode (what zyBooks calls a *file
   control block*) holds the file's size, owner, permissions, times and
   the list of its blocks, but never its name. Blocks (*disk blocks*) hold
   the bytes. *zyBooks Ch 8.*
2. **Tell a hard link from a symbolic link by evidence.** A hard link is a
   second name for the same inode, and the inode's link count (the book's
   *reference count*) goes up by one. A *symbolic link* is a file of its
   own, with its own inode, that holds a path. You will show the
   difference with `ls -i` and `stat`, not by remembering it. *zyBooks
   Ch 8.*
3. **Say what `rm` actually removes, and when the space is really freed.**
   `rm` removes a name. The inode and its blocks are freed only when the
   link count reaches zero **and** no process still has the file open.
   *zyBooks Ch 8.*
4. **Mount a disk image read-only, and say why read-only.** Attach a file
   system's whole tree at a directory, through a loop device, so that
   nothing — you included — can write to it. *zyBooks Ch 8.*
5. **Read and interpret all three timestamps, and say which an ordinary
   user can forge.** Modification, change and access times: what moves
   each one, and which one follows the kernel's own clock. *zyBooks Ch 8.*
6. **Recover a deleted file from an ext2 image, and explain why the same
   move mostly fails on ext4.** *zyBooks Ch 8.*

Objective 3 is the one the Guild examines hardest. Missing is not the same
as gone, and an apprentice who knows the difference knows where to look.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `ls`, `stat`, `ln`, `mv`, `cat`,
`diff`, `findmnt`, `losetup`, `blkid` and **`debugfs`**, a file-system
debugger from the `e2fsprogs` package. Every setup path in this course
installs it. `debugfs` lives in `/usr/sbin`; if typing `debugfs` gives you
`debugfs: command not found`, type `/usr/sbin/debugfs` instead, everywhere
this work order says `debugfs`. Nothing needs a network.

This week has **one** `sudo`, and it is optional: in Task 2 you may attach
the cabinet to your tree with `sudo mount`. The work order says what it
does before you type it. If you cannot or would rather not, Task 2 gives
you the archivist's route, which needs no `sudo` at all and reaches every
answer and every seal. If your environment broke over the weekend,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds it.

**P2 — This folder, open in a Linux terminal.** Run the line that matches
your setup:

```sh
cd ~/comp3100-student/labs/week-11
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-11
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-11
```

**P3 — Report for duty.** One command stages your bench:

```sh
bash report-for-duty.sh
```

It needs no input and takes a second or two. Expected output:

```

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-11 :: bench staged and verified
  ------------------------------------------------------------------
   Cabinet:  ~/enginehouse/cabinets/cabinet-1848.img
   Drill:    ~/enginehouse/ledger-halls/drill/register.txt

   A card cabinet has come up from the cellars for the Exhibition
   ledger audit, and the audit office has docketed it as found.
   Some of its papers are missing, and some do not look right.

   The cabinet is evidence: read it, never write to it. It was built
   just now, on this bench, from sealed papers, and running this
   script again builds it afresh. Start with the drill.
   (bash report-for-duty.sh --reset withdraws all of it.)
  ------------------------------------------------------------------

```

Three things land under `~/enginehouse/`:

- `cabinets/cabinet-1848.img` — the cabinet: a small disk image, two
  megabytes, holding a whole file system of its own. It was built a moment
  ago, on your bench, and it belongs to you;
- `mnt/cabinet/` — an empty folder, ready for Task 2 to attach the cabinet
  to;
- `ledger-halls/drill/register.txt` — one practice page for Task 1.

The script starts nothing and leaves nothing running. It is always safe to
run it again: it builds the cabinet afresh every time, which also cures a
cabinet that has come to harm. It will not do that while the cabinet is
attached in Task 2; it says so and tells you how to detach it first.

**Never run `report-for-duty.sh` with `sudo`.** Building the cabinet needs
no house keys at all. Under `sudo` the script would stage **root's** home
folder instead of yours, and nothing this week — not the commands below,
not the seals — would find it there. It refuses before it touches
anything, and says so. The one `sudo` this week is the mount in Task 2,
typed by you, at the moment the work order explains it.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds ten short
answers — A1 to A10 — that the seal checks read; the template says what
goes where, and each task tells you when. Your running `case-notes.md` is
already at the repo root.

**P5 — One setting for `debugfs`, once in every terminal you use it in.**
On a terminal, `debugfs` shows its answers through a pager: the output
appears with `(END)` at the bottom, and when you press `q` to get your
prompt back, the output vanishes with it. This line turns that off for the
terminal you type it in:

```sh
export DEBUGFS_PAGER=__none__
```

It prints nothing. Type it again in any new terminal before you use
`debugfs` there. (Two underscores before and after `none`.)

**What varies, and what does not.** Your screen will differ from this work
order in the places that are your bench's own: your user name and home
folder (written `you` here), **inode numbers** (every bench numbers its own
files, and a bench with a different version of `e2fsprogs` may number the
cabinet's differently too), the loop device (`/dev/loop0`, `/dev/loop3`
and so on, written `/dev/loopN` here), process ids and file-descriptor
paths under `/proc`, the UTC offset `stat` prints after a time (`-0500` on
the bench these were taken from) and the numbers on its `Device:` line, the dates and times of anything you made
yourself, and the first line `debugfs` prints about its own version.
Wherever an inode number would appear, this work order writes `…` or a
run of capital letters: the number on your screen is the one that counts,
and the seals read it from your bench. **The wall-clock times on the
cabinet's pages do not vary**: `19:22` is `19:22` on every bench.

**A note on this week's size.** Three sessions: **Monday's deck**, then
**Wednesday's and Friday's studios**, no break. Four tasks, four seals,
about two and a half hours at the terminal — more than the two studios
hold, so plan on some of it at home. Tasks 1 and 2 are Wednesday's, with
Task 3 begun; **finish Task 3 before Friday**. **Task 4 is Friday's
work**: it ends with one command, and you want to be at your bench when
you type it. Claim each seal as soon as its task is done.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-11`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `cd: ... No such file or directory` for `labs/week-11`? Your copy of
>   the repo predates this week. From the repo root: `git pull`.
> - `$'\r': command not found`, or a `syntax error near unexpected token`
>   from the script? The file picked up Windows line endings on the way
>   down. From the repo root: `git checkout -- .` and try again.
> - `report-for-duty: run this as YOURSELF, not as root.`? You typed
>   `sudo` in front of it. Building the cabinet needs no `sudo`; run it
>   again without it.
> - The script says a tool is missing, or `debugfs: command not found`
>   even as `/usr/sbin/debugfs`? Your bench has lost `e2fsprogs`. Run the
>   *"a tool is missing"* fix in `setup/getting-started.md`
>   (Troubleshooting), then run the script again.
> - `report-for-duty: the cabinet is attached at ~/enginehouse/mnt/cabinet`?
>   You mounted it in Task 2 and it is still attached. Do what the
>   message says (`cd ~`, then `sudo umount ~/enginehouse/mnt/cabinet`),
>   then run the script again.
> - You ran `--reset` and want the bench back? Run
>   `bash report-for-duty.sh` again. It is idempotent.

---

## Task 1 — Names and numbers *(~35 minutes → Seal M1)*

No cabinet yet. This task is one practice page in a folder of your own,
and four commands you already half know: `ls`, `stat`, `ln` and `rm`.

**1. Meet the page, and its number.**

```sh
cd ~/enginehouse/ledger-halls/drill
ls -li
```

Expected — `NNNNN` stands for a number, different on every bench:

```
total 4
NNNNN -rw-r--r-- 1 you you 157 Oct 11 10:55 register.txt
```

`-i` adds the first column: the file's **inode number**. An **inode** is
the record the file system keeps for each file: its size, its owner, its
permissions, its three times, and the list of blocks on the disk where its
bytes are kept. zyBooks Ch 8 calls this record a **file control block**;
on Linux it is an inode, and every inode has a number. What the inode does
**not** hold is the file's name. The name lives in the directory, and a
directory (a *file directory*, in the book) is nothing more than a list of
pairs: *this name, that inode number*.

The `1` after the permissions is the **link count**: how many names, in
all the directories on this file system, point at this inode. The book
calls it the *reference count*. One page, one name, so far.

Now ask the inode itself:

```sh
stat register.txt
```

Expected (your times are the moment you staged, and your offset may not
be `-0500`):

```
  File: register.txt
  Size: 157       	Blocks: 8          IO Block: 4096   regular file
Device: 8,48	Inode: NNNNN       Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/     you)   Gid: ( 1000/     you)
Access: 2026-10-11 10:55:52.543320428 -0500
Modify: 2026-10-11 10:55:52.251361472 -0500
Change: 2026-10-11 10:55:52.251361472 -0500
 Birth: 2026-10-11 10:48:30.238925233 -0500
```

`Inode:` and `Links:` are the two numbers `ls -li` gave you. The three
times are Task 3's business; leave them for now. Write the inode number of
`register.txt` in your logbook, under **Milestone 1**: it is **A1**.

**2. A second name.**

```sh
ln register.txt second-name.txt
ls -li
```

Expected:

```
total 8
NNNNN -rw-r--r-- 2 you you 157 Oct 11 10:55 register.txt
NNNNN -rw-r--r-- 2 you you 157 Oct 11 10:55 second-name.txt
```

Two lines, **one number**. `ln` did not copy anything: it wrote a second
pair into the directory, *second-name.txt → NNNNN*, and the inode's link
count went from 1 to 2. Both names are equally the file; neither is the
"real" one and neither is a shortcut. This is a **hard link**. (A file
system where one file can sit under more than one name is what the book
calls a *directed acyclic directory hierarchy*: a tree that is allowed to
share its leaves.)

**3. Write down the count.** In your logbook: the link count `ls -li`
showed just now, straight after `ln`. It is **A2**. Write it before you go
on, because step 5 changes it.

**4. A pointer.**

```sh
ln -s register.txt pointer
ls -li
```

Expected — `PPPPP` is another number, not the page's:

```
total 8
PPPPP lrwxrwxrwx 1 you you  12 Oct 11 10:55 pointer -> register.txt
NNNNN -rw-r--r-- 2 you you 157 Oct 11 10:55 register.txt
NNNNN -rw-r--r-- 2 you you 157 Oct 11 10:55 second-name.txt
```

`ln -s` makes a **symbolic link** (the book's term too). Read the evidence:
it has **its own inode number**, its type is `l`, its size is `12` — the
twelve characters of `register.txt` — and `->` shows what it holds: not
the page, but a **path** to the page. The page's link count did not move.
A symbolic link points by name, and a name is all it knows.

**5. Strike a name.**

```sh
rm register.txt
ls -li
cat second-name.txt
cat pointer
```

Expected:

```
total 4
PPPPP lrwxrwxrwx 1 you you  12 Oct 11 10:55 pointer -> register.txt
NNNNN -rw-r--r-- 1 you you 157 Oct 11 10:55 second-name.txt
LEDGER HALLS -- DRILL REGISTER
Brassbridge Enginehouse

  A practice page. One page, one number: give it a second name, strike a
  name, and see what stays.
cat: pointer: No such file or directory
```

`rm` removed **a name**. The inode is still there with the same number,
its link count is back to 1, and its words are untouched: the other name
opens it as if nothing happened. The pointer, though, is broken. It still
holds the path `register.txt`, and there is no longer any such name, so
it leads nowhere, even though the page it used to reach is sitting right
beside it. *Missing is not the same as gone.*

**6. Give the page its name back.**

```sh
mv second-name.txt register.txt
ls -li
cat pointer
```

Expected:

```
total 4
PPPPP lrwxrwxrwx 1 you you  12 Oct 11 10:55 pointer -> register.txt
NNNNN -rw-r--r-- 1 you you 157 Oct 11 10:55 register.txt
LEDGER HALLS -- DRILL REGISTER
Brassbridge Enginehouse

  A practice page. One page, one number: give it a second name, strike a
  name, and see what stays.
```

`mv` within one file system only renames: it moves the pair in the
directory and leaves the inode alone, so the number is the one you wrote
down as A1. And the pointer works again, because the path it holds leads
somewhere once more. Nothing about the pointer changed; the directory
did.

**Checkpoint.** You should be able to say, without looking: which of the
three things `ln`, `ln -s` and `rm` changed — a name, an inode, or a link
count — and why `cat pointer` failed in step 5 and worked in step 6 when
the pointer itself never changed.

**7. Open it, strike it, read it anyway.** Now the case where the last
name goes, but somebody is still holding the file open. You will be the
somebody: your own shell.

```sh
cp register.txt page.txt
exec 3< page.txt
rm page.txt
ls page.txt
ls -l /proc/$$/fd/3
```

`exec 3< page.txt` tells your shell to open `page.txt` for reading and keep
it open as its **file descriptor 3**, with nothing reading from it yet.
`$$` is your shell's own process id, and `/proc/<pid>/fd/` lists every
file that process holds open, one entry per descriptor. Expected — the
process id after `/proc/` is your shell's, different every time:

```
ls: cannot access 'page.txt': No such file or directory
lr-x------ 1 you you 64 Oct 11 10:55 /proc/…/fd/3 -> /home/you/enginehouse/ledger-halls/drill/page.txt (deleted)
```

The name is gone; `ls` cannot find it. But the kernel still shows your
shell holding the file, and it puts one word in brackets at the end of
the line. That word is **A3**. The file has a link count of 0 now, and it
is still not freed, because a process has it open: the kernel keeps an
entry for every open file (the book's *open file table*), and while that
entry is there, the inode and its blocks stay. Read it back while you
can:

```sh
cat /proc/$$/fd/3 > recovered-page.txt
exec 3<&-
ls -li
```

Expected:

```
total 8
PPPPP lrwxrwxrwx 1 you you  12 Oct 11 10:55 pointer -> register.txt
RRRRR -rw-r--r-- 1 you you 157 Oct 11 10:55 recovered-page.txt
NNNNN -rw-r--r-- 1 you you 157 Oct 11 10:55 register.txt
```

`exec 3<&-` closed descriptor 3. At that moment the last thing holding the
struck page let go, and the kernel freed it. Its words survive only
because you copied them out first, into `recovered-page.txt`, which is a
new file with a new inode of its own.

This is the whole of the week in one rule: **a file's space is freed only
when its link count is 0 and no process holds it open.** Until both are
true, it is missing, not gone. Task 4 finds the third way a struck file
can stay findable, inside the cabinet.

**One story for "deleted."** The deck, this work order and the
examination all use this table. You have just done the first two rows;
Task 4 does the third, and the last two are why the cabinet is handled the
way it is:

| What happened | Name? | Inode? | Bytes? | How you get it back |
|---|---|---|---|---|
| `rm` of one of two hard links | one name left | live, link count 1 | intact | use the other name |
| `rm` while a process holds it open | gone | live until the last close | intact | `/proc/<pid>/fd/<n>` |
| `rm` of the last name, nothing open (ext2) | struck, though the name may linger in the directory's slack | freed, but its block map is kept | intact until reused | `debugfs lsdel`, then `dump <N>` |
| the same on ext4 | struck | freed, and its extent map is cleared | lingering but unmapped | carving tools only, which are out of scope |
| blocks reused by a later write | — | — | overwritten | gone. This is why evidence is mounted **read-only** |

**8. Go back, and file what you found.** You are still in the drill
folder. `cd -` means "back to the folder I was in before the last `cd`",
which was `labs/week-11`, and it prints where it landed:

```sh
cd -
```

If what it prints does not end in `labs/week-11`, re-run the P2 `cd` line
that matches your setup instead. Then, in `check/answers.txt`:

- **`A1:`** — the inode number of `register.txt` (step 1). One number.
- **`A2:`** — its link count straight after your `ln` (step 3). One
  number.
- **`A3:`** — the word in brackets at the end of the fd 3 line (step 7).

**9. Claim the seal** — from `labs/week-11`:

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-11/check'
  ~~~ WAX SEAL of the Guild: ECCC5D52 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-11/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 1** with, in your own words: what `ln`, `ln -s`
and `rm` each changed, as your `ls -li` lines showed it; why the pointer
broke and came back; and the rule for when a file's space is really freed.

> **If you're lost, start here (Task 1).**
> - `cd: /home/.../ledger-halls/drill: No such file or directory`? Your
>   bench is not staged, or you reset it. From `labs/week-11`:
>   `bash report-for-duty.sh`.
> - `ln: failed to create hard link 'second-name.txt': File exists`? You
>   ran step 2 twice. `ls -li` will show both names already there; carry
>   on from step 3.
> - `ln: failed to create symbolic link 'pointer': File exists`? Same:
>   it is already made. Carry on.
> - `rm: cannot remove 'register.txt': No such file or directory` in step
>   5? You already struck it. `ls -li` shows what is left; step 6 gives
>   the page its name back.
> - `mv: cannot stat 'second-name.txt'`? There is no second name to
>   rename. If `register.txt` is there, you are fine. If neither name is
>   there, the page is gone for good: from `labs/week-11`,
>   `bash report-for-duty.sh` lays a fresh page — under a new number, so
>   read A1 again from `ls -li`.
> - `ls -l /proc/$$/fd/3` says `No such file or directory`? Descriptor 3
>   is not open in **this** shell — you closed it, or ran `exec 3<` in
>   another terminal. Start step 7 again from `cp`, all in one terminal.
> - `bash: page.txt: No such file or directory` on `exec 3< page.txt`?
>   Run the `cp` line first.
> - Your terminal closed when you typed an `exec` line? You typed `exec`
>   with something other than `3<` after it, which replaces the shell.
>   Open a new terminal, `cd ~/enginehouse/ledger-halls/drill`, and start
>   step 7 again.
> - `make: *** check: No such file or directory.  Stop.`? You are not in
>   `labs/week-11`. Run the `cd` line from P2 that matches your setup, then
>   claim the seal again.
> - Seal says the drill page has no name just now? `register.txt` is
>   missing: step 6 gives it back with `mv`.
> - Seal says A1 is the number of `pointer`? A symbolic link has a number
>   of its own. A1 wants the page's.
> - Seal says A1 is not the number `register.txt` carries now? Run
>   `ls -li` in the drill folder and copy the first column of the
>   `register.txt` line. If you staged again since step 1, the page may
>   have a new number.
> - Seal says A2 is 1? That is the count of one name. A2 wants it straight
>   after `ln`, before any `rm`.
> - Seal refuses A3? Copy the one word at the very end of the
>   `ls -l /proc/$$/fd/3` line from step 7, without the brackets.

---

## Task 2 — The cabinet, under the magistrate's rule *(~35 minutes → Seal M2)*

The cabinet is a **disk image**: one ordinary file, `cabinet-1848.img`,
whose bytes are laid out exactly as a disk's would be, with a whole file
system inside — its own directories, its own inodes, its own blocks. You
can look at it two ways. You can **mount** it: attach its tree at an
empty folder of yours, so that `ls`, `cat` and `stat` work on it like any
other folder. Or you can open the image file with `debugfs` and ask the
file system directly. Both are here. Do the first if you can, and
whichever you do, read the second.

**1. The cabinet, from outside.**

```sh
ls -l ~/enginehouse/cabinets/
ls -A ~/enginehouse/mnt/cabinet
```

Expected — one file of exactly 2 MiB, and an empty folder (the second
command prints nothing):

```
total 132
-rw-r--r-- 1 you you 2097152 Oct 11 10:55 cabinet-1848.img
```

To attach a file system, the kernel wants a **disk**, and this is a file.
A **loop device** bridges the two: it presents a file to the kernel as if
it were a disk. `mount -o loop` sets one up for you, and `-o ro` makes the
attachment **read-only**: the kernel will refuse every write to anything
under the mount point, whoever asks.

Why read-only? Because this is evidence, and on the file system inside it,
**a struck page's bytes stay on the disk only until something else is
written over them** (the last row of the table in Task 1). One careless
write — even the kernel updating an access time when you read a page —
could land on the very blocks Task 4 needs. Read-only is not caution; it
is how evidence is handled.

> **THE CABINET KEY — this step uses sudo.**
> *What it does:* attaches the cabinet's tree at
> `~/enginehouse/mnt/cabinet`, **read-only**, through a loop device.
> Mounting needs root because it changes what every user on the machine
> sees in the directory tree, and because a file system the kernel reads
> is trusted as far as the kernel itself.
> *Why it is safe:* it is read-only, so nothing can be written to the
> cabinet while it is attached. The image is your own file, made by the
> staging script on your bench a moment ago. And it is undone by one
> command, which puts everything back exactly as it was.
> *The exact command, and no other:*
> `sudo mount -o loop,ro ~/enginehouse/cabinets/cabinet-1848.img ~/enginehouse/mnt/cabinet`
> *How it ends:* step outside it, then detach it — `cd ~` and then
> `sudo umount ~/enginehouse/mnt/cabinet`. Task 3 tells you when. A reboot
> or `wsl --shutdown` detaches it too, harmlessly.
> *The password:* most of you will never be asked for one. Paths A and B
> (WSL2 and Multipass) both come with passwordless `sudo`, so the command
> simply runs. If you *are* prompted — a native Linux bench (Path C), or a
> distro you built yourself rather than from `setup/` — it wants your own
> account's login password, the one you chose when you created the user;
> there is no separate course password anywhere.

> **No sudo? Take the archivist's route.** Every answer and every seal
> this week is reachable either way. `debugfs` opens the image file
> directly, as your own user, and reads it **read-only** unless you give
> it `-w` — which this work order never does. You do not attach anything,
> so there is nothing to detach. Here is each mount-route command and the
> archivist's command that answers the same question (type P5's `export`
> line first):
>
> | Mount route | Archivist's route |
> |---|---|
> | `sudo mount -o loop,ro …` | nothing to attach |
> | `findmnt`, `losetup -a` | nothing to show: nothing is attached |
> | `stat -f ~/enginehouse/mnt/cabinet` | `blkid ~/enginehouse/cabinets/cabinet-1848.img` |
> | `ls -lai ledgers` (inside the cabinet) | `debugfs -R "ls -l /ledgers" ~/enginehouse/cabinets/cabinet-1848.img` |
> | `stat ledgers/table-ix-1848-q1.txt` | `debugfs -R "stat /ledgers/table-ix-1848-q1.txt" ~/enginehouse/cabinets/cabinet-1848.img` |
> | `cat README-cabinet.txt` | `debugfs -R "cat /README-cabinet.txt" ~/enginehouse/cabinets/cabinet-1848.img` |
> | `touch ledgers/note.txt` (refused) | nothing to try: without `-w`, `debugfs` cannot write |
> | `cd ~` then `sudo umount …` | nothing to detach |
>
> Inside `debugfs -R "…"`, a path starts at the **cabinet's** own root,
> `/`, not yours. Each step below shows the archivist's command beside the
> mount route's.

**2. Attach it** (mount route). Read the box, then type its command:

```sh
sudo mount -o loop,ro ~/enginehouse/cabinets/cabinet-1848.img ~/enginehouse/mnt/cabinet
```

It prints nothing when it works. Ask the system what it now has attached
there, and through what:

```sh
findmnt ~/enginehouse/mnt/cabinet
losetup -a
```

Expected — `N` is the loop device's number, often `0`:

```
TARGET                               SOURCE     FSTYPE OPTIONS
/home/you/enginehouse/mnt/cabinet /dev/loopN ext2   ro,relatime,errors=continue
/dev/loopN: []: (/home/you/enginehouse/cabinets/cabinet-1848.img)
```

`findmnt` reads the system's table of mounts: what is attached at that
folder (`TARGET`), from where (`SOURCE`, the loop device), what kind of
file system it is (`FSTYPE`) and how it is attached (`OPTIONS`, with `ro`
first: read-only). `losetup -a` lists the loop devices and the file
behind each one: your cabinet.

**3. Prove it is read-only** (mount route). Try to write one small note
into it:

```sh
touch ~/enginehouse/mnt/cabinet/ledgers/note.txt
```

Expected:

```
touch: cannot touch '/home/you/enginehouse/mnt/cabinet/ledgers/note.txt': Read-only file system
```

Good. That refusal is the point of `ro`.

**4. What kind of file system, and what size of block?** Mount route:

```sh
stat -f ~/enginehouse/mnt/cabinet
```

Expected (the `ID` varies):

```
  File: "/home/you/enginehouse/mnt/cabinet"
    ID: … Namelen: 255     Type: ext2/ext3
Block size: 1024       Fundamental block size: 1024
Blocks: Total: 2027       Free: 1995       Available: 1893
Inodes: Total: 64         Free: 41
```

`stat -f` describes the **file system**, not a file. `Type: ext2/ext3`
is how `stat` names this family; `findmnt` in step 2 was more exact.
`Block size` is the size, in bytes, of one **disk block** here: the unit
the file system hands out space in. Archivist's route, the same two facts:

```sh
blkid ~/enginehouse/cabinets/cabinet-1848.img
```

Expected (the `UUID` varies):

```
/home/you/enginehouse/cabinets/cabinet-1848.img: LABEL="cabinet-1848" UUID="…" BLOCK_SIZE="1024" TYPE="ext2"
```

Write the cabinet's type and block size in your logbook: they are **A4**.
Your own home folder is almost certainly **ext4**, with 4096-byte blocks.
The cabinet is the older **ext2**, which keeps no **journal**: ext3 and
ext4 write down each change they are about to make before making it, so
that a crash halfway through can be tidied up, and ext2 does not. Ext4 also
keeps a file's block list differently (as *extents*), and that difference
is the whole of Task 4's last paragraph. Hold on to it.

**Checkpoint.** You should be able to say what a loop device is for, what
the `ro` in `findmnt`'s options means for anyone trying to write, and
what kind of file system the cabinet holds.

**5. Walk the cabinet.** Mount route:

```sh
cd ~/enginehouse/mnt/cabinet
ls -lai
ls -lai ledgers
```

Expected — each `…` is an inode number on your screen:

```
total 21
    … drwxr-xr-x 6 you  you   1024 Oct 24  2026 .
    … drwxr-xr-x 3 you  you   4096 Oct 11 10:48 ..
    … -rw-r--r-- 1 you  you    764 Oct 24  2026 README-cabinet.txt
    … drwxr-xr-x 3 you  you   1024 Oct 24  2026 correspondence
    … lrwxrwxrwx 1 you  you     28 Oct 24  2026 current-quarter -> ledgers/table-ix-1848-q4.txt
    … drwxr-xr-x 3 you  you   1024 Oct 24  2026 index
    … drwxr-xr-x 2 you  you   1024 Oct 24  2026 ledgers
    … drwx------ 2 root root 12288 Oct 24  2026 lost+found
total 7
 … drwxr-xr-x 2 you you 1024 Oct 24  2026 .
 … drwxr-xr-x 6 you you 1024 Oct 24  2026 ..
 … -rw-r--r-- 1 you you  511 Oct 23  2026 district-balances-1848.txt
 … -rw-r--r-- 1 you you  632 Sep 16 19:22 table-ix-1848-q1.txt
 … -rw-r--r-- 2 you you  631 Sep 18 19:07 table-ix-1848-q2.txt
 … -rw-r--r-- 1 you you  636 Sep 23 19:36 table-ix-1848-q3.txt
 … -rw-r--r-- 1 you you  635 Oct 14  2026 table-ix-1848-q4.txt
```

A few things to read off that. `..` in the cabinet's top folder is **your**
`mnt` folder, on your own file system (4096-byte blocks): the mount point
is where the two trees join. `lost+found` belongs to root and is where a
file-system check files pieces it finds without a name; every ext file
system has one. The cabinet's own folders are yours, because the staging
script built them as you. Some dates above show a year where a time of
day should be: plain `ls -l` does that for any date later than now or more
than six months back, and these were taken on 11 October, before the
cabinet's last dates. Yours may show times there instead. Task 3 asks for
every time in full, with the weekday, which settles it.

Archivist's route, the same folders (the bracketed number after the mode
is the **kind** of entry — 1 a file, 2 a folder, 7 a symbolic link — not
a link count):

```sh
debugfs -R "ls -l /" ~/enginehouse/cabinets/cabinet-1848.img
debugfs -R "ls -l /ledgers" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected — `1000` is your own user number, and may differ:

```
debugfs 1.47.0 (5-Feb-2023)
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 .
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 ..
      …   40700 (2)      0      0   12288 24-Oct-2026 10:00 lost+found
      …  100644 (1)   1000   1000     764 24-Oct-2026 10:00 README-cabinet.txt
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 correspondence
      …  120777 (7)   1000   1000      28 24-Oct-2026 10:00 current-quarter
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 index
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 ledgers

debugfs 1.47.0 (5-Feb-2023)
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 .
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 ..
      …  100644 (1)   1000   1000     511 23-Oct-2026 20:03 district-balances-1848.txt
      …  100644 (1)   1000   1000     632 16-Sep-2026 19:22 table-ix-1848-q1.txt
      …  100644 (1)   1000   1000     631 18-Sep-2026 19:07 table-ix-1848-q2.txt
      …  100644 (1)   1000   1000     636 23-Sep-2026 19:36 table-ix-1848-q3.txt
      …  100644 (1)   1000   1000     635 14-Oct-2026 19:41 table-ix-1848-q4.txt

```

The first line, `debugfs 1.47.0 (5-Feb-2023)`, is `debugfs` announcing its
own version, on every call; yours may name another. Ignore it.

**6. The page filed under two headings.** The docket (Task 3) calls
`index/` the cabinet's cross-index. Look inside it, and in the empty
drawer while you are there:

```sh
ls -lai index/waterworks
ls -lai correspondence/memoranda-1848
```

Archivist's route:

```sh
debugfs -R "ls -l /index/waterworks" ~/enginehouse/cabinets/cabinet-1848.img
debugfs -R "ls -l /correspondence/memoranda-1848" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected for the cross-index — mount route, then archivist's (`…` and
`NNNNN` are inode numbers on your screen; `NNNNN` is the page's):

```
total 3
    … drwxr-xr-x 2 you you 1024 Oct 24  2026 .
    … drwxr-xr-x 3 you you 1024 Oct 24  2026 ..
NNNNN -rw-r--r-- 2 you you  631 Sep 18 19:07 table-ix-1848-q2.txt
```

```
debugfs 1.47.0 (5-Feb-2023)
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 .
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 ..
  NNNNN  100644 (1)   1000   1000     631 18-Sep-2026 19:07 table-ix-1848-q2.txt
```

The memoranda folder holds only `.` and `..`: nothing to `ls`. The
cross-index holds one page. Put its number beside the numbers you saw in
`ledgers`. One inode, two names, in two different folders: the page is
filed under two headings, and it is **one** page. That shared inode number
is **A5**.

**7. Which is the link, and which is the pointer?** Ask each one for its
inode. Mount route — the cabinet's symbolic link first:

```sh
stat current-quarter
```

Expected:

```
  File: current-quarter -> ledgers/table-ix-1848-q4.txt
  Size: 28        	Blocks: 0          IO Block: 1024   symbolic link
Device: 7,0	Inode: …           Links: 1
Access: (0777/lrwxrwxrwx)  Uid: ( 1000/     you)   Gid: ( 1000/     you)
Access: 2026-10-24 10:00:00.000000000 -0500
Modify: 2026-10-24 10:00:00.000000000 -0500
Change: 2026-10-24 10:00:00.000000000 -0500
 Birth: -
```

Archivist's route:

```sh
debugfs -R "stat /current-quarter" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected (`debugfs` prints its times in your zone, without an offset):

```
debugfs 1.47.0 (5-Feb-2023)
Inode: …   Type: symlink    Mode:  0777   Flags: 0x0
Generation: 0    Version: 0x00000000:00000000
User:  1000   Group:  1000   Project:     0   Size: 28
File ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x…:00000000 -- Sat Oct 24 10:00:00 2026
 atime: 0x…:00000000 -- Sat Oct 24 10:00:00 2026
 mtime: 0x…:00000000 -- Sat Oct 24 10:00:00 2026
crtime: 0x…:00000000 -- Sat Oct 24 10:00:00 2026
Size of extra inode fields: 32
Fast link dest: "ledgers/table-ix-1848-q4.txt"
```

The clerks' marker is a **symbolic link**: its own inode, its own times, a
size of 28 (the length of the path it holds), and the path itself —
`Fast link dest`, in `debugfs`'s words, because a path this short is kept
inside the inode instead of in a block. It is not the page; it says where
to find the page.

Now `stat` the page from step 6, **by both of its names** — the copy in
`ledgers/` and the copy in `index/waterworks/` — with `stat` on the mount
route or `debugfs -R "stat /…"` on the archivist's. Same inode, same size,
same times: one page. Its `Links:` line is **A6**.

**Checkpoint.** Two links in the cabinet, two kinds. You should be able
to say which name is the hard link and which is the symbolic link, and
point at the line of your own output that proves each: one shares a
number, the other has its own and holds a path.

**8. Leave the cabinet attached, and file what you found.** If you mounted
it, leave it attached: Task 3 reads it again. Go back to the lab folder
(the P2 `cd` line that matches your setup), and in `check/answers.txt`:

- **`A4:`** — the cabinet's file-system type and its block size in bytes
  (step 4).
- **`A5:`** — the inode number the page's two names share (step 6). One
  number.
- **`A6:`** — that inode's link count (step 7). One number.

**9. Claim the seal** — from `labs/week-11`:

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-11/check'
  ~~~ WAX SEAL of the Guild: 8CFE54A2 ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-11/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 2** with: which route you took; what a loop
device and a read-only mount are for, in a sentence each; the cabinet's
type and block size; and the cabinet's two links — which is which, and
the line of output that told you.

> **If you're lost, start here (Task 2).**
> - `mount: ... failed to setup loop device` or `must be superuser to use
>   mount`? You left out `sudo`. Type the box's command exactly, `sudo`
>   first — or take the archivist's route, which needs none.
> - `mount: ... already mounted on ...`? It is already attached. Carry on;
>   `findmnt ~/enginehouse/mnt/cabinet` shows it.
> - `sudo: ...` and a password you do not know, or `user is not in the
>   sudoers file`? Take the archivist's route; it reaches every answer.
>   Bring the `sudo` question to studio.
> - `findmnt` printed nothing at all? Nothing is attached there. On the
>   mount route, mount it (step 2). On the archivist's route, that is
>   expected.
> - `touch: cannot touch '...': No such file or directory`? The cabinet is
>   not attached, so the mount folder is still empty and has no `ledgers`
>   in it. Mount it (step 2), or take the archivist's route.
> - `debugfs` output ends with `(END)` at the bottom, and vanishes when you
>   press `q`? Type P5's `export DEBUGFS_PAGER=__none__` in this terminal,
>   then run the command again.
> - `debugfs: command not found`? Type `/usr/sbin/debugfs` in its place.
> - `debugfs` says `File not found by ext2_lookup`? Inside `-R "…"`, paths
>   start at the cabinet's root and are spelled exactly: `/ledgers`, not
>   `ledgers/` or `~/…`.
> - `debugfs` says `No such file or directory while trying to open`?
>   The image path at the end is wrong, or your bench is not staged.
>   `ls ~/enginehouse/cabinets/` shows it; from `labs/week-11`,
>   `bash report-for-duty.sh` stages it.
> - `make: *** check: No such file or directory.  Stop.`? You are still
>   inside the cabinet. Run the P2 `cd` line, then claim the seal again.
> - Seal says A4 names a type the cabinet is not? You read your home
>   folder's file system, not the cabinet's. Use `stat -f` on the mount
>   point, or `blkid` on the image.
> - Seal says A4 carries 4096? Same mistake, for the block size.
> - Seal says A5 is the number of the cabinet's symbolic link? The marker
>   is a file of its own. A5 wants the number two **names** share.
> - Seal says A5 is not the number the two names share? Look for one
>   number printed beside two different names, in `ledgers` and in
>   `index/waterworks`.
> - Seal says A6 is 1? Read `Links:` in `stat` for the page in A5.

---

## Task 3 — Every timestamp, like a magistrate *(~35 minutes → Seal M3)*

Every inode carries three clocks:

- **mtime**, *modify*: when the file's **contents** were last written;
- **ctime**, *change*: when the **inode** itself last changed — a write,
  but also a rename, a new link, new permissions;
- **atime**, *access*: when the contents were last **read**.

`stat` prints all three, as `Modify`, `Change` and `Access`. (The fourth
line, `Birth`, is when the inode was made. The kernel's ext2 driver does
not report it, so the cabinet's pages say `Birth: -`.)

An ordinary user can set two of the three by hand on their own files:
`touch -d` sets mtime and atime to any date you like. **ctime** cannot be
set that way. The kernel stamps it from its own clock whenever the inode
changes, and setting the other two is itself a change, so ctime moves to
*now*. (*For the curious* lets you watch it happen.) A careful reader
reads all three, and notes whether they agree.

This task asks you to read and record. It does not ask what anything
means.

**1. Back into the cabinet.** Mount route: if it is still attached
(`findmnt ~/enginehouse/mnt/cabinet` prints a line), go in; if not, attach
it again with the box's one command first.

```sh
cd ~/enginehouse/mnt/cabinet
stat ledgers/table-ix-1848-q1.txt
```

Expected:

```
  File: ledgers/table-ix-1848-q1.txt
  Size: 632       	Blocks: 2          IO Block: 1024   regular file
Device: 7,0	Inode: …           Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/     you)   Gid: ( 1000/     you)
Access: 2026-09-16 19:22:05.000000000 -0500
Modify: 2026-09-16 19:22:05.000000000 -0500
Change: 2026-09-16 19:22:05.000000000 -0500
 Birth: -
```

Archivist's route:

```sh
debugfs -R "stat /ledgers/table-ix-1848-q1.txt" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected — the same three clocks, each with its weekday, plus `crtime`:
the creation time this inode keeps in its extra space, which `debugfs`
shows and the kernel's ext2 driver does not:

```
debugfs 1.47.0 (5-Feb-2023)
Inode: …   Type: regular    Mode:  0644   Flags: 0x0
Generation: 0    Version: 0x00000000:00000000
User:  1000   Group:  1000   Project:     0   Size: 632
File ACL: 0
Links: 1   Blockcount: 2
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x…:00000000 -- Wed Sep 16 19:22:05 2026
 atime: 0x…:00000000 -- Wed Sep 16 19:22:05 2026
 mtime: 0x…:00000000 -- Wed Sep 16 19:22:05 2026
crtime: 0x…:00000000 -- Wed Sep 16 19:22:05 2026
Size of extra inode fields: 32
BLOCKS:
(0):…
TOTAL: 1

```

(The `0x…` before each date is the same instant as a raw count of
seconds, written in hex. Its digits depend on your bench's time zone, so
they are not shown here; step 5 comes back to what it counts. `BLOCKS` is
the page's block list, and Task 4's.)

**2. All five pages, with their weekdays.** Mount route:

```sh
ls -l --time-style='+%a %F %T' ledgers
```

`--time-style` tells `ls` how to print the time: `%a` the weekday, `%F`
the date as year-month-day, `%T` the time as hours:minutes:seconds, on the
24-hour clock. Expected:

```
total 5
-rw-r--r-- 1 you you 511 Fri 2026-10-23 20:03:18 district-balances-1848.txt
-rw-r--r-- 1 you you 632 Wed 2026-09-16 19:22:05 table-ix-1848-q1.txt
-rw-r--r-- 2 you you 631 Fri 2026-09-18 19:07:40 table-ix-1848-q2.txt
-rw-r--r-- 1 you you 636 Wed 2026-09-23 19:36:12 table-ix-1848-q3.txt
-rw-r--r-- 1 you you 635 Wed 2026-10-14 19:41:27 table-ix-1848-q4.txt
```

That is each page's **mtime**. Run it twice more, with `-lu` (atime) and
`-lc` (ctime) in place of `-l`, and compare the three listings line by
line.

Archivist's route: `debugfs -R "stat /ledgers/<page>" …` for each of the
five pages, as in step 1; the weekday is the first word of each date.
(`debugfs -R "ls -l /ledgers" …` from Task 2 gives every date and time at
once, but no weekday. `date -d 2026-09-16 +%a` prints the weekday of any
date: `Wed`.)

In your logbook, under **Milestone 3**, make a table with one row per
page: the page, the weekday, the date, and the time it was last written.
Then say, for each page, whether its three clocks agree. Then look at the
cabinet's own top folder the same way:

```sh
ls -l --time-style='+%a %F %T'
```

Expected:

```
total 16
-rw-r--r-- 1 you  you    764 Sat 2026-10-24 10:00:00 README-cabinet.txt
drwxr-xr-x 3 you  you   1024 Sat 2026-10-24 10:00:00 correspondence
lrwxrwxrwx 1 you  you     28 Sat 2026-10-24 10:00:00 current-quarter -> ledgers/table-ix-1848-q4.txt
drwxr-xr-x 3 you  you   1024 Sat 2026-10-24 10:00:00 index
drwxr-xr-x 2 you  you   1024 Sat 2026-10-24 10:00:00 ledgers
drwx------ 2 root root 12288 Sat 2026-10-24 10:00:00 lost+found
```

Those are the cabinet's folders, its docket and its marker, not its pages.
Add one line under your table for them.

**Checkpoint.** Five rows, each with a weekday, a date and a time to the
second, and a word on whether each page's three clocks agree. If any row
is missing its weekday, that row is not done.

**3. The docket.** Mount route:

```sh
cat README-cabinet.txt
```

Archivist's route:

```sh
debugfs -R "cat /README-cabinet.txt" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected — in full, and the same on every bench:

```
EXHIBITION AUDIT OFFICE -- DOCKET
Card cabinet, Waterworks series, 1848

  This cabinet came up from the cellars for the Exhibition ledger
  audit, and is entered here as it was found.

  ledgers/ ............ Table IX of the Waterworks, the four quarters
                        of 1848, and the district balances for the year
  index/ .............. the cabinet's cross-index, by department
  current-quarter ..... the clerks' marker for the quarter in hand
  correspondence/ ..... memoranda to the Board, 1848. Struck by order
                        of the Board, 1849.

  HOUSE RULE. The ledger halls and the reading room close at the
  bell, six o'clock (18:00). Visiting days are Wednesdays and Fridays.

  A cabinet under audit is read, and never written.
```

Copy the **HOUSE RULE** paragraph into your logbook, word for word,
directly beneath your table. Write nothing between them. A magistrate
records first.

Then, from your table: which of the five pages was written **latest**, and
at what time of day, as `HH:MM` on the 24-hour clock? That time is **A8**.

**4. Two kinds of date.** Every page says when it is from:

```sh
head -n 1 ledgers/*
```

Expected:

```
==> ledgers/district-balances-1848.txt <==
WATERWORKS -- DISTRICT BALANCES -- THE YEAR 1848

==> ledgers/table-ix-1848-q1.txt <==
WATERWORKS -- TABLE IX -- MARCH QUARTER, 1848

==> ledgers/table-ix-1848-q2.txt <==
WATERWORKS -- TABLE IX -- JUNE QUARTER, 1848

==> ledgers/table-ix-1848-q3.txt <==
WATERWORKS -- TABLE IX -- SEPTEMBER QUARTER, 1848

==> ledgers/table-ix-1848-q4.txt <==
WATERWORKS -- TABLE IX -- DECEMBER QUARTER, 1848
```

(Archivist's route: `debugfs -R "cat /ledgers/table-ix-1848-q1.txt" …`
shows a whole page; the heading is its first line.)

Two dates, then, on every page: **1848**, written in the page's words by
whoever wrote it, and **2026**, kept by the file system in the inode. They
are different kinds of thing. The first is a claim; anybody can type a
year. The second is a record the file system made, and it cannot say 1848
at all.

**5. Why an inode cannot say 1848.** An ext2 inode keeps each time as a
**signed 32-bit count of seconds** from the start of 1970 (UTC): the
`0x…` figures in step 1 are such counts, in hex. Positive counts reach forward to 2038;
negative ones reach back — but only so far. The most negative count a
signed 32-bit number can hold is −2147483648 seconds. Ask `date` what
moment that is:

```sh
date -d @-2147483648
```

Expected:

```
Fri Dec 13 14:45:52 CST 1901
```

The time, the zone, and even the day depend on your bench's time zone: on
a bench east of Greenwich it reads Saturday the **14th**. But on every
bench it is a moment in **December 1901**, and it is the **floor**: the
earliest instant this inode can record. Nothing in an inode can be older
than that, so a date like 1848 can only ever live in a page's own words.
Keep this in mind for Task 4. (The ceiling is
`date -d @2147483647`, in January 2038. Ext4's larger inodes push the
ceiling out by centuries, and leave the floor where it is.)

**6. Detach the cabinet** (mount route). Step **outside** it first: a
folder cannot be detached while a shell is standing in it.

```sh
cd ~
sudo umount ~/enginehouse/mnt/cabinet
findmnt ~/enginehouse/mnt/cabinet
```

Expected — nothing at all: `umount` prints nothing when it works, and
`findmnt` prints nothing because nothing is attached any more. Task 4
needs no mount: it reads the image itself, on every route.

**7. File what you read.** Go back to the lab folder (the P2 `cd` line),
and in `check/answers.txt`:

- **`A7:`** — the weekday each of the five pages was last written, in this
  order: `table-ix-1848-q1`, `q2`, `q3`, `q4`, then
  `district-balances-1848`. Five weekdays. (That is not the order `ls`
  lists them in.)
- **`A8:`** — the time of day the latest-written of those five pages was
  last written, `HH:MM`, on the 24-hour clock (step 3).

**8. Claim the seal** — from `labs/week-11`:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-11/check'
  ~~~ WAX SEAL of the Guild: F7A8DA13 ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-11/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 3** with your five-row table, the line for the
cabinet's folders, the HOUSE RULE beneath them, word for word, and two
sentences on the two kinds of date: what the 1848 on a page is, and why
no inode could have recorded it.

> **If you're lost, start here (Task 3).**
> - `ls: cannot access 'ledgers': No such file or directory`? You are not
>   inside the cabinet, or it is not attached. `findmnt
>   ~/enginehouse/mnt/cabinet` says which; attach it (Task 2's box) and
>   `cd ~/enginehouse/mnt/cabinet`. Or take the archivist's route.
> - `ls` printed `Oct 23  2026` with no time? You left out
>   `--time-style='+%a %F %T'`. Copy it exactly, quotes and all.
> - `umount: ... target is busy.`? A shell is still standing inside the
>   cabinet: this one, or another terminal. `cd ~` in each, then
>   `sudo umount ~/enginehouse/mnt/cabinet` again.
> - `umount: ... not mounted.`? It was already detached. Nothing to do.
> - `date -d @-2147483648` printed `Sat Dec 14`? Your bench's clock is set
>   east of Greenwich. It is the same instant.
> - Seal says A7 carries a Saturday? That is the cabinet's folders, read
>   in step 2's last listing. A7 wants each of the five **pages**.
> - Seal says A7 has the weekdays in the order `ls` lists them? The
>   template's order is q1, q2, q3, q4, then the district balances.
> - Seal says A7 carries some other number of weekdays than five? One per
>   page, five pages, spaces between.
> - Seal says A8 reads like a 12-hour clock? Write the hour exactly as
>   your bench printed it, `HH:MM`, no *am* or *pm*.
> - Seal says A8 is not the time of the latest-written page? Compare the
>   five **dates** in your table first, then copy the time from the latest.

---

## Task 4 — Struck from the record *(~45 minutes → Seal M4)*

The memoranda drawer is empty to `ls`. Now find out what that means.

On ext2, when the last name of a file goes and nothing holds it open, the
file system does three things. It removes the name from the directory —
though the bytes of the entry often stay in the directory's spare space,
marked unused. It marks the inode **free**, and stamps the moment in a
fourth clock, the inode's **dtime** (deletion time). And it marks the
file's blocks **free** in the **bitmap** — zyBooks Ch 8's word for the
map that keeps one bit per disk block: allocated or free. What it does
**not** do is erase the inode's own list of blocks, or the blocks
themselves. The inode is an index of where the file's bytes live (the
book's *indexed block allocation*), and on ext2 that index survives the
deletion intact. So does every byte, until a later write reuses the
blocks. That is row 3 of Task 1's table, and it is this task.

**1. Look in the drawer the archivist's way.** Every step of this task is
`debugfs` on the image, on both routes. (Type P5's `export` line first,
if this is a new terminal.)

```sh
debugfs -R "ls -l /correspondence/memoranda-1848" ~/enginehouse/cabinets/cabinet-1848.img
debugfs -R "ls -d /correspondence/memoranda-1848" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected — the first is the drawer as `ls` sees it, two entries and no
papers; the second is the same drawer with `-d`, which shows **deleted**
entries too. Each `…` is a number on your screen:

```
debugfs 1.47.0 (5-Feb-2023)
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 .
      …   40755 (2)   1000   1000    1024 24-Oct-2026 10:00 ..

debugfs 1.47.0 (5-Feb-2023)
 …  (12) .    …  (1012) ..   <…> (40) 1848-03-14-board-table-ix.txt   
<…> (48) 1848-08-02-board-district-balances.txt   
<…> (912) 1848-11-30-board-retain-the-computers.txt   
```

Three struck names, still legible in the directory's spare space, each
with the inode number it used to point at in **angle brackets** — `<` and
`>` around a number are `debugfs`'s mark for "a struck entry, and its old
inode". The number in round brackets is only the entry's length in the
directory; ignore it. Write the three names and their three inode numbers
in your logbook. The three numbers go in **A9**.

The ledgers folder has struck entries of its own:

```sh
debugfs -R "ls -d /ledgers" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected — the four live pages and the district balances, and four
struck names beside them:

```
debugfs 1.47.0 (5-Feb-2023)
 …  (12) .    …  (124) ..   <…> (28) 1848-q1-table-ix.txt   
<…> (28) 1848-q2-table-ix.txt   <…> (28) 1848-q3-table-ix.txt   
<…> (28) 1848-q4-table-ix.txt    …  (36) district-balances-1848.txt   
 …  (28) table-ix-1848-q1.txt    …  (28) table-ix-1848-q2.txt   
 …  (28) table-ix-1848-q3.txt    …  (768) table-ix-1848-q4.txt   
```

Write those four struck names and numbers down too.

**2. Every freed inode that still has its blocks.**

```sh
debugfs -R lsdel ~/enginehouse/cabinets/cabinet-1848.img
```

Expected — the shape, with most rows cut. Your screen shows one row per
freed inode, and the last line gives the count:

```
debugfs 1.47.0 (5-Feb-2023)
 Inode  Owner  Mode    Size      Blocks   Time deleted
     …   1000 100644    632      1/     1 Wed Sep 16 19:22:05 2026
...
     …   1000 100644   1242      2/     2 Fri Dec 13 14:45:52 1901
...
N deleted inodes found.
```

`lsdel` walks the inode table for inodes that are marked free but still
list their blocks, and prints each one: its number, owner, mode, size,
how many of its blocks are still listed, and its **dtime**. Match every
row to a struck name from step 1 by its number. Record the count from the
last line: it is the first number of **A9**.

Some rows give their deletion time as December 1901. You met that moment
in Task 3: it is the floor, the oldest instant an inode can hold (its
time of day, and even its day, follow your bench's zone, as they did
there). A dtime on the floor says *older than this clock can say*, and
nothing more precise. Copy every row's time into your logbook as printed.

**3. Prove the bytes are still there.** Take one memorandum's number from
step 1, and ask for its inode (type your own number in place of `N`, and
keep the angle brackets):

```sh
debugfs -R "stat <N>" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected for the first memorandum — the shape, with the numbers that vary
written `…`. Its 1901 times follow your bench's zone, exactly as the floor
did in Task 3 (on a bench east of Greenwich the day reads Saturday the
14th):

```
debugfs 1.47.0 (5-Feb-2023)
Inode: …   Type: regular    Mode:  0644   Flags: 0x0
Generation: 0    Version: 0x00000000:00000000
User:  1000   Group:  1000   Project:     0   Size: 1242
File ACL: 0
Links: 0   Blockcount: 4
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x80000000:00000000 -- Fri Dec 13 14:45:52 1901
 atime: 0x80000000:00000000 -- Fri Dec 13 14:45:52 1901
 mtime: 0x80000000:00000000 -- Fri Dec 13 14:45:52 1901
crtime: 0x80000000:00000000 -- Fri Dec 13 14:45:52 1901
 dtime: 0x80000000:(00000000) -- Fri Dec 13 14:45:52 1901
Size of extra inode fields: 32
BLOCKS:
(0-1):B1-B2
TOTAL: 2

```

`Links: 0` — no name points here. `dtime` — it was deleted. And `BLOCKS`
still lists where its bytes are: `(0-1):B1-B2` means its first and
second blocks are blocks `B1` to `B2` of the image (two numbers on your
screen). Ask the free map about the first of them, with your own number
in place of `B1`:

```sh
debugfs -R "testb B1" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected (with your block number):

```
debugfs 1.47.0 (5-Feb-2023)
Block B1 not in use
```

The **bitmap** says that block is free, ready to be handed to the next
file that wants space. The **inode** says the letter's bytes are in it.
Both are true at once, and that is why recovery works — and why it works
only until something is written. On ext4 the second half is false: when
ext4 frees an inode, it clears the inode's map of its blocks (its
*extents*) as well, so the bytes may linger on the disk with nothing left
to say where they are. Getting them back means searching the raw disk for
anything that looks like a letter, which is called **carving**; it is
slow, unreliable, and not this course's business. That, and nothing more
mysterious, is why the cabinet is ext2.

**Checkpoint.** You should be able to say, without looking: what `ls -d`
showed that `ls -l` did not; what the bitmap says about a struck file's
blocks and what the inode says; and why a read-only mount and a separate
recovery folder matter more on this file system, not less.

**4. Bring them back — into a folder of your own.** Never into the cabinet:
the cabinet is evidence, and what you recover goes beside it, not inside
it.

```sh
mkdir -p ~/enginehouse/recovered
cd ~/enginehouse/recovered
```

`debugfs`'s `dump` copies an inode's blocks out to a file. Give it the
inode as `<N>` (angle brackets, so it reads it as an inode number) and a
file name to write. For the first memorandum, with its number from step 1
in place of `N`:

```sh
debugfs -R "dump <N> 1848-03-14-board-table-ix.txt" ~/enginehouse/cabinets/cabinet-1848.img
```

Expected — only the version line; `dump` says nothing when it works:

```
debugfs 1.47.0 (5-Feb-2023)
```

Two things about that command, both of which matter:

- **The quotes.** Everything after `-R` is one `debugfs` command, so it
  goes inside one pair of double quotes. Without them, your shell reads
  `<` and `>` as **redirections** — "take input from" and "send output
  to" — long before `debugfs` sees them, and stops with
  `bash: syntax error near unexpected token` and your number.
- **The bare file name.** The file goes in the folder you are standing
  in, `~/enginehouse/recovered`, which is why step 4 began with `cd`.
  Do not put a `~` inside the quotes: `debugfs` does not know what `~`
  means, and says `No such file or directory while opening`.

Now dump **every** struck inode from step 1, each under its struck name:
the memoranda and the struck ledger pages alike, one `dump` for each,
each with its own number. Then:

```sh
ls -l
```

Expected — one file per struck inode, sizes matching `lsdel`'s (yours
carry today's date and time):

```
total 28
-rw-r--r-- 1 you you 1242 Oct 11 10:55 1848-03-14-board-table-ix.txt
-rw-r--r-- 1 you you  882 Oct 11 10:55 1848-08-02-board-district-balances.txt
-rw-r--r-- 1 you you  852 Oct 11 10:55 1848-11-30-board-retain-the-computers.txt
-rw-r--r-- 1 you you  632 Oct 11 10:55 1848-q1-table-ix.txt
-rw-r--r-- 1 you you  631 Oct 11 10:55 1848-q2-table-ix.txt
-rw-r--r-- 1 you you  636 Oct 11 10:55 1848-q3-table-ix.txt
-rw-r--r-- 1 you you  635 Oct 11 10:55 1848-q4-table-ix.txt
```

**Checkpoint.** Before you read a word of them, you should be able to say:
how many files you dumped and why that number matches `lsdel`'s count;
which of them were letters and which were ledger pages; and why every one
of them landed in `~/enginehouse/recovered` and none in the cabinet. If a
size here differs from `lsdel`'s, dump that one again with the number from
your own `ls -d`.

**Why not `undel`?** `debugfs` has a command that would put a struck file
back into the cabinet itself. It writes to the image, so it is never used
here: you do not write to evidence, not even to mend it. (It would refuse
anyway — `debugfs` without `-w` has the image open read-only.)

**5. Read what came back.** The letters first:

```sh
cat 1848-03-14-board-table-ix.txt
```

```
[ the letter prints on your screen. Read it through, then the other two
  the same way. Record in your logbook, for each: its date, to whom it is
  addressed, what it asks for, and how it is signed. ]
```

Then the struck ledger pages beside the live ones. Dump each live page
from the cabinet into the same folder, by its **path** this time (no
angle brackets — a path names a live file), and compare:

```sh
debugfs -R "dump /ledgers/table-ix-1848-q1.txt live-q1.txt" ~/enginehouse/cabinets/cabinet-1848.img
diff 1848-q1-table-ix.txt live-q1.txt
```

Expected:

```
debugfs 1.47.0 (5-Feb-2023)
18,19c18,19
<   computed loss, million gallons .. 0.515
<   district balance, pounds ........ 204.51
---
>   computed loss, million gallons .. 0.514
>   district balance, pounds ........ 204.49
```

`diff` prints only the lines that differ: `<` lines from the first file
(the struck page), `>` lines from the second (the live one), and
`18,19c18,19` means "lines 18 and 19 changed". Do the same for `q2`. In
your logbook, for `q1` and `q2`, record the two figures on the struck
page and the two on the live page, and say in a sentence how the figures
changed. Do not explain why; record how.

**`q3` and `q4` are optional.** They follow the same pattern: the same
two commands, with `q3` or `q4` in place of `q1`. Do them if the studio
has time, and record them the same way. No seal and no answer needs
them, and nothing is marked down if you skip them.

**6. File what you found.** You are in `~/enginehouse/recovered`. Go back
to the lab folder with the P2 `cd` line. (If you file your answers from a
second terminal, or an editor that takes over this one, that is fine —
but come back to **this** terminal afterwards: step 8 is the last command
of the studio, typed here.) In `check/answers.txt`:

- **`A9:`** — the count from `lsdel`'s last line, then the inode numbers
  of the three memoranda (step 1), any order: four numbers, spaces
  between.
- **`A10:`** — the signer's **post** and the memoranda's **closing line**,
  exactly as written, both on the one line. The post is the office the
  signature line gives after the name; the closing line is the one the
  letters close with, just above it.

**7. Claim the seal** — from `labs/week-11`:

```sh
make -C check m4
```

Expected:

```
make: Entering directory '.../labs/week-11/check'
  ~~~ WAX SEAL of the Guild: 7D1C68B7 ~~~
  (Paste this seal into your logbook under Milestone 4.)
make: Leaving directory '.../labs/week-11/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 4** with: every struck name and its
number; the `lsdel` count; the block that the bitmap called free and the
inode called full; the four quarters' figures, struck and live; and the
three letters as you recorded them in step 5.

> **If you're lost, start here (Task 4).**
> - `debugfs` output ends with `(END)` and vanishes when you press `q`?
>   Type P5's `export DEBUGFS_PAGER=__none__` in this terminal, then run
>   the command again.
> - `bash: syntax error near unexpected token` followed by your number?
>   The quotes are missing. Everything after `-R` goes inside one pair of
>   double quotes: `-R "dump <N> name.txt"`.
> - `File not found by ext2_lookup`, with your number at the front? You
>   left out the angle brackets. `dump N` looks for a **file called** `N`;
>   `dump <N>` means inode N.
> - `dump: No such file or directory while opening ~/...`? A `~` went
>   inside the quotes. `cd ~/enginehouse/recovered` first, then give a
>   bare file name.
> - The dump made a file of 0 bytes, or `ls -l` shows a size different
>   from `lsdel`'s? You typed another number, or one from somebody else's
>   screen. Take each number from **your** `ls -d`, and dump again.
> - `debugfs` says `Filesystem opened read/only`? You asked it to write
>   — `undel` or the like. Nothing was changed. Use `dump`.
> - `lsdel` shows nothing, or `0 deleted inodes found`? Your cabinet is
>   not the staged one. From `labs/week-11`, `bash report-for-duty.sh`
>   builds it afresh (detach it first if it is mounted).
> - `diff` printed nothing? You compared a file with itself, or two live
>   pages. The struck page is the `1848-q…` name; the live one is the copy
>   you dumped by path.
> - `make: *** check: No such file or directory.  Stop.`? You are still in
>   `~/enginehouse/recovered`. Run the P2 `cd` line, then claim the seal
>   again.
> - Seal says A9 carries the number of a struck ledger page? `lsdel`
>   lists every struck inode, and only the letters belong in A9. The
>   memoranda folder's `ls -d` shows which numbers were filed there.
> - Seal says A9 does not carry `lsdel`'s count? Put the count from its
>   last line first, then the three numbers.
> - Seal says A10 is missing the post, or the closing line? Read the foot
>   of any letter again and copy each exactly. The post is not the name.

**8. The closing command.** You have filed your answers and claimed M4.
One command left. If you opened an editor or a second terminal to fill
`answers.txt`, come back to this one — this is the last command of the
lab. From anywhere:

```sh
grep -h servant ~/enginehouse/recovered/* | sort -u
```

```
[ your bench prints a line here ]
```

Leave it on your screen.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 11 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, character for character — do not paraphrase:

- Your five-row table from Task 3, and the docket's **HOUSE RULE**
  paragraph beneath it.
- The `diff`s for `q1` and `q2` from Task 4, struck figures and live
  (and `q3` and `q4` too, if you did the optional two).
- The signature lines of one memorandum, as written: the closing line,
  the name and post, and any mark beneath them.

Three questions to write toward, none of which has an answer in this work
order:

1. The memoranda were struck, and on ext2 striking left every byte in
   place. If somebody had wanted them gone for good, what would they have
   had to do — and what does it tell you that it was not done?
2. Every live page agrees with itself: its three clocks match. Every
   struck original carries a deletion time. Put those beside each other.
   What do the clocks let you say, and what do they leave unsaid?
3. A letter tells you who wrote it. What does it not tell you?

Write a plain account of what the cabinet holds. The notebook is marked
on being kept honestly and quoting exactly, never on drawing the cleverest
conclusion — least of all about people.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the docket's.

1. In a paragraph: explain to someone who has never heard the word what
   happens when `rm` runs, using **name**, **inode**, **link count** and
   **block** correctly at least once each. Say when the space is really
   freed, and say why you could bring the memoranda back from the cabinet
   and could not expect to do the same from your own home folder.
   *zyBooks Ch 8.*
2. In two or three sentences: you mounted the evidence read-only and
   recovered into a folder of your own, and never once wrote to the
   cabinet. Suppose the file system had let you write. What is the
   smallest careless thing you could have done that would have cost a
   memorandum for good? (There is no answer key. I am asking what habit
   you would defend.)

## Turn it in

Due **Sunday, 1 November, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)).

1. **`logbook.md`** — all four milestones: what you did, the seal pasted
   in, what it means. M1 wants what `ln`, `ln -s` and `rm` each changed,
   the pointer that broke and came back, and the rule for when space is
   freed; M2 wants your route, the mount explained, the cabinet's type and
   block size, and its two links told apart by evidence; **M3 wants the
   five-row table with the HOUSE RULE beneath it**, and the two kinds of
   date; M4 wants every struck name, the bitmap and the inode
   disagreeing, the four quarters' figures, and the three letters
   recorded — which is the graded centre of the week. Plus both
   reflection prompts and the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 11 entry.

Upload both files to the Week 11 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.)

**When your paperwork is in,** you may stand the bench down. Detach the
cabinet first if it is still attached (`cd ~`, then
`sudo umount ~/enginehouse/mnt/cabinet`), then, from `labs/week-11`:

```sh
bash report-for-duty.sh --reset
```

It removes the cabinet, the empty mount folder, the drill hall, **and
`~/enginehouse/recovered/` with everything you recovered into it** — copy
anything you want to keep first. It leaves every other week's papers
exactly where they are.

**The usual late window applies.** Late work is accepted for two calendar
days at a flat 20%, so this order's window closes on **Tuesday, 3
November**. Hand it in on Sunday.

How the tasks cover the six objectives: Task 1 is objectives 1, 2 and 3;
Task 2 is objectives 2 and 4; Task 3 is objective 5; Task 4 is objectives
3 and 6. The reflections cover them in your own words.

**Also on this week's docket.**

- zyBooks **Ch 8** — file systems — due **before class on Wednesday, 28
  October**. Readings have no late window. It is the reading behind all
  four tasks; do it first.
- **Commission III — *The Pattern Loom*** (zyBooks 12.3, regular
  expressions) is due **Friday, 6 November, 11:59 pm, in zyBooks** — not
  Canvas.
- **Commission IV — *The Revision Registry*** (zyBooks 12.5, "Simple
  Versioning System") is **assigned today** and due **Friday, 20
  November, 11:59 pm, in zyBooks**. The cover is at
  [`commissions/04-the-revision-registry.md`](../../commissions/04-the-revision-registry.md).
  It decides what has changed by modification times, so this week's Task 3
  is its groundwork.
- **Week 12 has no required reading.**

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: FOUR. TWO STUDIOS. NO BREAK.`
> `THE CABINET: READ, NEVER WRITTEN. THIS PORTER KEPT HIS HANDS IN HIS POCKETS.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap.

- **Check a page's sums by hand.** Every figure on every page is there to
  be checked. On a live page, add the three culvert losses and round the
  total once, to three places; then add the four district balances and
  round once, to two. On the struck page for the same quarter, round each
  figure first and then add. Which page did which? The Guild's own rule
  is to add first and round once, at the foot of the column.
- **The file system's own ledger.** `debugfs -R stats …` prints the
  cabinet's superblock: its block and inode counts, its free counts, and
  its features — look for what is *not* there, `has_journal`.
  `debugfs -R "ncheck N" …` turns an inode number back into every name
  that points at it (try it on A5's number: two names). `debugfs -R
  "icheck B" …` turns a block number into the inode that owns it.
- **Forge a date, and watch the clock that will not follow.** On a file of
  your own — say `~/enginehouse/ledger-halls/drill/recovered-page.txt` —
  run `touch -d "2026-01-05 09:00"` on it, then `stat` it: `Modify` and
  `Access` move to January, and `Change` moves to *now*, because setting
  the other two changed the inode. Then try `touch -d "1848-03-14 10:00"`
  and `stat` again: your own ext4 inode quietly records December 1901,
  the floor, and says nothing about it.
- **Why `shred` exists, and why it is not a promise.** `shred` writes over
  a file's blocks before you delete it, so that nothing lingers to be
  dumped. On ext2 that works. On a **journaling** file system the journal
  may hold copies of the old blocks; on **flash** storage (an SSD, a USB
  stick) the drive itself moves writes to fresh cells and keeps the old
  ones until it gets round to erasing them. `man shred` says so in its
  own words. Deleting for good is much harder than deleting.
- **Watch `rm` ask for it.** `strace rm somefile` (on a file of your own)
  shows the one system call that does the work, `unlinkat`: *remove this
  name from that directory*. Nothing in its name says "delete", and now
  you know why. Week 2's `strace`, one more time.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"A name can be struck in a moment. A page takes rather longer to lose."*
