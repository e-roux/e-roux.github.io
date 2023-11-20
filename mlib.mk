#  SPDX-FileCopyrightText: 2021-present Emmanuel Roux
#  SPDX-FileCopyrightText: 2016-2021 The Upbound Authors
#  SPDX-License-Identifier: Apache-2.0
__VERSION__ := 0.2.0+pre.10.52e56e0.dirty
SHELL ?= /bin/bash
V ?= ##co Set to 1 enable verbose build.
ifeq ($(V),1)
	MAKEFLAGS += VERBOSE=1
else
MAKEFLAGS += --no-print-directory
endif
CI ?= 
MAKEFLAGS += --warn-undefined-variables
DEBUG ?= 0##co Whether to generate debug symbols. Default is 0.
ifeq ($(filter shell-export,$(value .FEATURES)),)
$(error Unsupported Make version. \
The build system does not work properly with GNU Make $(MAKE_VERSION) with features: $(value .FEATURES)\
please use GNU Make 4.4 or above.)
endif
.SUFFIXES:
.DEFAULT_GOAL := help
.PHONY: all
all:
GIT_COMMIT_HASH ?=
ALLOW_DIRTY ?=
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
XDG_STATE_HOME ?= $(HOME)/.local/state
XDG_CACHE_HOME ?= $(HOME)/.cache
MLIB_ROOT_HOME != (git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null || pwd) | head -1
MLIB_CONFIG_HOME ?= $(MLIB_ROOT_HOME)/.config
MLIB_DATA_HOME ?= $(MLIB_ROOT_HOME)/.local/share
MLIB_CACHE_HOME ?= $(MLIB_ROOT_HOME)/.cache
MLIB_STATE_HOME ?= $(MLIB_ROOT_HOME)/.local/state
MLIB_PROJECT_HOME  := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
MLIB_LIB_HOME ?= $(MLIB_ROOT_HOME)/.local/lib
MLIB_OUTPUT_HOME ?= $(MLIB_ROOT_HOME)/build
MLIB_WORK_HOME ?= $(MLIB_DATA_HOME)/mlib
MLIB_TOOLS_HOME := $(MLIB_ROOT_HOME)/.local/bin
 
_BLACK        != printf "\033[30m"
_BLACK_BOLD   != printf "\033[30;1m"
_RED          != printf "\033[31m"
_RED_BOLD     != printf "\033[31;1m"
_GREEN        != printf "\033[32m"
_GREEN_BOLD   != printf "\033[32\;1m"
_YELLOW       != printf "\033[33m"
_YELLOW_BOLD  != printf "\033[33\;1m"
_BLUE         != printf "\033[34m"
_BLUE_BOLD    != printf "\033[34\;1m"
_MAGENTA      != printf "\033[35m"
_MAGENTA_BOLD != printf "\033[35\;1m"
_CYAN         != printf "\033[36m"
_CYAN_BOLD    != printf "\033[36\;1m"
_WHITE        != printf "\033[37m"
_WHITE_BOLD   != printf "\033[37\;1m"
_CNone        != printf "\033[0m"
_CNONE_BOLD   != printf "\033[0\;1m"
_TERMINAL_WIDTH != tput cols
_TIME		= `date +%H:%M:%S`
INFO	= echo ${_TIME} ${_BLUE}[ .. ]${_CNone}
WARN	= echo ${_TIME} ${_YELLOW}[WARN]${_CNone}
ERR		= echo ${_TIME} ${_RED}[FAIL]${_CNone}
OK		= echo ${_TIME} ${_GREEN}[ OK ]${_CNone}
FAIL	= (echo ${_TIME} ${_RED}[FAIL]${_CNone} && false)
TEST	= echo ${_TIME} ${_CYAN_BOLD}[TEST]${_CNone}
STATUS_OK		= printf "\e[1A\e[$$(( 10 ))C${_GREEN} OK ${_CNone}\n"
STATUS_KO		= printf "\e[1A\e[$$(( 10 ))C${_RED_BOLD} KO ${_CNone}\n"
define _colorize
$(_MAGENTA)$(1)$(_CNone)
endef
ENV :=
.PHONY: printenv
.SECONDEXPANSION:
printenv: 
ifdef V
	@printf "$(ENV) = \"%s\", set in %s" "$($(ENV))" "$(origin $(ENV))"
else
	@printf "$(ENV) = %s" "$($(ENV))"
endif
CHANNEL ?= master
ifeq ($(filter master alpha beta stable,$(CHANNEL)),)
$(error invalid channel $(CHANNEL))
endif
GIT_BRANCH_NAME != git branch --show-current 2> /dev/null || git config --get init.defaultBranch
GIT_REMOTE_NAME ?= origin
GIT_REMOTE_URL != git remote get-url --push $(GIT_REMOTE_NAME) 2>/dev/null 
ifdef GIT_REMOTE_URL
GIT_REMOTE_URL != git remote get-url --push $(GIT_REMOTE_NAME) 2>/dev/null | sed -Ee "s/(https?\:\/\/).*@/\1/" \
	-e "s%.*git@(.*)\:(.*)%\1/\2%" \
	-e "s%.*ssh://(.*)\:(.*)%\1/\2%" 
GIT_REMOTE_HOST != echo $(GIT_REMOTE_URL) | sed -E \
	-e "s%^[A-Za-z]*\://(.*)%\1%" \
	-e "s%([A-Za-z]*)(:[0-9]{3,5})?/.*%\1%"
GIT_REMOTE_PORT != echo $(GIT_REMOTE_URL) | sed -nE 's%.*:([0-9]{3,5})/.*%\1%p'
GIT_PROJECT_NAME != echo $(GIT_REMOTE_URL) | sed -e 's/\.git//' | xargs basename
GIT_PROJECT_REPO != echo $(GIT_REMOTE_URL) | sed -E \
				-e 's%(https?://|ssh://git@)%%'  \
				-e 's%^[0-9A-Za-z\-\_\.\:]*@/(.*)%\1%' \
				-e 's%\:[0-9]*/%/%' \
				 | sed -Ee "s%\.git$$%%"
