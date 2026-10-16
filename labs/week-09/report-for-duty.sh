#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-09: stage the Store's bench.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/src/siphon/store-siphon.c   the routine the Store's audit
#                                             turned up, recovered as source
#   ~/enginehouse/src/siphon/.valgrindrc      one line for valgrind
#   ~/enginehouse/src/siphon/store.gdb        two settings for gdb
#   ~/enginehouse/src/siphon/store-siphon     yours: you build it. Staging
#                                             again leaves it alone; --reset
#                                             takes it away by name
#
# Never touches another week's papers: Week 1's inbox/, Week 2's
# ~/.ledger-annex, Weeks 6 and 7's interlocking/, ring-line/ and manuals/.
# --reset leaves anything of yours in src/siphon/ (a vgcore, your notes)
# where it is, and src/ with it.
#
# The source stays on the bench this week: reading it is part of the work.
# Works offline. Needs no sudo, no crontab, no background processes.
# Needs gcc and valgrind (both are on every setup path).
set -eu

ENGINEHOUSE="$HOME/enginehouse"
SRC="$ENGINEHOUSE/src"
SIPHON="$SRC/siphon"
SOURCE="$SIPHON/store-siphon.c"
VGRC="$SIPHON/.valgrindrc"
GDBFILE="$SIPHON/store.gdb"
BUILT="$SIPHON/store-siphon"

# --------------------------------------------------------------- root guard --
# Running the whole script under sudo stages root's home, not yours, and
# every check this week reads from your own bench. This week needs no house
# keys at all. Refuse before anything is created.
if [ "$(id -u)" -eq 0 ]; then
  echo "report-for-duty: run this as YOURSELF, not as root."                >&2
  echo "  This week needs no house keys at all, and running it under sudo"  >&2
  echo "  stages root's home directory instead of yours -- nothing this"    >&2
  echo "  week will find it there. Nothing has been staged. Run it again"   >&2
  echo "  as yourself:"                                                     >&2
  echo "    bash report-for-duty.sh"                                        >&2
  exit 1
