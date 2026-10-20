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

**Name:**
**Week:**
**Work Order No.:**

## Milestone 1
**What I did:**
slip         (asked for while running)    0x5689f2e912a0
main         (the program's own routine)  0x5689bee2f1c9
on_hand      (a variable inside main)     0x7ffdee0847dc
tally_kept   (set before the start)       0x5689bee32010
spare_slips  (never set at all)           0x5689bee32040
slip         (asked for while running)    0x62bb62ca02a0
main         (the program's own routine)  0x62bb5168c1c9
on_hand      (a variable inside main)     0x7ffd279d372c
tally_kept   (set before the start)       0x62bb5168f010
spare_slips  (never set at all)           0x62bb5168f040

**Output or seal:**
~~~ WAX SEAL of the Guild: 8F513B1B ~~~

**What it means:**
The addresses changed but not the order.
slip → heap (asked for while running)

main → text (the program's own routine) because text wants instructions

on_hand → stack (a variable inside main) Both are variables

tally_kept → data (set before the start) Both established before the start

spare_slips → bss (never set at all) Set to zero and never set at all

## Milestone 2
**What I did:**
==4046== Invalid write of size 1
==4046==    at 0x484F39E: strcpy (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==4046==    by 0x1092F1: enter (store-clerk.c:38)

==4046== Invalid read of size 4
==4046==    at 0x1093F6: main (store-clerk.c:67)

==4194== 105 (24 direct, 81 indirect) bytes in 1 blocks are definitely lost in loss record 6 of 6
==4194==    at 0x4846828: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==4194==    by 0x109249: enter (store-clerk.c:27)

**Output or seal:**
~~~ WAX SEAL of the Guild: 1A6E8F38 ~~~

**What it means:**
This means there were multiple issues with the code causing memory problems. First there was an error with a containers size, then with what it should be reading and finally, with what was lost.

## Milestone 3
**What I did:**
store-siphon: 52 blocks drawn from the Store; none returned.
store-siphon: the cap is reached. Resting.

217 bytes in 4 blocks -- by 0x109263: fair_copy (store-siphon.c:65) -- 54.25
196,608 bytes in 48 blocks -- by 0x1091FE: draw_block (store-siphon.c:53) -- 4,096
definitely lost: 196,825 bytes in 52 blocks VS 196,825 and 52

SIPHON_CAP = 48

**Output or seal:**
~~~ WAX SEAL of the Guild: 95E9B758 ~~~

**What it means:**
This means we are leaking memory from our program but not as visibly as our previous program. Valgrind is less able to specify what is leaking and why, so more investigation is needed.

## Milestone 4
**What I did:**
1:/* store-siphon -- draws from the Store and keeps what it draws.  -- E.K. */
6:/* Never more than this. The Engine shall not want for a block on my account.  -- E.K. */
13:/* The draft is kept in cipher on paper; the Store keeps the fair copy.  -- E.K. */
61:/* A fair copy is never written over. A new block for every hand.  -- E.K. */

==8470== 0x4AA5C40[72]
==8470== 0x4AA5CD0[38]
==8470== 0x4AA5D40[36]
==8470== 0x4AA5DB0[71]

0x4aa5c40:      "To the Board of the Enginehouse, and to its guests at the Exhibition --"
0x4aa5cd0:      "...they called our work superseded..."
0x4aa5d40:      "...they called our work obsolete..."
0x4aa5db0:      "A tool is obsolete. We were never the tool; we were the check upon it."

**Output or seal:**
~~~ WAX SEAL of the Guild: E3B07045 ~~~

**What it means:**
Someone is angry... Sometimes it takes a little help from other places to find and solve issues, not just straight in valgrind.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. In a paragraph: the routine leaks every block it draws, and the Engine is none the worse. Explain why a leak in a program that runs for a second and exits costs almost nothing, why a leak in a program that runs for months can bring a machine down, and what the cap changes. Use the words heap, leak, definitely lost and indirectly lost correctly at least once each.

The routine leaks every block it draws, but if the program runs for only a second and then exits, the operating system reclaims its memory, so the leak costs almost nothing beyond a small, temporary increase in heap usage. However, a program that runs for months can accumulate leaked allocations continuously, consuming more and more memory until the machine slows down, other processes are starved of memory, or the system crashes.A definitely lost block is memory that the program can no longer reach, while an indirectly lost block is memory that becomes unreachable because it was referenced only by another lost block. The Engine is none the worse if the routine's allocations are short-lived and the process exits promptly, but in a long-running process, even a small leak can grow into a serious problem.

2. The clerk printed the right ledger every time you ran it, and was wrong three ways. In two or three sentences: is a program that always prints the right answer a correct program? What would you want to see before you said so? (There is no answer key. I am asking what you would defend in a code review.)

I would say that I tend to trust a program that prints the right ledger even if it does not mean it is a correct program. I would want to see the logs like we did to see if it truly is correct even if it spills the right results. However, that is only if I am making it but if not I assume it is correct. 


## Sources and help

Anyone or anything that helped you this week — a classmate, a man page,
a Stack Overflow answer, an AI assistant. One line each: who or what,
and what you used it for. This is **not graded and never costs points**;
it is the habit professional engineers keep, and the syllabus asks for
it under *Academic integrity* and *Use of AI tools*.

- *(example)* Worked through the `fork` ordering with Sam in studio.
- *(example)* Used an AI assistant to explain what `EAGAIN` means in the trace.

*Nothing to report? Write "None" — that's a perfectly normal week.*
None

## Time spent

Roughly how long this took, start to finish: ____2___ hours
*No wrong answer — this just helps calibrate future work orders.*
