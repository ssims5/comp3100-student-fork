#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-10: stage the survey bench.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/survey/record-keeper      a keeper, compiled here, launched
#                                           as the archive account (uid 1849),
#                                           its hidden wing mapped and walled off
#   ~/enginehouse/survey/.record-keeper.pid the register of what is at work
#                                           (Week 3's pidfile idiom)
#   ~/enginehouse/survey/survey.gdb         two settings for gdb
#   ~/enginehouse/survey/wing.dump          only if you dump the wing yourself;
#                                           --reset sweeps it up with the rest
#   the house roll                          one dormant entry restored, by
#                                           labs/lib/archive-roll.sh
#
# Never touches Week 9's ~/enginehouse/src/ (the Store's siphon), Week 6's
# ~/enginehouse/interlocking/, Week 2's ~/.ledger-annex, or anything else.
# The roll entry is the course's, not this week's: later weeks rest on the
# same one, so no week's --reset removes it. The roll has its own removal,
# run once at end of term:  bash ../lib/archive-roll.sh teardown
#
# The keeper does NOT survive `wsl --shutdown` or a reboot: it is a living
# process, not a file. Re-run this script to stage it afresh.
#
# Sudo: this week asks for the house keys ONCE. Both jobs that need root are
# named below before either happens, and both are done inside the one window:
# restoring the roll entry, and launching the keeper as uid 1849. If this
# bench cannot get root, the script says so and stands down having staged
# nothing.
#
# Works offline. Needs gcc (Week 1's smoke test proved yours).
set -eu

ENGINEHOUSE="$HOME/enginehouse"
SURVEY="$ENGINEHOUSE/survey"
BIN="$SURVEY/record-keeper"
PIDFILE="$SURVEY/.record-keeper.pid"
GDBFILE="$SURVEY/survey.gdb"
DUMP="$SURVEY/wing.dump"
HOLDER_UID=1849
UNIT=record-keeper

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

# Is systemd the init here, and is systemd-run on the bench? If so, the keeper
# is launched as a transient unit, which systemd keeps alive past the shell
# that staged it. If not, we fall back to setsid (see launch_keeper).
have_systemd_run() {
  command -v systemd-run >/dev/null 2>&1 && [ -d /run/systemd/system ]
}

# The keeper's pid, read off the bench without root: pgrep by owner and name.
keeper_pid() { pgrep -u "$HOLDER_UID" -x record-keeper 2>/dev/null | head -1; }

