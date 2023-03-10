include ../config.mk
PLAF = -DLOGICAL_PROCESSORS=$(maxthreads_powerof2) -DMAX_TID_POW2=$(maxthreads_powerof2) -DCPU_FREQ_GHZ=$(cpu_freq_ghz) -DCPU_FREQ=$(cpu_freq_ghz)

GPP = g++-10
FLAGS = -std=c++11 -mcx16 
FLAGS += -O3
# FLAGS += -O0 -fsanitize=address -static-libasan -fsanitize=leak
# FLAGS += -g
FLAGS += -DNDEBUG
FLAGS += $(PLAF)
FLAGS += -DUSE_GSTATS
# FLAGS += -DNO_FREE
#FLAGS += -DUSE_STL_HASHLIST
FLAGS += -DUSE_SIMPLIFIED_HASHLIST
#FLAGS += -DRAPID_RECLAMATION
#FLAGS += -DRWLOCK_PTHREADS
#FLAGS += -DRWLOCK_FAVOR_WRITERS
FLAGS += -DRWLOCK_FAVOR_READERS
#FLAGS += -DRWLOCK_COHORT_FAVOR_WRITERS
#FLAGS += -DSNAPCOLLECTOR_PRINT_RQS
#FLAGS += -DUSE_RQ_DEBUGGING -DRQ_VALIDATION
#FLAGS += -DRQ_VISITED_IN_BAGS_HISTOGRAM
#FLAGS += -DRQ_HISTOGRAM
#FLAGS += -DADD_DELAY_BEFORE_DTIME
#FLAGS += -DRQ_LOCKFREE_WAITS_FOR_DTIME
#FLAGS += -DUSE_DEBUGCOUNTERS
#FLAGS += -DBLOCKBAG_ITERATOR_COUNT_BLOCKS_TRAVERSED
#FLAGS += -DDEBUG=if\(1\) -DDEBUG1=if\(1\) -DDEBUG2=if\(1\)
#FLAGS += -DDEBUG=if\(1\) -DDEBUG1=if\(0\) -DDEBUG2=if\(0\)
FLAGS += -DDEBUG=if\(0\) -DDEBUG1=if\(0\) -DDEBUG2=if\(0\)
FLAGS += -DMEMORY_STATS=if\(1\) -DMEMORY_STATS2=if\(1\)
#FLAGS += -DMEMORY_STATS=if\(0\) -DMEMORY_STATS2=if\(0\)
FLAGS += -DINSERT_FUNC=insertIfAbsent
#FLAGS += -DUSE_PAPI
# FLAGS += -DUSE_TRACE

# FLAGS += -DDEBRA_DISABLE_READONLY_OPT
#FLAGS += -DEERPRCU_DISABLE_RDTSC_TTAS
# FLAGS += -DSKIPLIST_DEBUGGING_FLATTEN_MAX_LEVEL

# Include bundle configuration macros
include bundle.mk

LDFLAGS = -L../lib
LDFLAGS += -I../
LDFLAGS += -I../bst
LDFLAGS += -I../bslack_reuse
LDFLAGS += -I../citrus
LDFLAGS += -I../common
LDFLAGS += -I../dcss_plus
LDFLAGS += -I../descriptors
LDFLAGS += -I../include
LDFLAGS += -I../lazylist
LDFLAGS += -I../lockfree_list
LDFLAGS += -I../lockfree_skiplist
LDFLAGS += -I../skiplist_lock
LDFLAGS += -I../microbench
LDFLAGS += -I../recordmgr
LDFLAGS += -I../rlu
LDFLAGS += -I../rlu_citrus
LDFLAGS += -I../rlu_linked_list
LDFLAGS += -I../rq
LDFLAGS += -I../rq/snapcollector

# Bundle specific includes.
LDFLAGS += -I../bundle
LDFLAGS += -I../bundle_lazylist
LDFLAGS += -I../bundle_skiplist_lock
LDFLAGS += -I../bundle_citrus
LDFLAGS += -I../bundle_bst
# -------------------------

# Unsafe specific includes.
LDFLAGS += -I../unsafe/lazylist/
LDFLAGS += -I../unsafe/skiplist_lock/
LDFLAGS += -I../unsafe/citrus/
# -------------------------

# vCAS specific includes
LDFLAGS += -I../vcas_bst
LDFLAGS += -I../vcas_lazylist
LDFLAGS += -I../vcas_skiplist_lock
LDFLAGS += -I../vcas_citrus
# -------------------------

