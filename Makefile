BUILDDIR = build

CARGO ?= cargo
RUSTC ?= rustc
RUST_DIRS := -L $(BUILDDIR) -L target -L target/deps

VALGRIND ?= valgrind

RUSTC_CMD := $(RUSTC) --out-dir $(BUILDDIR) $(RUST_DIRS) -O $(RUSTFLAGS)
VALGRIND_CMD := $(VALGRIND) -q --log-file=/dev/null

LIB_ALL_SRC := $(shell find src -type f -name '*.rs')
LIB         := $(BUILDDIR)/libvgrs.dummy

.PHONY: all
all: $(LIB)

$(BUILDDIR):
	mkdir -p $@

$(LIB): $(LIB_ALL_SRC) | $(BUILDDIR)
	$(CARGO) build
	touch $(LIB)

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
	$(CARGO) clean
	rm -fr $(BUILDDIR)