fi

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  rm -f "$SOURCE" "$VGRC" "$GDBFILE" "$BUILT"
  # Each room goes only if this week leaves it empty: rmdir refuses a room
  # that is not, which is exactly the guard wanted.
  rmdir "$SIPHON" 2>/dev/null || true
  rmdir "$SRC" 2>/dev/null || true
  # enginehouse/ is shared with other weeks (Week 1 lays the rooms down), so
  # it goes only if this week leaves it empty and only if Week 1's own marker
  # is gone too -- the same guard every week uses.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. The recovered source, its two settings files and your build are withdrawn."
  if [ -d "$SIPHON" ]; then
    echo "src/siphon/ still holds files this script did not make; they are yours, and left:"
    ls -A "$SIPHON" | sed 's/^/  /'
  elif [ -d "$SRC" ]; then
    echo "src/ still holds files this script did not make; they are yours, and left."
  fi
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# The recovered source, sealed for the journey. Decoded at stage time and
# left on the bench.
decode_source() { # writes the routine's C source to $1
  base64 -d > "$1" <<'B64'
Lyogc3RvcmUtc2lwaG9uIC0tIGRyYXdzIGZyb20gdGhlIFN0b3JlIGFuZCBrZWVwcyB3aGF0IGl0
IGRyYXdzLiAgLS0gRS5LLiAqLwojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5o
PgojaW5jbHVkZSA8c3RyaW5nLmg+CgovKiBOZXZlciBtb3JlIHRoYW4gdGhpcy4gVGhlIEVuZ2lu
ZSBzaGFsbCBub3Qgd2FudCBmb3IgYSBibG9jayBvbiBteSBhY2NvdW50LiAgLS0gRS5LLiAqLwoj
ZGVmaW5lIFNJUEhPTl9DQVAgIDQ4CiNkZWZpbmUgQkxPQ0tfU0laRSAgNDA5NgoKI2RlZmluZSBD
SVBIRVIgICAgICAweGE1CiNkZWZpbmUgRFJBRlRfTElORVMgNAoKLyogVGhlIGRyYWZ0IGlzIGtl
cHQgaW4gY2lwaGVyIG9uIHBhcGVyOyB0aGUgU3RvcmUga2VlcHMgdGhlIGZhaXIgY29weS4gIC0t
IEUuSy4gKi8Kc3RhdGljIGNvbnN0IHVuc2lnbmVkIGNoYXIgZHJhZnRfMVtdID0gewogICAgMHhm
MSwgMHhjYSwgMHg4NSwgMHhkMSwgMHhjZCwgMHhjMCwgMHg4NSwgMHhlNywgMHhjYSwgMHhjNCwg
MHhkNywgMHhjMSwKICAgIDB4ODUsIDB4Y2EsIDB4YzMsIDB4ODUsIDB4ZDEsIDB4Y2QsIDB4YzAs
IDB4ODUsIDB4ZTAsIDB4Y2IsIDB4YzIsIDB4Y2MsCiAgICAweGNiLCAweGMwLCAweGNkLCAweGNh
LCAweGQwLCAweGQ2LCAweGMwLCAweDg5LCAweDg1LCAweGM0LCAweGNiLCAweGMxLAogICAgMHg4
NSwgMHhkMSwgMHhjYSwgMHg4NSwgMHhjYywgMHhkMSwgMHhkNiwgMHg4NSwgMHhjMiwgMHhkMCwg
MHhjMCwgMHhkNiwKICAgIDB4ZDEsIDB4ZDYsIDB4ODUsIDB4YzQsIDB4ZDEsIDB4ODUsIDB4ZDEs
IDB4Y2QsIDB4YzAsIDB4ODUsIDB4ZTAsIDB4ZGQsCiAgICAweGNkLCAweGNjLCAweGM3LCAweGNj
LCAweGQxLCAweGNjLCAweGNhLCAweGNiLCAweDg1LCAweDg4LCAweDg4LCAweDAwLAp9OwoKc3Rh
dGljIGNvbnN0IHVuc2lnbmVkIGNoYXIgZHJhZnRfMltdID0gewogICAgMHg4YiwgMHg4YiwgMHg4
YiwgMHhkMSwgMHhjZCwgMHhjMCwgMHhkYywgMHg4NSwgMHhjNiwgMHhjNCwgMHhjOSwgMHhjOSwK
ICAgIDB4YzAsIDB4YzEsIDB4ODUsIDB4Y2EsIDB4ZDAsIDB4ZDcsIDB4ODUsIDB4ZDIsIDB4Y2Es
IDB4ZDcsIDB4Y2UsIDB4ODUsCiAgICAweGQ2LCAweGQwLCAweGQ1LCAweGMwLCAweGQ3LCAweGQ2
LCAweGMwLCAweGMxLCAweGMwLCAweGMxLCAweDhiLCAweDhiLAogICAgMHg4YiwgMHgwMCwKfTsK
CnN0YXRpYyBjb25zdCB1bnNpZ25lZCBjaGFyIGRyYWZ0XzNbXSA9IHsKICAgIDB4OGIsIDB4OGIs
IDB4OGIsIDB4ZDEsIDB4Y2QsIDB4YzAsIDB4ZGMsIDB4ODUsIDB4YzYsIDB4YzQsIDB4YzksIDB4
YzksCiAgICAweGMwLCAweGMxLCAweDg1LCAweGNhLCAweGQwLCAweGQ3LCAweDg1LCAweGQyLCAw
eGNhLCAweGQ3LCAweGNlLCAweDg1LAogICAgMHhjYSwgMHhjNywgMHhkNiwgMHhjYSwgMHhjOSwg
MHhjMCwgMHhkMSwgMHhjMCwgMHg4YiwgMHg4YiwgMHg4YiwgMHgwMCwKfTsKCnN0YXRpYyBjb25z
dCB1bnNpZ25lZCBjaGFyIGRyYWZ0XzRbXSA9IHsKICAgIDB4ZTQsIDB4ODUsIDB4ZDEsIDB4Y2Es
IDB4Y2EsIDB4YzksIDB4ODUsIDB4Y2MsIDB4ZDYsIDB4ODUsIDB4Y2EsIDB4YzcsCiAgICAweGQ2
LCAweGNhLCAweGM5LCAweGMwLCAweGQxLCAweGMwLCAweDhiLCAweDg1LCAweGYyLCAweGMwLCAw
eDg1LCAweGQyLAogICAgMHhjMCwgMHhkNywgMHhjMCwgMHg4NSwgMHhjYiwgMHhjMCwgMHhkMywg
MHhjMCwgMHhkNywgMHg4NSwgMHhkMSwgMHhjZCwKICAgIDB4YzAsIDB4ODUsIDB4ZDEsIDB4Y2Es
IDB4Y2EsIDB4YzksIDB4OWUsIDB4ODUsIDB4ZDIsIDB4YzAsIDB4ODUsIDB4ZDIsCiAgICAweGMw
LCAweGQ3LCAweGMwLCAweDg1LCAweGQxLCAweGNkLCAweGMwLCAweDg1LCAweGM2LCAweGNkLCAw
eGMwLCAweGM2LAogICAgMHhjZSwgMHg4NSwgMHhkMCwgMHhkNSwgMHhjYSwgMHhjYiwgMHg4NSwg
MHhjYywgMHhkMSwgMHg4YiwgMHgwMCwKfTsKCnN0YXRpYyBjb25zdCB1bnNpZ25lZCBjaGFyICpj
b25zdCBkcmFmdFtEUkFGVF9MSU5FU10gPSB7CiAgICBkcmFmdF8xLCBkcmFmdF8yLCBkcmFmdF8z
LCBkcmFmdF80LAp9OwoKc3RhdGljIGludCBkcmF3bjsKCnN0YXRpYyB2b2lkIGRyYXdfYmxvY2so
dm9pZCkKewogICAgY2hhciAqYmxvY2sgPSBtYWxsb2MoQkxPQ0tfU0laRSk7CgogICAgaWYgKGJs
b2NrID09IE5VTEwpCiAgICAgICAgcmV0dXJuOwogICAgbWVtc2V0KGJsb2NrLCAwLCBCTE9DS19T
SVpFKTsKICAgIGRyYXduKys7Cn0KCi8qIEEgZmFpciBjb3B5IGlzIG5ldmVyIHdyaXR0ZW4gb3Zl
ci4gQSBuZXcgYmxvY2sgZm9yIGV2ZXJ5IGhhbmQuICAtLSBFLksuICovCnN0YXRpYyB2b2lkIGZh
aXJfY29weShjb25zdCBjaGFyICpsaW5lKQp7CiAgICBzaXplX3QgbiA9IHN0cmxlbihsaW5lKTsK
ICAgIGNoYXIgKmNvcHkgPSBtYWxsb2MobiArIDEpOwogICAgc2l6ZV90IGk7CgogICAgaWYgKGNv
cHkgPT0gTlVMTCkKICAgICAgICByZXR1cm47CiAgICBmb3IgKGkgPSAwOyBpIDwgbjsgaSsrKQog
ICAgICAgIGNvcHlbaV0gPSAoY2hhcikobGluZVtpXSBeIENJUEhFUik7CiAgICBjb3B5W25dID0g
J1wwJzsKICAgIGRyYXduKys7Cn0KCnZvaWQgc2lwaG9uX3Jlc3RzKHZvaWQpCnsKfQoKaW50IG1h
aW4odm9pZCkKewogICAgY2hhciB0YWxseVs4MF07CiAgICBpbnQgaTsKCiAgICBmb3IgKGkgPSAw
OyBpIDwgU0lQSE9OX0NBUDsgaSsrKQogICAgICAgIGRyYXdfYmxvY2soKTsKICAgIGZvciAoaSA9
IDA7IGkgPCBEUkFGVF9MSU5FUzsgaSsrKQogICAgICAgIGZhaXJfY29weSgoY29uc3QgY2hhciAq
KWRyYWZ0W2ldKTsKICAgIHNucHJpbnRmKHRhbGx5LCBzaXplb2YgdGFsbHksCiAgICAgICAgICAg
ICAic3RvcmUtc2lwaG9uOiAlZCBibG9ja3MgZHJhd24gZnJvbSB0aGUgU3RvcmU7IG5vbmUgcmV0
dXJuZWQuIiwgZHJhd24pOwogICAgc2lwaG9uX3Jlc3RzKCk7CgogICAgcHV0cyh0YWxseSk7CiAg
ICBwdXRzKCJzdG9yZS1zaXBob246IHRoZSBjYXAgaXMgcmVhY2hlZC4gUmVzdGluZy4iKTsKICAg
IHJldHVybiAwOwp9Cg==
B64
}

# ------------------------------------------------------------ the toolchain --
# Checked before anything is staged, so a bench that cannot do the week is
# left exactly as it was found.
for tool in gcc valgrind; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "report-for-duty: $tool not found -- this week builds the routine at your" >&2
    echo "  own bench and walks it under valgrind. Nothing has been staged."       >&2
    echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting, then try again." >&2
    exit 1
  fi
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_source "$tmp/store-siphon.c"

# ------------------------------------------------------------------ the bench
mkdir -p "$SIPHON"
cp "$tmp/store-siphon.c" "$SOURCE"
printf '%s\n' '--enable-debuginfod=no' > "$VGRC"
printf '%s\n' 'set debuginfod enabled off' 'set pagination off' > "$GDBFILE"
# A store-siphon already here is your own build, and is left as it is.

# ------------------------------------------------------------------ self-test
fail=0
if [ ! -s "$SOURCE" ]; then
  echo "self-test: $SOURCE missing or empty" >&2; fail=1
else
  # It must build clean, exactly as the work order builds it -- but in a
  # scratch room, so your own build is never touched.
  mkdir "$tmp/build"
  cp "$SOURCE" "$tmp/build/store-siphon.c"
  if ! ( cd "$tmp/build" && gcc -g -O0 -Wall -Wextra -o store-siphon store-siphon.c ) \
       > "$tmp/build/gcc.txt" 2>&1; then
    echo "self-test: the recovered source did not build on this bench:" >&2
    cat "$tmp/build/gcc.txt" >&2; fail=1
  elif [ -s "$tmp/build/gcc.txt" ]; then
    echo "self-test: the recovered source builds, but not clean:" >&2
    cat "$tmp/build/gcc.txt" >&2; fail=1
  fi
  signed="$(grep -c -- '-- [A-Z]\.[A-Z]\. \*/$' "$SOURCE" || true)"
  if [ "$signed" != "4" ]; then
    echo "self-test: $SOURCE carries $signed signed comments, not 4" >&2; fail=1
  fi
