#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-11: stage the cabinet bench.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/cabinets/cabinet-1848.img   the card cabinet, up from the
#                                             cellars: a small ext2 disk
#                                             image, built here, at your bench
#   ~/enginehouse/mnt/cabinet/                an empty directory, ready for it
#   ~/enginehouse/ledger-halls/drill/register.txt
#                                             one page for the warm-up drill
#   ~/enginehouse/recovered/                  never made here: it is yours to
#                                             make. --reset sweeps it up
#
# Never touches the other weeks' rooms under ~/enginehouse (ledgers/,
# interlocking/, manuals/, ring-line/, src/, survey/ and the rest), Week 2's
# ~/.ledger-annex, or the house roll.
#
# The cabinet is built afresh on every run, from sealed papers, so a cabinet
# that comes to harm is cured by running this script again. It refuses to
# build, and --reset refuses to sweep, while the cabinet is attached at
# ~/enginehouse/mnt/cabinet: detach it first (the script tells you how).
#
# Works offline. Needs no sudo, no crontab, no background processes.
# Needs e2fsprogs (mke2fs, debugfs, e2fsck), which every setup path installs.
set -eu

ENGINEHOUSE="$HOME/enginehouse"
CABINETS="$ENGINEHOUSE/cabinets"
IMG="$CABINETS/cabinet-1848.img"
MNT="$ENGINEHOUSE/mnt"
CABMNT="$MNT/cabinet"
RECOVERED="$ENGINEHOUSE/recovered"
HALLS="$ENGINEHOUSE/ledger-halls"
DRILL="$HALLS/drill"
REGISTER="$DRILL/register.txt"

# mke2fs, debugfs and e2fsck live in /usr/sbin, which is not on every
# user's PATH.
PATH="$PATH:/usr/sbin:/sbin"
export PATH

# --------------------------------------------------------------- root guard --
# A classic move (Weeks 1 and 3 both log it): run the whole script under sudo.
# That stages root's home, not yours, and every check this week reads from
# your own bench. Building the cabinet needs no house keys at all. Refuse
# before anything is created.
if [ "$(id -u)" -eq 0 ]; then
  echo "report-for-duty: run this as YOURSELF, not as root."                >&2
  echo "  Building the cabinet needs no house keys at all, and running it"  >&2
  echo "  under sudo stages root's home directory instead of yours --"      >&2
  echo "  nothing this week will find it there. Nothing has been staged."   >&2
  echo "  Run it again as yourself:"                                        >&2
  echo "    bash report-for-duty.sh"                                        >&2
  exit 1
fi

# ------------------------------------------------------ the cabinet attached? --
# While the cabinet is attached at its mount point, neither a rebuild nor a
# sweep may touch it: stop, change nothing, and say the one command that
# detaches it.
attached() {
  command -v findmnt >/dev/null 2>&1 || return 1
  findmnt -rn --mountpoint "$CABMNT" >/dev/null 2>&1
}
refuse_attached() {
  echo "report-for-duty: the cabinet is attached at ~/enginehouse/mnt/cabinet," >&2
  echo "  so nothing has been changed. Detach it first -- from outside it"     >&2
  echo "  (cd ~), with:"                                                       >&2
  echo "    sudo umount ~/enginehouse/mnt/cabinet"                             >&2
  echo "  then run this again."                                                >&2
  exit 1
}

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  attached && refuse_attached
  # Something of the student's own mounted inside recovered/ or the drill
  # hall is never followed: say so and change nothing.
  if command -v findmnt >/dev/null 2>&1 &&
     findmnt -rn -o TARGET | grep -Eq "^($RECOVERED|$HALLS)(/|\$)"; then
    echo "report-for-duty: something is mounted inside ~/enginehouse/recovered or" >&2
    echo "  ~/enginehouse/ledger-halls, so nothing has been changed. Unmount it" >&2
    echo "  first (findmnt shows where), then run this again." >&2
    exit 1
  fi
  had_recovered=0
  [ -e "$RECOVERED" ] && had_recovered=1
  rm -f "$IMG"
  rm -rf --one-file-system "$RECOVERED" "$HALLS"
  rmdir "$CABMNT" 2>/dev/null || true
  # Each room goes only if this week leaves it empty.
  rmdir "$CABINETS" 2>/dev/null || true
  rmdir "$MNT" 2>/dev/null || true
  # enginehouse/ is shared with other weeks (Week 1 lays the rooms down), so
  # it goes only if this week leaves it empty and only if Week 1's own marker
  # is gone too -- the same guard Weeks 4 to 10 use.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. The cabinet, its empty mount point and the drill hall are withdrawn."
  if [ "$had_recovered" -eq 1 ]; then
    echo "~/enginehouse/recovered/ was removed too, with everything you recovered into it."
  fi
  if [ -d "$CABMNT" ]; then
    echo "~/enginehouse/mnt/cabinet/ still holds files this script did not make; they are yours, and left."
  fi
  if [ -d "$ENGINEHOUSE" ]; then
    echo "~/enginehouse still holds other weeks' papers; they were not touched."
  fi
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

attached && refuse_attached

# The cabinet's papers, sealed. Decoded at stage time into a scratch folder,
# laid into the image, and swept up: only the image is left on the bench.
decode_papers() { # writes the script that lays out the cabinet's tree to $1
  base64 -d > "$1" <<'B64'
IyEvYmluL3NoCiMgY2FiaW5ldC10cmVlLnNoIERJUiAtLSB3cml0ZXMgdGhlIGNhYmluZXQncyB0
cmVlIGludG8gRElSLCBhcyBpdCBzdG9vZAojIGJlZm9yZSBhbnl0aGluZyB3YXMgc3RydWNrLiBU
aGUgb3JpZ2luYWxzIGFyZSBmaWxlZCB1bmRlciBuYW1lcyB0aGF0CiMgc29ydCBmaXJzdCwgc28g
dGhleSBhcmUgbGFpZCBkb3duIChhbmQgbnVtYmVyZWQpIGZpcnN0LgpzZXQgLWV1CmQ9IiQxIgpt
a2RpciAtcCAiJGQvbGVkZ2VycyIgIiRkL2luZGV4L3dhdGVyd29ya3MiICIkZC9jb3JyZXNwb25k
ZW5jZS9tZW1vcmFuZGEtMTg0OCIKCmNhdCA+ICIkZC9SRUFETUUtY2FiaW5ldC50eHQiIDw8J1RY
VCcKRVhISUJJVElPTiBBVURJVCBPRkZJQ0UgLS0gRE9DS0VUCkNhcmQgY2FiaW5ldCwgV2F0ZXJ3
b3JrcyBzZXJpZXMsIDE4NDgKCiAgVGhpcyBjYWJpbmV0IGNhbWUgdXAgZnJvbSB0aGUgY2VsbGFy
cyBmb3IgdGhlIEV4aGliaXRpb24gbGVkZ2VyCiAgYXVkaXQsIGFuZCBpcyBlbnRlcmVkIGhlcmUg
YXMgaXQgd2FzIGZvdW5kLgoKICBsZWRnZXJzLyAuLi4uLi4uLi4uLi4gVGFibGUgSVggb2YgdGhl
IFdhdGVyd29ya3MsIHRoZSBmb3VyIHF1YXJ0ZXJzCiAgICAgICAgICAgICAgICAgICAgICAgIG9m
IDE4NDgsIGFuZCB0aGUgZGlzdHJpY3QgYmFsYW5jZXMgZm9yIHRoZSB5ZWFyCiAgaW5kZXgvIC4u
Li4uLi4uLi4uLi4uIHRoZSBjYWJpbmV0J3MgY3Jvc3MtaW5kZXgsIGJ5IGRlcGFydG1lbnQKICBj
dXJyZW50LXF1YXJ0ZXIgLi4uLi4gdGhlIGNsZXJrcycgbWFya2VyIGZvciB0aGUgcXVhcnRlciBp
biBoYW5kCiAgY29ycmVzcG9uZGVuY2UvIC4uLi4uIG1lbW9yYW5kYSB0byB0aGUgQm9hcmQsIDE4
NDguIFN0cnVjayBieSBvcmRlcgogICAgICAgICAgICAgICAgICAgICAgICBvZiB0aGUgQm9hcmQs
IDE4NDkuCgogIEhPVVNFIFJVTEUuIFRoZSBsZWRnZXIgaGFsbHMgYW5kIHRoZSByZWFkaW5nIHJv
b20gY2xvc2UgYXQgdGhlCiAgYmVsbCwgc2l4IG8nY2xvY2sgKDE4OjAwKS4gVmlzaXRpbmcgZGF5
cyBhcmUgV2VkbmVzZGF5cyBhbmQgRnJpZGF5cy4KCiAgQSBjYWJpbmV0IHVuZGVyIGF1ZGl0IGlz
IHJlYWQsIGFuZCBuZXZlciB3cml0dGVuLgpUWFQKCnBhZ2UoKSB7ICMgcGFnZSBGSUxFIFFVQVJU
RVIgSEVBRCBEUkFXIEMxIEMyIEMzIEQxIEQyIEQzIEQ0IExPU1MgQkFMQU5DRQogIGNhdCA+ICIk
MSIgPDxUWFQKV0FURVJXT1JLUyAtLSBUQUJMRSBJWCAtLSAkMiBRVUFSVEVSLCAxODQ4CkJyYXNz
YnJpZGdlIFdhdGVyd29ya3MsIGxlZGdlciBvZiB0aGUgcXVhcnRlcgoKICByZXNlcnZvaXIgaGVh
ZCwgZmVldCAuLi4uLi4uLi4uLi4gJDMKICBtYWlucyBkcmF3LCBtaWxsaW9uIGdhbGxvbnMgLi4u
Li4gJDQKCiAgQ1VMVkVSVCBMT1NTRVMgLS0gbWlsbGlvbiBnYWxsb25zCiAgICBDdWx2ZXJ0IEkg
Li4uLi4uLi4uLi4uLi4uLi4uLi4uICQ1CiAgICBDdWx2ZXJ0IElJIC4uLi4uLi4uLi4uLi4uLi4u
Li4uICQ2CiAgICBDdWx2ZXJ0IElJSSAuLi4uLi4uLi4uLi4uLi4uLi4uICQ3CgogIERJU1RSSUNU
IEJBTEFOQ0VTIC0tIHBvdW5kcwogICAgTm9ydGhnYXRlIC4uLi4uLi4uLi4uLi4uLi4uLi4uLiAk
OAogICAgV2F0ZXJzaWRlIC4uLi4uLi4uLi4uLi4uLi4uLi4uLiAkOQogICAgT2xkIFF1YXJ0ZXIg
Li4uLi4uLi4uLi4uLi4uLi4uLiAkezEwfQogICAgS2lsbiBSb3cgLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLiAkezExfQoKICBjb21wdXRlZCBsb3NzLCBtaWxsaW9uIGdhbGxvbnMgLi4gJHsxMn0KICBk
aXN0cmljdCBiYWxhbmNlLCBwb3VuZHMgLi4uLi4uLi4gJHsxM30KVFhUCn0KCiMgVGhlIGZvdXIg
b3JpZ2luYWxzLCBhcyB0aGUgRW5naW5lIGNvbXB1dGVkIHRoZW06IGVhY2ggZmlndXJlIHJvdW5k
ZWQgdG8KIyB0aGUgcGxhY2UgdGhlIFRhYmxlIHByaW50cywgdGhlbiBhZGRlZC4KcGFnZSAiJGQv
bGVkZ2Vycy8xODQ4LXExLXRhYmxlLWl4LnR4dCIgTUFSQ0ggICAgIDM5Ljg2IDcuOTQwIDAuMTYz
NSAwLjE5MjUgMC4xNTgwIDUxLjI0NSA1OC43MzUgNDIuMTE1IDUyLjM5NSAwLjUxNSAyMDQuNTEK
cGFnZSAiJGQvbGVkZ2Vycy8xODQ4LXEyLXRhYmxlLWl4LnR4dCIgSlVORSAgICAgIDQyLjA1IDgu
NDE1IDAuMTc0NSAwLjIwMTUgMC4xMzkwIDUzLjEwNSA2MC40ODUgNDQuMjU1IDU1LjAxNSAwLjUx
NiAyMTIuODgKcGFnZSAiJGQvbGVkZ2Vycy8xODQ4LXEzLXRhYmxlLWl4LnR4dCIgU0VQVEVNQkVS
IDM3LjQ4IDkuMTIwIDAuMTkwNSAwLjIyMTUgMC4xNTYwIDQ5Ljg3NSA1Ny4zMzUgNDEuNjQ1IDUw
LjkyNSAwLjU2OSAxOTkuODAKcGFnZSAiJGQvbGVkZ2Vycy8xODQ4LXE0LXRhYmxlLWl4LnR4dCIg
REVDRU1CRVIgIDQwLjMzIDcuNjY1IDAuMTU1NSAwLjE4MTAgMC4xNDc1IDUyLjY2NSA1OS4xMTUg
NDMuMzg1IDUzLjc0NSAwLjQ4NSAyMDguOTMKCiMgVGhlIHBhZ2VzIHRoYXQgc3RhbmQgaW4gdGhl
IGNhYmluZXQgbm93OiB0aGUgc2FtZSBmaWd1cmVzLCBhZGRlZCBmaXJzdAojIGFuZCByb3VuZGVk
IG9uY2UuCnBhZ2UgIiRkL2xlZGdlcnMvdGFibGUtaXgtMTg0OC1xMS50eHQiIE1BUkNIICAgICAz
OS44NiA3Ljk0MCAwLjE2MzUgMC4xOTI1IDAuMTU4MCA1MS4yNDUgNTguNzM1IDQyLjExNSA1Mi4z
OTUgMC41MTQgMjA0LjQ5CnBhZ2UgIiRkL2xlZGdlcnMvdGFibGUtaXgtMTg0OC1xMi50eHQiIEpV
TkUgICAgICA0Mi4wNSA4LjQxNSAwLjE3NDUgMC4yMDE1IDAuMTM5MCA1My4xMDUgNjAuNDg1IDQ0
LjI1NSA1NS4wMTUgMC41MTUgMjEyLjg2CnBhZ2UgIiRkL2xlZGdlcnMvdGFibGUtaXgtMTg0OC1x
My50eHQiIFNFUFRFTUJFUiAzNy40OCA5LjEyMCAwLjE5MDUgMC4yMjE1IDAuMTU2MCA0OS44NzUg
NTcuMzM1IDQxLjY0NSA1MC45MjUgMC41NjggMTk5Ljc4CnBhZ2UgIiRkL2xlZGdlcnMvdGFibGUt
aXgtMTg0OC1xNC50eHQiIERFQ0VNQkVSICA0MC4zMyA3LjY2NSAwLjE1NTUgMC4xODEwIDAuMTQ3
NSA1Mi42NjUgNTkuMTE1IDQzLjM4NSA1My43NDUgMC40ODQgMjA4LjkxCgpjYXQgPiAiJGQvbGVk
Z2Vycy9kaXN0cmljdC1iYWxhbmNlcy0xODQ4LnR4dCIgPDwnVFhUJwpXQVRFUldPUktTIC0tIERJ
U1RSSUNUIEJBTEFOQ0VTIC0tIFRIRSBZRUFSIDE4NDgKQnJhc3NicmlkZ2UgV2F0ZXJ3b3Jrcywg
cG91bmRzLCBmcm9tIHRoZSBmb3VyIHF1YXJ0ZXJzIG9mIFRhYmxlIElYCgogICAgICAgICAgICAg
ICAgICBNYXJjaCAgICAgSnVuZSAgICAgIFNlcHQuICAgICBEZWMuICAgICAgdGhlIHllYXIKICBO
b3J0aGdhdGUgICAgICAgNTEuMjQ1ICAgIDUzLjEwNSAgICA0OS44NzUgICAgNTIuNjY1ICAgIDIw
Ni44OQogIFdhdGVyc2lkZSAgICAgICA1OC43MzUgICAgNjAuNDg1ICAgIDU3LjMzNSAgICA1OS4x
MTUgICAgMjM1LjY3CiAgT2xkIFF1YXJ0ZXIgICAgIDQyLjExNSAgICA0NC4yNTUgICAgNDEuNjQ1
ICAgIDQzLjM4NSAgICAxNzEuNDAKICBLaWxuIFJvdyAgICAgICAgNTIuMzk1ICAgIDU1LjAxNSAg
ICA1MC45MjUgICAgNTMuNzQ1ICAgIDIxMi4wOAoKICBhbGwgZGlzdHJpY3RzLCB0aGUgeWVhciAu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiA4MjYuMDQKVFhUCgpsbiAiJGQvbGVkZ2Vy
cy90YWJsZS1peC0xODQ4LXEyLnR4dCIgIiRkL2luZGV4L3dhdGVyd29ya3MvdGFibGUtaXgtMTg0
OC1xMi50eHQiCmxuIC1zIGxlZGdlcnMvdGFibGUtaXgtMTg0OC1xNC50eHQgIiRkL2N1cnJlbnQt
cXVhcnRlciIKCmNhdCA+ICIkZC9jb3JyZXNwb25kZW5jZS9tZW1vcmFuZGEtMTg0OC8xODQ4LTAz
LTE0LWJvYXJkLXRhYmxlLWl4LnR4dCIgPDwnVFhUJwpUbyB0aGUgSG9ub3VyYWJsZSB0aGUgQm9h
cmQgb2YgdGhlIFdhdGVyd29ya3MKMTQgTWFyY2ggMTg0OAoKR2VudGxlbWVuLAoKSSBiZWcgbGVh
dmUgdG8gbGF5IGJlZm9yZSB0aGUgQm9hcmQgYSBzbWFsbCBtYXR0ZXIgb2YgbWV0aG9kIGluIHRo
ZQpFbmdpbmUncyB3b3JraW5nIG9mIFRhYmxlIElYLCB3aGljaCBJIGZlYXIgd2lsbCBub3Qgc3Rh
eSBzbWFsbC4KClRoZSBFbmdpbmUgcm91bmRzIGVhY2ggY3VsdmVydCBsb3NzIGFuZCBlYWNoIGRp
c3RyaWN0IGJhbGFuY2UgdG8gdGhlCnBsYWNlIHRoZSBUYWJsZSBwcmludHMsIGFuZCBvbmx5IHRo
ZW4gYWRkcyB0aGVtLiBUaGUgY29tcHV0ZXJzIGhhdmUKYWx3YXlzIGFkZGVkIGZpcnN0IGFuZCBy
b3VuZGVkIG9uY2UsIGF0IHRoZSBmb290IG9mIHRoZSBjb2x1bW4uIFRoZQp0d28gbWV0aG9kcyBh
Z3JlZSBvbmx5IGJ5IGx1Y2suIFdoZXJlIGEgZmlndXJlIGVuZHMgaW4gYSBmaXZlLCB0aGUKRW5n
aW5lJ3Mgd2F5IHJvdW5kcyBpdCB1cCwgYW5kIGV2ZXJ5IHN1Y2ggZmlndXJlIGFkZHMgaXRzIGhh
bGYgdG8gdGhlCnRvdGFsLiBJbiB0aGUgRGVjZW1iZXIgcXVhcnRlciBsYXN0IEkgY291bnQgdHdv
IGN1bHZlcnQgZmlndXJlcyBhbmQKZm91ciBkaXN0cmljdCBmaWd1cmVzIHNvIHBsYWNlZDogdGhl
IEVuZ2luZSdzIGxvc3Mgc3RhbmRzIG9uZQp0aG91c2FuZHRoIHRvbyBoaWdoIGFuZCBpdHMgYmFs
YW5jZSB0d28gcGVuY2UgdG9vIGhpZ2gsIGJvdGggaW4gdGhlCnNhbWUgZGlyZWN0aW9uLCBhcyBh
IG1ldGhvZCBlcnJzIGFuZCBhIHNsaXAgb2YgdGhlIHBlbiBkb2VzIG5vdC4KClRoZSBzdW1zIGFy
ZSBub3QgbGFyZ2UuIFRoZSBoYWJpdCBpcy4gQSB0YWJsZSB0aGF0IGlzIHdyb25nIGJ5IGEgcnVs
ZQppcyB3cm9uZyBpbiBldmVyeSBxdWFydGVyIGl0IGlzIHVzZWQsIGFuZCB3aWxsIGJlIHRydXN0
ZWQgdGhlIG1vcmUgZm9yCmJlaW5nIGNvbnNpc3RlbnQuCgpJIHdvdWxkIGFzayB0aGF0IFRhYmxl
IElYIGJlIHN1bW1lZCBiZWZvcmUgaXQgaXMgcm91bmRlZCwgYXMgdGhlCkd1aWxkJ3MgcnVsZSBo
YXMgYWx3YXlzIHJlcXVpcmVkLCBhbmQgdGhhdCBhIGNvbXB1dGVyIGNoZWNrIHRoZSBmb290Cm9m
IGVhY2ggcXVhcnRlciBieSBoYW5kIHVudGlsIGl0IGlzLgoKSSBoYXZlIHRoZSBob25vdXIgdG8g
cmVtYWluLCBHZW50bGVtZW4sCnlvdXIgZGlsaWdlbnQgc2VydmFudCwKCkkuIE0uIEt1cmVvcywg
Q2hpZWYgQ29tcHV0ZXIKRS5LLgpUWFQKCmNhdCA+ICIkZC9jb3JyZXNwb25kZW5jZS9tZW1vcmFu
ZGEtMTg0OC8xODQ4LTA4LTAyLWJvYXJkLWRpc3RyaWN0LWJhbGFuY2VzLnR4dCIgPDwnVFhUJwpU
byB0aGUgSG9ub3VyYWJsZSB0aGUgQm9hcmQgb2YgdGhlIFdhdGVyd29ya3MKMiBBdWd1c3QgMTg0
OAoKR2VudGxlbWVuLAoKSSB3cm90ZSB0byB0aGUgQm9hcmQgaW4gTWFyY2ggb2YgdGhlIEVuZ2lu
ZSdzIHJvdW5kaW5nIGluIFRhYmxlIElYLiBJCndyaXRlIGFnYWluIG9ubHkgYmVjYXVzZSB0aGUg
c2FtZSBtZXRob2QgaGFzIG5vdyByZWFjaGVkIHRoZSBkaXN0cmljdApiYWxhbmNlcy4KCkVhY2gg
ZGlzdHJpY3QncyBiYWxhbmNlIGlzIHJvdW5kZWQgdG8gdGhlIHBlbm55IGJlZm9yZSB0aGUgZm91
ciBhcmUKYWRkZWQuIEZvdXIgZGlzdHJpY3RzLCBlYWNoIGVuZGluZyBpbiBhIGhhbGYtcGVubnks
IG1ha2UgdHdvIHBlbmNlCnRoYXQgdGhlIFRhYmxlIG93ZXMgdG8gbm9ib2R5LiBObyByYXRlcGF5
ZXIgd2lsbCBub3RpY2UgdHdvIHBlbmNlLiBUaGUKQm9hcmQncyBhdWRpdG9ycywgYWRkaW5nIHRo
ZSB5ZWFyLCB3aWxsIGZpbmQgdGhhdCB0aGUgcXVhcnRlcnMgZG8gbm90CmFncmVlIHdpdGggdGhl
IHllYXIsIGFuZCB3aWxsIG5vdCBiZSB0b2xkIHdoeS4KCkkgZW5jbG9zZSBub3RoaW5nIHRoZSBC
b2FyZCBkb2VzIG5vdCBhbHJlYWR5IGhvbGQuIFRoZSB3b3JraW5nIHBhcGVycwpmb3IgdGhlIEp1
bmUgcXVhcnRlciBzaG93IGl0IHBsYWlubHkgdG8gYW55b25lIHdobyBhZGRzIHRoZSBjb2x1bW4K
YmVmb3JlIHJvdW5kaW5nIGl0LgoKSSBhc2sgYWdhaW4gdGhhdCB0aGUgYmFsYW5jZXMgYmUgc3Vt
bWVkIGZpcnN0IGFuZCByb3VuZGVkIG9uY2UsIGF0CnRoZSBmb290LgoKSSBoYXZlIHRoZSBob25v
dXIgdG8gcmVtYWluLCBHZW50bGVtZW4sCnlvdXIgZGlsaWdlbnQgc2VydmFudCwKCkkuIE0uIEt1
cmVvcywgQ2hpZWYgQ29tcHV0ZXIKRS5LLgpUWFQKCmNhdCA+ICIkZC9jb3JyZXNwb25kZW5jZS9t
ZW1vcmFuZGEtMTg0OC8xODQ4LTExLTMwLWJvYXJkLXJldGFpbi10aGUtY29tcHV0ZXJzLnR4dCIg
PDwnVFhUJwpUbyB0aGUgSG9ub3VyYWJsZSB0aGUgQm9hcmQgb2YgdGhlIFdhdGVyd29ya3MKMzAg
Tm92ZW1iZXIgMTg0OAoKR2VudGxlbWVuLAoKSSB1bmRlcnN0YW5kIHRoYXQgdGhlIEJvYXJkIGlu
dGVuZHMgdGhlIGNvbXB1dGluZyByb29tIHRvIGJlIHdvdW5kCmRvd24gd2hlbiB0aGUgeWVhciBj
bG9zZXMsIGFuZCB0aGUgRW5naW5lJ3MgdGFibGVzIHRvIGJlIHByaW50ZWQgYXMKdGhleSBjb21l
LgoKSSBkbyBub3QgYXNrIHRoZSBCb2FyZCB0byBrZWVwIHRoZSByb29tIGFzIGl0IGlzLiBJIGFz
ayB0aGF0IGl0IGtlZXAKdGhlIGNvbXB1dGVycyBhcyB2ZXJpZmllcnM6IG9uZSBoYW5kIHRvIGFk
ZCBlYWNoIHRhYmxlJ3MgY29sdW1uIGJlZm9yZQppdCBpcyByb3VuZGVkLCBhbmQgdG8gc2lnbiB0
aGUgZm9vdC4gVGhlIEVuZ2luZSBpcyBxdWlja2VyIHRoYW4gYW55IG9mCnVzIGFuZCBkb2VzIG5v
dCB0aXJlLiBJdCBpcyBleGFjdCBpbiBldmVyeXRoaW5nIGJ1dCBpdHMgbWV0aG9kLCBhbmQKaXRz
IG1ldGhvZCBpcyBvbmUgbGluZSBpbiBpdHMgaW5zdHJ1Y3Rpb25zLiBVbnRpbCB0aGF0IGxpbmUg
aXMgbWVuZGVkLAphIGNvbXB1dGVyIGF0IHRoZSBmb290IG9mIGVhY2ggdGFibGUgaXMgdGhlIGNo
ZWFwZXN0IGluc3VyYW5jZSB0aGUKQm9hcmQgY2FuIGJ1eS4KClRoZSBlcnJvcnMgSSByZXBvcnRl
ZCBpbiBNYXJjaCBhbmQgaW4gQXVndXN0IHN0YW5kIGluIHRoZSB0YWJsZXMgb2YKdGhlIFNlcHRl
bWJlciBxdWFydGVyIHN0aWxsLgoKSSBoYXZlIHRoZSBob25vdXIgdG8gcmVtYWluLCBHZW50bGVt
ZW4sCnlvdXIgZGlsaWdlbnQgc2VydmFudCwKCkkuIE0uIEt1cmVvcywgQ2hpZWYgQ29tcHV0ZXIK
RS5LLgpUWFQK
B64
}

# -------------------------------------------------------------- the tools --
if ! command -v mke2fs >/dev/null 2>&1 || ! command -v debugfs >/dev/null 2>&1 ||
   ! command -v e2fsck >/dev/null 2>&1; then
  echo "report-for-duty: mke2fs, debugfs or e2fsck not found -- this week's cabinet" >&2
  echo "  is built at your own bench with e2fsprogs. Run the 'A tool is missing'"    >&2
  echo "  fix in setup/getting-started.md Troubleshooting (the package is"           >&2
  echo "  e2fsprogs), then try again. Nothing has been staged."                      >&2
  exit 1
fi

# Everything below is built in a scratch folder first, so a bench that cannot
# build the cabinet is left exactly as it was found.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
work="$tmp/cabinet-1848.img"
broken() {
  echo "report-for-duty: the cabinet did not build on this bench: $1" >&2
  echo "  Nothing has been staged. Take this to your instructor rather than" >&2
  echo "  working around it." >&2
  exit 1
}

# Runs debugfs in write mode over the command file $1. debugfs reports a
# failed command on stderr and still exits 0, so anything on stderr but its
# banner is a failure.
debugfs_w() {
  debugfs -w -f "$1" "$work" > "$tmp/dbg.out" 2> "$tmp/dbg.err" || broken "debugfs would not run"
  if grep -v '^debugfs [0-9]' "$tmp/dbg.err" | grep -q .; then
    broken "debugfs: $(grep -v '^debugfs [0-9]' "$tmp/dbg.err" | head -3 | tr '\n' ' ')"
  fi
}
dbg() { debugfs -R "$1" "$work" 2>/dev/null; }