GIT_PROJECT_NAMESPACE != echo $(GIT_PROJECT_REPO) | xargs dirname | \
				sed -Ee 's%^[0-9A-Za-z\-\_\.]*/(.*)%\1%' 2>/dev/null 
else
GIT_REMOTE_HOST ?= 
GIT_PROJECT_REPO ?=
GIT_REMOTE_PORT ?=
GIT_PROJECT_NAME_SPACE ?=
endif
GIT_CONFIG_USER_NAME := $(shell git config --get user.name)
GIT_CONFIG_USER_EMAIL := $(shell git config --get user.email)
 
PLATFORMS ?= darwin_amd64 darwin_arm64 linux_amd64 linux_arm64
HOST_OS != uname -s | tr '[:upper:]' '[:lower:]'
ifeq ($(filter darwin linux,$(HOST_OS)),)
$(error build only supported on linux and darwin host currently)
endif
HOST_ARCH != uname -m
ifeq ($(HOST_ARCH),x86_64)
HOST_ARCH := amd64
endif
ifeq ($(HOST_ARCH),aarch64)
HOST_ARCH := arm64
endif
ifeq ($(filter amd64 arm64,$(HOST_ARCH)),)
$(error $(HOST_ARCH) unsupported, build only supported on amd64 and arm64 host currently)
endif
HOST_PLATFORM := $(HOST_OS)_$(HOST_ARCH)
ifeq ($(origin PLATFORM),undefined)
PLATFORM := $(HOST_PLATFORM)##co The platform to build.
BUILD_PLATFORMS ?= 
ifneq ($(filter $(PLATFORMS),$(HOST_PLATFORM)),)
ifeq ($(filter $(BUILD_PLATFORMS),$(HOST_PLATFORM)),)
BUILD_PLATFORMS += $(HOST_PLATFORM)
endif
endif
ifneq ($(HOST_OS),linux)
endif
else
BUILD_PLATFORMS = $(PLATFORM)
endif
OS := $(word 1, $(subst _, ,$(PLATFORM)))
ARCH := $(word 2, $(subst _, ,$(PLATFORM)))
ifeq ($(HOST_OS),darwin)
NPROCS != sysctl -n hw.ncpu
else
NPROCS != nproc
endif
HOSTNAME != hostname
WHOAMI != whoami
 
CURL ?= curl
 
_GIT_IS_DIRTY != [[ -n "$$(git status --porcelain 2>/dev/null)" ]] && printf "true"
_GIT_NCOMMITS_SINCE_TAG != git rev-list "$$(git describe --tags --abbrev=0 2>/dev/null)..HEAD" --count 2>/dev/null || printf 0
_GIT_LAST_COMMIT_HASH != git rev-parse --short HEAD 2>/dev/null || printf 0000000
ifeq ($(origin VERSION),command line) 
_GIT_LAST_TAG  != echo $(VERSION) 2>/dev/null 
else  
_GIT_LAST_TAG != ( git describe --tags --abbrev=0 2>/dev/null || printf "0.1.0" ) 2>/dev/null 
endif
_GIT_LAST_TAG_HASH != git rev-parse --short $(_GIT_LAST_TAG) 2>/dev/null || printf ""
VERSION_MAJOR != printf "$(_GIT_LAST_TAG)" | awk -F'.' '{print $$1}' | sed -e s/^v//
VERSION_MINOR != printf "$(_GIT_LAST_TAG)" | awk -F'.' '{print $$2}'
VERSION_PATCH != printf "$(_GIT_LAST_TAG)" | awk -F'.' '{print $$3}' | sed -e 's/\([[:digit:]]*\).*/\1/'
VERSION := $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)
ifneq ($(origin VERSION),command line) 
ifneq ($(_GIT_LAST_COMMIT_HASH),$(_GIT_LAST_TAG_HASH))
VERSION != printf "$(VERSION)+pre%s%s%s" \
	"$(if $(_GIT_NCOMMITS_SINCE_TAG),.$(_GIT_NCOMMITS_SINCE_TAG),)" \
	".$(_GIT_LAST_COMMIT_HASH)" 
ifdef _GIT_IS_DIRTY
VERSION := $(VERSION).dirty
endif
else
ifdef _GIT_IS_DIRTY
VERSION := $(VERSION)+dirty
endif
endif
endif
VERSION_PRE_RELEASE != printf "$(VERSION)" | awk -F'+' '{print $$2}'
VERSION ?= ##ro The version information for binaries and releases.
export VERSION
VERSION_REGEX := ^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*).*$$
VERSION_VALID != echo "$(VERSION)" | grep -Eq '$(VERSION_REGEX)' && echo true || echo false
SED_CMD?=sed -i -e
COMMA := ,
SPACE :=
SPACE +=
define normalize-bool =
$(and $(filter $1,True true yes 1 TRUE YES),true)
endef
doc: ##ct Build project documentation.
fmt: ##cs Checks source code for formatting issues.
test: ##ct Runs unit tests.
e2e: ##ct Runs end-to-end integration tests.
lint: ##cs Run lint and code analysis tools.
define _template_verb_steps
.PHONY: $(1) $(1).init $(1).run $(1).done
$(1).init: ; @:
$(1).run: ; @:
$(1).done: ; @:
$(1):
	@$(MAKE) $(1).init
	@$(MAKE) $(1).run
	@$(MAKE) $(1).done
