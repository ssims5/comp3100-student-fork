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

Scott Sims
Week 2
Work Order No. 2

## Milestone 1
**What I did:**
One sentence per error
Error One had an error of string length because string.h was not included, without which the machine gets confused. My second error revolved around incorrect syntax an = vs == mistake, a mistake I made often when learning to code. The third fault revolved around going past the end of the array, once again a common mistake when learning to code. Finally the fourth issue was an uninitialized value. This is probably the third most common beginner decision one that took me forever to solve. However, it wasn't because I didn't fix the issue it was because I was forgetting to "make" after fixing my code. After fixing the initialization issue and before I "maked" I spent so long trying to figure it out I turned to AI to see if it could figure out issues with my code but it found nothing - because my code was correct. Eventually I figured out all on my own what my silly mistake was. 

**Output or seal:**
~~~ WAX SEAL of the Guild: B641F0B1 ~~~

**What it means:**
This means that simple mistakes and errors can majorly derail any attempt at coding and if the guardians are not put in place manually it do as it pleases with no concern for the consequences. I learned to double check my code and to put barriers in place for when I slip up. 

## Milestone 2
**What I did:**
I called strace to check what actually what was going on between user mode and the kernel. I got to see what was happening even when I asked the engine house and it said everything was all good. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 1BEC440E ~~~

**What it means:**
This means that what the program says is not always true, it is always best to do your due diligence and check yourself. In Linux you always have the option to check yourself, and it seems you should. 

## Milestone 3
**What I did:**
I looked more in depth into what was going on in the guild, looking into the ledger annex and there were some suspicious things going on. Someone's hours were being booked in a hidden ledger.

~~~ WAX SEAL of the Guild: A6D355D8 ~~~
 
**What it means:**
I am unsure of what it quite means for our story, I have suspicions but not enough to accuse. For Linux however I continue to learn the importance of checking yourself rather than letting the machine decide for itself.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. The card-reader's own output claimed all was in order while its system-call record showed an unannounced write. In two or three sentences: why is the kernel's record the authoritative one? Use user mode and kernel mode the way zyBooks 1.2 does — who runs in which mode, and who is allowed to touch the hardware.
The kernels record is always authoritative because it is the one that actually interacts with the hardware and it approves all requests from the user mode. Programs run through the user mode and not allowed touch anything they must request through the kernel. 

2. Four faults, three watchmen: the compiler caught two, ASan caught one at runtime, valgrind caught one more. Why do you suppose C needs all three, when the languages you knew before catch most of this in one place? One honest paragraph — "because C trusts the programmer" is a fine place to start, if you say what that trust costs and what it buys.
C trusts the programmer which to me is an interesting proposition because C can be give access to so much. As we learned earlier the kernel will approve what it asks even if it is not what the user intended. This can be a dangerous idea. People also make mistakes constantly so letting the user have free range is good because they can make the decisions they want but dangerous because they will inevitably mess up. That is why I will always use all three after learning about this otherwise I would end up breaking something on accident. 


## Sources and help

Anyone or anything that helped you this week — a classmate, a man page,
a Stack Overflow answer, an AI assistant. One line each: who or what,
and what you used it for. This is **not graded and never costs points**;
it is the habit professional engineers keep, and the syllabus asks for
it under *Academic integrity* and *Use of AI tools*.

- *(example)* Worked through the `fork` ordering with Sam in studio.
- *(example)* Used an AI assistant to explain what `EAGAIN` means in the trace.

*Nothing to report? Write "None" — that's a perfectly normal week.*

I used AI when I got stuck on part 2 but I ended up solving it myself because it was a dumb error not a programming issue.

## Time spent

Roughly how long this took, start to finish: __2___ hours
*No wrong answer — this just helps calibrate future work orders.*