LDFLAGS += -lpthread
LDFLAGS += -ldl
LDFLAGS += -lnuma
LDFLAGS += -lpapi

machine=$(shell hostname)

all: bst lazylist citrus rlu skiplistlock bundle vcas ebr ubundle

.PHONY: bundle rbundle
bundle: lazylist_bundle skiplistlock_bundle citrus_bundle bst_bundle
lazylist_bundle: lazylist.rq_bundle.ts lazylist.rq_bundle.rdtsc lazylist.rq_bundle.rdtscp
skiplistlock_bundle: skiplistlock.rq_bundle.ts skiplistlock.rq_bundle.rdtsc skiplistlock.rq_bundle.rdtscp
citrus_bundle: citrus.rq_bundle.ts citrus.rq_bundle.rdtsc citrus.rq_bundle.rdtscp
bst_bundle: bst.rq_bundle.ts bst.rq_bundle.rdtsc bst.rq_bundle.rdtscp
rbundle: citrus.rq_rbundle skiplistlock.rq_rbundle lazylist.rq_rbundle
bundlerq: citrus.rq_bundlerq skiplistlock.rq_bundlerq lazylist.rq_bundlerq

.PHONY: vcas
vcas: lazylist_vcas skiplistlock_vcas citrus_vcas bst_vcas
lazylist_vcas: lazylist.rq_vcas.ts lazylist.rq_vcas.rdtsc lazylist.rq_vcas.rdtscp
skiplistlock_vcas: skiplistlock.rq_vcas.ts skiplistlock.rq_vcas.rdtsc skiplistlock.rq_vcas.rdtscp
citrus_vcas: citrus.rq_vcas.ts citrus.rq_vcas.rdtsc citrus.rq_vcas.rdtscp
bst_vcas: bst.rq_vcas.ts bst.rq_vcas.rdtsc bst.rq_vcas.rdtscp

.PHONY: ebr
ebr: lazylist_ebr skiplistlock_ebr citrus_ebr bst_ebr lazylist_ebr_lockfree skiplistlock_ebr_lockfree citrus_ebr_lockfree bst_ebr_lockfree
lazylist_ebr: lazylist.rq_rwlock.ts lazylist.rq_rwlock.rdtsc lazylist.rq_rwlock.rdtscp
skiplistlock_ebr: skiplistlock.rq_rwlock.ts skiplistlock.rq_rwlock.rdtsc skiplistlock.rq_rwlock.rdtscp
citrus_ebr: citrus.rq_rwlock.ts citrus.rq_rwlock.rdtsc citrus.rq_rwlock.rdtscp
bst_ebr: bst.rq_rwlock.ts bst.rq_rwlock.rdtsc bst.rq_rwlock.rdtscp
lazylist_ebr_lockfree: lazylist.rq_lockfree.ts lazylist.rq_lockfree.rdtsc lazylist.rq_lockfree.rdtscp
skiplistlock_ebr_lockfree: skiplistlock.rq_lockfree.ts skiplistlock.rq_lockfree.rdtsc skiplistlock.rq_lockfree.rdtscp
citrus_ebr_lockfree: citrus.rq_lockfree.ts citrus.rq_lockfree.rdtsc citrus.rq_lockfree.rdtscp
bst_ebr_lockfree: bst.rq_lockfree.ts bst.rq_lockfree.rdtsc bst.rq_lockfree.rdtscp

BUNDLE_FLAGS = -DRQ_BUNDLE -DBUNDLE_LINKED_BUNDLE -DTS_PROVIDER=BackoffTimestamp #BundlingTimestamp
BUNDLE_FLAGS_RDTSC = -DRQ_BUNDLE -DBUNDLE_LINKED_BUNDLE -DTS_PROVIDER=RdtscTimestamp
BUNDLE_FLAGS_RDTSCP = -DRQ_BUNDLE -DBUNDLE_LINKED_BUNDLE -DTS_PROVIDER=RdtscpTimestamp

VCAS_FLAGS = -DRQ_VCAS -DTS_PROVIDER=BackoffTimestamp
VCAS_FLAGS_RDTSC = -DRQ_VCAS -DTS_PROVIDER=RdtscTimestamp
VCAS_FLAGS_RDTSCP = -DRQ_VCAS -DTS_PROVIDER=RdtscpTimestamp

