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

Scot Sims
**Week: 5**
**Work Order No.: 5**

## Milestone 1
**What I did:**
For Milestone 1 I checked to see if the looms were keeping count, they were not. They could keep track of their own counting but they could not work together. 

**Output or seal:**
~~~ WAX SEAL of the Guild: AB2DDCB5 ~~~

**What it means:**
Both are told to keep track of their own and combined however, something is interrupting them when they try and record to their shared counter.

## Milestone 2
**What I did:**
First I took the time to understand how the entries operate and how they can overlap when writing to total. This is a mistake that when pointed out made a lot of sense to me but I can easily see myself making the same mistake. Next I added a lock to my code that only allows one to access total at a time and forces the others to be in a queue. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 8D7A745E ~~~

**What it means:**
This means that I am now capable of understanding at a base level why a program (even ones that simply keep track of what they do) can get off. I am able to place a lock in the correct place to protect myself in future programs and I learned only to lock what absolutely needs it. 

## Milestone 3
**What I did:**
I computed by hand losses and compared them to what the computer said. I got 0.5170 on paper and 0.517 from the computer. I also had this number incorrectly saved 214.06.

**Output or seal:**
~~~ WAX SEAL of the Guild: 70DAB71D ~~~

**What it means:**
This means that the computer can get off by a little, which can add up over time, through rounding errors by dropping numbers it does not think matters.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. Your guarded build printed the same total five times out of five — 400000 on the default count, or whatever your two A1 figures add up to if you raised it. In a paragraph: does five exact runs prove the race is gone? Say what the unguarded runs would have looked like if you had been unlucky enough to see only exact ones — and then say what would count as proof, given that "I ran it and it worked" is the same sentence a student says about a program with a live data race in it. Use the words critical section and data race correctly at least once each. zyBooks Ch 4.1.

Running five times and going 5/5 runs does not prove the race is gone. It shows that one may be on the right track or one may have it right, but it does not show for certain it has been completed. A lucky (or unlucky) run depending on perspective could have 5 in a row showing it work even if there are still issues. The more you run it and the more it is correct the lower the likelihood of it being incorrect, but five makes no guarantees. Adding a critical section through a lock was essential for my program to work properly but I can not guarantee it with only five runs.

2. You have just told the Guild that two figures in a filed ledger do not match a second document, and that your own arithmetic makes a third opinion. In two or three sentences: what would you need before you were willing to tell the Board that a figure in a ledger is wrong? Name the evidence you would want, and — harder — name something that would still not be enough. (There is no answer key. I am asking what standard you hold yourself to.)

I would want evidence of where the figures are coming from, something that shows the numbers going in are correct to be able to prove the one ledgers numbers that are coming out are wrong because I can guarantee the numbers going in are right. Evidence that would not be enough would be additional numbers for each ledger.


## Sources and help

Anyone or anything that helped you this week — a classmate, a man page,
a Stack Overflow answer, an AI assistant. One line each: who or what,
and what you used it for. This is **not graded and never costs points**;
it is the habit professional engineers keep, and the syllabus asks for
it under *Academic integrity* and *Use of AI tools*.

- *(example)* Worked through the `fork` ordering with Sam in studio.
- *(example)* Used an AI assistant to explain what `EAGAIN` means in the trace.

*Nothing to report? Write "None" — that's a perfectly normal week.*

## Time spent

Roughly how long this took, start to finish: __1.5_____ hours
*No wrong answer — this just helps calibrate future work orders.*