# Every time is reckoned from the wall clock of this bench, so the cabinet
# reads the same hours here as on every other bench, whatever its time zone.
at() { date -d "$1" +%s; }
SEALED="$(at '2026-10-24 10:00:00')"
FLOOR=-2147483648      # the oldest instant an inode's clock can hold

tree="$tmp/tree"
decode_papers "$tmp/papers.sh"
sh "$tmp/papers.sh" "$tree" || broken "the papers would not unpack"

mke2fs -q -t ext2 -b 1024 -I 256 -N 64 -L cabinet-1848 \
  -E "root_owner=$(id -u):$(id -g)" -d "$tree" -F "$work" 2048 \
  > "$tmp/mke2fs.out" 2>&1 || broken "mke2fs: $(head -3 "$tmp/mke2fs.out" | tr '\n' ' ')"

# -- every time on every inode, in one pass ----------------------------------
# path|mtime=ctime=atime(=crtime)
{
  printf '%s|%s\n' \
    / "$SEALED" /lost+found "$SEALED" /README-cabinet.txt "$SEALED" \
    /current-quarter "$SEALED" /ledgers "$SEALED" /index "$SEALED" \
    /index/waterworks "$SEALED" /correspondence "$SEALED" \
    /correspondence/memoranda-1848 "$SEALED" \
    /ledgers/1848-q1-table-ix.txt "$SEALED" /ledgers/1848-q2-table-ix.txt "$SEALED" \
    /ledgers/1848-q3-table-ix.txt "$SEALED" /ledgers/1848-q4-table-ix.txt "$SEALED" \
    /ledgers/table-ix-1848-q1.txt "$(at '2026-09-16 19:22:05')" \
    /ledgers/table-ix-1848-q2.txt "$(at '2026-09-18 19:07:40')" \
    /ledgers/table-ix-1848-q3.txt "$(at '2026-09-23 19:36:12')" \
    /ledgers/table-ix-1848-q4.txt "$(at '2026-10-14 19:41:27')" \
    /ledgers/district-balances-1848.txt "$(at '2026-10-23 20:03:18')"
  for m in 1848-03-14-board-table-ix.txt 1848-08-02-board-district-balances.txt \
           1848-11-30-board-retain-the-computers.txt; do
    printf '%s|%s\n' "/correspondence/memoranda-1848/$m" "$FLOOR"
  done
} > "$tmp/times"
while IFS='|' read -r p t; do
  for f in mtime ctime atime crtime; do
    printf 'set_inode_field %s %s @%s\n' "$p" "$f" "$t"
  done