# Is the keeper actually at work? A register can go stale, so look for a
# uid-1849 process of exactly that name in /proc. (Not kill -0: you may not
# signal another account's process, so the knock fails with EPERM.)
keeper_up() {
  _p="$(keeper_pid)"
  [ -n "$_p" ] && [ -d "/proc/$_p" ]
}

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  # Stopping a process owned by uid 1849 needs the house keys, because you
  # launched it as that account, not as yourself. One sudo step, named here.
  if keeper_up; then
    echo "Standing the keeper down. One step, via sudo: it stops the keeper"
    echo "the roll owns (uid $HOLDER_UID). sudo may ask for your password now."
    if ! command -v sudo >/dev/null 2>&1 || { ! sudo -n true 2>/dev/null && { ! { [ -t 0 ] && [ -t 1 ]; } || ! sudo -v; }; }; then
      echo "report-for-duty: this bench cannot get root, so the keeper could"   >&2
      echo "  not be stood down. Nothing has been removed -- the survey is"     >&2
      echo "  exactly as you found it, the keeper still at work. Take this to"  >&2
      echo "  your instructor rather than working around it."                   >&2
      exit 1
    fi
    # Stop the transient unit if that is how it was launched. Otherwise (and
    # as a backstop) find the keeper the way keeper_pid does -- pgrep, uid
    # 1849, exact name, never the register, which can be stale -- and take
    # it down: SIGTERM, then, if it will not go, SIGKILL.
    if have_systemd_run; then
      sudo systemctl stop "$UNIT" 2>/dev/null || true
    fi
    if keeper_up; then
      pid="$(keeper_pid)"
      sudo kill -TERM "$pid" 2>/dev/null || true
      i=0
      while [ "$i" -lt 40 ] && [ -d "/proc/$pid" ]; do sleep 0.1; i=$((i + 1)); done
      [ -d "/proc/$pid" ] && sudo kill -KILL "$pid" 2>/dev/null || true
    fi
    if have_systemd_run; then
      sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
    fi
    if keeper_up; then
      echo "report-for-duty: the keeper would not stand down. Nothing has been" >&2
      echo "  removed. Take this to your instructor."                           >&2
      exit 1
    fi
  else
    # Not at work -- a reboot or wsl --shutdown may have taken it. Clear a
    # stale unit if root is free, but do not demand it just to sweep files.
    if have_systemd_run && sudo -n true 2>/dev/null; then
      sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
    fi
  fi

  # The survey is yours; the dump (if you took one) and the binary and the
  # register go with it. wing.dump is written by root under gdb, but it sits
  # in a directory you own, so you may remove it without sudo.
  rm -f "$BIN" "$PIDFILE" "$GDBFILE" "$DUMP"
  rmdir "$SURVEY" 2>/dev/null || true
  # enginehouse/ is shared (Week 1 lays the rooms down; Week 9's src/ may
  # still stand). It goes only if this week leaves it empty and Week 1's own
  # marker is gone too -- the guard Weeks 4-7 use. A standing src/ keeps it.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. The keeper is stood down and the survey with it."
  if [ -d "$ENGINEHOUSE" ]; then
    echo "~/enginehouse still holds other weeks' papers (Week 9's src/, perhaps); they were not touched."
  fi
  echo "The house roll is untouched -- that entry belongs to the course and not"
  echo "to this week, and later work still rests on it. (bash ../lib/archive-roll.sh"
  echo "teardown removes it, once, at the end of term.)"
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# The sealed drawing of the keeper. Decoded at stage time, compiled, and swept
# up: only the built keeper is left on the bench. The names in its mapped
# record live only here, in the payload (the publish gate scans payloads for
# instructor filenames, not story names) and in the wing it maps -- never in
# any file this week ships.
decode_keeper() { # writes the keeper's C source to $1
  base64 -d > "$1" <<'B64'
LyogcmVjb3JkLWtlZXBlci5jIC0tIGEga2VlcGVyIHRoYXQgbm8gc2NoZWR1bGUgb3ducy4KICoK
ICogQnVpbHQgb24gdGhlIGJlbmNoIGJ5IHJlcG9ydC1mb3ItZHV0eS5zaCBhbmQgbGF1bmNoZWQs
IG9uY2UsIHVuZGVyIHRoZQogKiBob3VzZSBrZXlzOiBpdCBkcm9wcyB0byB0aGUgYXJjaGl2ZSBh
Y2NvdW50ICh1aWQgMTg0OSkgYW5kIHN0YW5kcyBmb3JldmVyLgogKiBCZWZvcmUgaXQgZHJvcHMs
IGl0IG1hcHMgb25lIGFub255bW91cyByZWdpb24gLS0gdGhlIGhpZGRlbiB3aW5nIC0tIHdyaXRl
cwogKiB0aGUgb2xkIENvbXB1dGluZyBSb29tJ3MgcHJlc2VydmVkIHJlY29yZHMgaW50byBpdCwg
YW5kIHRoZW4gd2FsbHMgdGhlCiAqIHdpbmcgb2ZmIHdpdGggUFJPVF9OT05FLiBUaGUgcmVjb3Jk
cyBhcmUgbWFwcGVkIGJ1dCB1bnJlYWNoYWJsZTogdGhlIHdpbmcKICogc2hvd3MgaW4gL3Byb2Mv
PHBpZD4vbWFwcyBhcyBvbmUgLS0tcCBsaW5lLCBpdHMgdmlydHVhbCBzaXplIGNvdW50cywgaXRz
CiAqIHJlc2lkZW50IHNpemUgZG9lcyBub3QsIGFuZCBvbmx5IGEgZGVidWdnZXIgYXR0YWNoZWQg
YXMgcm9vdCBjYW4gcmVhZCBpdC4KICoKICogSXQgcHJpbnRzIG5vdGhpbmcuIFRoZSByZWNvcmRz
IGxpdmUgb25seSBpbiB0aGUgbWFwcGVkIHdpbmcsIHJlY292ZXJlZCBieQogKiBkdW1wLCBuZXZl
ciBvbiBhIHRlcm1pbmFsIG9yIGluIGEgZmlsZSBvbiB0aGUgYmVuY2guCiAqCiAqIEdlbmVyYXRl
ZCBmcm9tIGEgYmFzZTY0IHBheWxvYWQgYXQgc3RhZ2luZzsgdGhlIHNvdXJjZSBpcyBub3QgbGVm
dCBiZWhpbmQuCiAqLwojZGVmaW5lIF9HTlVfU09VUkNFCiNpbmNsdWRlIDxncnAuaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2lu
Y2x1ZGUgPHN5cy9tbWFuLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KCi8qIFRoZSBhcmNoaXZl
IGFjY291bnQsIGFzIHRoZSBob3VzZSByb2xsIGNhcnJpZXMgaXQgKHVpZCAxODQ5LCBwcmltYXJ5
CiAqIGdyb3VwIDEwMCAtLSAidXNlcnMiLCB0aGUgZGVmYXVsdCBncm91cCB1c2VyYWRkIC1OIGxl
YXZlcyBpdCBpbikuICovCiNkZWZpbmUgQVJDSElWRV9VSUQgMTg0OQojZGVmaW5lIEFSQ0hJVkVf
R0lEIDEwMAoKLyogVGhlIGhpZGRlbiB3aW5nOiBhIGZpeGVkLCBkaXN0aW5jdGl2ZSBjb3VudCBv
ZiBwYWdlcy4gVGhlIGJ5dGUgc2l6ZSBpcwogKiBXSU5HX1BBR0VTICogdGhlIGJlbmNoJ3MgcGFn
ZSBzaXplLCBzbyBhIDQgS2lCLXBhZ2UgYmVuY2ggZ2l2ZXMgMTAyNCBLaUIKICogKDEgTWlCKSBh
bmQgYSAxNiBLaUItcGFnZSBiZW5jaCBnaXZlcyA0MDk2IEtpQiAtLSByb3VuZCBhbmQgZGlzdGlu
Y3RpdmUKICogZWl0aGVyIHdheS4gVGhlIHdpbmcgaXMgZm91bmQgYnkgaXRzIHNoYXBlICgtLS1w
IGFuZCB0aGlzIHNpemUpLCBuZXZlciBieQogKiBhIHBpbm5lZCBhZGRyZXNzOiB0aGUgYWRkcmVz
cyBpcyBBU0xSLXJhbmRvbWlzZWQgZXZlcnkgcnVuLiAqLwojZGVmaW5lIFdJTkdfUEFHRVMgMjU2
CgovKiBUaGUgb2xkIENvbXB1dGluZyBSb29tJ3MgcHJlc2VydmVkIHJlY29yZHMuIEtlcHQgcGVy
aW9kLXBsYWluIGFuZCBBU0NJSQogKiAoYW4gZW0gZGFzaCBkb2VzIG5vdCBzdXJ2aXZlIGBzdHJp
bmdzYCwgd2hpY2ggZHJvcHMgbm9uLUFTQ0lJIGJ5dGVzIGFuZAogKiB3b3VsZCBzcGxpdCB0aGUg
cm90YSBsaW5lIGluIHR3bzsgdGhlIGNsb3NpbmcgYmVhdCBuZWVkcyB0aGUgcm90YSBsaW5lCiAq
IHdob2xlKS4gVGhlIHJlY29yZCBuYW1lcyBFLksuIGFuZCBFYXN0IGdhbGxlcnkgYW5kIGJvdGgg
Y2FuZGlkYXRlcywgd2l0aAogKiBubyBjb25jbHVzaW9uIGRyYXduIC0tIGl0IGlzIGFuIGFyY2hp
dmUsIG5vdCBhIHZlcmRpY3QuICovCnN0YXRpYyBjb25zdCBjaGFyIHJlY29yZHNbXSA9CiAgICAi
QlJBU1NCUklER0UgRU5HSU5FSE9VU0UgLS0gT0xEIENPTVBVVElORyBST09NXG4iCiAgICAiUHJl
c2VydmVkIHJlY29yZHMgb2YgdGhlIGNvbXB1dGVyIGNvcnBzLCBoZWxkIHdob2xlIGZvciB0aGVc
biIKICAgICJFeGhpYml0aW9uIGFyY2hpdmUsIHVuY3V0LCBhcyB0aGUgYXJjaGl2aXN0IHJlY2Vp
dmVkIHRoZW0uXG4iCiAgICAiXG4iCiAgICAiICBUSEUgQ0hJRUYgQ09NUFVURVInUyBSRUNPUkRc
biIKICAgICIgIEtVUkVPUywgSS4gTS4gLS0gQ2hpZWYgQ29tcHV0ZXIsIHJldGlyZWQgd2l0aG91
dCBwZW5zaW9uLCAxODQ5LlxuIgogICAgIlxuIgogICAgIiAgREVTSy1NQVJLIFJPU1RFUlxuIgog
ICAgIiAgRS5LLiA9IEVhc3QgZ2FsbGVyeSwgZGVzayBLIC0tIHRoZSBDaGllZiBDb21wdXRlcidz
IHN0YXRpb24uXG4iCiAgICAiICBIZWxkIGJ5IEtVUkVPUywgSS4gTS4sIDE4MzAtMTg0OS5cbiIK
ICAgICJcbiIKICAgICIgIFdJTkQtRE9XTiBST1RBXG4iCiAgICAiVEhJU1RMRVdPT0QsIE4uIC0t
IHNlY29uZGVkIDE4NDg7IGRlc2sgSywgRWFzdCBnYWxsZXJ5LCBhdCB0aGUgd2luZC1kb3duLlxu
IgogICAgIlxuIgogICAgIiAgLS0gZW50ZXJlZCBieSB0aGUgYXJjaGl2aXN0LiBObyBjb25jbHVz
aW9uIGlzIGRyYXduLlxuIjsKCmludCBtYWluKHZvaWQpCnsKICAgIGxvbmcgcGFnZXNpemUgPSBz
eXNjb25mKF9TQ19QQUdFU0laRSk7CiAgICBpZiAocGFnZXNpemUgPD0gMCkKICAgICAgICByZXR1
cm4gMTsKICAgIHNpemVfdCB3aW5nID0gKHNpemVfdClwYWdlc2l6ZSAqIFdJTkdfUEFHRVM7Cgog
ICAgLyogTWFwIHRoZSB3aW5nIHJlYWRhYmxlIGFuZCB3cml0YWJsZSwgd3JpdGUgdGhlIHJlY29y
ZHMgaW4sIHRoZW4gd2FsbAogICAgICogaXQgb2ZmLiBUaGUgcmVnaW9uIGlzIGFub255bW91cyBh
bmQgcHJpdmF0ZSwgc28gaXQgY2FycmllcyBubyBmaWxlCiAgICAgKiBiYWNraW5nIGFuZCBpdHMg
LS0tcCBsaW5lIG5ldmVyIG1lcmdlcyB3aXRoIGEgbmVpZ2hib3VyLiAqLwogICAgY2hhciAqcCA9
IG1tYXAoTlVMTCwgd2luZywgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwKICAgICAgICAgICAgICAg
ICAgIE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUywgLTEsIDApOwogICAgaWYgKHAgPT0gTUFQ
X0ZBSUxFRCkKICAgICAgICByZXR1cm4gMTsKICAgIG1lbWNweShwLCByZWNvcmRzLCBzaXplb2Yg
cmVjb3Jkcyk7ICAgICAgLyogdG91Y2hlcyB0aGUgZmlyc3QgcGFnZSBvbmx5ICovCiAgICBpZiAo
bXByb3RlY3QocCwgd2luZywgUFJPVF9OT05FKSAhPSAwKQogICAgICAgIHJldHVybiAxOwoKICAg
IC8qIERyb3AgdG8gdGhlIGFyY2hpdmUgYWNjb3VudCwgYnV0IG9ubHkgd2hlbiBzdGFydGVkIGFz
IHJvb3QgKHRoZQogICAgICogc3R1ZGVudCwgcnVubmluZyBpdCBieSBoYW5kLCBpcyBsZWZ0IGFz
IHRoZW1zZWx2ZXMgYW5kIHRoZSBkcm9wIGlzCiAgICAgKiBza2lwcGVkKS4gR3JvdXBzIGZpcnN0
LCB0aGVuIGdpZCwgdGhlbiB1aWQgbGFzdCAtLSBvbmNlIHRoZSB1aWQgaXMKICAgICAqIGRyb3Bw
ZWQgdGhlIG90aGVycyBjYW4gbm8gbG9uZ2VyIGJlIHNldC4gKi8KICAgIGlmIChnZXRldWlkKCkg
PT0gMCkgewogICAgICAgIGlmIChzZXRncm91cHMoMCwgTlVMTCkgIT0gMCkKICAgICAgICAgICAg
cmV0dXJuIDE7CiAgICAgICAgaWYgKHNldHJlc2dpZChBUkNISVZFX0dJRCwgQVJDSElWRV9HSUQs
IEFSQ0hJVkVfR0lEKSAhPSAwKQogICAgICAgICAgICByZXR1cm4gMTsKICAgICAgICBpZiAoc2V0
cmVzdWlkKEFSQ0hJVkVfVUlELCBBUkNISVZFX1VJRCwgQVJDSElWRV9VSUQpICE9IDApCiAgICAg
ICAgICAgIHJldHVybiAxOwogICAgfQoKICAgIGlmIChjaGRpcigiLyIpICE9IDApCiAgICAgICAg
cmV0dXJuIDE7CgogICAgLyogQ29weSBpdHNlbGYgYW5kIGxldCB0aGUgb3JpZ2luYWwgd2FsayBh
d2F5LCBzbyB0aGUgY29weSBpcyBsZWZ0IGZvcgogICAgICogdGhlIE92ZXJzZWVyJ3MgaG91c2Vo
b2xkIChQSUQgMSkgdG8gYWRvcHQ6IG5vIHNjaGVkdWxlIG93bnMgaXQuICovCiAgICBwaWRfdCBj
b3B5ID0gZm9yaygpOwogICAgaWYgKGNvcHkgPCAwKQogICAgICAgIHJldHVybiAxOwogICAgaWYg
KGNvcHkgPiAwKQogICAgICAgIHJldHVybiAwOwoKICAgIGZvciAoOzspCiAgICAgICAgcGF1c2Uo
KTsKICAgIHJldHVybiAwOwp9Cg==
B64
}

