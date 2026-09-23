#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-06: stage the signal box bench.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/interlocking/lever-07.lock    the lever that will not go back
#   ~/enginehouse/interlocking/lock-record.txt  the signal box's own record
#   the house roll                              one dormant entry restored, by
#                                               labs/lib/archive-roll.sh
#
# The roll entry is the course's, not this week's: later weeks rest on the
# same one. --reset takes the lever and the record and leaves the roll
# exactly as it found it. The roll has its own removal, run once at the end
# of term:  bash ../lib/archive-roll.sh teardown
#
# Sudo: this is the first week that needs the house keys, and it asks for
# them ONCE. Both jobs that need root are named below before either of them
# happens, and both are done inside the one window. If this bench cannot get
# root, the script says so and stands down having staged nothing -- a
# half-made signal box is worse than no signal box at all.
#
# Works offline. No crontab, no background processes.
set -eu

ENGINEHOUSE="$HOME/enginehouse"
FRAME="$ENGINEHOUSE/interlocking"
LOCK="$FRAME/lever-07.lock"
RECORD="$FRAME/lock-record.txt"
HOLDER_UID=1849

HERE="$(cd "$(dirname "$0")" && pwd)"
ROLL="$HERE/../lib/archive-roll.sh"

# --------------------------------------------------------------- root guard --
# A classic move (Weeks 1 and 3 both log it): run the whole script under sudo
# instead of letting it ask for root itself. That stages root's home, not
# yours, and every check this week reads from your own bench. Refuse before
# anything is created.
if [ "$(id -u)" -eq 0 ]; then
  echo "report-for-duty: run this as YOURSELF, not as root."                >&2
  echo "  This script asks for the house keys itself, once, exactly when"   >&2
  echo "  it needs them -- running it under sudo stages root's home"        >&2
  echo "  directory instead of yours, and nothing this week will find it"   >&2
  echo "  there. Nothing has been staged. Run it again as yourself:"        >&2
  echo "    bash report-for-duty.sh"                                        >&2
  exit 1
fi

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  rm -f "$LOCK" "$RECORD"
  rmdir "$FRAME" 2>/dev/null || true
  # enginehouse/ is shared with other weeks (Week 1 lays the rooms down), so
  # it goes only if this week leaves it empty and only if Week 1's own marker
  # is gone too -- the same guard Weeks 4 and 5 use.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. Lever 07 is free, its record is gone, and the signal box with it."
  echo "The house roll is untouched -- that entry belongs to the course and not to"
  echo "this week, and later work still rests on it. (bash ../lib/archive-roll.sh"
  echo "teardown removes it, once, at the end of term.)"
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# ------------------------------------------------------- what still wants doing
# Worked out before anything is created, so that a bench which cannot get root
# is left exactly as it was found rather than half-staged.
lever_is_staged() {
  [ -f "$LOCK" ] || return 1
  [ "$(stat -c %u "$LOCK" 2>/dev/null || echo none)" = "$HOLDER_UID" ]
}

need_roll=0
need_lever=0
bash "$ROLL" check || need_roll=1
lever_is_staged  || need_lever=1

# -------------------------------------------------------------- the house keys
stand_down() {
  echo "report-for-duty: this bench cannot get root -- either sudo is not"      >&2
  echo "  installed, or it wants a password prompt this session has no"         >&2
  echo "  terminal to give. Nothing has been staged: the signal box is exactly" >&2
  echo "  as you found it. Take this to your instructor rather than working"    >&2
  echo "  around it."                                                           >&2
  exit 1
}

if [ "$need_roll" -ne 0 ] || [ "$need_lever" -ne 0 ]; then
  echo "Before the bench can be staged, the house keys are wanted. They are"
  echo "asked for once, for the whole of the following, and for nothing else:"
  echo
  if [ "$need_roll" -ne 0 ]; then
    echo "  * The roll. One dormant entry is restored to it (useradd, by"
    echo "    labs/lib/archive-roll.sh): no password, no home directory, no"
    echo "    login shell -- nothing can log in as it. Reversible by name, and"
    echo "    shared with later weeks, so no week's --reset takes it away."
  fi
  if [ "$need_lever" -ne 0 ]; then
    echo "  * The lever. One file -- $LOCK"
    echo "    -- is made over to uid $HOLDER_UID (chown), so that the lock on the"
    echo "    frame and the signal box's record agree about who left lever 07"
    echo "    thrown. Nothing else changes hands."
  fi
  echo
  echo "One prompt covers all of it. sudo may ask for your password now, once,"
  echo "and everything listed above happens inside that one window."
  if [ "$need_roll" -ne 0 ]; then
    echo "(The roll office adds its own note on the first item as it works. It"
    echo "will not ask you for anything.)"
  fi
  echo

  command -v sudo >/dev/null 2>&1 || stand_down
  if ! sudo -n true 2>/dev/null; then
    { [ -t 0 ] && [ -t 1 ]; } || stand_down
    sudo -v || stand_down
  fi