fi
if [ "$(cat "$VGRC" 2>/dev/null)" != "--enable-debuginfod=no" ]; then
  echo "self-test: $VGRC does not read exactly --enable-debuginfod=no" >&2; fail=1
fi
if [ "$(cat "$GDBFILE" 2>/dev/null)" != "$(printf '%s\n' 'set debuginfod enabled off' 'set pagination off')" ]; then
  echo "self-test: $GDBFILE is not the two settings lines" >&2; fail=1
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above. Take this to" >&2
  echo "  your instructor rather than working around it."                     >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-09 :: bench staged and verified
  ------------------------------------------------------------------
   Source:  ~/enginehouse/src/siphon/store-siphon.c
   Also:    ~/enginehouse/src/siphon/.valgrindrc   (one line for valgrind)
            ~/enginehouse/src/siphon/store.gdb     (two settings for gdb)

   The routine the Store's audit turned up, recovered whole and left
   as source. Nothing has been built and nothing is running: you
   build it yourself, with the line in the work order, when the work
   order says to.
   No house keys were wanted this week.
   (bash report-for-duty.sh --reset withdraws all of it, and your
   build of store-siphon with it.)
  ------------------------------------------------------------------

SLIP

# The week's dump works in gdb as well. It is on every setup path, but a bench that
# lost it should hear so now rather than at the first command.
if ! command -v gdb >/dev/null 2>&1; then
  echo "report-for-duty: note -- gdb is not on this bench, and this week's dump needs it." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting." >&2
fi
