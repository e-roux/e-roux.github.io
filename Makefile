#  SPDX-FileCopyrightText: 2023-present Emmanuel Roux
#  SPDX-License-Identifier: MIT
 
PYTHON_PROJECT_NAME := manux

include mlib.mk

# ··························································
# CSS
# ··························································
TAILWINDCSS := build/doc/_static/css/tailwind.css
.PHONY: $(TAILWINDCSS)

$(TAILWINDCSS):
	@npx tailwindcss -c $(MLIB_CONFIG_HOME)/tailwindcss/tailwind.config.js -o $@

tailwindcss: $(TAILWINDCSS)

# ··························································
# Doc
# ··························································
SPHINX_AUTOBUILD_OPTS += --post-build "make tailwindcss"
sphinx.doc.done: $(TAILWINDCSS)
sphinx.doc.watch: 