# Launch the keeper as uid 1849. It drops its own privileges (setgroups,
# setresgid, setresuid) once it is up, so it is started as root and ends as
# the archive account.
#
# Preferred: a transient systemd unit. systemd keeps it alive past the shell
# that staged it and tops its chain out at PID 1 -- no schedule owns it.
# Fallback (no systemd as PID 1, or no systemd-run): setsid. That path may not
# outlive its login session -- a shell logout can have its scope torn down and
# the keeper reaped with it -- so it is only for benches without systemd.
launch_keeper() {
  if have_systemd_run; then
    sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
    # Type=forking: the keeper forks and its parent exits; a default
    # (simple) unit would take that exit for the end and reap the copy.
    sudo systemd-run --collect --quiet --unit="$UNIT" -p Type=forking "$BIN"
  else
    sudo setsid "$BIN" </dev/null >/dev/null 2>&1
  fi
}

# ------------------------------------------------------ what still wants doing
# Worked out before anything root happens, so a bench that cannot get root is
# left as it was found rather than half-staged.
need_roll=0
need_keeper=0
bash "$ROLL" check || need_roll=1
keeper_up || need_keeper=1

# ------------------------------------------------------------ build the keeper
# Built before the root window, so a bench that cannot build it is left
# exactly as it was found. Built every run, but only put in place when a
# keeper is about to be launched (or the binary is missing): a keeper already
# at work is left running on the very file at this path, so maps, pmap and
# gdb never show it as (deleted) after a re-stage.
if ! command -v gcc >/dev/null 2>&1; then
  echo "report-for-duty: gcc not found -- this week's keeper is compiled at your own bench." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting, then try again." >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_keeper "$tmp/record-keeper.c"
