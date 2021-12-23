######################################################################
# @author      : Emmanuel Roux
# @file        : Makefile
# @created     : Ven 10 déc 05:33:59 202
# 1
######################################################################

.DEFAULT_GOAL := all

# include vendors/makefile/common.mk
ESBUILD := ./node_modules/.bin/esbuild

./node_modules/bin/%:
	@npm install $*

static/js/lunr.min.js: $(ESBUILD)
	@npm install -u lunr
	@$(ESBUILD) --minify

VENDOR_DIR := static/vendors

# {{{1 Bootstrap
BOOTSTRAP_VERSION := 5.1.3
BOOTSTRAP_ARCHIVE := bootstrap-$(BOOTSTRAP_VERSION)-dist.zip
BOOTSTRAP_URL := https://github.com/twbs/bootstrap/releases/download/v$(BOOTSTRAP_VERSION)
BOOTSTRAP := $(VENDOR_DIR)/bootstrap
BOOTSTRAP_TMP := /tmp
BOOTSTRAP_CSS := $(BOOTSTRAP)/css/bootstrap.min.css

$(BOOTSTRAP_CSS):
	curl -L $(BOOTSTRAP_URL)/$(BOOTSTRAP_ARCHIVE) -o $(BOOTSTRAP_TMP)/$(BOOTSTRAP_ARCHIVE)
	@unzip $(BOOTSTRAP_TMP)/$(BOOTSTRAP_ARCHIVE) -d $(VENDOR_DIR)
	@mv $(VENDOR_DIR)/$(basename $(BOOTSTRAP_ARCHIVE)) $(BOOTSTRAP)
# 1}}}

# Highlight.js {{{1
HIGHLIGHT_JS := $(VENDOR_DIR)/highlight/js/highlight.min.js
HIGHLIGHT_CSS := $(VENDOR_DIR)/highlight/css/highlight.min.css
HIGHLIGHT_JS_VERSION := 11.3.1

ifndef NODE_BUILD
HIGHLIGHT_JS_URL := https://cdnjs.cloudflare.com/ajax/libs/highlight.js/$(HIGHLIGHT_JS_VERSION)/highlight.min.js

$(HIGHLIGHT_JS):
	@mkdir -p $(@D)
	@curl -L "$(HIGHLIGHT_JS_URL)" -o $@
else
static/js/highlight.min.js:
	echo "non"
endif

HIGHLIGHT_CSS_URL := https://cdnjs.cloudflare.com/ajax/libs/highlight.js/$(HIGHLIGHT_JS_VERSION)/styles/default.min.css

$(HIGHLIGHT_CSS):
	@mkdir -p $(@D)
	@curl -L "$(HIGHLIGHT_CSS_URL)" -o $@
# 1}}}

# Katex {{{1
KATEX_VERSION := 0.15.1
KATEX_URL := https://cdn.jsdelivr.net/npm/katex@$(KATEX_VERSION)/dist
KATEX_CSS := $(VENDOR_DIR)/katex/css/katex.min.css
KATEX_JS := $(VENDOR_DIR)/katex/js/katex.min.js

$(KATEX_CSS) $(KATEX_JS):
	@mkdir -p $(@D)
	@curl -L "$(KATEX_URL)/$(@F)" -o $@
# 1}}}

# {{{1 Fontawesome
FONTAWESOME_VERSION := 5.15.4
FONTAWESOME_ARCHIVE := fontawesome-free-$(FONTAWESOME_VERSION)-web.zip
FONTAWESOME_URL := https://use.fontawesome.com/releases/v$(FONTAWESOME_VERSION)
FONTAWESOME := $(VENDOR_DIR)/fontawesome
FONTAWESOME_TMP := /tmp

FONTAWESOME_CSS := $(FONTAWESOME)/css/all.css

$(FONTAWESOME_CSS):
	@mkdir -p $(VENDOR_DIR)
	@curl -L $(FONTAWESOME_URL)/$(FONTAWESOME_ARCHIVE) -o $(FONTAWESOME_TMP)/$(FONTAWESOME_ARCHIVE)
	@unzip $(FONTAWESOME_TMP)/$(FONTAWESOME_ARCHIVE) -d $(VENDOR_DIR)
	@mv $(VENDOR_DIR)/$(basename $(FONTAWESOME_ARCHIVE)) $(FONTAWESOME)
# 1}}}

_VENDORS_JS := $(HIGHLIGHT_JS) $(KATEX_JS) $(BOOTSTRAP_JS)
_VENDORS_CSS := $(HIGHLIGHT_CSS) $(KATEX_CSS) $(FONTAWESOME_CSS) $(BOOTSTRAP_CSS)

clean:
	@rm -f $(_VENDORS_JS) $(_VENDORS_CSS)

all: $(_VENDORS_JS) $(_VENDORS_CSS)
# vim:set fdm=marker:
