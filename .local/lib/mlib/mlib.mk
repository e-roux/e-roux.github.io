# SPDX-FileCopyrightText: 2021-present Emmanuel Roux
# SPDX-FileCopyrightText: 2016-2021 The Upbound Authors
# SPDX-License-Identifier: Apache-2.0
__VERSION__ := 0.2.0+pre.53.52637a9.dirty
SHELL := /bin/bash
PWD = $(shell pwd)
THIS := $(lastword $(MAKEFILE_LIST))
THIS_DIR = $(PWD)
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
CI ?= 
GIT_COMMIT_HASH ?=
ALLOW_DIRTY ?=
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
XDG_STATE_HOME ?= $(HOME)/.local/state
XDG_CACHE_HOME ?= $(HOME)/.cache
export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_STATE_HOME XDG_DATA_HOME
ifndef CI_PROJECT_DIR
MLIB_ROOT_HOME != (git rev-parse --absolute-git-dir 2>/dev/null || pwd) | head -1 | sed -e 's@/\.git.*@@'
else
MLIB_ROOT_HOME := $(CI_PROJECT_DIR)
endif
MLIB_CONFIG_HOME = $(PWD)/.config
MLIB_DATA_HOME ?= $(MLIB_ROOT_HOME)/.local/share
MLIB_CACHE_HOME ?= $(MLIB_ROOT_HOME)/.cache
MLIB_STATE_HOME ?= $(MLIB_ROOT_HOME)/.local/state
MLIB_PROJECT_HOME = $(patsubst %/,%,$(realpath $(PWD)))
MLIB_LIB_HOME ?= $(MLIB_ROOT_HOME)/.local/lib
MLIB_OUTPUT_HOME ?= $(MLIB_PROJECT_HOME)/build
MLIB_WORK_HOME ?= $(MLIB_DATA_HOME)/mlib
MLIB_TOOLS_HOME := $(MLIB_ROOT_HOME)/.local/bin
TEST_SRC_HOME := $(MLIB_PROJECT_HOME)/test
DOC_SRC_HOME := $(MLIB_PROJECT_HOME)/doc
$(TEST_SRC_HOME) $(DOC_SRC_HOME): ; @mkdir -p $@
SED_CMD?=sed -i -e
COMMA := ,
SPACE :=
SPACE +=
MLIB_BASE_VERBS := fmt lint test e2e doc 
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
uc = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$1))))))))))))))))))))))))))
stem = $(basename $(notdir $(1)))
rel_path = $(patsubst $(MLIB_ROOT_HOME)/%,%,$(1))
normalize-bool = $(and $(filter $(strip $1),True true yes 1 TRUE YES),true)
define _create_new_hook
.PHONY: $(1) $(1).init $(1).run $(1).done $(1).watch
$(1).init:$(if $(2),; @$(2),)
$(1).run:$(if $(2),; @$(2),)
$(1).done:$(if $(2),; @$(2),)
$(1).watch:
$(1):
	@$$(MAKE) $(1).init
	@$$(MAKE) $(1).run
	@$$(MAKE) $(1).done
endef
define create_new_hook
$(eval $(call _create_new_hook,$(1),$(2)))
endef
define _bind_ns_stage_to_parent
.PHONY: $(1).$(2)
$(1).$(2):
$(2): $(1).$(2)
endef
define bind_ns_stage_to_parent
$(eval $(call _bind_ns_stage_to_parent,$(1),$(2)))
endef
define _register_ns
.PHONY: $(1).$(2)
$(call _bind_ns_stage_to_parent,$(1),$(2).init)
$(call _bind_ns_stage_to_parent,$(1),$(2).run)
$(call _bind_ns_stage_to_parent,$(1),$(2).done)
endef
define register_ns
$(eval $(call _register_ns,$(1),$(2)))
endef
define register_mlib_namespace
$(foreach verb,doc e2e fmt lint test,$(call register_ns,$(1),$(verb)))
$(foreach stage,init check code done,$(call bind_ns_stage_to_parent,$(1),build.$(stage)))
$(foreach stage,clean distclean sync,$(call bind_ns_stage_to_parent,$(1),$(stage)))
endef
define assert_equals
[[ "$1" == "$2" ]] && ${STATUS_OK} \
	|| ( ${STATUS_KO} && $(ERR) Got "$1", want "$2" >&3 && exit 1)
endef
define assert_file_exists
[[ -f "$1" ]] && ${STATUS_OK} || \
	( ${STATUS_KO} && $(ERR) "$1" does not exists >&3 && exit 1)
endef
NO_AUTOLOAD_DOC :=
_IS_PYTHON_PROJECT := $(wildcard pyproject.toml)
_IS_GOLANG_PROJECT := $(wildcard go.mod)
_IS_NODEJS_PROJECT := $(wildcard package.json)
_IS_SPHINX_CONFIGURED := $(wildcard $(DOC_SRC_HOME)/conf.py)
_IS_MKDOCS_CONFIGURED := $(wildcard $(DOC_SRC_HOME)/mkdocs.yml)
_IS_HUGO_CONFIGURED := $(wildcard $(DOC_SRC_HOME)/config.toml)
 
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
CLEAR_PREVLINE = printf "\e[1A\e[2K"
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
 
_SUPPORTED_PLAFORMS := darwin_amd64 darwin_arm64 linux_amd64 linux_arm64
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
_IS_HOST_PLATFORM_SUPPORTED := $(filter $(_SUPPORTED_PLAFORMS),$(HOST_PLATFORM))
ifeq ($(flavor BUILD_PLATFORMS),undefined)
ifdef BUILD_PLATFORMS
_IS_HOST_PLATFORM_IN_BUILD := $(filter $(BUILD_PLATFORMS),$(HOST_PLATFORM))
ifdef _IS_HOST_PLATFORM_SUPPORTED 
ifndef _IS_HOST_PLATFORM_IN_BUILD 
BUILD_PLATFORMS += $(HOST_PLATFORM)
endif
endif
else
BUILD_PLATFORMS = $(PLATFORM)
endif
endif
endif
export BUILD_PLATFORMS
OS := $(word 1, $(subst _, ,$(PLATFORM)))
ARCH := $(word 2, $(subst _, ,$(PLATFORM)))
ifeq ($(HOST_OS),darwin)
NPROCS != sysctl -n hw.ncpu
else
NPROCS != nproc
endif
HOSTNAME != hostname
WHOAMI != whoami
HOSTARCH := $(HOST_ARCH)
HOSTOS := $(HOST_OS)
 
CURL ?= curl
ifeq ($(HOST_OS),darwin)
FIND != command -v gfind 2>/dev/null
SED != command -v gsed 2>/dev/null
GREP != command -v ggrep 2>/dev/null
XARGS != command -v gxargs 2>/dev/null
else
FIND != command -v find 2>/dev/null
SED != command -v sed 2>/dev/null
GREP != command -v grep 2>/dev/null
XARGS != command -v xargs 2>/dev/null
endif
ifndef FIND
$(error GNU find was not find on this system, on mac OS install with `brew`)
endif
MLIB_TOOLSSRC_HOME := $(if $(CI),$(MLIB_CACHE_HOME),$(XDG_CACHE_HOME))/mlib
$(MLIB_TOOLSSRC_HOME):
	@mkdir -p $@
ARCADE_VERSION ?= 0.10.20
ARCADE := $(MLIB_TOOLS_HOME)/arcade-$(ARCADE_VERSION)
ARCADE_URL := https://github.com/alexellis/arkade/releases/download/$(ARCADE_VERSION)/arkade-$(HOST_OS)$(if $(and $(filter darwin,$(HOST_OS)), $(filter amd64,$(HOST_ARCH))),,-$(HOST_ARCH))
ISTIO_VERSION ?= 1.19.3
ISTIO := $(MLIB_TOOLS_HOME)/istioctl-$(ISTIO_VERSION)
ISTIO_URL := https://github.com/istio/istio/releases/download/$(ISTIO_VERSION)/istio-$(ISTIO_VERSION)-$(if ifeq($(HOST_OS),darwin),osx,$(HOST_OvS)-$(HOST_ARCH)).tar.gz
K8SEC_VERSION ?= v0.8.0
K8SEC := $(MLIB_TOOLS_HOME)/k8sec-$(K8SEC_VERSION)
K8SEC_URL := https://github.com/dtan4/k8sec/releases/download/$(K8SEC_VERSION)/k8sec_$(HOST_OS)_$(if ifeq($(HOST_ARCH), amd64),x86_64,$(HOST_ARCH)).tar.gz
KIND_VERSION ?= v0.21.0
KIND := $(MLIB_TOOLS_HOME)/kind-$(KIND_VERSION)
KIND_URL := https://github.com/kubernetes-sigs/kind/releases/download/$(KIND_VERSION)/kind-$(HOST_OS)-$(HOST_ARCH)
KUBECTL_VERSION ?= v1.29.2
KUBECTL := $(MLIB_TOOLS_HOME)/kubectl-$(KUBECTL_VERSION)
KUBECTL_URL := https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/$(HOST_OS)/$(HOST_ARCH)/kubectl
MICROMAMBA_VERSION ?= v1.5.1-1
MICROMAMBA := $(MLIB_TOOLS_HOME)/micromamba-$(MICROMAMBA_VERSION)
MICROMAMBA_URL := https://github.com/mamba-org/micromamba-releases/releases/download/$(patsubst v%,%,$(MICROMAMBA_VERSION))/micromamba-$(if ifeq($(HOST_OS),darwin),osx,$(HOST_OS))-$(if ifeq($(HOST_OS),darwin),64,$(HOST_ARCH))
GLAB_VERSION ?= 1.36.0
GLAB := $(MLIB_TOOLS_HOME)/glab-$(GLAB_VERSION)
GLAB_URL := https://gitlab.com/gitlab-org/cli/-/releases/v$(GLAB_VERSION)/downloads/glab_$(GLAB_VERSION)_$(if ifeq($(HOST_OS),darwin),macOS,$(HOST_OS:linux%=Linux%))_$(HOST_ARCH:amd%=x86_%).tar.gz
HELM_VERSION ?= v3.14.0
HELM := $(MLIB_TOOLS_HOME)/helm-$(HELM_VERSION)
HELM_URL := https://get.helm.sh/helm-$(HELM_VERSION)-$(HOST_OS)-$(HOST_ARCH).tar.gz 
JQ_VERSION ?= 1.7.1
JQ := $(MLIB_TOOLS_HOME)/jq-$(JQ_VERSION)
JQ_URL := https://github.com/jqlang/jq/releases/download/jq-$(JQ_VERSION)/jq-$(HOST_OS:darwin=macos)-$(HOST_ARCH)
DASEL_VERSION ?= v2.6.0
DASEL := $(MLIB_TOOLS_HOME)/dasel-$(DASEL_VERSION)
DASEL_URL := https://github.com/TomWright/dasel/releases/download/$(DASEL_VERSION)/dasel_$(HOST_OS)_$(HOST_ARCH).gz
export RYE_HOME := $(MLIB_CACHE_HOME)/rye
RYE_VERSION ?= 0.28.0
export RYE_NO_AUTO_INSTALL := 1
export RYE_TOOLCHAIN_VERSION := cpython@3.11
export RYE_INSTALL_OPTION := --yes
RYE = $(MLIB_TOOLS_HOME)/rye-$(RYE_VERSION)
ifeq ($(RYE_VERSION),latest)
RYE_URL = https://github.com/mitsuhiko/rye/releases/latest/download/rye-$(patsubst arm64,aarch64,$(HOST_ARCH:amd64%=x86_64%))-$(HOST_OS:darwin%=macos%).gz
else
RYE_URL = https://github.com/mitsuhiko/rye/releases/download/$(RYE_VERSION)/rye-$(patsubst arm64,aarch64,$(HOST_ARCH:amd64%=x86_64%))-$(HOST_OS:darwin%=macos%).gz
endif
RYE_ARCHIVE := $(MLIB_TOOLSSRC_HOME)/$(call stem,$(RYE_URL))-$(RYE_VERSION).gz
ifeq ($(RYE_VERSION),latest)
.PHONY: $(RYE_ARCHIVE)
endif
$(RYE_ARCHIVE):
	@$(INFO) "Downloading rye $(RYE_VERSION)"
	@$(CURL) --create-dirs --disable -fsSL -o $@ $(RYE_URL) && $(STATUS_OK) && $(STATUS_OK) || $(STATUS_KO)
$(RYE_HOME):
	@mkdir -p $@
ifndef CI1
$(XDG_CACHE_HOME)/rye/py: ; @mkdir -p $@
$(RYE_HOME)/py: $(XDG_CACHE_HOME)/rye/py
	@mkdir -p $(@D)
	@ln -nfs $< $@
$(RYE): $(RYE_HOME)/py 
endif
$(RYE): $(RYE_ARCHIVE) | $(RYE_HOME)
	@$(INFO) "Extracting $(notdir $<)"
	@mkdir -p $(@D)
	@gunzip -c $< > $@ && $(STATUS_OK) || $(FAIL)
	@chmod +x $@
	@$(RYE) config --set-bool behavior.global-python=true
	@$(RYE) config --set-bool behavior.use-uv=$(PYTHON_USE_UV)
	@$(RYE) config --set default.requires-python=">=3.10"
	@$(RYE) config --set default.toolchain="cpython@3.11.8"
TOMLJSON_VERSION ?= 2.1.0
TOMLJSON := $(MLIB_TOOLS_HOME)/tomljson-$(TOMLJSON_VERSION)
$(TOMLJSON):
	@$(INFO) installing tomljson $(HOST_OS)-$(HOST_ARCH)
	@mkdir -p $(MLIB_TOOLS_HOME)/tmp-tomljson
	@curl -fsSL https://github.com/pelletier/go-toml/releases/download/v$(TOMLJSON_VERSION)/tomljson_$(HOST_OS)_$(HOST_ARCH).tar.xz | tar -xJ -C $(MLIB_TOOLS_HOME)/tmp-tomljson || $(FAIL)
	@mv $(MLIB_TOOLS_HOME)/tmp-tomljson/tomljson $@
	@rm -fr $(MLIB_TOOLS_HOME)/tmp-tomljson
	@$(OK) installed tomljson $(HOST_OS)-$(HOST_ARCH)
YQ_VERSION ?= v4.35.2
YQ := $(MLIB_TOOLS_HOME)/yq-$(YQ_VERSION)
YQ_URL := https://github.com/mikefarah/yq/releases/download/$(YQ_VERSION)/yq_$(HOST_OS)_$(HOST_ARCH).tar.gz 
$(YQ):
	@$(INFO) installing yq $(HOST_OS)-$(HOST_ARCH)
	@mkdir -p $(MLIB_TOOLS_HOME)/tmp-yq
	@curl -fsSL https://github.com/mikefarah/yq/releases/download/$(YQ_VERSION)/yq_$(HOST_OS)_$(HOST_ARCH).tar.gz | tar -xz -C $(MLIB_TOOLS_HOME)/tmp-yq
	@mv $(MLIB_TOOLS_HOME)/tmp-yq/yq_$(HOST_OS)_$(HOST_ARCH) $(YQ)
	@rm -fr $(MLIB_TOOLS_HOME)/tmp-yq
	@$(OK) installed yq $(HOST_OS)-$(HOST_ARCH)
GOMPLATE_VERSION := 3.11.5
GOMPLATE := $(MLIB_TOOLS_HOME)/gomplate-$(GOMPLATE_VERSION)
GOMPLATE_URL := https://github.com/hairyhenderson/gomplate/releases/download/v$(GOMPLATE_VERSION)/gomplate_$(HOST_OS)-$(HOST_ARCH) 
CF_VERSION ?= v8.7.4
CF := $(MLIB_TOOLS_HOME)/cf-$(CF_VERSION)
$(CF):
	@$(INFO) installing cf $(HOST_OS)-$(HOST_ARCH)
	@mkdir -p $(MLIB_TOOLS_HOME)/tmp-cf
	@$(WARN) downloading linux64 version, valid for macOS and linux
	@curl -LsSL "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=$(CF_VERSION)&source=github" | tar -xz -C $(MLIB_TOOLS_HOME)/tmp-cf
	@mv $(shell readlink -f $(MLIB_TOOLS_HOME)/tmp-cf/cf) $@
	@rm -fr $(MLIB_TOOLS_HOME)/tmp-cf
	@$(OK) installed cf $(HOST_OS)-$(HOST_ARCH)
MLR_VERSION ?= v6.9.0
MLR := $(MLIB_TOOLS_HOME)/mlr-$(MLR_VERSION)
MLR_URL := https://github.com/johnkerl/miller/releases/download/$(MLR_VERSION)/miller-$(patsubst v%,%,$(MLR_VERSION))-$(HOST_OS)-$(HOST_ARCH).tar.gz
HUGO_VERSION ?= 0.122.0
HUGO := $(MLIB_TOOLS_HOME)/hugo-$(HUGO_VERSION)
HUGO_URL := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_$(HUGO_VERSION)_$(HOST_OS)-$(if ifeq($(HOST_OS),darwin),universal,$(HOST_ARCH)).tar.gz
BATS_VERSION := v1.10.0
BATS = $(MLIB_TOOLS_HOME)/bats-$(BATS_VERSION)
BATS_URL := https://github.com/bats-core/bats-core/archive/refs/tags/$(BATS_VERSION).tar.gz
BATS_LIB_PATH ?= $(MLIB_LIB_HOME)/bats
BATS_SUPPORT_VERSION := v0.3.0
BATS_FILE_VERSION := v0.4.0
BATS_ASSERT_VERSION := v2.1.0
BATS_LIBS := bats-support bats-file bats-assert
BATS_LIBS := $(addprefix $(MLIB_LIB_HOME)/bats/,$(BATS_LIBS))
$(BATS_LIBS): _LIB_VERSION=$($(subst -,_,$(call uc,$(@F)))_VERSION)
$(BATS_LIBS): _LIB=https://github.com/bats-core/$(@F)/archive/refs/tags/$(_LIB_VERSION).zip
$(BATS_LIBS): 
	@$(INFO) Installing bats library $(@F)
	@$(CURL) --create-dirs --disable -fsSLo $(MLIB_CACHE_HOME)/bats/$(@F).zip $(_LIB) && $(STATUS_OK) || $(FAIL)
	@mkdir -p $(@D)
	@unzip -qo $(MLIB_CACHE_HOME)/bats/$(@F).zip -d $(@D) || $(FAIL)
	@ln -nfs $@-$(_LIB_VERSION:v%=%) $@
$(BATS): | $(BATS_LIBS)
BATS_OPTS += $(if $(V), -x ) ##co Bats Options
BATS_ENV += BATS_LIB_PATH="$(BATS_LIB_PATH)"
BATS_CMD = $(BATS_ENV) $(BATS) $(BATS_OPTS)
GOIMPORTS_VERSION ?= 0.1.12
GOIMPORTS := $(MLIB_TOOLS_HOME)/goimports-$(GOIMPORTS_VERSION)
GOJUNIT_VERSION ?= v2@latest
GOJUNIT = $(MLIB_TOOLS_HOME)/go-junit-report
GOLANGCILINT_VERSION ?= 1.54.2
GOLANGCILINT = $(MLIB_TOOLS_HOME)/golangci-lint-v$(GOLANGCILINT_VERSION)
$(GOLANGCILINT):
	@$(INFO) Installing $(@F) in \$$MLIB_TOOLS_HOME
	@mkdir -p $(MLIB_CACHE_HOME)/tmp-golangci-lint || $(FAIL)
	@curl -fsSL https://github.com/golangci/golangci-lint/releases/download/v$(GOLANGCILINT_VERSION)/golangci-lint-$(GOLANGCILINT_VERSION)-$(HOSTOS)-$(HOSTARCH).tar.gz | tar -xz --strip-components=1 -C $(MLIB_CACHE_HOME)/tmp-golangci-lint || $(FAIL)
	@mkdir -p $(@D) || $(FAIL)
	@mv $(MLIB_CACHE_HOME)/tmp-golangci-lint/golangci-lint $@ || $(FAIL)
	@rm -fr $(MLIB_CACHE_HOME)/tmp-golangci-lint && $(STATUS_OK) || $(FAIL)
$(GOJUNIT):
	@$(INFO) Installing $(@F) in \$$MLIB_TOOLS_HOME
	@mkdir -p $(MLIB_CACHE_HOME)/tmp-$(@F) || $(FAIL)
	@GOBIN=$(MLIB_CACHE_HOME)/tmp-$(@F) $(GOHOST) install github.com/jstemmer/go-junit-report/$(GOJUNIT_VERSION) || $(FAIL)
	@mkdir -p $(@D) || $(FAIL)
	@mv $(MLIB_CACHE_HOME)/tmp-$(@F)/$(@F) $@ || $(FAIL)
	@rm -fr $(MLIB_CACHE_HOME)/tmp-$(@F) && $(STATUS_OK) || $(FAIL)
$(GOIMPORTS):
	@$(INFO) Installing $(@F) in \$$MLIB_TOOLS_HOME
	@GOBIN=$(MLIB_CACHE_HOME)/tmp-$(@F) $(GOHOST) install golang.org/x/tools/cmd/goimports@v$(GOIMPORTS_VERSION) || $(FAIL)
	@mkdir -p $(@D) || $(FAIL)
	@mv $(MLIB_CACHE_HOME)/tmp-$(@F)/$(subst -$(GOIMPORTS_VERSION),,$(@F)) $@ || $(FAIL)
	@rm -fr $(MLIB_CACHE_HOME)/tmp-$(@F) && $(STATUS_OK) || $(FAIL)
TOOLS = ARCADE BATS DASEL GLAB GOMPLATE HELM HUGO ISTIO JQ KIND K8SEC KUBECTL MICROMAMBA MLR 
define _set_tool_var
.SECONDEXPANSION:
$$($(1)): TOOL_URL=$$($(1)_URL)
$$($(1)): TOOL_VERSION=$$($(1)_VERSION)
$$($(1)): | $$(MLIB_TOOLSSRC_HOME)/$$(notdir $$($(1)_URL))
$$($(1)): ARCHIVE_NAME?=$$(MLIB_TOOLSSRC_HOME)/$$(notdir $$($(1)_URL))
$$(MLIB_TOOLSSRC_HOME)/$$(notdir $$($(1)_URL)): | $$(MLIB_TOOLSSRC_HOME)
	@$(INFO) "Downloading $$(notdir $$($(1)_URL))"
	@$$(CURL) --create-dirs --disable -fsSLo $$@ $$(TOOL_URL) && $$(STATUS_OK) || $$(FAIL)
endef
_TOOLS = $(foreach t,$(TOOLS),$($(t)))
$(foreach tool,$(TOOLS),$(eval $(call _set_tool_var,$(tool))))
ifdef CI
$(_TOOLS): MLIB_CACHE_HOME=$(XDG_CACHE_HOME)
endif
$(_TOOLS): 
	@$(INFO) "Install $(@F)" on $(HOST_OS), $(HOST_ARCH) 
	@mkdir -p "$(@D)"
	@cmd_name=$(patsubst %-$(TOOL_VERSION),%,$(@F)) && \
		case "$(@F)" in \
			bats-$(TOOL_VERSION)) \
				mkdir -p $(MLIB_DATA_HOME)/bats && \
				tar -C $(MLIB_DATA_HOME)/bats -xzf "$(ARCHIVE_NAME)" && \
				ln -nfs $(MLIB_DATA_HOME)/bats/bats-core-$(patsubst v%,%,$(TOOL_VERSION))/bin/bats $@ && \
				$(STATUS_OK) || $(STATUS_KO) ;; \
			*) \
				case "$(ARCHIVE_NAME)" in \
					*.tar.gz) \
						tar -C $(MLIB_TOOLSSRC_HOME) -xzf "$(ARCHIVE_NAME)" && \
						cmd_path=$$($(FIND) $(MLIB_TOOLSSRC_HOME) -iname $${cmd_name}) && \
						install -m 755 "$${cmd_path}" $@ && ${STATUS_OK} || $(FAIL) ;; \
					*.zip) \
						echo "Handling .zip file";; \
					*.gz) \
						gunzip -c "$(ARCHIVE_NAME)" > $(MLIB_TOOLSSRC_HOME)/$(call stem,$(ARCHIVE_NAME)) && \
						cmd_path=$$($(FIND) $(MLIB_TOOLSSRC_HOME) -iname "$${cmd_name}*" -cnewer "$(ARCHIVE_NAME)") && \
						install -m 755 "$${cmd_path}" $@ && ${STATUS_OK} || $(FAIL) ;; \
					*) \
						install -m 755 '$(MLIB_TOOLSSRC_HOME)/$(notdir $(TOOL_URL))' $@ && ${STATUS_OK} || $(FAIL);; \
				esac;; \
		esac
$(MLIB_TOOLS_HOME)/% $(patsubst $(PWD)/%,%,$(MLIB_TOOLS_HOME))/%: $(ARCADE) 
	@$(INFO) Installing $(notdir $@) with arcade
	@mkdir -p $(XDG_CACHE_HOME)/mlib
	@$(ARCADE) get --quiet --progress --path $(XDG_CACHE_HOME)/mlib $(notdir $@) && \
		( $(CLEAR_PREVLINE); $(STATUS_OK) ) || ( $(CLEAR_PREVLINE); $(STATUS_KO) )
tools.buildvars: ; @:
build.vars: tools.buildvars
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
GIT_PROJECT_REPO != echo $(GIT_REMOTE_URL) | sed -E \
				-e 's%(https?://|ssh://git@)%%'  \
				-e 's%^[0-9A-Za-z\-\_\.\:]*@/(.*)%\1%' \
				-e 's%\:[0-9]*/%/%' \
				 | sed -Ee "s%\.git$$%%"
GIT_PROJECT_NAMESPACE != echo $(GIT_PROJECT_REPO) | xargs dirname | \
				sed -Ee 's%^[0-9A-Za-z\-\_\.]*/(.*)%\1%' 2>/dev/null 
else
GIT_PROJECT_NAME ?= $(shell echo $(call lc,$(notdir $(MLIB_ROOT_HOME))) | tr "-" "_")
GIT_PROJECT_NAMESPACE ?= 
GIT_REMOTE_HOST ?= 
GIT_PROJECT_REPO ?=
GIT_REMOTE_PORT ?=
GIT_PROJECT_NAME_SPACE ?=
endif
GIT_CONFIG_USER_NAME := $(shell git config --get user.name)
GIT_CONFIG_USER_EMAIL := $(shell git config --get user.email)
GITIGNORE := $(MLIB_ROOT_HOME)/.gitignore
$(GITIGNORE):
	@$(INFO) Writing default gitignore
	@echo -e "## Ignore files\n$(MLIB_CACHE_HOME:$(MLIB_ROOT_HOME)/%=%)/*\n" > $@ && $(STATUS_OK) || $(STATUS_KO)
	
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
 
common.buildvars:
	@echo GIT_PROJECT_NAME=$(GIT_PROJECT_NAME)
	@echo GIT_PROJECT_NAMESPACE=$(GIT_PROJECT_NAMESPACE)
	@echo GIT_PROJECT_REPO=$(GIT_PROJECT_REPO)
	@echo GIT_REMOTE_HOST=$(GIT_REMOTE_HOST)
	@echo BUILD_HOST=$(HOSTNAME)
	@echo MLIB_OUTPUT_HOME=$(MLIB_OUTPUT_HOME)
	@echo MLIB_CONFIG_HOME=$(MLIB_CONFIG_HOME)
	@echo MLIB_DATA_HOME=$(MLIB_DATA_HOME)
	@echo MLIB_PROJECT_HOME=$(MLIB_PROJECT_HOME)
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
DOCKER ?= docker
PODMAN ?= podman
IMAGE_CONTAINER_ENGINE ?= $(PODMAN)
CONTAINER_IMAGES_RUNTIME ?= $(IMAGE_CONTAINER_ENGINE)
CONTAINER_IMAGES_BUILDER ?= $(IMAGE_CONTAINER_ENGINE)
REGISTRY_HOST ?= 
REGISTRY_PORT ?= 
REGISTRY_NAMESPACE ?=
REGISTRY_URL = $(REGISTRY_HOST)$(if $(REGISTRY_PORT),:$(REGISTRY_PORT),)$(if $(REGISTRY_NAMESPACE),/$(REGISTRY_NAMESPACE),)
CONTAINER_IMAGE_NAME ?= $(GIT_PROJECT_NAME)
CONTAINER_IMAGE_TAG ?= $(VERSION)__$(OS)_$(ARCH)
REGISTRY_IMAGE = $(REGISTRY_URL)
REGISTRY_IMAGE_TAG = $(REGISTRY_IMAGE):$(CONTAINER_IMAGE_TAG)
REGISTRY_IMAGE_LATEST_TAG = $(REGISTRY_IMAGE):latest
.PHONY: img.build build.artifacts img.build.check _img_no_build_info _img_build_intro img.build.$(CONTAINER_IMAGES_BUILDER)
img.build.init:
	@$(INFO) Building $(CONTAINER_IMAGE_NAME) using $(CONTAINER_IMAGES_BUILDER)
img.build.check:
	@$(if $(CONTAINER_IMAGE_NAME),,$(ERR) No IMAGE_NAME defined)
	@$(if $(CONTAINER_IMAGE_NAME),,exit 1)
img.build.check.platform:
img.build.code.platform:
img.build.artifacts:
img.build.artifacts.platform:
img.build.done:
_img_no_build_info:
	@$(INFO) $(CONTAINER_IMAGE_NAME) already built. Force build with IMAGE_TRIGGER_BUILD=1
img.build: _img_build_intro
img.build.artifacts: img.build.$(CONTAINER_IMAGES_BUILDER) 
ifdef IMAGE_TRIGGER_BUILD
$(foreach stage,init check code done,$(call bind_ns_stage_to_parent,img,build.$(stage)))
endif
_IS_IMAGE_CONTAINER_ENGINE_ON_SYSTEM = $(shell command -v $(IMAGE_CONTAINER_ENGINE))
.PHONY: img.registry.login img.push img.push.%
img.registry.login:
ifneq ($(filter-out img.%,$(MAKECMDGOALS)),$(MAKECMDGOALS))
	@$(_IS_IMAGE_CONTAINER_ENGINE_ON_SYSTEM) && \
		$(ERROR) $(IMAGE_CONTAINER_ENGINE) is not installed on your system
	@$(INFO) Logging to container registry
	@$(INFO) "... $(REGISTRY_HOST)"
	@$(if $(REGISTRY_HOST),,$(ERR) No REGISTRY_HOST defined)
	@$(if $(REGISTRY_HOST),,exit 1)
	@$(IMAGE_CONTAINER_ENGINE) login \
		$(if $(REGISTRY_USERNAME), -u $(REGISTRY_USERNAME),) \
		$(if $(REGISTRY_PASSWORD), -p $(REGISTRY_PASSWORD),) \
		$(REGISTRY_HOST) >/dev/null && \
		$(INFO) "Login successful to registry" || \
		$(ERR) "Could not login to registry"
endif
img.push: img.build.check img.registry.login
	@$(_IS_IMAGE_CONTAINER_ENGINE_ON_SYSTEM) && \
		$(ERROR) $(IMAGE_CONTAINER_ENGINE) is not installed on your system
	@$(INFO) "Pushing image to $(REGISTRY_HOST)"
ifeq ($(IMAGE_CONTAINER_ENGINE),podman)
	@$(IMAGE_CONTAINER_ENGINE) push \
	     $(CONTAINER_IMAGE_NAME)$(if $(CONTAINER_IMAGE_TAG),:$(CONTAINER_IMAGE_TAG),) \
	     $(REGISTRY_URL)/$(CONTAINER_IMAGE_NAME)$(if $(CONTAINER_IMAGE_TAG),:$(CONTAINER_IMAGE_TAG),)
ifdef TAG_LATEST
	@$(IMAGE_CONTAINER_ENGINE) push \
	     $(CONTAINER_IMAGE_NAME)$(if $(CONTAINER_IMAGE_TAG),:$(CONTAINER_IMAGE_TAG),) \
		 $(REGISTRY_URL)/$(CONTAINER_IMAGE_NAME):latest
endif
else
	@$(WARNING) The container engine $(IMAGE_CONTAINER_ENGINE) is not currently supported for push.
endif
publish.init: img.registry.login
publish.artifacts: img.push
img.push.%: img.push; @
PYTHON_PREFIX := $(MLIB_PROJECT_HOME)/.venv
PYTHON_PROJECT_NAME ?= $(shell $(RYE) project name 2>/dev/null)
ifndef GIT_PROJECT_NAME
PYTHON_PROJECT_NAME := $(subst -,_,$(notdir $(MLIB_ROOT_HOME)))
else ifndef PYTHON_PROJECT_NAME
PYTHON_PROJECT_NAME := $(subst -,_,$(GIT_PROJECT_NAME))
endif
PYTHON_PROJECT_NAME := $(subst -,_,$(PYTHON_PROJECT_NAME))
PYTHON_PROJECT_NAME := $(subst .,_,$(PYTHON_PROJECT_NAME))
_IS_PYTHON_VIRTUALPROJECT ?= 
PYTHON_PROVIDER ?= rye
PYTHON_TOOLCHAIN_VERSION ?= 3.11
PYTHON_SRC_HOME ?= src
export PYTHON_PROVIDER_INSTALLOPTS ?=
PYTHON_TYPE_CHECKER := false
PYTHON_USE_UV ?= true
ifneq ($(filter-out rye system micromamba,$(strip $(PYTHON_PROVIDER))),)
$(error Only system and micromamba python are supported)
endif
PYTHON := $(PYTHON_PREFIX)/bin/python
ifeq ($(PYTHON),)
$(error the variable PYTHON is not set. Is python present on the system?)
endif
PYTHON_VERSION_PY ?= $(PYTHON_SRC_HOME)/$(PYTHON_PROJECT_NAME)/__version__.py
ifdef _IS_PYTHON_PROJECT
$(call register_mlib_namespace,python)
endif
define _pip_cmd
@$(INFO) Install $(call _colorize,$(2)) with pip
@$(PYTHON_PREFIX)/bin/python -m pip install $(if $(1),-U ,)"$(subst >,\>,$(subst <,\<,$(2)))" && ${STATUS_OK} || ${FAIL}
endef
define _flit_cmd 
@$(INFO) Install $(call _colorize,$(PYTHON_PROJECT_NAME)$(if $(1),"[$(1)]",)) with flit
@msg=$$($(PYTHON_PREFIX)/bin/python -m flit install -s $(if $(_IS_PYTHON_VIRTUALPROJECT),--only-deps,) $(if $(1),--extras "$(1)",) 2>&1) && ${STATUS_OK} || (echo "$${msg}" && ${FAIL})
endef
$(PYTHON): | $(RYE)
ifeq ($(strip $(PYTHON_PROVIDER)), micromamba)
$(PYTHON): | $(MICROMAMBA)
endif
$(PYTHON): 
	@echo ${_TIME} ${_BLUE}[ ⛵ ]${_CNONE_BOLD} Init project $(PYTHON_PROJECT_NAME) $*${_CNone}
	@$(INFO) Python provided by $(strip $(PYTHON_PROVIDER)) in $(dir $(@D))
ifeq ($(strip $(PYTHON_PROVIDER)),micromamba)
	@$(MICROMAMBA) create -y --root-prefix $(MLIB_WORK_HOME) --prefix $(PYTHON_PREFIX) $${PYTHON_PROVIDER_INSTALLOPTS:-python} && $(STATUS_OK) || $(FAIL)
else ifeq ($(strip $(PYTHON_PROVIDER)),rye)
	@$(RYE) sync
else
	@$(PYTHON) -m venv $(PYTHON_PREFIX) && ${STATUS_OK} || ${FAIL}
	@$(call _pip_cmd,-U,pip) 
	@$(call _pip_cmd,-U,"flit>=3.9") 
	@$(call _pip_cmd,-U,build)
	@$(call _flit_cmd,all) 
endif
_PYTHON_BINS := COVERAGE MYPY PYRIGHT PYTEST TWINE RUFF SPHINX-AUTOBUILD YAMLLINT MKDOCS
ifdef _IS_PYTHON_PROJECT
$(foreach bin,$(_PYTHON_BINS),$(eval $(subst -,_,$(bin)) := $(PYTHON_PREFIX)/bin/$(call lc,$(bin))))
SPHINX_BUILD := $(PYTHON_PREFIX)/bin/sphinx-build
else
$(foreach bin,$(_PYTHON_BINS),$(eval $(subst -,_,$(bin)) := $(RYE_HOME)/tools/$(call lc,$(bin))/bin/$(call lc,$(bin))))
SPHINX_BUILD := $(RYE_HOME)/tools/sphinx/bin/sphinx-build
endif
SPHINX_QUICKSTART := $(patsubst %-build,%-quickstart,$(SPHINX_BUILD))
$(SPHINX_QUICKSTART): .EXTRA_PREREQS = $(SPHINX_BUILD); @:
ifeq ($(strip $(PYTHON_PROVIDER)),rye)
$(PYTHON_PREFIX)/bin/%: | $(PYTHON) $(DASEL)
	@$(DASEL) -f pyproject.toml .tool.rye.dev-dependencies 2> /dev/null | $(GREP) ${*:%sphinx-build=%sphinx} > /dev/null || \
		($(INFO) Add $(@F) as dev feature && $(RYE) add --quiet --dev ${*:%sphinx-build=%sphinx} && \
		$(RYE) sync --all-features --quiet && $(STATUS_OK) || $(STATUS_KO))
$(RYE_HOME)/tools/%: | $(RYE)
	@$(INFO) Install $(@F) as tool
	@case "$(@F)" in \
		mkdocs) \
		 	$(SED) -e 's/^/--extra-requirement /' $(DOC_SRC_HOME)/requirements.txt | $(XARGS) $(RYE) tools install mkdocs --force --quiet  && $(STATUS_OK) || $(STATUS_KO);; \
		sphinx*) \
			$(GREP)	-e sphinx-autobuild $(DOC_SRC_HOME)/requirements.txt > /dev/null || echo "sphinx-autobuild" >> $(DOC_SRC_HOME)/requirements.txt; \
		 	$(SED) -e 's/^/--extra-requirement /' $(DOC_SRC_HOME)/requirements.txt | $(XARGS) $(RYE) tools install sphinx --force --quiet  && $(STATUS_OK) || $(STATUS_KO);; \
		*) \
			$(RYE) tools install --force --quiet $(@F) && $(STATUS_OK) || $(STATUS_KO);; \
	esac
endif
requirements.txt: 
	@$(INFO) Writing $@
	@$(PYTHON_PREFIX)/bin/python -m pip freeze > $@ && ${STATUS_OK} || ${FAIL}
$(PYTHON_SRC_HOME): ; @mkdir -p $@
.python-version:
	@echo $(PYTHON_TOOLCHAIN_VERSION) >| $@
pyproject.toml: | $(RYE)
	@$(INFO) Creating $(call _colorize,$@)
	@$(RYE) fetch $(RYE_TOOLCHAIN_VERSION)
	@$(RYE) init --quiet . > /dev/null && $(STATUS_OK) || $(FAIL)
python.init: .python-version
python.init: | pyproject.toml 
ifndef _IS_PYTHON_PROJECT
	@$(INFO) Python project initialized with $(PYTHON_TOOLCHAIN_VERSION)
	@echo "|- $(PYTHON_SRC_HOME)/$(PYTHON_PROJECT_NAME)"
	@echo "|- $(TEST_SRC_HOME:$(MLIB_PROJECT_HOME)/%=%)/$(PYTHON_PROJECT_NAME)"
	@echo "|- pyproject.toml"
	@echo "|- .python-version"
else
	@$(INFO) Python project already initialized 
endif
ifdef PYTHON_VERSION_ISDYNAMIC
python.init: $(PYTHON_VERSION_PY)
endif
python.init: | $(PYTHON_SRC_HOME) $(TEST_SRC_HOME) $(DOC_SRC_HOME) $(PYTHON)
$(PYTHON_SRC_HOME)/$(PYTHON_PROJECT_NAME)/__init__.py:
	@mkdir -p $(@D)
	@touch $@ || ${FAIL}
.PHONY: $(PYTHON_VERSION_PY)
$(PYTHON_VERSION_PY):
	@mkdir -p $(@D)
	@$(file >$@,__version__ = "$(if $(VERSION),$(VERSION),0.0.0)")
.PHONY: python.sync
python.sync: | $(RYE)
ifndef _IS_PYTHON_PROJECT
	@$(WARN) Please initialize the project first with 'make python.init'
else
	@$(INFO) Syncronizing dependencies and tools
	@$(RYE) sync --quiet --all-features && $(STATUS_OK) || $(FAIL)
endif
RUFF_CHECK_OPTS := #- --select I --fixable I --fix
RUFF_FORMAT_OPTS := 
python.fmt.init: | $(RUFF) ; @: #- make sure they are installed in not present in pyproject.toml 
python.fmt.run: 
	@$(INFO) Formating code with ruff 'format $(RUFF_FORMAT_OPTS)'
	@$(RUFF) format --config pyproject.toml $(RUFF_FORMAT_OPTS) $(PYTHON_SRC_HOME) 
.PHONY: python.lint.init.ruff python.lint.run.ruff
python.lint.init.ruff: | $(RUFF); @:
python.lint.run.ruff: | $(PYTHON_SRC_HOME)
	@$(INFO) Running ruff
	@$(RUFF) check --config pyproject.toml $(PYTHON_SRC_HOME) $(TEST_SRC_HOME)
python.lint.init: python.lint.init.ruff
python.lint.run: python.lint.run.ruff
PYTEST_OPTS ?= 
ifeq ($(PYTHON_TYPE_CHECKER),true)
python.test.mypy.run: | $(MYPY)
	@$(INFO) Running mypy
	@$(MYPY)
endif
python.test.coverage.init: | $(COVERAGE) $(PYTEST)
python.test.coverage.run:
	@$(INFO) Running pytest with coverage report
	@$(COVERAGE) run -m pytest -m "not e2e" --junitxml=report.xml $(PYTEST_OPTS) \
		|| ([ $$? = 5 ] && exit 0 || exit $$?)
python.test.coverage.done:
	@$(INFO) Coverage report:
	$(COVERAGE) report -m
python.test.pytest.init: | $(PYTEST)
python.test.pytest.run:
	@$(INFO) Running pytest
	@$(PYTEST) -m "not e2e" $(PYTEST_OPTS) \
		|| ([ $$? = 5 ] && exit 0 || exit $$?)
python.test.init: | $(PYTEST) $(COVERAGE)
python.test.run: python.test.coverage.run
python.test.done: python.test.coverage.done
python.e2e.init: | $(PYTEST) $(BATS)
python.e2e.pytest.run:
	@$(INFO) Running e2e test with pytest
	$(PYTEST) -m "e2e" $(PYTEST_OPTS) || ([ $$? = 5 ] && exit 0 || exit $$?)
python.e2e.run: python.e2e.pytest.run
PYTHON_BUILD_SDIST ?= True
$(MLIB_OUTPUT_HOME)/pkg:
	@mkdir -p $@
ifndef _IS_PYTHON_VIRTUALPROJECT
python.build.code: $(PYTHON_VERSION_PY) | $(PYTHON_PREFIX)/bin/python
python.build.code: | $(MLIB_OUTPUT_HOME)/pkg 
	@$(INFO) Building wheel 
	@$(PYTHON_PREFIX)/bin/python -m build \
		-w \
		$(if $(PYTHON_BUILD_SDIST), -s,) \
		--outdir $(MLIB_OUTPUT_HOME)/pkg
endif
python.publish.init: | $(TWINE)
python.publish.artifacts:
	@$(INFO) Uploading artifacts
	@$(TWINE) upload --skip-existing --verbose dist/*$(VERSION)*
ifdef _IS_PYTHON_PROJECT
python.buildvars:
	@echo PYTHON=$(shell which $(PYTHON))
	@echo PYTHON_PREFIX=$(PYTHON_PREFIX)
	@echo PYTHON_SRC_HOME=$(PYTHON_SRC_HOME)
	@echo PYTHON_PROJECT_NAME=$(PYTHON_PROJECT_NAME)
build.vars: python.buildvars
endif
python.clean:
	@-$(RM) -r {**/,}__pycache__
python.distclean:
	@rm -Rf \
		build \
		dist \
		{**/,}*.egg-info \
		"$(PYTHON_PREFIX)" \
		.coverage \
		.mypy_cache