EBR_LOCKFREE_FLAGS = -DRQ_LOCKFREE
EBR_LOCKFREE_FLAGS_RDTSC = -DRQ_LOCKFREE_HW -DTS_PROVIDER=RdtscTimestamp
EBR_LOCKFREE_FLAGS_RDTSCP = -DRQ_LOCKFREE_HW -DTS_PROVIDER=RdtscpTimestamp

thispath=

.PHONY: lazylist.rq_lockfree.ts lazylist.rq_lockfree.rdtsc lazylist.rq_lockfree.rdtscp lazylist.rq_rwlock.ts lazylist.rq_rwlock.rdtsc lazylist.rq_rwlock.rdtscp lazylist.rq_unsafe lazylist.rq_bundle.ts lazylist.rq_bundle.rdtsc lazylist.rq_bundle.rdtscp lazylist.rq_bundlerq lazylist.rq_rlu lazylist.rq_vcas.ts lazylist.rq_vcas.rdtsc lazylist.rq_vcas.rdtscp
lazylist: lazylist.rq_lockfree.ts lazylist.rq_lockfree.rdtsc lazylist.rq_lockfree.rdtscp lazylist.rq_rwlock.ts lazylist.rq_rwlock.rdtsc lazylist.rq_rwlock.rdtscp lazylist.rq_unsafe lazylist.rq_bundle.ts lazylist.rq_bundle.rdtsc lazylist.rq_bundle.rdtscp lazylist.rq_bundlerq lazylist.rq_rlu lazylist.rq_vcas.ts lazylist.rq_vcas.rdtsc lazylist.rq_vcas.rdtscp
lazylist.rq_lockfree.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DLAZYLIST ${EBR_LOCKFREE_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_lockfree.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DLAZYLIST ${EBR_LOCKFREE_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_lockfree.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DLAZYLIST ${EBR_LOCKFREE_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_rwlock.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DLAZYLIST -DRQ_RWLOCK -DTS_PROVIDER=EbrTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_rwlock.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DLAZYLIST -DRQ_RWLOCK -DTS_PROVIDER=RdtscTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_rwlock.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DLAZYLIST -DRQ_RWLOCK -DTS_PROVIDER=RdtscpTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_unsafe:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DUNSAFE_LIST $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_bundle.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_LIST ${BUNDLE_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_bundle.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_LIST ${BUNDLE_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_bundle.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_LIST ${BUNDLE_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_bundlerq:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_LIST ${BUNDLE_FLAGS} -DBUNDLE_RQTS $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_vcas.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_LAZYLIST ${VCAS_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_vcas.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_LAZYLIST ${VCAS_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_vcas.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_LAZYLIST ${VCAS_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
lazylist.rq_rlu:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DRLU_LIST $(pinning) $(thispath)main.cpp $(thispath)../rlu/rlu.cpp $(LDFLAGS)


.PHONY: skiplistlock skiplistlock.rq_lockfree.ts skiplistlock.rq_lockfree.rdtsc skiplistlock.rq_lockfree.rdtscp skiplistlock.rq_rwlock.ts skiplistlock.rq_rwlock.rdtsc skiplistlock.rq_rwlock.rdtscp skiplistlock.rq_unsafe skiplistlock.rq_snapcollector skiplistlock.rq_bundle.ts skiplistlock.rq_bundle.rdtsc skiplistlock.rq_bundle.rdtscp skiplistlock.rq_bundlerq skiplistlock.rq_vcas.ts skiplistlock.rq_vcas.rdtsc skiplistlock.rq_vcas.rdtscp
skiplistlock: skiplistlock skiplistlock.rq_lockfree.ts skiplistlock.rq_lockfree.rdtsc skiplistlock.rq_lockfree.rdtscp skiplistlock.rq_rwlock.ts skiplistlock.rq_rwlock.rdtsc skiplistlock.rq_rwlock.rdtscp skiplistlock.rq_unsafe skiplistlock.rq_snapcollector skiplistlock.rq_bundle.ts skiplistlock.rq_bundle.rdtsc skiplistlock.rq_bundle.rdtscp skiplistlock.rq_bundlerq skiplistlock.rq_vcas.ts skiplistlock.rq_vcas.rdtsc skiplistlock.rq_vcas.rdtscp
skiplistlock.rq_lockfree.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DSKIPLISTLOCK ${EBR_LOCKFREE_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_lockfree.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DSKIPLISTLOCK ${EBR_LOCKFREE_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_lockfree.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DSKIPLISTLOCK ${EBR_LOCKFREE_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_rwlock.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DSKIPLISTLOCK -DRQ_RWLOCK -DTS_PROVIDER=EbrTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_rwlock.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DSKIPLISTLOCK -DRQ_RWLOCK -DTS_PROVIDER=RdtscTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_rwlock.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DSKIPLISTLOCK -DRQ_RWLOCK -DTS_PROVIDER=RdtscpTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_unsafe:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DUNSAFE_SKIPLIST $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_snapcollector:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DSKIPLISTLOCK -DRQ_SNAPCOLLECTOR $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_bundle.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_SKIPLIST ${BUNDLE_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_bundle.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_SKIPLIST ${BUNDLE_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_bundle.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_SKIPLIST ${BUNDLE_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_bundlerq:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_SKIPLIST ${BUNDLE_FLAGS} -DBUNDLE_RQTS $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_vcas.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_SKIPLIST ${VCAS_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_vcas.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_SKIPLIST ${VCAS_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_vcas.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_SKIPLIST ${VCAS_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)

.PHONY: bst bst.rq_lockfree.ts bst.rq_lockfree.rdtsc bst.rq_lockfree.rdtscp bst.rq_rwlock.ts bst.rq_rwlock.rdtsc bst.rq_rwlock.rdtscp bst.rq_htm_rwlock bst.rq_unsafe bst.rq_vcas.ts bst.rq_vcas.rdtsc bst.rq_vcas.rdtscp bst.rq_bundle.ts bst.rq_bundle.rdtsc bst.rq_bundle.rdtscp
bst: bst.rq_lockfree.ts bst.rq_lockfree.rdtsc bst.rq_lockfree.rdtscp bst.rq_rwlock.ts bst.rq_rwlock.rdtsc bst.rq_rwlock.rdtscp bst.rq_htm_rwlock bst.rq_unsafe bst.rq_vcas.ts bst.rq_vcas.rdtsc bst.rq_vcas.rdtscp bst.rq_bundle.ts bst.rq_bundle.rdtsc bst.rq_bundle.rdtscp
bst.rq_lockfree.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBST ${EBR_LOCKFREE_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_lockfree.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBST ${EBR_LOCKFREE_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_lockfree.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBST ${EBR_LOCKFREE_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_rwlock.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(;ilesuffix).out $(xargs) -DBST -DRQ_RWLOCK -DTS_PROVIDER=EbrTimestamp  $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_rwlock.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(;ilesuffix).out $(xargs) -DBST -DRQ_RWLOCK -DTS_PROVIDER=RdtscTimestamp  $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_rwlock.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(;ilesuffix).out $(xargs) -DBST -DRQ_RWLOCK -DTS_PROVIDER=RdtscpTimestamp  $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_htm_rwlock:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBST -DRQ_HTM_RWLOCK $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_unsafe:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBST -DRQ_UNSAFE $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_vcas.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCASBST ${VCAS_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_vcas.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCASBST ${VCAS_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
bst.rq_vcas.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCASBST ${VCAS_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)


.PHONY: citrus citrus.rq_lockfree.ts citrus.rq_lockfree.rdtsc citrus.rq_lockfree.rdtscp citrus.rq_rwlock.ts citrus.rq_rwlock.rdtsc citrus.rq_rwlock.rdtscp citrus.rq_htm_rwlock citrus.rq_unsafe citrus.rq_bundle.ts citrus.rq_bundle.rdtsc citrus.rq_bundle.rdtscp citrus.rq_rbundle citrus.rq_bundlerq citrus.rq_tsrbundle citrus.rq_rcbundle citrus.rq_tsrcbundle citrus.rq_vcas.ts citrus.rq_vcas.rdtsc citrus.rq_vcas.rdtscp
citrus: citrus.rq_lockfree.ts citrus.rq_lockfree.rdtsc citrus.rq_lockfree.rdtscp citrus.rq_rwlock.ts citrus.rq_rwlock.rdtsc citrus.rq_rwlock.rdtscp citrus.rq_htm_rwlock citrus.rq_unsafe citrus.rq_bundle.ts citrus.rq_bundle.rdtsc citrus.rq_bundle.rdtscp citrus.rq_rbundle citrus.rq_bundlerq citrus.rq_tsrbundle citrus.rq_rcbundle citrus.rq_tsrcbundle citrus.rq_vcas.ts citrus.rq_vcas.rdtsc citrus.rq_vcas.rdtscp
citrus.rq_lockfree.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DCITRUS ${EBR_LOCKFREE_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_lockfree.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DCITRUS ${EBR_LOCKFREE_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_lockfree.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DCITRUS ${EBR_LOCKFREE_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_rwlock.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DCITRUS -DRQ_RWLOCK -DTS_PROVIDER=EbrTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_rwlock.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DCITRUS -DRQ_RWLOCK -DTS_PROVIDER=RdtscTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_rwlock.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DCITRUS -DRQ_RWLOCK -DTS_PROVIDER=RdtscpTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_unsafe:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DUNSAFE_CITRUS $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_bundle.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_CITRUS ${BUNDLE_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_bundle.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_CITRUS ${BUNDLE_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_bundle.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_CITRUS ${BUNDLE_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_bundlerq:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_CITRUS ${BUNDLE_FLAGS} -DBUNDLE_RQTS$(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_vcas.ts:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_CITRUS ${VCAS_FLAGS} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_vcas.rdtsc:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_CITRUS ${VCAS_FLAGS_RDTSC} $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_vcas.rdtscp:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DVCAS_CITRUS ${VCAS_FLAGS_RDTSCP} $(pinning) $(thispath)main.cpp $(LDFLAGS)

.PHONY: rlu lazylist.rq_rlu citrus.rq_rlu
rlu: lazylist.rq_rlu citrus.rq_rlu
citrus.rq_rlu:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DRLU_CITRUS $(pinning) $(thispath)main.cpp $(thispath)../rlu/rlu.cpp $(LDFLAGS)

.PHONY: ubundle lazylist.rq_ubundle skiplistlock.rq_ubundle citrus.rq_ubundle 
ubundle: lazylist.rq_ubundle skiplistlock.rq_ubundle citrus.rq_ubundle 
lazylist.rq_ubundle:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DRQ_BUNDLE -DBUNDLE_UNSAFE_BUNDLE -DBUNDLE_LIST -DTS_PROVIDER=BackoffTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
skiplistlock.rq_ubundle:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DBUNDLE_SKIPLIST -DRQ_BUNDLE -DBUNDLE_UNSAFE_BUNDLE -DBUNDLE_RESTARTS -DTS_PROVIDER=BackoffTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)
citrus.rq_ubundle:
	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DRQ_BUNDLE -DBUNDLE_UNSAFE_BUNDLE -DBUNDLE_CITRUS -DTS_PROVIDER=BackoffTimestamp $(pinning) $(thispath)main.cpp $(LDFLAGS)

## The following is an experimental bundle implementation that uses a circular buffer instead of a linked list.
# .PHONY: cbundle lazylist.rq_cbundle skiplistlock.rq_cbundle citrus.rq_cbundle
# cbundle: lazylist.rq_cbundle skiplistlock.rq_cbundle citrus.rq_cbundle
# lazylist.rq_cbundle:
# 	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DRQ_BUNDLE -DBUNDLE_CIRCULAR_BUNDLE -DBUNDLE_LIST $(pinning) $(thispath)main.cpp $(LDFLAGS)
# skiplistlock.rq_cbundle:
# 	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DRQ_BUNDLE -DBUNDLE_CIRCULAR_BUNDLE -DBUNDLE_SKIPLIST $(pinning) $(thispath)main.cpp $(LDFLAGS)
# citrus.rq_cbundle:
# 	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DRQ_BUNDLE -DBUNDLE_CIRCULAR_BUNDLE -DBUNDLE_CITRUS $(pinning) $(thispath)main.cpp $(LDFLAGS)

# .PHONY: unsafe lazylist.rq_unsafe skiplistlock.rq_unsafe citrus.rq_unsafe
# unsafe: lazylist.rq_unsafe skiplistlock.rq_unsafe citrus.rq_unsafe
# lazylist.rq_unsafe:
# 	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DUNSAFE_LIST $(pinning) $(thispath)main.cpp $(LDFLAGS)
# skiplistlock.rq_unsafe:
# 	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DUNSAFE_SKIPLIST $(pinning) $(thispath)main.cpp $(LDFLAGS)
# citrus.rq_unsafe:
# 	$(GPP) $(FLAGS) -o $(thispath)$(machine).$@$(filesuffix).out $(xargs) -DUNSAFE_CITRUS $(pinning) $(thispath)main.cpp $(LDFLAGS)

.PHONY: clean
clean:
	rm *.out
