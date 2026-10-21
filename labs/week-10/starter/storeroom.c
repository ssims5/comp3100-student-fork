/* storeroom.c -- Work Order No. 1851-10, Task 1: demand paging, in the open.
 *
 * Requisitions a storeroom of 256 pages with mmap and leaves it empty. The
 * pages cost almost no real memory until something is put on them: the first
 * time a page is touched the kernel fills it in (one MINOR page fault) and
 * the resident size grows by one page; touch the same page again and nothing
 * happens -- it is already there.
 *
 * Minor faults are counted with getrusage(RUSAGE_SELF).ru_minflt; the
 * resident size is read from /proc/self/statm (field 2, in pages). The
 * program prints nothing that depends on the story.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>

static long minflt(void)
{
    struct rusage r;
    getrusage(RUSAGE_SELF, &r);
    return r.ru_minflt;
}

/* Resident pages, from /proc/self/statm field 2. */
static long resident_pages(void)
{
    FILE *f = fopen("/proc/self/statm", "r");
    long total = 0, res = 0;
    if (f) {
        if (fscanf(f, "%ld %ld", &total, &res) != 2)
            res = 0;
        fclose(f);
    }
    return res;
}

int main(void)
{
    long ps = sysconf(_SC_PAGESIZE);
    size_t n = 256;
    size_t sz = (size_t)ps * n;

    char *p = mmap(NULL, sz, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (p == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    long f0 = minflt();
    long r0 = resident_pages();
    printf("storeroom: %zu pages (%zu KiB) requisitioned, nothing shelved yet.\n",
           n, sz / 1024);
    printf("  resident now: %ld KiB\n", r0 * ps / 1024);

    for (size_t i = 0; i < n; i++)
        p[i * (size_t)ps] = 1;           /* first touch: one minor fault each */
    long f1 = minflt();
    long r1 = resident_pages();
    printf("first round -- one item onto each of the %zu shelves:\n", n);
    printf("  minor page faults: +%ld\n", f1 - f0);
    printf("  resident now:      +%ld KiB\n", (r1 - r0) * ps / 1024);

    for (size_t i = 0; i < n; i++)
        p[i * (size_t)ps] = 2;           /* second round: already resident */
    long f2 = minflt();
    long r2 = resident_pages();
    printf("second round -- over the same %zu shelves again:\n", n);
    printf("  minor page faults: +%ld\n", f2 - f1);
    printf("  resident now:      +%ld KiB\n", (r2 - r1) * ps / 1024);

    munmap(p, sz);
    return 0;
}