if ! ( cd "$tmp" && gcc -O0 -s -Wall -Wextra -o record-keeper record-keeper.c ); then
  echo "report-for-duty: the keeper did not build on this bench. The messages"  >&2
  echo "  above are gcc's. Nothing has been staged. Take this to your"          >&2
  echo "  instructor rather than working around it."                            >&2
  exit 1
fi

# -------------------------------------------------------------- the house keys
stand_down() {
  echo "report-for-duty: this bench cannot get root -- either sudo is not"      >&2
  echo "  installed, or it wants a password prompt this session has no"         >&2
  echo "  terminal to give. Nothing has been staged: the survey is exactly"     >&2
  echo "  as you found it. Take this to your instructor rather than working"    >&2
  echo "  around it."                                                           >&2
  exit 1
}

if [ "$need_roll" -ne 0 ] || [ "$need_keeper" -ne 0 ]; then
  echo "Before the bench can be staged, the house keys are wanted. They are"
  echo "asked for once, for the whole of the following, and for nothing else:"
  echo
  if [ "$need_roll" -ne 0 ]; then
    echo "  * The roll. One dormant entry is restored to it (useradd, by"
    echo "    labs/lib/archive-roll.sh): no password, no home directory, no"
    echo "    login shell -- nothing can log in as it. Reversible by name, and"
    echo "    shared with later weeks, so no week's --reset takes it away."
  fi
  if [ "$need_keeper" -ne 0 ]; then
    if have_systemd_run; then
      echo "  * The keeper. It is launched as a transient unit named"
      echo "    '$UNIT' (systemd-run), which then drops itself to uid"
      echo "    $HOLDER_UID and stands. systemd keeps it alive past this shell;"
      echo "    its chain tops out at PID 1, so no schedule owns it."
    else
      echo "  * The keeper. It is launched (setsid) and drops itself to uid"
      echo "    $HOLDER_UID, then stands. This bench has no systemd to keep it,"
      echo "    so it may not outlive this login session."
    fi
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
    echo "report-for-duty: the house roll was not restored, so the keeper has"  >&2
    echo "  been left unstaged rather than half-staged. The message above is"   >&2
    echo "  the roll office's -- take it to your instructor."                    >&2
    exit 1
  fi
  echo