endef
$(foreach verb,doc e2e fmt lint test,$(eval $(call _template_verb_steps,$(verb))))
TEST_SRC_HOME := $(MLIB_PROJECT_HOME)/test
DOC_SRC_HOME := $(MLIB_PROJECT_HOME)/doc
common.buildvars:
	@echo GIT_PROJECT_NAME=$(GIT_PROJECT_NAME)
	@echo GIT_PROJECT_NAMESPACE=$(GIT_PROJECT_NAMESPACE)
	@echo GIT_PROJECT_REPO=$(GIT_PROJECT_REPO)
	@echo GIT_REMOTE_HOST=$(GIT_REMOTE_HOST)
	@echo BUILD_HOST=$(HOSTNAME)
	@echo MLIB_OUTPUT_HOME=$(MLIB_OUTPUT_HOME)
	@echo MLIB_CONFIG_HOME=$(MLIB_CONFIG_HOME)
	@echo MLIB_DATA_HOME=$(MLIB_DATA_HOME)
	@echo MLIB_WORK_HOME=$(MLIB_WORK_HOME)
	@echo MLIB_CACHE_HOME=$(MLIB_CACHE_HOME)
	@echo HOST_OS=$(HOST_OS)
	@echo HOST_ARCH=$(HOST_ARCH)
	@echo GIT_REMOTE_NAME=$(GIT_REMOTE_NAME)
	@echo GIT_REMOTE_URL=$(GIT_REMOTE_URL)
	@echo GIT_BRANCH_NAME=$(GIT_BRANCH_NAME)
	@echo BUILD_PLATFORMS=$(BUILD_PLATFORMS)
	@echo VERSION=$(VERSION)
build.vars: common.buildvars
.PHONY: build.init build.check build.check.platform build.code build.code.platform build.artifacts build.artifacts.platform build.done do.build.platform.% do.build.platform do.build.artifacts.% do.build.artifacts build.all build
build.init: ; @:
build.check: ; @:
build.check.platform: ; @:
build.code: ; @:
build.code.platform: ; @:
build.artifacts: ; @:
build.artifacts.platform: ; @:
build.done: ; @:
do.build.platform.%:
	@$(MAKE) build.code.platform PLATFORM=$* 
do.build.platform: $(foreach p,$(PLATFORMS), do.build.platform.$(p))
do.build.artifacts.%:
	@$(MAKE) build.artifacts.platform PLATFORM=$*
do.build.artifacts: $(foreach p,$(PLATFORMS), do.build.artifacts.$(p))
build.all:
	@$(MAKE) build.init
	@$(MAKE) build.check
	@$(MAKE) build.code
	@$(MAKE) do.build.platform
ifdef IMAGENAME	# Only if image.mk seems to be loaded 
	@$(MAKE) build.artifacts
	@$(MAKE) do.build.artifacts
endif
	@$(MAKE) build.done
build: ##ct Build source code and other artifacts for host platform.
ifneq ($(BUILD_PLATFORMS),)
	@$(MAKE) build.all PLATFORMS="$(BUILD_PLATFORMS)"
else
	@:
endif
.PHONY: tag
tag: release.tag ##rt Tag a release
.PHONY: common.watermark info.watermark info.vars info
common.watermark:
	@echo "OS: $(HOST_OS)"
	@echo "Release: $$(uname -r | sed 's/-.*//')"
	@echo "Architecture: $(ARCH)"
	@echo "CPU cores: $(NPROCS)"
info.watermark: common.watermark
info.vars: build.vars
info: ##pr Display build variable
	@echo System informations
	@echo ---------------------
	@$(MAKE) info.watermark
	@echo
	@echo Environment variables
	@echo ---------------------
	@$(MAKE) info.vars | sort