done < "$tmp/times" > "$tmp/set.cmd"
debugfs_w "$tmp/set.cmd"

# -- the struck papers: what each was, and when it went ----------------------
# path|size|dtime. Each original went when its replacement was written; the
# memoranda went before the cabinet's clock could say when.
inode_of() { # inode_of DIR NAME, read off the image
  dbg "ls -l $1" | awk -v n="$2" '$NF == n { print $1; exit }'
}
{
  for q in 1 2 3 4; do
    printf '/ledgers|1848-q%s-table-ix.txt|%s\n' "$q" \
      "$(awk -F'|' -v p="/ledgers/table-ix-1848-q$q.txt" '$1 == p { print $2 }' "$tmp/times")"
  done
  for m in 1848-03-14-board-table-ix.txt 1848-08-02-board-district-balances.txt \
           1848-11-30-board-retain-the-computers.txt; do
    printf '/correspondence/memoranda-1848|%s|%s\n' "$m" "$FLOOR"
  done
} > "$tmp/struck"
: > "$tmp/rm.cmd"
: > "$tmp/struck.map"
while IFS='|' read -r dir name when; do
  [ -n "$when" ] || broken "no time for $dir/$name"
  n="$(inode_of "$dir" "$name")"
  [ -n "$n" ] || broken "$dir/$name is not in the image"
  if [ "$dir" = /ledgers ]; then src="$tree/ledgers/$name"; else src="$tree/correspondence/memoranda-1848/$name"; fi
  printf '%s|%s|%s|%s\n' "$n" "$(wc -c < "$src" | tr -d ' ')" "$when" "$dir/$name" >> "$tmp/struck.map"
  printf 'rm %s/%s\n' "$dir" "$name" >> "$tmp/rm.cmd"