fi

# ------------------------------------------------------------------ the bench
mkdir -p "$SURVEY"
if [ "$need_keeper" -ne 0 ] || [ ! -e "$BIN" ]; then
  mv -f "$tmp/record-keeper" "$BIN"
fi
printf '%s\n' 'set debuginfod enabled off' 'set pagination off' > "$GDBFILE"

# ------------------------------------------------------------- launch the keeper
if [ "$need_keeper" -ne 0 ]; then
  if ! launch_keeper; then
    echo "report-for-duty: the keeper could not be launched. Take this to your" >&2
    echo "  instructor."                                                        >&2
    exit 1
  fi
  # It forks as it drops privileges; wait for the copy to answer to its name.
  i=0
  while [ "$i" -lt 40 ] && ! keeper_up; do sleep 0.1; i=$((i + 1)); done
fi

# The register is yours. It is a record for you, not how this script finds
# the keeper (that is pgrep, above): it is rewritten to the keeper at work
# now, so a re-run that found it already up still points it at the live pid.
if keeper_up; then
  keeper_pid > "$PIDFILE"
fi

# ------------------------------------------------------------------ self-test
fail=0
[ -x "$BIN" ] || { echo "self-test: $BIN missing or not executable" >&2; fail=1; }
[ -f "$GDBFILE" ] || { echo "self-test: $GDBFILE missing" >&2; fail=1; }
if [ "$(cat "$GDBFILE" 2>/dev/null)" != "$(printf '%s\n' 'set debuginfod enabled off' 'set pagination off')" ]; then
  echo "self-test: $GDBFILE is not the two canon lines" >&2; fail=1
