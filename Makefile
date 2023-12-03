#  SPDX-FileCopyrightText: 2023-present Emmanuel Roux
#  SPDX-License-Identifier: MIT
 
PYTHON_PROJECT_NAME := manux
PYTHON_PREFIX := .local/share/mlib/venv
MLIB_OUTPUT_HOME := ./build

include mlib.mk

# This is needed to patch sphinx-autobuild
.PHONY: sphinx.patch
sphinx.patch:
	@$(PYTHON) -m pip uninstall -y sphinx-autobuild
	@$(PYTHON) -m pip install "git+https://github.com/e-roux/sphinx-autobuild@feat/post-build"
	@sp_ab=$(shell $(PYTHON) -c "import os; import sphinx_autobuild as mod; print(os.path.dirname(mod.__file__))") && \
		cd "$${sp_ab}" && \
		gh pr -R 'executablebooks/sphinx-autobuild' diff 134 > /tmp/134.diff && \
		patch < /tmp/134.diff
# ··························································
# CSS
# ··························································
TAILWINDCSS := build/doc/_static/css/tailwind.css
.PHONY: $(TAILWINDCSS)

$(TAILWINDCSS):
	@npx tailwindcss -c $(MLIB_CONFIG_HOME)/tailwindcss/tailwind.config.js -i $(DOC_SRC_HOME)/_static/css/$(@F) -o $@

tailwindcss: $(TAILWINDCSS)

# ··························································
# Doc
# ··························································
SPHINX_AUTOBUILD_OPTS += --post-build "make tailwindcss"
sphinx.doc.done: $(TAILWINDCSS)
sphinx.doc.watch: 

