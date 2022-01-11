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
BOOTSTRAP_TARGET := $(VENDOR_DIR)/bootstrap
BOOTSTRAP_TMP := /tmp
BOOTSTRAP_CSS := $(BOOTSTRAP_TARGET)/css/bootstrap.min.css
BOOTSTRAP := $(BOOTSTRAP_CSS) $(BOOTSTRAP_JS)

$(BOOTSTRAP_CSS):
	curl -L $(BOOTSTRAP_URL)/$(BOOTSTRAP_ARCHIVE) -o $(BOOTSTRAP_TMP)/$(BOOTSTRAP_ARCHIVE)
	@unzip $(BOOTSTRAP_TMP)/$(BOOTSTRAP_ARCHIVE) -d $(VENDOR_DIR)
	@mv $(VENDOR_DIR)/$(basename $(BOOTSTRAP_ARCHIVE)) $(BOOTSTRAP_TARGET)
# 1}}}

# Highlight.js {{{1
HIGHLIGHT_JS := $(VENDOR_DIR)/highlight/js/highlight.min.js
HIGHLIGHT_CSS := $(VENDOR_DIR)/highlight/css/highlight.min.css
HIGHLIGHT_JS_VERSION := 11.3.1

HIGHLIGHT := $(HIGHLIGHT_JS) $(HIGHLIGHT_CSS)

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
KATEX := $(KATEX_CSS) $(KATEX_JS)

$(KATEX):
	@mkdir -p $(@D)
	@curl -L "$(KATEX_URL)/$(@F)" -o $@
# 1}}}

# {{{1 Fontawesome
FONTAWESOME_VERSION := 5.15.4
FONTAWESOME_ARCHIVE := fontawesome-free-$(FONTAWESOME_VERSION)-web.zip
FONTAWESOME_URL := https://use.fontawesome.com/releases/v$(FONTAWESOME_VERSION)
FONTAWESOME_TARGET := $(VENDOR_DIR)/fontawesome
FONTAWESOME_TMP := /tmp

FONTAWESOME_CSS := $(FONTAWESOME_TARGET)/css/all.css

FONTAWESOME := $(FONTAWESOME_CSS)

$(FONTAWESOME_CSS):
	@mkdir -p $(VENDOR_DIR)
	@curl -L $(FONTAWESOME_URL)/$(FONTAWESOME_ARCHIVE) -o $(FONTAWESOME_TMP)/$(FONTAWESOME_ARCHIVE)
	@unzip $(FONTAWESOME_TMP)/$(FONTAWESOME_ARCHIVE) -d $(VENDOR_DIR)
	@mv $(VENDOR_DIR)/$(basename $(FONTAWESOME_ARCHIVE)) $(FONTAWESOME_TARGET)
# 1}}}

# {{{1 Photoswipe
# https://github.com/dimsemenov/PhotoSwipe
PHOTOSWIPE_VERSION := 4.1.3
PHOTOSWIPE_URL := https://raw.githubusercontent.com/dimsemenov/PhotoSwipe/v$(PHOTOSWIPE_VERSION)/dist
PHOTOSWIPE_TARGET := static/vendors/photoswipe
PHOTOSWIPE_BASE_JS := $(PHOTOSWIPE_TARGET)/photoswipe.min.js
PHOTOSWIPE_UI_JS := $(PHOTOSWIPE_TARGET)/photoswipe-ui-default.min.js
PHOTOSWIPE_BASE_CSS := $(PHOTOSWIPE_TARGET)/photoswipe.css
PHOTOSWIPE_SKIN_CSS := $(PHOTOSWIPE_TARGET)/default-skin.css
PHOTOSWIPE := $(PHOTOSWIPE_BASE_JS) $(PHOTOSWIPE_UI_JS) $(PHOTOSWIPE_BASE_CSS) $(PHOTOSWIPE_SKIN_CSS)

$(PHOTOSWIPE_SKIN_CSS):
	@mkdir -p static/vendors/photoswipe
	@curl -L $(PHOTOSWIPE_URL)/default-skin/$(@F) -o $@

$(PHOTOSWIPE_BASE_JS) $(PHOTOSWIPE_UI_JS) $(PHOTOSWIPE_BASE_CSS):
	@mkdir -p static/vendors/photoswipe
	@curl -L $(PHOTOSWIPE_URL)/$(@F) -o $@
# 1}}}

# {{{1 Fonts
FONTS := static/css/fonts.css

$(FONTS):
	@curl -L 'https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic' >> $@
	@curl -L 'https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' >> $@
	# 1}}}

VENDORS := $(FONTAWESOME) $(PHOTOSWIPE) $(KATEX) $(HIGHLIGHT) $(FONTS) $(BOOTSTRAP)

clean:
	@rm -f $(VENDORS)

all: $(VENDORS)
# vim:set fdm=marker:
