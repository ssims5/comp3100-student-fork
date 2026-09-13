#!/usr/bin/env bash
# loom-job.sh -- one loom's honest shift, counted fair.
#
# Usage:   bash loom-job.sh [name]        (name it after a loom: north, south)
# Stop:    Ctrl-C in the foreground; kill %1 (or its pid) in the background.
#
# The shift: rule a card line, checksum it character by character, next
# card. Forever. Every two seconds (as the loom experiences seconds) it
# reports its working rate:
#
#     loom north:     4288 lines/sec   (courtesy 19)
#
# "courtesy" is the loom's own nice value, read fresh for every report --
# so if somebody renices this job while it runs, the label changes with
# it. The rate is real measured work, not a guess: when this number
# falls, the loom is being starved of engine time, and when it rises,
# the time came back. That is the week's instrument. No network, no
# files, no sudo; everything happens in this one process, in the open.
set -u

# EPOCHREALTIME is printed with the locale's decimal separator, and the
# report below splits on that separator to get microseconds. Under a
# comma-decimal locale (de_DE, fr_FR, es_ES and many more) the split
# fails and the loom either misreports its rate or dies mid-shift -- and
# an instrument that reads differently on different benches is no
# instrument. Pin the numeric category to C so the separator stays a dot.
unset LC_ALL          # LC_ALL, if it is set, outranks LC_NUMERIC
export LC_NUMERIC=C

if [ -z "${EPOCHREALTIME:-}" ]; then
  echo "loom-job: this loom wants bash 5 or newer (EPOCHREALTIME)" >&2
  exit 1
fi

label="${1:-loom}"

serial=0                              # cards completed since the shift began
done_in_window=0                      # cards completed since the last report
window_start=${EPOCHREALTIME/./}      # now, in microseconds, no fork needed

while :; do
  # Rule one card: a serial, a product, entered fair.
  printf -v line 'CARD %06d : %d x %d = %d' \
    "$serial" $((serial % 89 + 11)) $((serial % 97 + 13)) \
    $(( (serial % 89 + 11) * (serial % 97 + 13) ))

  # Checksum it the clerk's way: sum every character, carry modulo 251.
  sum=0
  for ((i = 0; i < ${#line}; i++)); do
    printf -v c '%d' "'${line:i:1}"
    sum=$(( (sum + c) % 251 ))
  done

  serial=$((serial + 1))
  done_in_window=$((done_in_window + 1))

  now=${EPOCHREALTIME/./}
  elapsed=$(( now - window_start ))
  if (( elapsed >= 2000000 )); then
    rate=$(( done_in_window * 1000000 / elapsed ))
    courtesy=$(ps -o ni= -p $$ | tr -d ' ')
    printf 'loom %-8s %6d lines/sec   (courtesy %s)\n' \
      "$label:" "$rate" "$courtesy"
    done_in_window=0
    window_start=$now
  fi
done
