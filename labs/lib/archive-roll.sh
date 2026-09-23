#!/usr/bin/env bash
# archive-roll.sh -- course-level helper. Shared, not any one week's.
#
# The Guild is restoring a dormant entry to the house roll ahead of the
# Exhibition archive: a name struck off nobody's active service, never
# properly decommissioned. Which entry, and what it was doing there, is
# for your own bench to tell you -- this office only keeps the roll
# current.
#
# Usage:
#   bash archive-roll.sh ensure     restore the entry if the roll does not
#                                   already carry it. Idempotent -- call
#                                   it as often as you like; a second call
#                                   is a clean no-op.
#   bash archive-roll.sh check      exit 0 if the entry is on the roll,
#                                   non-zero if it is not. Prints nothing
#                                   -- this is for scripts, not for reading.
#   bash archive-roll.sh teardown   the course-level removal. Run this
#                                   ONCE, at the end of the semester. It is
#                                   not part of any week's --reset, and no
#                                   week calls it.
#
# Why this lives here, and not inside any one week's script: several
# weeks' work rests on the same entry existing on the bench. It is
# created once, by whichever week gets there first, and stays until the
# course-level teardown above removes it -- never earlier, and never as a
# side effect of a week's own --reset.
#
# Sudo: `ensure` and `teardown` each need it for exactly one command,
# named and announced below before it runs. If this bench cannot get
# root, they say so plainly and stand down rather than leaving a
# half-made roll or a stack trace -- take that to your instructor rather
# than working around it.
#
# Works offline.
set -eu

ROLL_UID=1849

# The registrar's sealed particulars for the dormant entry -- decoded at
# call time, run, and swept up again. Never shipped in the clear: meeting
# this entry is meant to happen by reading your own bench, not this file.
decode_payload() { # writes the payload to $1
  base64 -d > "$1" <<'B64'
IyEvYmluL3NoCiMgQ291cnNlLXJvbGwgcGF5bG9hZCAtLSBkZWNvZGVkIGFuZCBydW4gYnkgYXJj
aGl2ZS1yb2xsLnNoOyBuZXZlciBzaGlwcGVkCiMgaW4gdGhlIGNsZWFyLgpzZXQgLWV1Cm1vZGU9
IiR7MTo/ZW5zdXJlfHRlYXJkb3dufG5hbWV9IgpuYW1lPWNvbXB1dGF0b3IKCmNhc2UgIiRtb2Rl
IiBpbgogIG5hbWUpCiAgICAjIEV4cG9zZXMgdGhlIGV4cGVjdGVkIGFjY291bnQgbmFtZSBzbyB0
aGUgY2FsbGVyIGNhbiB2ZXJpZnkgdWlkCiAgICAjIDE4NDkgYWN0dWFsbHkgYmVsb25ncyB0byB0
aGlzIG9mZmljZSBiZWZvcmUgdHJ1c3RpbmcgaXQgLS0gd2l0aG91dAogICAgIyBldmVyIGhvbGRp
bmcgdGhlIG5hbWUgaW4gdGhlIGNhbGxlcidzIG93biBzb3VyY2UuCiAgICBwcmludGYgJyVzXG4n
ICIkbmFtZSIKICAgIDs7CiAgZW5zdXJlKQogICAgZ2V0ZW50IHBhc3N3ZCAxODQ5ID4vZGV2L251
bGwgMj4mMSAmJiBleGl0IDAKICAgIHN1ZG8gdXNlcmFkZCAtdSAxODQ5IC1NIC1OIC1zIC91c3Iv
c2Jpbi9ub2xvZ2luIFwKICAgICAgLWMgIkNvbXB1dGluZyBSb29tIGNvcnBzLCBwZW5kaW5nIGFy
Y2hpdmUgdHJhbnNmZXIiICIkbmFtZSIKICAgIDs7CiAgdGVhcmRvd24pCiAgICBnZXRlbnQgcGFz
c3dkIDE4NDkgPi9kZXYvbnVsbCAyPiYxIHx8IGV4aXQgMAogICAgc3VkbyB1c2VyZGVsICIkbmFt
ZSIKICAgIDs7CmVzYWMK
B64
}

