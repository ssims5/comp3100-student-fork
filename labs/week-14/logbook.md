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
**Week: 14**
**Work Order No.:**

## Milestone 1
**What I did:**
First I found an open port I could borrow then I connected my server to a listener. I communicated between them, then confirmed the connection.

**Output or seal:**
~~~ WAX SEAL of the Guild: BCC92809 ~~~

**What it means:**
This means I am able to create and connect two programs and communicate between them.

## Milestone 2
**What I did:**
I checked what was running and found that there are three things the engine needs and one I did not start. I looked into what was running and found its uid and pid to uncover more.

**Output or seal:**
~~~ WAX SEAL of the Guild: 10F21572 ~~~

**What it means:**
This means once again I find things that start without my permission or knowledge, but I begin my journey onto finding it, who started it, and what it is doing.

## Milestone 3
**What I did:**
I read the queue and found what was held there. I was able to open and read what they contained, then I was able to read the procedure as well. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 4F300D3E ~~~

**What it means:**
Everything that is hidden has been readable and this continues to hold true. Files that were stored are accessible and the policies and procedures governing them are readable.  

## Milestone 4
**What I did:**
I counted and moved all of the dispatches that were waiting. Because I owned both folders I was able to move them untouched. I filed the cancel order and found that my move was successful. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 31AD856D ~~~

**What it means:**
I am able to move what I own. Copying is different than moving because a copy is different, a copy is my own, but movement from places I own to places I own changes nothing.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. In a paragraph: explain to someone who has never used a terminal how your own nc listener and the listener nobody started each looked in ss, and why one showed its program to you and the other did not. Use port, socket, loopback and process correctly at least once each. 

When I start my own nc listener, ss showed the listening socket along with the program name (nc) and its process ID because I had permission to see the process information. When I looked at the listener which no one I knew about started, ss still showed that it was listening on a port using a socket, often on the loopback address, but it did not show the program name or process ID. This happened because the listener belonged to a different user, and my account did not have permission to view its process details.

2. In two or three sentences: an audit found a listener you could reach only from this machine. Would you rather it had been bound to 0.0.0.0, or not running at all? What would you ask before deciding which listeners a machine should keep?

I would rather it was not running at all if it was unnecessary, because binding it to 0.0.0.0 would make it reachable from other network interfaces and potentially expose it to attackers. Before deciding which listeners to keep, I would ask what purpose each one serves, what depends on it, and whether having it open would create a security risk.

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

Roughly how long this took, start to finish: _______ hours
*No wrong answer — this just helps calibrate future work orders.*