define _print_target_help
@grep -h -E '^[a-zA-Z0-9_-].?+:.*$(2)\s+.*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?$(2) "}; {printf "    \033[;3m%-12s\033[;m %s\n", $$1, $$2}' | sort
endef
define _help_section_header
@printf "\033[33;1m%-60s\033[;m\n" "$(1)"
@$(call _print_target_help,$(1),$(2))
@echo
endef
define _help_options
@printf "\033[;1m%-60s\033[;m\n" "$(1)"
@grep -h -E '^[a-zA-Z]\w*\s+[\?:]?=\s*.*$(2)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "$(2) "}; {split($$1, a, " "); printf "    \033[;3m%-12s\033[;m %s\n", a[1], $$2}' | sort
@echo
endef
define _py_help 
endef
define _go_help 
endef
.PHONY: help 
help: 
	@printf "\033[1;35mmakelib\033[;m v%s on " $(__VERSION__)
	@$(MAKE) --version | head -n 1
	@printf "Usage: \033[;1mmake \033[;3m[make-options]\033[;m <target> \033[;3m[options]\033[;m\n"
	@echo
	@$(call _help_section_header,Project scaffold and info,##pr)
	@$(call _help_section_header,Code standards,##cs)
	@$(call _help_section_header,Common Targets,##ct)
	@$(call _help_section_header,Release Targets,##rt)
	@$(call _go_help,Go Targets,##got)
	@$(call _py_help,Python Targets,##pyt)
	@$(call _help_options,Common Options,##co)
	@$(call _help_options,Release Options,##ro)
	@printf "\033[A;\33[2K\r"
HOSTARCH := $(HOST_ARCH)
HOSTOS := $(HOST_OS)
MLIB_TOOLS_SRC_HOME := $(if $(CI),$(MLIB_CACHE_HOME),$(XDG_CACHE_HOME))
ISTIO_VERSION ?= 1.19.3
ISTIO := $(MLIB_TOOLS_HOME)/istioctl-$(ISTIO_VERSION)
ISTIO_URL := https://github.com/istio/istio/releases/download/$(ISTIO_VERSION)/istio-$(ISTIO_VERSION)-$(if ifeq($(HOST_OS),darwin),osx,$(HOST_OS)-$(HOST_ARCH)).tar.gz
K8SEC_VERSION ?= v0.8.0
K8SEC := $(MLIB_TOOLS_HOME)/k8sec-$(K8SEC_VERSION)
K8SEC_URL := https://github.com/dtan4/k8sec/releases/download/$(K8SEC_VERSION)/k8sec_$(HOST_OS)_$(if ifeq($(HOST_ARCH), amd64),x86_64,$(HOST_ARCH)).tar.gz
KIND_VERSION ?= v0.20.0
KIND := $(MLIB_TOOLS_HOME)/kind-$(KIND_VERSION)
KIND_URL := https://github.com/kubernetes-sigs/kind/releases/download/$(KIND_VERSION)/kind-$(HOST_OS)-$(HOST_ARCH)
KUBECTL_VERSION ?= v1.28.3
KUBECTL := $(MLIB_TOOLS_HOME)/kubectl-$(KUBECTL_VERSION)
KUBECTL_URL := https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/$(HOST_OS)/$(HOST_ARCH)/kubectl
MICROMAMBA_VERSION ?= v1.5.1-1
MICROMAMBA := $(MLIB_TOOLS_HOME)/micromamba-$(MICROMAMBA_VERSION)
MICROMAMBA_URL := https://github.com/mamba-org/micromamba-releases/releases/download/$(patsubst v%,%,$(MICROMAMBA_VERSION))/micromamba-$(if ifeq($(HOST_OS),darwin),osx,$(HOST_OS))-$(if ifeq($(HOST_OS),darwin),64,$(HOST_ARCH))
HELM_VERSION ?= v3.13.1
HELM := $(MLIB_TOOLS_HOME)/helm-$(HELM_VERSION)
HELM_URL := https://get.helm.sh/helm-$(HELM_VERSION)-$(HOST_OS)-$(HOST_ARCH).tar.gz 
JQ_VERSION ?= 1.7
JQ := $(MLIB_TOOLS_HOME)/jq-$(JQ_VERSION)
JQ_URL := https://github.com/jqlang/jq/releases/download/jq-$(JQ_VERSION)/jq-$(if ifeq($(HOST_OS),darwin),macos,$(HOST_OS))-$(HOST_ARCH)
TOMLJSON_VERSION ?= 2.1.0
TOMLJSON := $(MLIB_TOOLS_HOME)/tomljson-$(TOMLJSON_VERSION)
$(TOMLJSON):
	@$(INFO) installing tomljson $(HOSTOS)-$(HOSTARCH)
	@mkdir -p $(MLIB_TOOLS_HOME)/tmp-tomljson
	@curl -fsSL https://github.com/pelletier/go-toml/releases/download/v$(TOMLJSON_VERSION)/tomljson_$(HOSTOS)_$(HOSTARCH).tar.xz | tar -xJ -C $(MLIB_TOOLS_HOME)/tmp-tomljson || $(FAIL)
	@mv $(MLIB_TOOLS_HOME)/tmp-tomljson/tomljson $@
	@rm -fr $(MLIB_TOOLS_HOME)/tmp-tomljson
	@$(OK) installed tomljson $(HOSTOS)-$(HOSTARCH)
YQ_VERSION ?= v4.35.2
YQ := $(MLIB_TOOLS_HOME)/yq-$(YQ_VERSION)
YQ_URL := https://github.com/mikefarah/yq/releases/download/$(YQ_VERSION)/yq_$(HOSTOS)_$(HOSTARCH).tar.gz 
$(YQ):
	@$(INFO) installing yq $(HOSTOS)-$(HOSTARCH)
	@mkdir -p $(MLIB_TOOLS_HOME)/tmp-yq
	@curl -fsSL https://github.com/mikefarah/yq/releases/download/$(YQ_VERSION)/yq_$(HOSTOS)_$(HOSTARCH).tar.gz | tar -xz -C $(MLIB_TOOLS_HOME)/tmp-yq
	@mv $(MLIB_TOOLS_HOME)/tmp-yq/yq_$(HOSTOS)_$(HOSTARCH) $(YQ)
	@rm -fr $(MLIB_TOOLS_HOME)/tmp-yq
	@$(OK) installed yq $(HOSTOS)-$(HOSTARCH)
GOMPLATE_VERSION := 3.11.5
GOMPLATE := $(MLIB_TOOLS_HOME)/gomplate-$(GOMPLATE_VERSION)
GOMPLATE_URL := https://github.com/hairyhenderson/gomplate/releases/download/v$(GOMPLATE_VERSION)/gomplate_$(HOSTOS)-$(HOSTARCH) 
CF_VERSION ?= v8.7.4
CF := $(MLIB_TOOLS_HOME)/cf-$(CF_VERSION)
$(CF):
	@$(INFO) installing cf $(HOSTOS)-$(HOSTARCH)
	@mkdir -p $(MLIB_TOOLS_HOME)/tmp-cf
	@$(WARN) downloading linux64 version, valid for macOS and linux
	@curl -LsSL "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=$(CF_VERSION)&source=github" | tar -xz -C $(MLIB_TOOLS_HOME)/tmp-cf
	@mv $(shell readlink -f $(MLIB_TOOLS_HOME)/tmp-cf/cf) $@
	@rm -fr $(MLIB_TOOLS_HOME)/tmp-cf
	@$(OK) installed cf $(HOSTOS)-$(HOSTARCH)
MLR_VERSION ?= v6.9.0
MLR := $(MLIB_TOOLS_HOME)/mlr-$(MLR_VERSION)
MLR_URL := https://github.com/johnkerl/miller/releases/download/$(MLR_VERSION)/miller-$(patsubst v%,%,$(MLR_VERSION))-$(HOST_OS)-$(HOST_ARCH).tar.gz
HUGO_VERSION ?= v0.120.0
HUGO := $(MLIB_TOOLS_HOME)/hugo-$(HUGO_VERSION)
HUGO_URL := https://github.com/gohugoio/hugo/releases/download/$(HUGO_VERSION)/hugo_$(HUGO_VERSION)-$(if ifeq($(HOST_OS),darwin),universal,$(HOST_ARCH)).tar.gz
BATS_VERSION := v1.10.0
BATS = $(MLIB_TOOLS_HOME)/bats-$(BATS_VERSION)
BATS_URL := https://github.com/bats-core/bats-core/archive/refs/tags/$(BATS_VERSION).tar.gz
BATS_LIB_PATH ?= $(MLIB_LIB_HOME)/bats
BATS_SUPPORT_VERSION := v0.3.0
BATS_FILE_VERSION := v0.4.0
BATS_ASSERT_VERSION := v2.1.0
BATS_LIBS := bats-support bats-file bats-assert
BATS_LIBS := $(addprefix $(BATS_LIB_PATH)/,$(BATS_LIBS))
$(BATS): _TOOL_ARCHIVE=bats-$(notdir $(BATS_URL))
BATS_OPTS += $(if $(V), -x ) ##co Bats Options
BATS_ENV += BATS_LIB_PATH="$(BATS_LIB_PATH)"
BATS_CMD = $(BATS_ENV) $(BATS) $(BATS_OPTS)
TOOLS = BATS GOMPLATE HELM HUGO ISTIO JQ KIND K8SEC KUBECTL MICROMAMBA MLR
_TOOL_ARCHIVE ?=
define _set_tool_var
.SECONDEXPANSION:
$$($(1)): TOOL_URL=$$($(1)_URL)
$$($(1)): TOOL_VERSION=$$($(1)_VERSION)
endef
_TOOLS = $(foreach t,$(TOOLS),$($(t)))
$(foreach tool,$(TOOLS),$(eval $(call _set_tool_var,$(tool))))
ifdef CI
$(_TOOLS): MLIB_CACHE_HOME=$(XDG_CACHE_HOME)
endif
$(_TOOLS): 
	@$(INFO) "Install $(@F)"
	@mkdir -p "$(@D)"
	@archive_name=$(or $(_TOOL_ARCHIVE),$(notdir $(TOOL_URL))) && \
		curl --create-dirs -fsSLo "$(MLIB_TOOLS_SRC_HOME)/mlib/$${archive_name}" $(TOOL_URL) || $(FAIL)
	@archive_name=$(or $(_TOOL_ARCHIVE),$(notdir $(TOOL_URL))) && \
		cmd_name=$(patsubst %-$(TOOL_VERSION),%,$(@F)) && \
		case "$${archive_name}" in \
				bats-*.tar.gz) \
					mkdir -p $(MLIB_DATA_HOME)/bats && \
					tar -C $(MLIB_DATA_HOME)/bats -xzf "$(MLIB_TOOLS_SRC_HOME)/mlib/$${archive_name}" && \
					ln -nfs $(MLIB_DATA_HOME)/bats/bats-core-$(patsubst v%,%,$(TOOL_VERSION))/bin/bats $@ && \
					$(STATUS_OK) || $(STATUS_KO) ;; \
				*.tar.gz) \
					tar -C '$(MLIB_TOOLS_SRC_HOME)/mlib/' -xzf "$(MLIB_TOOLS_SRC_HOME)/mlib/$${archive_name}" && \
					cmd_path=$$(find $(MLIB_TOOLS_SRC_HOME)/mlib/ -iname $${cmd_name}) && \
					install -m 755 "$${cmd_path}" $@ && ${STATUS_OK} || $(FAIL) ;; \
				*.zip) \
					echo "Handling .zip file";; \
				*) \
					install -m 755 '$(MLIB_TOOLS_SRC_HOME)/mlib/$(notdir $(TOOL_URL))' $@ && ${STATUS_OK} || $(FAIL);; \
		esac
tools.buildvars: ; @:
build.vars: tools.buildvars
.PHONY: clean distclean
clean: ##ct Remove files created during build.
	@rm -fr $(MLIB_OUTPUT_HOME) 
distclean: clean  ##ct Remove files created during build including cached tools.
	@rm -fr $(MLIB_CACHE_HOME) $(MLIB_TOOLS_HOME) $(MLIB_WORK_HOME)
DOC_BUILD_SYSTEM ?= sphinx # Defines the documentation build system (*default to sphinx*)
docs.publish:
init: ; @: ##pr Init a new project
.PHONY: promote.init promote.artifacts promote
promote.init: ; @:
promote.artifacts: ; @:
promote:
	@$(MAKE) promote.init
	@$(MAKE) promote.artifacts
release.tag:
ifneq ($(VERSION_VALID),true)
	$(error invalid version $(VERSION). must be a semantic version with v[Major].[Minor].[Patch] only)
endif
	@$(INFO) tagging commit hash $(GIT_COMMIT_HASH) with v$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)
	@git tag -f -m "Release $(VERSION)" v$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) $(GIT_COMMIT_HASH) >/dev/null && ${STATUS_OK} || ${FAIL}
	@_RELEASE_BRANCH="release-$(VERSION_MAJOR).$(VERSION_MINOR)" && \
		if [[ -z "$$(git branch --list $${_RELEASE_BRANCH})" ]];  \
		then \
		$(INFO) Creating branch $${_RELEASE_BRANCH} && \
		git branch $${_RELEASE_BRANCH} && ${STATUS_OK} || ${FAIL}; fi && \
		git branch -f $${_RELEASE_BRANCH} ${GIT_COMMIT_HASH} && \
		$(INFO) Push to to ${GIT_BRANCH_NAME} && \
		git push --quiet $(GIT_REMOTE_NAME) v$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH) && ${STATUS_OK} ||${FAIL} && \
		$(INFO) Push to branch $${_RELEASE_BRANCH} && \
		git push --quiet ${GIT_REMOTE_NAME} $${_RELEASE_BRANCH} > /dev/null && ${STATUS_OK} || ${FAIL}
version.isdirty:
ifeq ($(ALLOW_DIRTY),)
	@if [[ $(VERSION) = *.dirty ]]; then \
		$(ERR) version '$(VERSION)' is dirty aborting publish. The following files changed: ;\
		git status --short;\
		exit 1; \
	fi
endif
.PHONY: publish.init publish.artifacts publish 
publish.init: ; @:
publish.artifacts: ; @:
publish: version.isdirty  ##rt Build and publish final releasable artifacts
	@$(MAKE) publish.init
	@$(MAKE) publish.artifacts
ifdef VENV
PYTHON_PREFIX := $(VENV) ##co Path to Python's venv
else
PYTHON_PREFIX ?= $(MLIB_WORK_HOME)/venv
endif
ifndef GIT_PROJECT_NAME
PYTHON_PROJECT_NAME := $(subst -,_,$(notdir $(MLIB_ROOT_HOME)))
else ifndef PYTHON_PROJECT_NAME
PYTHON_PROJECT_NAME := $(subst -,_,$(GIT_PROJECT_NAME))
endif
PYTHON_PROJECT_NAME := $(subst -,_,$(PYTHON_PROJECT_NAME))
PYTHON_PROJECT_NAME := $(subst .,_,$(PYTHON_PROJECT_NAME))
ifeq ($(origin MICROMAMBA),undefined)
MICROMAMBA := micromamba
endif
PYTHON_PROVIDER ?= system
ifneq ($(filter-out system micromamba,$(PYTHON_PROVIDER)),)
$(error Only system and micromamba python are supported)
endif
export PYTHON_PROVIDER
ifeq ($(PYTHON_PROVIDER),micromamba)
PIP_REQUIRE_VIRTUALENV := false
endif
PYTHON_SRC_PATH ?= src
EXTRA ?=
PYTHON != test -x $(PYTHON_PREFIX)/bin/python && \
	echo $(PYTHON_PREFIX)/bin/python || \
	command -v python
ifeq ($(PYTHON),)
$(error the variable PYTHON is not set. Is python present on the system?)
endif
export PIP_REQUIRE_VIRTUALENV ?= true
export PIP_UPGRADE := false
export PIP_QUIET := 3
PYTHON_LINT_SUITE ?= ruff yamllint
PYTHON_TEST_SUITE ?= coverage
PYTHON_DOC_SUITE ?= sphinx furo
PYTHON_VERSION_PY ?= $(PYTHON_SRC_PATH)/$(PYTHON_PROJECT_NAME)/__version__.py
YAMLLINT_CONFIG_FILE := $(addsuffix /yamllint/config.yml,$(MLIB_CONFIG_HOME))
define DEFAULT_YAMLLINT_CONF
---
extends: default
\nignore:
  - mlib
  - wt
endef
export DEFAULT_YAMLLINT_CONF
define PYPROJECT
[build-system]
requires = ["flit_core >=3.2,<4"]
build-backend = "flit_core.buildapi"
\n[project]
name = "$(PYTHON_PROJECT_NAME)"
authors = [
    { name = "$(GIT_CONFIG_USER_NAME)" },
    {email = "$(GIT_CONFIG_USER_EMAIL)" }
]
dynamic = ["version"]
dependencies = []
description = ""
\n[project.optional-dependencies]
	doc = ["sphinx", "sphinx-pyproject", "$(SPHINX_DOC_THEME)", "sphinx-autobuild"]
	test = ["coverage[toml]>=7", "pytest>=7"]
	fmt = ["black"]
	lint = ["ruff", "yamllint"]
\n[tool.black]
line-length = 80
include = '\.py$$'
target-version = ["py39", "py310", "py311"]
skip-string-normalization = true
\n[tool.coverage.run]
command_line = "-m pytest --junitxml=report.xml"
source = [
  "$(PYTHON_SRC_PATH)"
]
disable_warnings = [ "no-data-collected" ]
\n[tool.coverage.report]
exclude_lines = [
	"if TYPE_CHECKING:",
	"pragma: no cover"
]
omit = ["$(PYTHON_VERSION_PY)"]
\n[tool.mypy]
mypy_path = "stubs"
files = "$(PYTHON_SRC_PATH)"
pretty = true
show_column_numbers = true
show_error_codes = true
warn_return_any = true
\n[tool.ruff]
cache-dir = "$(MLIB_CACHE_HOME)/ruff"
\n[tool.pytest.ini_options]
addopts = [ 
    "--ignore=setup.py",
    "--strict-markers",
    "--strict-config",
    "-ra"
]
filterwarnings = [
  "ignore:the imp module is deprecated"
]
markers = [
  "e2e: tests that require an external connection",
]
testpaths = [
  "$(TEST_SRC_HOME)",
]
cache_dir = ".cache/pytest"
endef
export PYPROJECT
pyproject.toml:
	@$(INFO) Creating $(call _colorize,$@)
	@$(shell printf "$${PYPROJECT}" > $@) ${STATUS_OK}
define _template_lang_steps
python.$(1).init python.$(1).run python.$(1).done:
python.$(1).init: pyproject.toml
$(1).init: python.$(1).init
$(1).run: python.$(1).run
$(1).done: python.$(1).done
endef
$(foreach verb,e2e fmt lint test,$(eval $(call _template_lang_steps,$(verb))))
define _pip_cmd
@$(INFO) Install $(call _colorize,$(2)) with pip
@$(PYTHON_PREFIX)/bin/python -m pip install $(if $(1),-U ,)"$(subst >,\>,$(subst <,\<,$(2)))" && ${STATUS_OK} || ${FAIL}
endef
define _flit_cmd 
@$(INFO) Install $(call _colorize,$(PYTHON_PROJECT_NAME)$(if $(1),"[$(1)]",)) with flit
@msg=$$($(PYTHON_PREFIX)/bin/python -m flit install -s $(if $(1),--extras "$(1)",) 2>&1) && ${STATUS_OK} || (echo "$${msg}" && ${FAIL})
endef
.PHONY: _get_python_prefix
_get_python_prefix:
	@printf "%q" `$(PYTHON_PREFIX)/bin/python -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])'`
ifeq ($(PYTHON_PROVIDER), micromamba)
$(PYTHON_PREFIX)/bin/python: $(MICROMAMBA)
endif 
$(PYTHON_PREFIX)/bin/python: 
	@echo ${_TIME} ${_BLUE}[ ⛵ ]${_CNONE_BOLD} Init project $(PYTHON_PROJECT_NAME) $*${_CNone}
	@$(INFO) Creating env from $(PYTHON_PROVIDER) in $(subst $(MLIB_ROOT_HOME),\$$\(pwd\),$(PYTHON_PREFIX))
ifeq ($(PYTHON_PROVIDER),micromamba)
	@$(MICROMAMBA) create -y --root-prefix $(MLIB_WORK_HOME) --prefix $(PYTHON_PREFIX) python && $(STATUS_OK) || $(FAIL)
else
	@$(PYTHON) -m venv $(PYTHON_PREFIX) && ${STATUS_OK} || ${FAIL}
endif
	@$(call _pip_cmd,-U,pip) 
	@$(call _pip_cmd,-U,"flit>=3.9") 
	@$(call _pip_cmd,-U,build)
	@$(call _flit_cmd,all) 
$(PYTHON_PREFIX)/bin/%: | $(PYTHON_PREFIX)/bin/python
	@$(call _pip_cmd,-U,$*) 
_PYTHON_BINS := BLACK COVERAGE MYPY PYLINT PYTEST TWINE RUFF SPHINX-AUTOBUILD SPHINX-BUILD YAMLLINT
$(foreach bin,$(_PYTHON_BINS),$(eval $(subst -,_,$(bin)) := $(PYTHON_PREFIX)/bin/$(bin)))
requirements.txt: pyproject.toml
	@$(INFO) Writing $@
	@$(PYTHON_PREFIX)/bin/python -m pip freeze > $@ && ${STATUS_OK} || ${FAIL}
.NOTINTERMEDIATE:
$(MLIB_CACHE_HOME)/python/$(notdir $(PYTHON_PREFIX))/%.cache: pyproject.toml
	@mkdir -p $(@D)
	@echo ${_TIME} ${_BLUE}[ ⛺ ]${_CNONE_BOLD} Init $*${_CNone}
	@$(call _flit_cmd,$*) 
	@touch $@
python.%.init: init $(MLIB_CACHE_HOME)/python/$(notdir $(PYTHON_PREFIX))/%.cache | $(PYTHON_PREFIX)/bin/python ; @:
python.%.run: mess
python.fmt.run: $(RUFF) $(BLACK) # make sure they are installed in not present in pyproject.toml
	@$(INFO) Fix code with ruff
	@$(RUFF) check --select I --fixable I --fix $(PYTHON_SRC_PATH) && $(STATUS_OK) || $(FAIL)
	@$(INFO) Formating code with black
	@$(BLACK) -q $(PYTHON_SRC_PATH) && $(STATUS_OK) || $(FAIL)
python.lint.run.pylint: $(PYLINT)
	@$(INFO) Running $(@F)
	@$(PYLINT) --exit-zero $(PYTHON_SRC_PATH) && ${STATUS_OK} || ${FAIL}
.PHONY: python.lint.init.ruff python.lint.run.ruff
python.lint.init.ruff: ; @:
python.lint.run.ruff: $(RUFF)
	@$(INFO) Running $(@F)
	@$(PYTHON_PREFIX)/bin/ruff check $(PYTHON_SRC_PATH) $(TEST_SRC_HOME) && ${STATUS_OK} || ${FAIL}
$(YAMLLINT_CONFIG_FILE):
	@$(INFO) Writing default yamllint configuration in $(@D)
	@mkdir -p $(@D)
	@$(shell echo -e "$${DEFAULT_YAMLLINT_CONF}" > $@) ${STATUS_OK}
.PHONY: python.lint.init.yamllint python.lint.run.yamllint
python.lint.init.yamllint: $(YAMLLINT_CONFIG_FILE)
python.lint.run.yamllint: $(YAMLLINT) 
	@$(INFO) Running $(@F)
	@YAMLLINT_CONFIG_FILE=$(YAMLLINT_CONFIG_FILE) $(YAMLLINT) $(MLIB_ROOT_HOME) 
python.lint.init: $(addprefix python.lint.init.,$(PYTHON_LINT_SUITE))
python.lint.run: $(addprefix python.lint.run.,$(PYTHON_LINT_SUITE))
python.test.init: $(PYTEST) $(COVERAGE)
ifneq ($(filter mypy, $(PYTHON_TEST_SUITE)),)
python.test.mypy.run:
	@$(INFO) Running mypy
	@$(MYPY)
python.test.run: python.test.mypy.run
endif
ifneq ($(filter coverage, $(PYTHON_TEST_SUITE)),)
python.test.coverage.run:
	@$(INFO) Running pytest with coverage report
	@$(COVERAGE) run -m pytest -m "not e2e" --junitxml=report.xml \
		|| ([ $$? = 5 ] && exit 0 || exit $$?)
python.test.coverage.done:
	@$(INFO) Coverage report:
	$(COVERAGE) report -m
python.test.run: python.test.coverage.run
python.test.done: python.test.coverage.done
else
python.test.pytest.run:
	@$(INFO) Running pytest
	@$(PYTEST) -m "not e2e" \
		|| ([ $$? = 5 ] && exit 0 || exit $$?)
python.test.run: python.test.pytest.run
endif
python.e2e.init: $(PYTEST)
python.e2e.pytest.run:
	@$(INFO) Running e2e test with pytest
	$(PYTEST) -m "e2e" || ([ $$? = 5 ] && exit 0 || exit $$?)
python.e2e.run: python.e2e.pytest.run
PYTHON_BUILD_SDIST := True
python.build.code: $(PYTHON_VERSION_PY)
	@$(INFO) Building wheel 
	@$(PYTHON_PREFIX)/bin/python -m build \
		-w \
		$(if $(PYTHON_BUILD_SDIST), -s,) \
		--outdir $(MLIB_OUTPUT_HOME) 
build.code: python.build.code
python.publish.init: $(TWINE)
python.publish.artifacts:
	@$(INFO) Uploading artifacts
	@$(TWINE) upload --skip-existing --verbose dist/*$(VERSION)*
publish.init: python.publish.init
publish.artifacts: python.publish.artifacts
SPHINX_DOC_THEME ?= furo# sphinx theme, default to [furo](https://github.com/pradyunsg/furo)
SPHINX_LINKCHECK_ENABLE ?= 1# set to check links
SPHINX_LINKCHECK_HOME ?= $(MLIB_OUTPUT_HOME)/linkcheck# path to linkcheck output
SPHINX_AUTBUILD_ENABLE ?=
SPHINX_AUTOBUILD_OPTS += --watch $(PYTHON_SRC_PATH)
SPHINX_DOC_OPTS += -b html 
SPHINX_DOC_EXTS ?= intersphinx autodoc
$(SPHINX_BUILD): $(PYTHON_PREFIX)/bin/sphinx 
	@ln -nfs $@ $<
$(DOC_SRC_HOME)/conf.py: $(SPHINX_BUILD)
	@$(INFO) Creating sphinx configuration in $(@D)
	@$(PYTHON_PREFIX)/bin/sphinx-quickstart \
		-p "$(GIT_PROJECT_NAME)" \
		-a "$(GIT_CONFIG_USER_NAME)" \
		--no-sep \
		--no-batchfile \
		--ext-intersphinx \
		--ext-autodoc \
		--no-makefile \
		-q $(@D) >/dev/null || $(FAIL)
	@rmdir $(@D)/_build 2>/dev/null 
	@${STATUS_OK} 
sphinx.doc.init: | $(DOC_SRC_HOME)/conf.py
ifdef SPHINX_AUTBUILD_ENABLE
sphinx.doc.init: $(SPHINX_AUTOBUILD)
else
sphinx.doc.init: $(SPHINX_BUILD)
endif
sphinx.doc.run:
	@$(INFO) Building doc with sphinx
ifdef SPHINX_AUTBUILD_ENABLE
	@$(SPHINX_AUTOBUILD) $(SPHINX_AUTOBUILD_OPTS) "$(DOC_SRC_HOME)" "$(MLIB_OUTPUT_HOME)/doc" 
else
	@$(SPHINX_BUILD) $(SPHINX_DOC_OPTS) "$(DOC_SRC_HOME)" "$(MLIB_OUTPUT_HOME)/doc" 
endif
sphinx.doc.watch:
	@$(INFO) Building doc with sphinx
	@$(SPHINX_AUTOBUILD) $(SPHINX_AUTOBUILD_OPTS) "$(DOC_SRC_HOME)" "$(MLIB_OUTPUT_HOME)/doc" 
ifdef SPHINX_LINKCHECK_ENABLE
sphinx.doc.done: $(JQ) $(MLR)
	@$(INFO) Checking links with sphinx
	@mkdir -p "$(strip $(SPHINX_LINKCHECK_HOME))"
	@$(SPHINX_BUILD) -b linkcheck "$(DOC_SRC_HOME)" "$(SPHINX_LINKCHECK_HOME)" 2>&1>/dev/null && ${STATUS_OK} || ( ${STATUS_KO}; \
		$(JQ) -r '. | select(.status == "broken") | {file: .filename, lineno: .lineno, uri: .uri}' $(SPHINX_LINKCHECK_HOME)/output.json | $(MLR) --ijson --opprint --barred cat \
		)
endif
ifeq ($(DOC_BUILD_SYSTEM),sphinx)
doc.%: sphinx.doc.%
endif
.PHONY: python.watermark
python.watermark:
	@$(PYTHON) -c "import platform; print(f'Python implementation: {platform.python_implementation()}\nPython version: {platform.python_version()}')"
info.watermark: python.watermark
python.buildvars:
	@echo PYTHON=$(shell which $(PYTHON))
	@echo PYTHON_PREFIX=$(PYTHON_PREFIX)
	@echo PIP_REQUIRE_VIRTUALENV=$(PIP_REQUIRE_VIRTUALENV)
	@echo PYTHON_SRC_PATH=$(PYTHON_SRC_PATH)
	@echo PYTHON_PROJECT_NAME=$(PYTHON_PROJECT_NAME)
build.vars: python.buildvars
python.clean:
	@-$(RM) -r {**/,}__pycache__