fi
if keeper_up; then
  pid="$(keeper_pid)"
  owner="$(awk '/^Uid:/{print $2}' "/proc/$pid/status" 2>/dev/null || echo none)"
  if [ "$owner" != "$HOLDER_UID" ]; then
    echo "self-test: the keeper runs as uid $owner, not $HOLDER_UID" >&2; fail=1
  fi
  if [ "$(cat "$PIDFILE" 2>/dev/null)" != "$pid" ]; then
    echo "self-test: the register does not point at the keeper's pid" >&2; fail=1
  fi
else
  echo "self-test: no keeper is at work after staging" >&2; fail=1
fi
if ! bash "$ROLL" check; then
  echo "self-test: the house roll does not carry uid $HOLDER_UID" >&2; fail=1
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

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

   The keeper is a living process, not a file: it does NOT survive
   `wsl --shutdown` or a reboot. Re-run this script to stage it
   afresh. (bash report-for-duty.sh --reset stands it down and
   sweeps the survey. The house roll stays -- later weeks are
   standing on it.)
  ------------------------------------------------------------------

SLIP

# gdb is this week's instrument. It is on every setup path, but a bench that
# lost it should hear so now rather than at the first command.
if ! command -v gdb >/dev/null 2>&1; then
  echo "report-for-duty: note -- gdb is not on this bench, and this week needs it." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting." >&2
fi