fi

# -------------------------------------------------------------- the house roll
if [ "$need_roll" -ne 0 ]; then
  if ! bash "$ROLL" ensure; then
    echo "report-for-duty: the house roll was not restored, so the signal box" >&2
    echo "  has been left unstaged rather than half-staged. The message above" >&2
    echo "  is the roll office's -- take it to your instructor."               >&2
    exit 1
  fi
  echo
fi

# ------------------------------------------------------------------ the bench
mkdir -p "$FRAME"

if [ "$need_lever" -ne 0 ]; then
  rm -f "$LOCK"
  cat > "$LOCK" <<LEVER
INTERLOCKING FRAME -- NORTH GALLERY -- LEVER 07 -- HELD
held-by-uid: $HOLDER_UID
session opened: 1851-09-18 18:40
taken: 1851-09-21 04:12
note: whatever took this lever is no longer on the floor. The lock
      outlived it. The frame will not release lever 07 while this
      file stands.
LEVER
  if ! sudo chown "$HOLDER_UID" "$LOCK"; then
    # The record goes too -- an earlier run may have left one, and a record
    # standing beside no lock is exactly the half-staged bench this avoids.
    rm -f "$LOCK" "$RECORD"
    rmdir "$FRAME" 2>/dev/null || true
    echo "report-for-duty: the lock could not be made over to uid $HOLDER_UID," >&2
    echo "  so it has been withdrawn rather than left standing in the wrong"    >&2
    echo "  hands. Nothing is half-staged. Take this to your instructor."       >&2
    exit 1
  fi
fi

# The record is the signal box's own book and stays in your hands, so it is
# rewritten every time -- which is why running this script twice is dull.
cat > "$RECORD" <<RECORD
SIGNAL BOX RECORD -- NORTH GALLERY INTERLOCKING FRAME
Brassbridge Enginehouse, Work Order No. 1851-06

  frame ............ north gallery, levers 01-24
  lever ............ 07  (admits the single line)
  state ............ THROWN, and will not be worked back
  held by, uid ..... $HOLDER_UID
  held by, name .... -- the frame books numbers. It does not book names.
  taken ............ 21 September 1851, 04:12, before the early turn
  released ......... --
  holder present ... no. Nothing of that hand is on the floor, and
                     nothing of that hand is running.

  The frame will not release lever 07 while the lock stands beside this
  record, and the frame cannot tell you whose lock it is. It was never
  the frame's business to know. Numbers are kept here. Names are kept on
  the house roll, and the house roll will answer anyone who asks it
  properly.

  -- signed, the duty signalman, north gallery
RECORD

# ------------------------------------------------------------------ self-test
fail=0
[ -f "$LOCK" ]   || { echo "self-test: $LOCK missing" >&2; fail=1; }
[ -f "$RECORD" ] || { echo "self-test: $RECORD missing" >&2; fail=1; }

if [ -f "$LOCK" ]; then
  owner="$(stat -c %u "$LOCK" 2>/dev/null || echo none)"
  if [ "$owner" != "$HOLDER_UID" ]; then
    echo "self-test: the lock is held by uid $owner, not $HOLDER_UID" >&2
    fail=1
  fi
fi
if [ -f "$RECORD" ] && ! grep -q "$HOLDER_UID" "$RECORD"; then
  echo "self-test: the record does not book uid $HOLDER_UID" >&2
  fail=1
fi
if ! bash "$ROLL" check; then
  echo "self-test: the house roll does not carry uid $HOLDER_UID" >&2
  fail=1
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-06 :: bench staged and verified
  ------------------------------------------------------------------
   Signal box: ~/enginehouse/interlocking/lever-07.lock
               ~/enginehouse/interlocking/lock-record.txt
   Forge:      labs/week-06/starter   (interlocking, sorting-floor,
               ledger-hall, philosophers -- make builds all four)

   Lever 07 stands thrown and nobody on the floor will own it. The
   record books its holder by number, because numbers are the frame's
   business. Names are the house roll's.

   Take the four floors in the order they are listed. The last one does
   not finish, and is not meant to: it closes itself after five idle
   seconds, and Ctrl-C closes it sooner.
   (bash report-for-duty.sh --reset withdraws all of it. The house roll
   stays -- later weeks are standing on it.)
  ------------------------------------------------------------------

SLIP