clean: python.clean
distclean.python:
	@rm -Rf \
		build \
		dist \
		{**/,}*.egg-info \
		"$(PYTHON_PREFIX)" \
		.coverage \
		.mypy_cache
distclean: distclean.python
define PYTHON_HELPTEXT
Python Targets:
    init         create a vitualenv in $$(PYTHON_PREFIX), default $$(MLIB_WORK_HOME)/venv
endef
export PYTHON_HELPTEXT
python.help:
	@echo "$$PYTHON_HELPTEXT"
help-special: python.help
python.init: pyproject.toml $(PYTHON_SRC_PATH)/$(PYTHON_PROJECT_NAME)/__init__.py $(PYTHON_VERSION_PY) | $(PYTHON_PREFIX)/bin/python  # python.venv ##pr create a vitualenv in $$(PYTHON_PREFIX), default $$(MLIB_WORK_HOME)/venv
	@mkdir -p $(PYTHON_SRC_PATH) $(TEST_SRC_HOME) $(DOC_SRC_HOME)
$(PYTHON_SRC_PATH)/$(PYTHON_PROJECT_NAME)/__init__.py:
	@mkdir -p $(@D)
	@touch $@ || ${FAIL}
.PHONY: $(PYTHON_VERSION_PY)
$(PYTHON_VERSION_PY):
	@mkdir -p $(@D)
	@$(file >$@,__version__ = "$(if $(VERSION),$(VERSION),0.0.0)")
init: python.init 