# Recovers the expected account name from the sealed payload itself, so
# nothing here ever holds it in the clear -- the same seal, read instead
# of run.
expected_name() {
  tmp="$(mktemp -d)"
  decode_payload "$tmp/payload.sh"
  name="$(sh "$tmp/payload.sh" name 2>/dev/null || true)"
  rm -rf "$tmp"
  printf '%s' "$name"
}

# True only if uid ROLL_UID exists AND belongs to this office by name --
# not merely that something answers to that uid. An unrelated account
# sitting on the same uid must never be mistaken for ours.
on_roll() {
  line="$(getent passwd "$ROLL_UID" 2>/dev/null)" || return 1
  [ "${line%%:*}" = "$(expected_name)" ]
}

# True if the uid is occupied at all, ours or not -- used to tell
# "absent" (safe to create) apart from "occupied by something else"
# (a collision that needs a human, not a script guessing around it).
uid_taken() { getent passwd "$ROLL_UID" >/dev/null 2>&1; }

collision_message() {
  echo "archive-roll: the account this would restore already exists" >&2
  echo "  here under a different identity -- something unrelated already" >&2
  echo "  occupies that slot on the roll. A script has no business" >&2
  echo "  guessing around that. Take this to your instructor." >&2
}

have_root() {
  command -v sudo >/dev/null 2>&1 || return 1
  sudo -n true 2>/dev/null && return 0
  # sudo is here but wants a password -- fine, as long as something can
  # actually ask for one.
  [ -t 0 ] && [ -t 1 ]
}

no_root_message() {
  echo "archive-roll: this bench cannot get root -- either sudo is not" >&2
  echo "  installed, or it needs a password prompt this session has no" >&2
  echo "  terminal to give. Restoring the house roll needs it. Take this" >&2
  echo "  to your instructor rather than guessing at a workaround." >&2
}

mode="${1:-}"
case "$mode" in
  check)
    if on_roll; then
      exit 0
    else
      exit 1
    fi
    ;;

  ensure)
    if on_roll; then
      exit 0
    fi
    if uid_taken; then
      collision_message
      exit 1
    fi
    if ! have_root; then
      no_root_message
      exit 1
    fi
    echo "Restoring a dormant entry to the house roll, ahead of the Exhibition"
    echo "archive. One command, via sudo: useradd -- one entry, no login shell,"
    echo "no password, no home directory: nothing can log in as it. Reversible"
    echo "by name (bash labs/lib/archive-roll.sh teardown), and yours to look up"
    echo "yourself right after. If sudo has not already been given your"
    echo "password, it will ask for it now."
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    decode_payload "$tmp/payload.sh"
    if ! sh "$tmp/payload.sh" ensure; then
      echo "archive-roll: the roll was not restored -- sudo may have" >&2
      echo "  refused the command above. Take this to your instructor." >&2
      exit 1
    fi
    echo "Done. The house roll carries one more entry than it did a"
    echo "moment ago."
    ;;

  teardown)
    if ! on_roll; then
      echo "Nothing to remove -- the roll does not carry this entry."
      exit 0
    fi
    if ! have_root; then
      no_root_message
      exit 1
    fi
    echo "Course-level teardown -- run ONCE, at the end of the semester,"
    echo "never by any week's --reset. One command, via sudo: userdel --"
    echo "removing that one entry and nothing else. sudo may ask for your"
    echo "password now."
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    decode_payload "$tmp/payload.sh"
    if ! sh "$tmp/payload.sh" teardown; then
      echo "archive-roll: the entry was not removed -- sudo may have" >&2
      echo "  refused the command above." >&2
      exit 1
    fi
    echo "Removed. The house roll is back to its ordinary complement."
    ;;

  *)
    echo "usage: bash archive-roll.sh {ensure|check|teardown}" >&2
    exit 2
    ;;
esac
