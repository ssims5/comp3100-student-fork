# Engineer's Logbook

*Honourable Guild of Enginewrights — Ex Vapore, Ordo*

Copy this into your week's folder as `logbook.md` and fill it in as you
work. Paste your wax seals where marked — that's how a milestone gets
marked done.

Write it the way you'd explain the week to a classmate who missed it:
plain sentences, no polish. An honest half-answer under "what it
means" — *I got the seal but I'm still fuzzy on why the second run
differed* — beats a confident sentence you don't believe, and it tells
me where to start when you bring it to studio.

**Name: Scott**
**Week: **
**Work Order No.:**

## Milestone 1
**What I did:**
15018. Tried deleting files and looking to see if I actually did. 

**Output or seal:**
~~~ WAX SEAL of the Guild: ECCC5D52 ~~~

**What it means:**
Learned the difference between hard and symbolic links and how deleting a file name doesn't always actually delete the file. Using file descriptors I checked how iondes are connected.

## Milestone 2
**What I did:**
Tried to touch a file but was rejected, then searched for its route to find where it was hiding. I mounted the route, finding directions for myself to see where to looked.

**Output or seal:**
~~~ WAX SEAL of the Guild: 8CFE54A2 ~~~

**What it means:**
Used read only to prevent myself from using bytes that were marked as opened but being used. I then tried to follow the trail of where the files could be and where they went after deletion. 

## Milestone 3
**What I did:**
511 Fri 2026-10-23 20:03:18 district-balances-1848.txt
632 Wed 2026-09-16 19:22:05 table-ix-1848-q1.txt
631 Fri 2026-09-18 19:07:40 table-ix-1848-q2.txt
636 Wed 2026-09-23 19:36:12 table-ix-1848-q3.txt
635 Wed 2026-10-14 19:41:27 table-ix-1848-q4.txt
HOUSE RULE. The ledger halls and the reading room close at the
  bell, six o'clock (18:00). Visiting days are Wednesdays and Fridays
The 1848 is what is claimed by the person who made it but the 2026 is when it was truly made, tracked by the ledger itself.
**Output or seal:**
~~~ WAX SEAL of the Guild: F7A8DA13 ~~~

**What it means:**
This means that something was marked and changed not when it said. The name lied but the ledger always keeps track.

## Milestone 4
**What I did:**
I looked into the places the files and bits were hiding to see what happened and if I could recover them. With the inodes help I was able to find them, they couldn't all hide from me. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 7D1C68B7 ~~~

**What it means:**
Despite the files being struck I was still able to recover and look through exactly what they were hiding. 

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. In a paragraph: explain to someone who has never heard the word what happens when rm runs, using name, inode, link count and block correctly at least once each. Say when the space is really freed, and say why you could bring the memoranda back from the cabinet and could not expect to do the same from your own home folder.

When you run rm, the computer removes the file's name from its directory and decreases the link count on its inode, which keeps track of the file's information and blocks where its data is stored. The space is not really freed until the link count reaches zero and no program still has the file open; then the system can reuse its blocks. We could recover the memoranda from the cabinet because it used ext2, which still retained the inode's block information even after deletion, allowing us to find and copy the data. We could not expect the same recovery from our home folder because it uses ext4, which clears the inode's block mapping when a file is deleted, making recovery much harder and often requiring unreliable data carving.

2. In two or three sentences: you mounted the evidence read-only and recovered into a folder of your own, and never once wrote to the cabinet. Suppose the file system had let you write. What is the smallest careless thing you could have done that would have cost a memorandum for good? (There is no answer key. I am asking what habit you would defend.)

A careless thing to have done would be to create or sae a small file inside the cabinet. That could have caused the file system to reuse a freed block that was contained in a part of a deleted memorandum. I would protect the habit of never writing to original evidence. Keep the evidence read only.

## Sources and help

Anyone or anything that helped you this week — a classmate, a man page,
a Stack Overflow answer, an AI assistant. One line each: who or what,
and what you used it for. This is **not graded and never costs points**;
it is the habit professional engineers keep, and the syllabus asks for
it under *Academic integrity* and *Use of AI tools*.

- *(example)* Worked through the `fork` ordering with Sam in studio.
- *(example)* Used an AI assistant to explain what `EAGAIN` means in the trace.

*Nothing to report? Write "None" — that's a perfectly normal week.*
A.I. clarified Inodes.

## Time spent

Roughly how long this took, start to finish: ___3____ hours
*No wrong answer — this just helps calibrate future work orders.*