done < "$tmp/struck"
debugfs_w "$tmp/rm.cmd"

# lsdel, in its own order, must list exactly the seven struck inodes, each the
# size its paper was. Each gets its time of striking from that list.
dbg lsdel | awk '$1 ~ /^[0-9]+$/ && NF >= 5 { print $1 "|" $4 }' > "$tmp/lsdel"
[ "$(wc -l < "$tmp/lsdel" | tr -d ' ')" = "$(wc -l < "$tmp/struck.map" | tr -d ' ')" ] ||
  broken "lsdel finds $(wc -l < "$tmp/lsdel" | tr -d ' ') struck inodes, not $(wc -l < "$tmp/struck.map" | tr -d ' ')"
: > "$tmp/dtime.cmd"
while IFS='|' read -r n size; do
  row="$(awk -F'|' -v n="$n" '$1 == n' "$tmp/struck.map")"
  [ -n "$row" ] || broken "lsdel lists inode $n, which was not struck"
  [ "$(printf '%s' "$row" | cut -d'|' -f2)" = "$size" ] ||
    broken "inode $n is $size bytes, not the size of $(printf '%s' "$row" | cut -d'|' -f4)"
  printf 'set_inode_field <%s> dtime @%s\n' "$n" "$(printf '%s' "$row" | cut -d'|' -f3)" >> "$tmp/dtime.cmd"