ifdef _IS_PYTHON_PROJECT
define PYTHON_HELPTEXT
Python Targets:
    init         create a vitualenv in $$(PYTHON_PREFIX), default $$(MLIB_WORK_HOME)/venv
export PYTHON_HELPTEXT
python.help:
	@echo "$$PYTHON_HELPTEXT"
endef
endif
 
doc: ##ct Build project documentation.
fmt: ##cs Checks source code for formatting issues.
test: ##ct Runs unit tests.
e2e: ##ct Runs end-to-end integration tests.
lint: ##cs Run lint and code analysis tools.
$(foreach verb,doc e2e fmt lint test,$(eval $(call create_new_hook,$(verb),:)))
 
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
	@$(INFO) Building platform $*
	@$(MAKE) build.code.platform PLATFORM=$* 
do.build.platform: $(foreach p,$(BUILD_PLATFORMS), do.build.platform.$(p))
do.build.artifacts.%:
	@$(MAKE) build.artifacts.platform PLATFORM=$*
do.build.artifacts: $(foreach p,$(BUILD_PLATFORMS), do.build.artifacts.$(p))
build: ##ct Build source code and other artifacts for host platform.
	@$(MAKE) build.init
	@$(MAKE) build.check
	@$(MAKE) build.code
ifneq ($(words $(BUILD_PLATFORMS)),1)
	@$(MAKE) do.build.platform
endif
ifdef IMAGENAME# Only if image.mk seems to be loaded 
	@$(MAKE) build.artifacts
	@$(MAKE) do.build.artifacts
endif
	@$(MAKE) build.done
.PHONY: clean distclean
clean: ##ct Remove files created during build.
	@$(INFO) Removing output directory $(call rel_path,$(MLIB_OUTPUT_HOME))
	@rm -fr $(MLIB_OUTPUT_HOME) && $(STATUS_OK) || $(STATUS_KO)
distclean: clean ##ct Remove files created during build including cached
	@$(INFO) Removing cache
	@rm -fr $(MLIB_CACHE_HOME) && $(STATUS_OK) || $(STATUS_KO)
	@$(INFO) Removing tools
	@rm -fr $(MLIB_TOOLS_HOME) && $(STATUS_OK) || $(STATUS_KO)
	@$(INFO) Removing working directory
	@rm -fr $(MLIB_WORK_HOME) && $(STATUS_OK) || $(STATUS_KO)
ifndef _IS_PYTHON_PROJECT
$(DOC_SRC_HOME)/requirements.txt: 
	@mkdir -p $(@D)
	@touch $@
SPHINX_AUTOBUILD := $(RYE_HOME)/tools/sphinx/bin/sphinx-autobuild
$(SPHINX_BUILD) $(SPHINX_AUTOBUILD) $(MKDOCS): $(DOC_SRC_HOME)/requirements.txt 
endif
SPHINX_CONF_PY := $(DOC_SRC_HOME)/conf.py
$(SPHINX_CONF_PY): | $(SPHINX_BUILD)
	@$(INFO) Creating sphinx configuration in $(call rel_path,$(@D))
	@$(SPHINX_QUICKSTART) \
		-p "$(GIT_PROJECT_NAME)" \
		-a "$(GIT_CONFIG_USER_NAME)" \
		--no-sep \
		--no-batchfile \
		--ext-intersphinx \
		--ext-autodoc \
		--no-makefile \
		-q $(@D) >/dev/null || $(FAIL)
	@${STATUS_OK} 
.PHONY: sphinx.init mkdocs.init
sphinx.init: | $(SPHINX_CONF_PY); @:
ifdef _IS_SPHINX_CONFIGURED
SPHINX_LINKCHECK_ENABLE ?=# set to check links
SPHINX_LINKCHECK_HOME ?= $(MLIB_OUTPUT_HOME)/linkcheck# path to linkcheck output
SPHINX_AUTOBUILD_OPTS += --watch $(PYTHON_SRC_HOME)# sphinx_autobuild options passed to the cli
SPHINX_DOC_OPTS += -b html# sphinx_build options passed to the cli 
.PHONY: sphinx.run sphinx.done sphinx.watch
sphinx.watch: | $(SPHINX_AUTOBUILD)
	@$(INFO) Building doc with sphinx 
	@$(SPHINX_AUTOBUILD) $(SPHINX_AUTOBUILD_OPTS) "$(DOC_SRC_HOME)" "$(MLIB_OUTPUT_HOME)/doc" 
sphinx.run:
	@$(INFO) Building doc with sphinx
	@$(SPHINX_BUILD) $(SPHINX_DOC_OPTS) "$(DOC_SRC_HOME)" "$(MLIB_OUTPUT_HOME)/doc" 
ifdef SPHINX_LINKCHECK_ENABLE
sphinx.done: $(JQ) $(MLR)
	@$(INFO) Checking links with sphinx
	@mkdir -p "$(strip $(SPHINX_LINKCHECK_HOME))"
	@$(SPHINX_BUILD) -b linkcheck "$(DOC_SRC_HOME)" "$(SPHINX_LINKCHECK_HOME)" 2>&1>/dev/null && ${STATUS_OK} || ( ${STATUS_KO}; \
		$(JQ) -r '. | select(.status == "broken") | {file: .filename, lineno: .lineno, uri: .uri}' $(SPHINX_LINKCHECK_HOME)/output.json | $(MLR) --ijson --opprint --barred cat \
		)
endif
doc.watch: sphinx.watch
$(foreach step,init run done watch,$(eval doc.$(step): sphinx.$(step)))
endif
MKDOCS_CONF_PY := $(DOC_SRC_HOME)/mkdocs.yml
$(MKDOCS_CONF_PY): | $(MKDOCS)
	@$(INFO) Creating mkdocs configuration in $(call rel_path,$(DOC_SRC_HOME))
	@$(MKDOCS) new -q $(DOC_SRC_HOME) && $(STATUS_OK) || $(STATUS_KO)
mkdocs.init: $(MKDOCS_CONF_PY); @:
docs.publish:
 
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
init: ; @: ##pr Init a new project
YAMLLINT_CONFIG_FILE := $(addsuffix /yamllint/config.yml,$(MLIB_CONFIG_HOME))
define DEFAULT_YAMLLINT_CONF
---
extends: default
\nignore-from-file: .gitignore
endef
export DEFAULT_YAMLLINT_CONF
$(YAMLLINT_CONFIG_FILE):
	@$(INFO) Writing default yamllint configuration 
	@mkdir -p $(@D)
	@echo -e "$${DEFAULT_YAMLLINT_CONF}" > $@  && ${STATUS_OK} || ( $(STATUS_OK) && $(FAIL) )
$(YAMLLINT): | $(YAMLLINT_CONFIG_FILE) $(GITIGNORE)
.PHONY: lint.yaml.init lint.yaml.run lint.yaml.done
lint.yaml.init: | $(YAMLLINT)
lint.yaml.run: 
	@$(INFO) Running yamllint
	@$(YAMLLINT) -c $(YAMLLINT_CONFIG_FILE) . && $(STATUS_OK) || $(STATUS_KO)
lint.yaml.done:
_IS_YAML_LINTED := $(wildcard *.yml *.yaml **/*.yml **/*.yaml)
ifdef _IS_YAML_LINTED
lint.init: lint.yaml.init
lint.run: lint.yaml.run
lint.done: lint.yaml.done
endif
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
sync:##pr Synchronize the projet data and dependencies
 
.PHONY: tag
tag: release.tag ##rt Tag a release
bash.test.init: | $(BATS)
 
JUPYTER_CONFIG_PATH ?= $(MLIB_CONFIG_HOME)/jupyter  
JUPYTER_KERNEL_SPEC := /tmp/_fixme/kernel.json
$(JUPYTER_KERNEL_SPEC):
	@$(INFO) Installing ipykernel
	@$(PYTHON_PREFIX)/bin/python -m ipykernel install \
		--user \
		--name=$(PYTHON_PROJECT_NAME) \
		--env JUPYTER_CONFIG_PATH "$(JUPYTER_CONFIG_PATH)" >/dev/null && \
		${STATUS_OK} || ${FAIL}
$(JUPYTER_CONFIG_PATH)/jupyter_lab_config.py:
	@mkdir -p $@ || ${FAIL}
	@$(INFO) Creating empty juputer lab configuration
	@JUPYTER_CONFIG_DIR=$(@D) \
		jupyter lab \
		--generate-config \
		-y >/dev/null \
		&& ${STATUS_OK} || ${FAIL}
jupyter.init: $(JUPYTER_CONFIG_PATH)/jupyter_lab_config.py $(JUPYTER_KERNEL_SPEC)
MPLCONFIGDIR ?=
MATPLOTLIBRC ?=
MATPLOTLIB_CONFIG_PATH := $(if $(MPLCONFIGDIR),$(MPLCONFIGDIR),$(if $(MATPLOTLIBRC),$(MATPLOTLIBRC:/matplotlibrc=),$(MLIB_CONFIG_HOME)/matplotlib))
MATPLOTLIBRC := $(MATPLOTLIB_CONFIG_PATH)/matplotlibrc
$(MATPLOTLIBRC):
	@mkdir -p $(@D)
	@curl -L https://raw.githubusercontent.com/matplotlib/matplotlib/main/lib/matplotlib/mpl-data/matplotlibrc -o $@
matplotlib.init: $(MATPLOTLIBRC)
DUCKDB_VERSION := 0.10.0
_DUCKDB_REMOTE_SRC := https://github.com/duckdb/duckdb/releases/download/v$(DUCKDB_VERSION)/duckdb_cli-$(if ifeq($(HOST_ARCH), darwin),osx-universal,$(HOST_OS)-$(HOST_ARCH)).zip
DUCKDB := $(MLIB_TOOLS_HOME)/duckdb
$(DUCKDB): 
	@$(INFO) Install duckdb $(DUCKDB_VERSION)
	@mkdir -p $(MLIB_CACHE_HOME)/scm
	@$(CURL) -s -C - -L $(_DUCKDB_REMOTE_SRC) -o ${MLIB_CACHE_HOME}/scm/$(@F).zip
	@mkdir -p $(MLIB_TOOLS_HOME)
	@msg=$$(unzip -d $(@D) ${MLIB_CACHE_HOME}/scm/$(@F).zip 2>&1) && $(STATUS_OK) || $(FAIL)
	@chmod +x $@
CGO_ENABLED := 0 #- https://dave.cheney.net/2016/01/18/cgo-is-not-go
GO111MODULE := on
GOOS := $(OS)
GOARCH := $(ARCH)
export CGO_ENABLED GO111MODULE GOOS GOARCH
GO_PROJECT ?= $(subst -,_,$(GIT_PROJECT_REPO))
GO_SUBDIRS ?= cmd pkg internal
GO_SUBDIRS := $(foreach d,$(GO_SUBDIRS),$(wildcard $(d)))
GO_CMD_PATH := $(sort $(dir $(wildcard cmd/*/*)))
GO_INTEGRATION_TESTS_SUBDIRS ?=
GO_VENDOR_DIR ?= vendor
GO_PKG_DIR ?= $(MLIB_WORK_HOME)/pkg
GO_BUILDFLAGS ?=
GO_LDFLAGS ?=
GO_ASMFLAGS ?=
GO_CGFLAGS ?=
GO_TAGS ?=
GO_TEST_FLAGS ?=
GO_TEST_SUITE ?=
GO_NOCOV ?=
GO_COVER_MODE ?= count
GO_TEST_PARALLEL ?=
ifeq ($(V),1)
GO_LDFLAGS += -v -n
GO_BUILDFLAGS += -x
endif
ifeq ($(DEBUG),0)
GO_LDFLAGS += -s -w
endif
GO_SUPPORTED_VERSIONS ?= 1.20|1.21|1.22
GOHOSTOS := $(HOSTOS)
GOHOSTARCH := $(HOSTARCH)
GO_PACKAGES := $(foreach t,$(GO_SUBDIRS),$(GO_PROJECT)/$(t)/...)
GO_INTEGRATION_TEST_PACKAGES := $(foreach t,$(GO_INTEGRATION_TESTS_SUBDIRS),$(GO_PROJECT)/$(t)/integration)
ifneq ($(GO_TEST_PARALLEL),)
GO_TEST_FLAGS += -p $(GO_TEST_PARALLEL)
endif
ifneq ($(GO_TEST_SUITE),)
GO_TEST_FLAGS += -run '$(GO_TEST_SUITE)'
endif
GO := CGO_ENABLED=$(CGO_ENABLED) go
GOHOST := GOOS=$(GOHOSTOS) GOARCH=$(GOHOSTARCH) $(GO)
GOFMT := gofmt
GO_BIN_DIR = $(abspath $(MLIB_OUTPUT_HOME)/bin)
GO_OUT_DIR = $(GO_BIN_DIR)/$(PLATFORM)
GO_TEST_DIR = $(abspath $(MLIB_OUTPUT_HOME)/tests)
GO_TEST_OUTPUT = $(GO_TEST_DIR)/$(PLATFORM)
GO_LINT_DIR = $(abspath $(MLIB_OUTPUT_HOME)/lint)
GO_LINT_OUTPUT = $(GO_LINT_DIR)/$(PLATFORM)
ifdef CI
GO_LINT_ARGS := --timeout 10m0s --out-format=checkstyle > $(GO_LINT_OUTPUT)/checkstyle.xml
else
GO_LINT_ARGS :=
endif
ifneq ($(GO_PKG_DIR),)
GO_PKG_BASE_DIR := $(abspath $(GO_PKG_DIR)/$(PLATFORM))
GO_PKG_STATIC_FLAGS := -pkgdir $(GO_PKG_BASE_DIR)_static
endif
GO_COMMON_FLAGS = $(GO_BUILDFLAGS) -tags '$(GO_TAGS)'
GO_STATIC_FLAGS = $(GO_COMMON_FLAGS) $(GO_PKG_STATIC_FLAGS) -installsuffix static  -ldflags '$(GO_LDFLAGS)'
GO_GENERATE_FLAGS = $(GO_BUILDFLAGS) -tags 'generate $(GO_TAGS)'
GO_STATIC_PACKAGES ?= 
go.mod:
	@$(GO) mod init $(GO_PROJECT)
go.init: go.mod go.vendor.lite 
	@if ! `$(GO) version | grep -q -E '\bgo($(GO_SUPPORTED_VERSIONS))\b'`; then \
		$(ERR) unsupported go version. Please make install one of the following supported version: '$(GO_SUPPORTED_VERSIONS)' ;\
		exit 1 ;\
	fi
ifdef _IS_GOLANG_PROJECT
_CMD_TO_BUILD := $(foreach cmd,$(GO_CMD_PATH),$(MLIB_TOOLS_HOME)/$(notdir $(cmd:/=)))
.SECONDEXPANSION:
$(MLIB_TOOLS_HOME)/%: $$(wildcard cmd/%/*.go) $$(wildcard cmd/%/**/*.go)
	@$(INFO) go build $(_MAGENTA)$(@F)$(_CNone) # $(subst $(MLIB_OUTPUT_HOME)/,'',$@)
	@$(GO) build -o $@ "./cmd/$(subst $(MLIB_TOOLS_HOME)/,,$@)" && $(STATUS_OK) || $(FAIL)
go.build: $(_CMD_TO_BUILD)
go.install:
	@$(INFO) go install $(PLATFORM)
	$(foreach p,$(GO_STATIC_PACKAGES),@$(GO) install -v $(GO_STATIC_FLAGS) $(p) || $(FAIL) ${\n})
	@$(OK) go install $(PLATFORM)
go.test.unit: $(GOJUNIT)
	@$(INFO) go test unit-tests
ifeq ($(GO_NOCOV),true)
	@$(WARN) coverage analysis is disabled
	@$(GOHOST) test $(GO_TEST_FLAGS) $(GO_STATIC_FLAGS) $(GO_PACKAGES) || $(FAIL)
else
	@mkdir -p $(GO_TEST_OUTPUT)
	@$(GOHOST) test -cover $(GO_STATIC_FLAGS) $(GO_PACKAGES) || $(FAIL)
	@$(GOHOST) test -v -covermode=$(GO_COVER_MODE) -coverprofile=$(GO_TEST_OUTPUT)/coverage.txt $(GO_TEST_FLAGS) $(GO_STATIC_FLAGS) $(GO_PACKAGES) 2>&1 | tee $(GO_TEST_OUTPUT)/unit-tests.log || $(FAIL)
	@cat $(GO_TEST_OUTPUT)/unit-tests.log | $(GOJUNIT) -set-exit-code > $(GO_TEST_OUTPUT)/unit-tests.xml || $(FAIL)
endif
	@$(OK) go test unit-tests
go.test.codecov:
	@$(INFO) go test codecov
	@cd $(GO_TEST_OUTPUT) && bash <(curl -s https://codecov.io/bash) || $(FAIL)
	@$(OK) go test codecov
go.test.integration: $(GOJUNIT)
	@$(INFO) go test integration-tests
	@mkdir -p $(GO_TEST_OUTPUT) || $(FAIL)
	@$(GOHOST) test -i $(GO_STATIC_FLAGS) $(GO_INTEGRATION_TEST_PACKAGES) || $(FAIL)
	@$(GOHOST) test $(GO_TEST_FLAGS) $(GO_STATIC_FLAGS) $(GO_INTEGRATION_TEST_PACKAGES) $(TEST_FILTER_PARAM) 2>&1 | tee $(GO_TEST_OUTPUT)/integration-tests.log || $(FAIL)
	@cat $(GO_TEST_OUTPUT)/integration-tests.log | $(GOJUNIT) -set-exit-code > $(GO_TEST_OUTPUT)/integration-tests.xml || $(FAIL)
	@$(OK) go test integration-tests
go.lint: $(GOLANGCILINT)
	@$(INFO) Running $(_MAGENTA)$(<F)$(_CNone)
	@mkdir -p $(GO_LINT_OUTPUT)
	@$(GOLANGCILINT) run $(GO_LINT_ARGS) && $(STATUS_OK) || $(FAIL)
go.vet:
	@$(INFO) Running $(_MAGENTA)go vet $(PLATFORM)$(_CNone)
	@echo $(GO_PACKAGES)
	@$(GOHOST) vet $(GO_COMMON_FLAGS) $(GO_PACKAGES) $(GO_INTEGRATION_TEST_PACKAGES) && $(STATUS_OK) || $(FAIL)
go.fmt.init: 
go.fmt.run: 
	@$(INFO) Running $(_MAGENTA)gofmt$(_CNone)
	@gofmt_out=$$($(GOFMT) -l $(GO_SUBDIRS) $(GO_INTEGRATION_TESTS_SUBDIRS) 2>&1) && ([ -z "$${gofmt_out}" ] && $(STATUS_OK) || ($(STATUS_KO) && printf "Files would be modified by gofmt:\n$${gofmt_out}")) || $(FAIL)
go.fmt.done: 
go.validate: go.vet go.fmt
go.vendor.lite go.vendor.check:
	@$(INFO) Verify dependencies have expected content
	@$(GOHOST) mod verify 1>/dev/null  && $(STATUS_OK) || $(STATUS_KO)
go.vendor.update:
	@$(INFO) Update go modules
	@$(GOHOST) get -u ./... && $(STATUS_OK) || $(STATUS_KO)
go.vendor:
	@$(INFO) go mod vendor
	@$(GOHOST) mod vendor && $(STATUS_OK) || $(STATUS_KO)
go.clean:
	@# `go modules` creates read-only folders under MLIB_WORK_HOME
	@# make all folders within MLIB_WORK_HOME writable, so they can be deleted
	@if [ -d $(MLIB_WORK_HOME) ]; then chmod -R +w $(MLIB_WORK_HOME); fi
	@rm -fr $(GO_BIN_DIR) $(GO_TEST_DIR)
go.distclean:
	@rm -rf $(GO_VENDOR_DIR) $(GO_PKG_DIR)
go.generate:
	@$(INFO) go generate $(PLATFORM)
	@$(GOHOST) generate $(GO_GENERATE_FLAGS) $(GO_PACKAGES) $(GO_INTEGRATION_TEST_PACKAGES) && $(STATUS_OK) || $(STATUS_KO)
.PHONY: go.init go.build go.install go.test.unit go.test.integration go.test.codecov go.lint go.vet go.fmt go.generate
.PHONY: go.validate go.vendor.lite go.vendor go.vendor.check go.vendor.update go.clean go.distclean
.PHONY: go.watermark
go.watermark:
	@$(GO) version
go.buildvars:
	@echo GO_ASMFLAGS=$(GO_ASMFLAGS)
	@echo GO_CGFLAGS=$(GO_CGFLAGS)
	@echo GO_LDFLAGS=$(GO_LDFLAGS)
	@echo GO_PROJECT=$(GO_PROJECT)
	@echo $(shell $(GO) env | tr '\n' '§' | sed 's/.$$//') | tr "§" "\n"
.PHONY: go.imports imports
go.imports.init: $(GOIMPORTS)
go.imports.run: 
	@$(INFO) Running $(_MAGENTA)goimports$(_CNone)
	@goimports_out=$$($(GOIMPORTS) -srcdir $(MLIB_ROOT_HOME) -l $(GO_SUBDIRS) $(GO_INTEGRATION_TESTS_SUBDIRS) 2>&1) && ([ -z "$${goimports_out}" ] && $(STATUS_OK) || ($(STATUS_KO) && printf "Files would be modified by gofmt:\n$${goimports_out}\n" && exit 1)) || $(FAIL)
go.imports.done: 
define _go_help +=
@printf "\033[34;1m%-60s\033[39;49m\n" "$(1)"
@$(call _print_target_help,$(1),$(2))
@echo
endef
endif
PLUGIN_SRC_DIR=$(realpath .) # Should not be changed
NVIM_TEST_INIT=$(MLIB_WORK_HOME)/init.lua
NVIM_TEST_DIR=tests
PACK_PATH=$(MLIB_WORK_HOME)
PLENARY_DIR ?= $(PACK_PATH)/pack/foobar/start/plenary.nvim
PLENARY_OPTIONS ?= PlenaryBustedDirectory ${NVIM_TEST_DIR} { \
			minimal_init = '${NVIM_TEST_INIT}', \
			sequential = true \
			}
$(PLENARY_DIR):
	@$(INFO) Installing plenary
	@git clone --quiet --depth 1 https://github.com/nvim-lua/plenary.nvim $@
.PHONY: nvim.test.init nvim.test.run
PLUGIN_DIRS = lua plugins tests 
$(PLUGIN_DIRS):
	@mkdir -p $@
nvim.init: $(PLUGIN_DIRS)
define INITLUA
local M = {
  MLIB_WORK_HOME = os.getenv('MLIB_WORK_HOME'), -- set in Makefile
}
function M.setup()
  -- Nvim searches for |:runtime| files in:
  -- 	1. all paths in 'runtimepath'
  -- 	2. all "pack/*/start/*" dirs
  vim.cmd([[set runtimepath=$$VIMRUNTIME]])
  vim.opt.runtimepath:append(os.getenv('PLUGIN_SRC_DIR'))
  vim.opt.packpath = { os.getenv('PACK_PATH') }
  -- set XDG variables
  vim.env.XDG_CONFIG_HOME = M.MLIB_WORK_HOME .. '/config'
  vim.env.XDG_DATA_HOME = M.MLIB_WORK_HOME .. '/data'
  vim.env.XDG_STATE_HOME = M.MLIB_WORK_HOME .. '/state'
  vim.env.XDG_CACHE_HOME = M.MLIB_WORK_HOME .. '/cache'
   vim.cmd('runtime plugin/plenary.vim')
end
M.setup()
endef
export INITLUA
$(NVIM_TEST_INIT):
	@mkdir -p $(@D)
	@echo "$${INITLUA}" > $@
nvim.test.init: $(PLENARY_DIR) $(NVIM_TEST_INIT)
nvim.test.run:
	@$(INFO) Running nvim test using plenary
	@PLUGIN_SRC_DIR=$(PLUGIN_SRC_DIR) \
		PLENARY_DIR=$(PLENARY_DIR) \
		MLIB_WORK_HOME=$(MLIB_WORK_HOME) \
		PACK_PATH=$(PACK_PATH) \
		nvim \
		--headless \
		--noplugin \
		-u "${NVIM_TEST_INIT}" \
		-c "$(PLENARY_OPTIONS)"
YARN := yarn
YARN_MODULE_HOME := node_modules
YARN_PACKAGE_FILE := package.json
YARN_PACKAGE_LOCK_FILE := yarn.lock
YARN_DIST_HOME := dist
YARN_SRC_HOME := bundle
YARN_DOC_HOME := doc
YARN_TEST_HOME := test
YARN_OUTDIR ?= $(MLIB_OUTPUT_HOME)/yarn
$(YARN_SRC_HOME)/main.ts:
	@mkdir -p $(@D)
	@touch $@
ESBUILD := ./$(YARN_MODULE_HOME)/.bin/esbuild
$(ESBUILD):
	@$(INFO) Installing $(@F)
	@$(YARN) add  --exact --dev $(@F)
YARN_INSTALL_STAMP := $(YARN_MODULE_HOME)/yarn.install.$(HOST_PLATFORM).stamp
$(YARN_PACKAGE_LOCK_FILE):
	@$(INFO) Generate $@
	@$(YARN) install --mode update-lockfile
$(YARN_INSTALL_STAMP): $(YARN_PACKAGE_FILE) $(YARN_PACKAGE_LOCK_FILE)
	@$(INFO) install deps 
	@$(YARN) --immutable
	@touch $(YARN_INSTALL_STAMP)
.PHONY: yarn.init yarn.init.dev
yarn.init: $(YARN_SRC_HOME)/main.ts $(YARN_INSTALL_STAMP) 
yarn.version:
	@$(YARN) version --no-git-tag-version --new-version $(VERSION)
yarn.build: $(ESBUILD) yarn.init
	@$(INFO) yarn build $(PLATFORM)
	@$(ESBUILD) "./bundle/main.ts" --outfile=www/js/main.js --bundle 
yarn.build.watch:
	$(ESBUILD) "./bundle/main.ts" --watch --outfile=www/js/main.js --bundle --servedir=www
yarn.init.dev: yarn.init 
	@$(INFO) install dev deps 
	@$(YARN) install --dev
yarn.test: yarn.init.dev
	@$(INFO) yarn test
	@$(YARN) test
yarn.lint:
	@$(INFO) yarn lint
	@$(YARN) lint
yarn.clean:
	@rm -Rf $(YARN_MODULE_HOME)
yarn.distclean:
	@rm -Rf $(YARN_DIST_HOME) .cache $(YARN_PACKAGE_LOCK_FILE)
.PHONY: yarn.build yarn.lint yarn.test yarn.clean yarn.distclean
