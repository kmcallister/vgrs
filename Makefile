BUILDDIR = build

RUSTC ?= rustc
RUSTDOC ?= rustdoc
RUST_DIRS := -L $(BUILDDIR)

VALGRIND ?= valgrind

RUSTC_CMD := $(RUSTC) --out-dir $(BUILDDIR) $(RUST_DIRS) -O $(RUSTFLAGS)
VALGRIND_CMD := $(VALGRIND) -q --log-file=/dev/null

LIB_TOP_SRC := src/lib.rs
LIB_ALL_SRC := $(shell find src -type f -name '*.rs')
LIB         := $(BUILDDIR)/$(shell $(RUSTC) --print-file-name "$(LIB_TOP_SRC)")

.PHONY: all
all: $(LIB) doc

$(BUILDDIR):
	mkdir -p $@

$(LIB): $(LIB_ALL_SRC) | $(BUILDDIR)
	$(RUSTC_CMD) $(LIB_TOP_SRC)

.PHONY: doc
doc: $(BUILDDIR)/doc/vgrs/index.html

$(BUILDDIR)/doc/vgrs/index.html: $(LIB_ALL_SRC) | $(BUILDDIR)
	$(RUSTDOC) -o $(BUILDDIR)/doc $(LIB_TOP_SRC)

TEST_TOOLS = valgrind memcheck

define DEF_TEST
$(BUILDDIR)/vgrs-$(1)-test: test/$(1).rs $$(LIB)
	$$(RUSTC_CMD) $$<
endef

$(foreach tool,$(TEST_TOOLS),\
$(eval $(call DEF_TEST,$(tool))))

.PHONY: check
check: $(foreach tool,$(TEST_TOOLS),$(BUILDDIR)/vgrs-$(tool)-test)
	$(VALGRIND_CMD) --tool=none $(BUILDDIR)/vgrs-valgrind-test
	$(VALGRIND_CMD) --tool=memcheck $(BUILDDIR)/vgrs-memcheck-test

.PHONY: clean
clean:
	rm -fr $(BUILDDIR)