done < "$tmp/lsdel"
debugfs_w "$tmp/dtime.cmd"

e2fsck -fn "$work" > "$tmp/fsck.out" 2>&1 || broken "e2fsck: $(tail -3 "$tmp/fsck.out" | tr '\n' ' ')"

# ------------------------------------------------------------------ the bench
mkdir -p "$CABINETS" "$CABMNT" "$DRILL"
chmod 644 "$work"
mv -f "$work" "$IMG"

# The drill page. Rewritten in place, so a page you have already given a
# second name keeps its number.
cat > "$REGISTER" <<'PAGE'
LEDGER HALLS -- DRILL REGISTER
Brassbridge Enginehouse

  A practice page. One page, one number: give it a second name, strike a
  name, and see what stays.
PAGE

# ------------------------------------------------------------------ self-test
fail=0
ck() { debugfs -R "$1" "$IMG" 2>/dev/null; }
epoch_of() { # epoch_of FIELD PATH -- the field's 32-bit time, signed
  h="$(ck "stat $2" | sed -n "s/^ *$1: 0x\([0-9a-f]*\):.*/\1/p" | head -1)"
  [ -n "$h" ] || { echo none; return; }
  v=$((16#$h))
  [ "$v" -ge 2147483648 ] && v=$((v - 4294967296))
  echo "$v"
}

if ! e2fsck -fn "$IMG" > "$tmp/fsck2.out" 2>&1; then
  echo "self-test: e2fsck does not pass the cabinet clean" >&2; fail=1
fi
struck="$(ck lsdel | sed -n 's/^\([0-9][0-9]*\) deleted inodes found\.$/\1/p')"
if [ "$struck" != "7" ]; then
  echo "self-test: lsdel finds ${struck:-no} struck inodes, not 7" >&2; fail=1
fi
while IFS='|' read -r p want; do
  for f in mtime ctime atime; do
    e="$(epoch_of "$f" "/ledgers/$p")"
    got="$(LC_ALL=C date -d "@$e" '+%a %F %T' 2>/dev/null || echo none)"
    if [ "$got" != "$want" ]; then
      echo "self-test: $p reads $f $got, not $want" >&2; fail=1
    fi
  done
done <<'TIMES'
table-ix-1848-q1.txt|Wed 2026-09-16 19:22:05
table-ix-1848-q2.txt|Fri 2026-09-18 19:07:40
table-ix-1848-q3.txt|Wed 2026-09-23 19:36:12
table-ix-1848-q4.txt|Wed 2026-10-14 19:41:27
district-balances-1848.txt|Fri 2026-10-23 20:03:18
TIMES
a="$(ck 'ls -l /ledgers' | awk '$NF == "table-ix-1848-q2.txt" { print $1 }')"
b="$(ck 'ls -l /index/waterworks' | awk '$NF == "table-ix-1848-q2.txt" { print $1 }')"
links="$(ck 'stat /ledgers/table-ix-1848-q2.txt' | sed -n 's/^Links: \([0-9]*\).*/\1/p')"
if [ -z "$a" ] || [ "$a" != "$b" ] || [ "$links" != "2" ]; then
  echo "self-test: q2's two names do not share one inode with link count 2" >&2; fail=1
fi
if ! ck 'stat /current-quarter' | grep -q 'Type: symlink'; then
  echo "self-test: current-quarter is not a symbolic link" >&2; fail=1
fi
# Every inode in the cabinet is yours, or (lost+found, and the unused ones)
# root's. Nobody else's.
count="$(ck 'stats -h' | sed -n 's/^Inode count: *\([0-9]*\)$/\1/p')"
i=1
: > "$tmp/owners.cmd"
while [ "$i" -le "${count:-0}" ]; do printf 'stat <%s>\n' "$i" >> "$tmp/owners.cmd"; i=$((i + 1)); done
others="$(debugfs -f "$tmp/owners.cmd" "$IMG" 2>/dev/null |
  sed -n 's/^User: *\([0-9]*\) .*/\1/p' | sort -u | grep -vx -e 0 -e "$(id -u)" || true)"
if [ -z "$count" ] || [ -n "$others" ]; then
  echo "self-test: the cabinet holds inodes owned by someone else: ${others:-unreadable}" >&2; fail=1
fi
[ -f "$REGISTER" ] || { echo "self-test: $REGISTER missing" >&2; fail=1; }
[ -d "$CABMNT" ] || { echo "self-test: $CABMNT missing" >&2; fail=1; }
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-11 :: bench staged and verified
  ------------------------------------------------------------------
   Cabinet:  ~/enginehouse/cabinets/cabinet-1848.img
   Drill:    ~/enginehouse/ledger-halls/drill/register.txt

   A card cabinet has come up from the cellars for the Exhibition
   ledger audit, and the audit office has docketed it as found.
   Some of its papers are missing, and some do not look right.

   The cabinet is evidence: read it, never write to it. It was built
   just now, on this bench, from sealed papers, and running this
   script again builds it afresh. Start with the drill.
   (bash report-for-duty.sh --reset withdraws all of it.)
  ------------------------------------------------------------------

SLIP
