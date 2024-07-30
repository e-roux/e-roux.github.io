# SPDX-FileCopyrightText: 2021-present Emmanuel Roux
# SPDX-FileCopyrightText: 2016-2021 The Upbound Authors
# SPDX-License-Identifier: Apache-2.0
_IS_MAKEFILES_SET := $(intcmp $(words $(MAKEFILES)),0,,,true)
_MAKEFILES_IS_NOT_MAKEFILE_LIST := $(intcmp $(words $(filter-out $(MAKEFILES),$(MAKEFILE_LIST))),0,,,true)
ifneq ($(and $(_IS_MAKEFILES_SET),$(_MAKEFILES_IS_NOT_MAKEFILE_LIST)),true)
__VERSION__ := 0.1.0+11.0b708ef.dirty
CF_VERSION?=8.7.10
GLAB_VERSION?=1.36.0
MC_VERSION?=RELEASE.2024-06-12T14-34-03Z
ARKADE_VERSION?=0.11.16
BATS_VERSION?=1.11.0
BATS_SUPPORT_VERSION?=0.3.0
BATS_FILE_VERSION?=0.4.0
BATS_ASSERT_VERSION?=2.1.0
BUN_VERSION?=1.1.13
CADDY_VERSION?=2.8.4
DASEL_VERSION?=2.7.0
DUCKDB_VERSION?=1.0.0
GOJUNIT_VERSION?=2.1.0
GOLANGCILINT_VERSION?=1.59.1
HELM_VERSION?=3.15.2
JQ_VERSION?=1.7.1
K8SEC_VERSION?=0.8.0
HUGO_VERSION?=0.127.0
KIND_VERSION?=0.23.0
MICROMAMBA_VERSION?=2024.03.25
MLR_VERSION?=6.12.0
NODE_VERSION?=22.3.0
RYE_VERSION?=0.34.0
SHFMT_VERSION?=3.8.0
TOMLJSON_VERSION?=2.2.2
YQ_VERSION?=4.44.1
SHELL := /usr/bin/env bash
CWD = $(shell pwd)
MLIB := $(lastword $(MAKEFILE_LIST))
THIS = $(lastword $(filter-out $(MLIB),$(MAKEFILE_LIST)))
THIS_DIR = $(CWD)
V ?= ##co Set to 1 enable verbose build.
ifeq ($(V),1)
	MAKEFLAGS += VERBOSE=1
else
MAKEFLAGS += --no-print-directory
endif
CI ?= 
MAKEFLAGS += --warn-undefined-variables
_TRUE := true#- this is our true value
normalize-bool = $(and $(filter $(strip $1),True true yes 1 TRUE YES),$(_TRUE))
DEBUG ?= 0##co Whether to generate debug symbols. Default is 0.
ifeq ($(call normalize-bool,$(DEBUG)),true)
    $(warning $(shell printf "$$(date +%H:%M:%S) \033[34m\033[0m starting Makefile for target(s) $(MAKECMDGOALS)"))
    MAKEFLAGS += --no-silent
else
    # Don't echo recipes.
    MAKEFLAGS += -s
endif
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
ALLOW_DIRTY ?=
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME ?= $(HOME)/.local/share
XDG_STATE_HOME ?= $(HOME)/.local/state
XDG_CACHE_HOME ?= $(HOME)/.cache
export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_STATE_HOME XDG_DATA_HOME
ifndef CI_PROJECT_DIR
MLIB_ROOT_HOME != (git worktree list --porcelain | awk 'NR==1 { print $$2}' 2>/dev/null || pwd)
else
MLIB_ROOT_HOME := $(CI_PROJECT_DIR)
endif
MLIB_CONFIG_HOME = $(CWD)/.config
MLIB_DATA_HOME ?= $(MLIB_ROOT_HOME)/.local/share
MLIB_CACHE_HOME ?= $(MLIB_ROOT_HOME)/.cache
MLIB_STATE_HOME ?= $(MLIB_ROOT_HOME)/.local/state
MLIB_PROJECT_HOME = $(patsubst %/,%,$(realpath $(CWD)))
MLIB_LIB_HOME ?= $(MLIB_ROOT_HOME)/.local/lib
MLIB_OUTPUT_HOME ?= $(MLIB_PROJECT_HOME)/build
MLIB_WORK_HOME ?= $(MLIB_DATA_HOME)/mlib
USE_SYSTEM_TOOLS ?= true
ifeq ($(USE_SYSTEM_TOOLS),true)
MLIB_LOCAL_BIN := $(HOME)/.local/bin
else
MLIB_LOCAL_BIN := $(MLIB_ROOT_HOME)/.local/bin
endif
TEST_SRC_HOME := $(MLIB_PROJECT_HOME)/test
DOC_SRC_HOME := $(MLIB_PROJECT_HOME)/doc
$(TEST_SRC_HOME) $(DOC_SRC_HOME): ; @mkdir -p $@
COMMA := ,
SPACE :=
SPACE +=
MLIB_BASE_VERBS := fmt lint test e2e doc 
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
uc = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$1))))))))))))))))))))))))))
stem = $(basename $(notdir $(1)))
rel_path = $(patsubst $(MLIB_ROOT_HOME)/%,%,$(1))
define assert_defined
if [[ "$(strip $1)" -ne "$1" ]]; then ( $(ERR) $1 contains trailing whitespaces; exit 1 ); else :; fi
endef
define assert_equals
[[ "$1" == "$2" ]] && : || ( $(ERR) Got "$1", want "$2"; exit 1 )
endef
define assert_file_exists
[[ -f "$1" ]] && : || ( $(ERR) "$1" does not exists; exit 1 )
endef
define _bind_target_to_parent
.PHONY: $(1).$(2)
$(1).$(2):
$(2): $(1).$(2)
endef
define bind_target_to_parent
$(eval $(call _bind_target_to_parent,$(1),$(2)))
endef
define _new_hooked_target
.PHONY: $(1) $(1).init $(1).run $(1).done $(1).watch
$(1).init:
$(1).run: $(1).init 
$(1).done: $(1).run
$(1).watch:
$(1): $(1).done ; @:
endef
define new_hooked_target
$(eval $(call _new_hooked_target,$(1)))
endef
define _insert_hooked_target
.PHONY: $(2).$(1) $(2).$(1).init $(2).$(1).run $(2).$(1).done
$(2).init: $(2).$(1).init
$(2).run: $(2).$(1).run
$(2).done: $(2).$(1).done
endef
define insert_hooked_target
$(eval $(call _insert_hooked_target,$(1),$(2)))
endef
define _project_hooked_target
.PHONY: $(1).$(2)
$(call _bind_target_to_parent,$(1),$(2).init)
$(call _bind_target_to_parent,$(1),$(2).run)
$(call _bind_target_to_parent,$(1),$(2).done)
endef
define project_hooked_target
$(eval $(call _project_hooked_target,$(1),$(2)))
endef
define register_mlib_namespace
$(foreach verb,$(MLIB_BASE_VERBS),$(call project_hooked_target,$(1),$(verb)))
$(foreach stage,init check code done,$(call bind_target_to_parent,$(1),build.$(stage)))
$(foreach stage,clean distclean sync,$(call bind_target_to_parent,$(1),$(stage)))
endef
HTTP_PROXY ?=
HTTPS_PROXY ?=
USE_GLOBAL_TOOLS ?= 
NO_AUTOLOAD_DOC :=
_IS_PYTHON_PROJECT := $(wildcard pyproject.toml)
_IS_GOLANG_PROJECT := $(wildcard go.mod)
_IS_NODEJS_PROJECT := $(wildcard package.json)
_IS_SPHINX_CONFIGURED := $(wildcard $(DOC_SRC_HOME)/conf.py)
_IS_MKDOCS_CONFIGURED := $(wildcard $(DOC_SRC_HOME)/mkdocs.yml)
_IS_HUGO_CONFIGURED := $(wildcard $(DOC_SRC_HOME)/config.toml)
_IS_OBSERVABLE_CONFIGURED := $(wildcard $(DOC_SRC_HOME)/observablehq.config.js)
 
_BLACK        := \033[30m
_BLACK_BOLD   := \033[30;1m
_RED          := \033[31m
_RED_BOLD     := \033[31;1m
_GREEN        := \033[32m
_GREEN_BOLD   := \033[32;1m
_YELLOW       := \033[33m
_YELLOW_BOLD  := \033[33;1m
_BLUE         := \033[34m
_BLUE_BOLD    := \033[34;1m
_MAGENTA      := \033[35m
_MAGENTA_BOLD := \033[35;1m
_CYAN         := \033[36m
_CYAN_BOLD    := \033[36;1m
_WHITE        := \033[37m
_WHITE_BOLD   := \033[37;1m
_CNone        := \033[0m
_CNONE        := \033[0m
_CNONE_BOLD   := \033[0;1m
_TERMINAL_WIDTH != TERM=$${TERM:-dumb} tput cols
_TIME		= `date +%H:%M:%S`
INFO	= echo -e "$(_TIME) $(_BLUE)[ .. ]$(_CNONE)" 
WARN	= echo -e "$(_TIME) $(_YELLOW)[WARN]$(_CNONE)"
ERR		= echo -e "$(_TIME) $(_RED)[FAIL]$(_CNONE)"
OK		= echo -e "$(_TIME) $(_GREEN)[ OK ]$(_CNONE)"
TEST	= echo -e "$(_TIME) $(_CYAN_BOLD)[TEST]$(_CNONE)"
FAIL	= ($(ERR) && false)
STATUS_OK		= printf "\e[1A\e[$$(( 9 ))C$(_GREEN_BOLD)[ OK ]${_CNone}\n"
STATUS_KO		= printf "\e[1A\e[$$(( 9 ))C$(_RED_BOLD)[ KO ]${_CNone}\n"
CLEAR_PREVLINE = printf "\e[1A\e[2K"
_log_test:
	$(INFO) Some tests on colors...
	echo -e "$(_BLACK)BLACK" 
	echo -e "$(_BLACK_BOLD)BLACK_BOLD$(_CNONE)"
	echo -e "$(_RED)RED$(_CNONE)"
	echo -e "$(_RED_BOLD)RED_BOLD$(_CNONE)"
	echo -e "$(_GREEN)GREEN$(_CNONE)"
	echo -e "$(_GREEN_BOLD)GREEN_BOLD$(_CNONE)"
	echo -e "$(_YELLOW)YELLOW$(_CNONE)"
	echo -e "$(_YELLOW_BOLD)YELLOW_BOLD$(_CNONE)"
	echo -e "$(_BLUE)BLUE$(_CNONE)"
	echo -e "$(_BLUE_BOLD)BLUE_BOLD$(_CNONE)"
	echo -e "$(_MAGENTA)MAGENTA$(_CNONE)"
	echo -e "$(_MAGENTA_BOLD)MAGENTA_BOLD$(_CNONE)"
	echo -e "$(_CYAN)CYAN$(_CNONE)"
	echo -e "$(_CYAN_BOLD)CYAN_BOLD$(_CNONE)"
	echo -e "$(_WHITE)WHITE$(_CNONE)"
	echo -e "$(_WHITE_BOLD)WHITE_BOLD$(_CNONE)"
	echo -e "$(_CNone)CNone$(_CNONE)"
	echo -e "$(_CNONE_BOLD)CNONE_BOLD$(_CNONE)"
	$(INFO) This is an information message
	$(WARN) This is a warn message
	$(ERR) This is an error message
	$(OK) This is an ok message
	$(TEST) This is a test 
	$(TEST) This is a test that should be ok
	$(STATUS_OK)
	$(TEST) This is a test that should not be ok
	$(STATUS_KO)
	$(FAIL) || true
	@$(INFO) Install $(call _colorize,package) with pip
define _colorize
"$(_MAGENTA)$(1)$(_CNone)"
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
HOST_OS := $(call lc,$(shell uname -s))
ifeq ($(filter darwin linux,$(HOST_OS)),)
$(error build only supported on linux and darwin host currently)
endif
HOST_ARCH != uname -m
ifeq ($(HOST_ARCH),x86_64)
HOST_ARCH := amd64
else ifeq ($(HOST_ARCH),aarch64)
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
AWK := gawk
B2SUM := gb2sum
BASE32 := gbase32
BASE64 := gbase64
BASENAME := gbasename
BASENC := gbasenc
CAT := gcat
CHCON := gchcon
CHGRP := gchgrp
CHMOD := gchmod
CHOWN := gchown
CHROOT := gchroot
CKSUM := gcksum
COMM := gcomm
CP := gcp
CSPLIT := gcsplit
CUT := gcut
DATE := gdate
DD := gdd
DF := gdf
DIR := gdir
DU := gdu
ECHO := gecho
ENV := genv
EXPAND := gexpand
EXPR := gexpr
FACTOR := gfactor
FALSE := gfalse
FIND := gfind
FMT := gfmt
FOLD := gfold
GREP := ggrep
GROUPS := ggroups
HEAD := ghead
HOSTID := ghostid
ID := gid
INSTALL := ginstall
JOIN := gjoin
KILL := gkill
LINK := glink
LN := gln
LOGNAME := glogname
LS := gls
MD5SUM := gmd5sum
MKDIR := gmkdir
MKFIFO := gmkfifo
MKNOD := gmknod
MKTEMP := gmktemp
MV := gmv
NICE := gnice
NL := gnl
NOHUP := gnohup
NPROC := gnproc
NUMFMT := gnumfmt
OD := god
PASTE := gpaste
PATHCHK := gpathchk
PINKY := gpinky
PR := gpr
PRINTENV := gprintenv
PRINTF := gprintf
PTX := gptx
PWD := gpwd
READLINK := greadlink
REALPATH := grealpath
RM := grm
RMDIR := grmdir
RUNCON := gruncon
SED := gsed
SEQ := gseq
SHA1SUM := gsha1sum
SHA224SUM := gsha224sum
SHA256SUM := gsha256sum
SHA384SUM := gsha384sum
SHA512SUM := gsha512sum
SHRED := gshred
SHUF := gshuf
SLEEP := gsleep
SORT := gsort
SPLIT := gsplit
STAT := gstat
STDBUF := gstdbuf
STTY := gstty
SUM := gsum
SYNC := gsync
TAC := gtac
TAIL := gtail
TEE := gtee
TIMEOUT := gtimeout
TOUCH := gtouch
TR := gtr
TRUE := gtrue
TRUNCATE := gtruncate
TSORT := gtsort
UNAME := guname
UNEXPAND := gunexpand
UNIQ := guniq
UNLINK := gunlink
UPTIME := guptime
USERS := gusers
VDIR := gvdir
WC := gwc
WHO := gwho
WHOAMI := gwhoami
XARGS := gxargs
YES := gyes
else
AWK := awk
B2SUM := b2sum
BASE32 := base32
BASE64 := base64
BASENAME := basename
BASENC := basenc
CAT := cat
CHCON := chcon
CHGRP := chgrp
CHMOD := chmod
CHOWN := chown
CHROOT := chroot
CKSUM := cksum
COMM := comm
CP := cp
CSPLIT := csplit
CUT := cut
DATE := date
DD := dd
DF := df
DIR := dir
DU := du
ECHO := echo
ENV := env
EXPAND := expand
EXPR := expr
FACTOR := factor
FALSE := false
FIND := find
FMT := fmt
FOLD := fold
GREP := grep
GROUPS := groups
HEAD := head
HOSTID := hostid
ID := id
INSTALL := install
JOIN := join
KILL := kill
LINK := link
LN := ln
LOGNAME := logname
LS := ls
MD5SUM := md5sum
MKDIR := mkdir
MKFIFO := mkfifo
MKNOD := mknod
MKTEMP := mktemp
MV := mv
NICE := nice
NL := nl
NOHUP := nohup
NPROC := nproc
NUMFMT := numfmt
OD := od
PASTE := paste
PATHCHK := pathchk
PINKY := pinky
PR := pr
PRINTENV := printenv
PRINTF := printf
PTX := ptx
PWD := pwd
READLINK := readlink
REALPATH := realpath
RM := rm
RMDIR := rmdir
RUNCON := runcon
SED := sed
SEQ := seq
SHA1SUM := sha1sum
SHA224SUM := sha224sum
SHA256SUM := sha256sum
SHA384SUM := sha384sum
SHA512SUM := sha512sum
SHRED := shred
SHUF := shuf
SLEEP := sleep
SORT := sort
SPLIT := split
STAT := stat
STDBUF := stdbuf
STTY := stty
SUM := sum
SYNC := sync
TAC := tac
TAIL := tail
TEE := tee
TIMEOUT := timeout
TOUCH := touch
TR := tr
TRUE := true
TRUNCATE := truncate
TSORT := tsort
UNAME := uname
UNEXPAND := unexpand
UNIQ := uniq
UNLINK := unlink
UPTIME := uptime
USERS := users
VDIR := vdir
WC := wc
WHO := who
WHOAMI := whoami
XARGS := xargs
YES := yes
endif
ifndef FIND
$(error GNU find was not find on this system, on mac OS install with `brew`)
endif
MLIB_TOOLSSRC_HOME := $(if $(CI),$(MLIB_CACHE_HOME),$(XDG_CACHE_HOME))/mlib
$(MLIB_TOOLSSRC_HOME): ; mkdir -p $@
ARKADE := $(MLIB_LOCAL_BIN)/arkade-$(ARKADE_VERSION)
ARKADE_URL := https://github.com/alexellis/arkade/releases/download/$(ARKADE_VERSION)/arkade$(and $(filter darwin,$(HOST_OS)),-$(HOST_OS))$(and $(filter arm64,$(HOST_ARCH)),-$(HOST_ARCH))
K8SEC := $(MLIB_LOCAL_BIN)/k8sec-$(K8SEC_VERSION)
K8SEC_URL := https://github.com/dtan4/k8sec/releases/download/$(K8SEC_VERSION)/k8sec_$(HOST_OS)_$(if ifeq($(HOST_ARCH), amd64),x86_64,$(HOST_ARCH)).tar.gz
MICROMAMBA := $(MLIB_LOCAL_BIN)/micromamba-$(MICROMAMBA_VERSION)
MICROMAMBA_URL := https://github.com/mamba-org/micromamba-releases/releases/download/$(patsubst v%,%,$(MICROMAMBA_VERSION))/micromamba-$(if ifeq($(HOST_OS),darwin),osx,$(HOST_OS))-$(if ifeq($(HOST_OS),darwin),64,$(HOST_ARCH))
GLAB := $(MLIB_LOCAL_BIN)/glab-$(GLAB_VERSION)
GLAB_URL := https://gitlab.com/gitlab-org/cli/-/releases/v$(GLAB_VERSION)/downloads/glab_$(GLAB_VERSION)_$(if ifeq($(HOST_OS),darwin),macOS,$(HOST_OS:linux%=Linux%))_$(HOST_ARCH:amd%=x86_%).tar.gz
JQ := $(MLIB_LOCAL_BIN)/jq-$(JQ_VERSION)
JQ_URL := https://github.com/jqlang/jq/releases/download/jq-$(JQ_VERSION)/jq-$(HOST_OS:darwin=macos)-$(HOST_ARCH)
DASEL := $(MLIB_LOCAL_BIN)/dasel-$(DASEL_VERSION)
DASEL_URL := https://github.com/TomWright/dasel/releases/download/v$(patsubst v%,%,$(DASEL_VERSION))/dasel_$(HOST_OS)_$(HOST_ARCH).gz
TOMLJSON := $(MLIB_LOCAL_BIN)/tomljson-$(TOMLJSON_VERSION)
$(TOMLJSON):
	@$(INFO) installing tomljson $(HOST_OS)-$(HOST_ARCH)
	@mkdir -p $(MLIB_LOCAL_BIN)/tmp-tomljson
	@curl -fsSL https://github.com/pelletier/go-toml/releases/download/v$(TOMLJSON_VERSION)/tomljson_$(HOST_OS)_$(HOST_ARCH).tar.xz | tar -xJ -C $(MLIB_LOCAL_BIN)/tmp-tomljson || $(FAIL)
	@mv $(MLIB_LOCAL_BIN)/tmp-tomljson/tomljson $@
	@rm -fr $(MLIB_LOCAL_BIN)/tmp-tomljson
	@$(OK) installed tomljson $(HOST_OS)-$(HOST_ARCH)
CF := $(MLIB_LOCAL_BIN)/cf-$(CF_VERSION)
$(CF):
	@$(INFO) installing cf $(HOST_OS)-$(HOST_ARCH)
	@mkdir -p $(MLIB_LOCAL_BIN)/tmp-cf
	@$(WARN) downloading linux64 version, valid for macOS and linux
	@curl -LsSL "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=$(CF_VERSION)&source=github" | tar -xz -C $(MLIB_LOCAL_BIN)/tmp-cf
	@mv $(shell readlink -f $(MLIB_LOCAL_BIN)/tmp-cf/cf) $@
	@rm -fr $(MLIB_LOCAL_BIN)/tmp-cf
	@$(OK) installed cf $(HOST_OS)-$(HOST_ARCH)
export MC_CONFIG_DIR ?= $(MLIB_CONFIG_HOME)/mc
export MC_NO_COLOR ?= true
export MC_QUIET ?= true
MLR := $(MLIB_LOCAL_BIN)/mlr-$(MLR_VERSION)
MLR_URL := https://github.com/johnkerl/miller/releases/download/v$(patsubst v%,%,$(MLR_VERSION))/miller-$(patsubst v%,%,$(MLR_VERSION))-$(HOST_OS)-$(HOST_ARCH).tar.gz
export RYE_TOOLCHAIN_VERSION := cpython@3.11
export RYE_INSTALL_OPTION := --yes
ifndef USE_SYSTEM_RYE
export RYE_HOME := $(MLIB_CACHE_HOME)/rye
export RYE_NO_AUTO_INSTALL := 1
RYE = $(MLIB_LOCAL_BIN)/rye-$(RYE_VERSION)
RYE_URL = https://github.com/astral-sh/rye/releases/download/$(RYE_VERSION)/rye-$(patsubst arm64,aarch64,$(HOST_ARCH:amd64%=x86_64%))-$(HOST_OS:darwin%=macos%).gz
RYE_ARCHIVE := $(MLIB_TOOLSSRC_HOME)/$(call stem,$(RYE_URL))-$(RYE_VERSION).gz
$(RYE_ARCHIVE):
	@$(INFO) "Downloading rye $(RYE_VERSION)"
	@$(CURL) --create-dirs --disable -fsSL -o $@ $(RYE_URL) \
		&& $(STATUS_OK) || $(STATUS_KO)
$(RYE_HOME):
	@mkdir -p $@
$(RYE): $(RYE_ARCHIVE) | $(RYE_HOME)
	@$(INFO) "Extracting $(notdir $<)"
	@mkdir -p $(@D)
	@gunzip -c $< > $@ && $(STATUS_OK) || $(FAIL)
	@chmod +x $@
	#@$(RYE) config --set-bool behavior.global-python=true
	@$(RYE) config --set-bool behavior.use-uv=$(RYE_USE_UV)
	@$(RYE) config --set default.requires-python=">=3.10"
	@$(RYE) config --set default.toolchain="$(RYE_DEFAULT_TOOLCHAIN)"
else
RYE != command -v rye
endif
BATS = $(MLIB_LOCAL_BIN)/bats-$(BATS_VERSION)
BATS_URL := https://github.com/bats-core/bats-core/archive/refs/tags/v$(patsubst v%,%,$(BATS_VERSION)).tar.gz
BATS_LIB_PATH ?= $(MLIB_LIB_HOME)/bats
BATS_LIBS := bats-support bats-file bats-assert
BATS_LIBS := $(addprefix $(MLIB_LIB_HOME)/bats/,$(BATS_LIBS))
$(BATS_LIBS): _LIB_VERSION=$($(subst -,_,$(call uc,$(@F)))_VERSION)
$(BATS_LIBS): _LIB=https://github.com/bats-core/$(@F)/archive/refs/tags/v$(patsubst v%,%,$(_LIB_VERSION)).zip
$(BATS_LIBS): 
	$(INFO) Installing bats library $(@F)
	$(CURL) --create-dirs --disable -fsSLo $(MLIB_CACHE_HOME)/bats/$(@F).zip $(_LIB) && $(STATUS_OK) || $(FAIL)
	mkdir -p $(@D)
	unzip -qo $(MLIB_CACHE_HOME)/bats/$(@F).zip -d $(@D) || $(FAIL)
	ln -nfs $@-$(_LIB_VERSION:v%=%) $@
$(BATS): | $(BATS_LIBS)
BATS_OPTS += $(if $(V), -x ) ##co Bats Options
BATS_ENV += BATS_LIB_PATH="$(BATS_LIB_PATH)"
BATS_CMD = $(BATS_ENV) $(BATS) $(BATS_OPTS)
GOJUNIT = $(MLIB_LOCAL_BIN)/go-junit-report
$(GOJUNIT):
	@$(INFO) Installing $(@F) in \$$MLIB_LOCAL_BIN
	@mkdir -p $(MLIB_CACHE_HOME)/tmp-$(@F) || $(FAIL)
	@GOBIN=$(MLIB_CACHE_HOME)/tmp-$(@F) $(GOHOST) install github.com/jstemmer/go-junit-report/$(GOJUNIT_VERSION) || $(FAIL)
	@mkdir -p $(@D) || $(FAIL)
	@mv $(MLIB_CACHE_HOME)/tmp-$(@F)/$(@F) $@ || $(FAIL)
	@rm -fr $(MLIB_CACHE_HOME)/tmp-$(@F) && $(STATUS_OK) || $(FAIL)
GOIMPORTS_VERSION ?= 0.1.12
GOIMPORTS := $(MLIB_LOCAL_BIN)/goimports-$(GOIMPORTS_VERSION)
$(GOIMPORTS):
	@$(INFO) Installing $(@F) in \$$MLIB_LOCAL_BIN
	@GOBIN=$(MLIB_CACHE_HOME)/tmp-$(@F) $(GOHOST) install golang.org/x/tools/cmd/goimports@v$(GOIMPORTS_VERSION) || $(FAIL)
	@mkdir -p $(@D) || $(FAIL)
	@mv $(MLIB_CACHE_HOME)/tmp-$(@F)/$(subst -$(GOIMPORTS_VERSION),,$(@F)) $@ || $(FAIL)
	@rm -fr $(MLIB_CACHE_HOME)/tmp-$(@F) && $(STATUS_OK) || $(FAIL)
SHFMT := $(MLIB_LOCAL_BIN)/shfmt
SHFMT_URL := https://github.com/mvdan/sh/releases/download/v$(patsubst v%,%,$(SHFMT_VERSION))/shfmt_v$(patsubst v%,%,$(SHFMT_VERSION))_$(HOST_OS)_$(HOST_ARCH)
TOOLS = ARKADE BATS DASEL GLAB K8SEC MICROMAMBA MLR SHFMT
define _set_tool_var
.SECONDEXPANSION:
$$($(1)): TOOL_URL=$$($(1)_URL)
$$($(1)): TOOL_VERSION=$$($(1)_VERSION)
$$($(1)): | $$(MLIB_TOOLSSRC_HOME)/$$(notdir $$($(1)_URL))
$$($(1)): ARCHIVE_NAME?=$$(MLIB_TOOLSSRC_HOME)/$$(notdir $$($(1)_URL))
$$(MLIB_TOOLSSRC_HOME)/$$(notdir $$($(1)_URL)): | $$(MLIB_TOOLSSRC_HOME)
	$(INFO) "Downloading $$(notdir $$($(1)_URL))"
	$$(CURL) --create-dirs --disable -fsSLo $$@ $$(TOOL_URL) && $$(STATUS_OK) || $$(FAIL)
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
$(MLIB_LOCAL_BIN)/_arkade/%: $(ARKADE) 
	$(INFO) Installing $(shell echo $(notdir $@) | cut -d "_" -f 1) with arkade
	mkdir -p $(@D)
	_tool=$(shell echo $(notdir $@) | cut -d "_" -f 1) && \
	_tool_version=$(shell echo $(notdir $@) | cut -d "_" -f 1 | tr "a-z" "A-Z")_VERSION && \
	$(ARKADE) get --quiet --progress \
		--path $(@D) \
		$$_tool \
			&& ( mv $(@D)/$$_tool $@; $(CLEAR_PREVLINE); $(STATUS_OK) ) \
			|| ( $(CLEAR_PREVLINE); $(STATUS_KO) )
tools.buildvars: ; @:
build.vars: tools.buildvars
HTTP_PROXY ?=
HTTPS_PROXY ?=
ACTIONS_USAGE_VERSION ?= latest
ACTIONS_USAGE = $(MLIB_LOCAL_BIN)/_arkade/actions-usage_$(ACTIONS_USAGE_VERSION)
ACTUATED_CLI_VERSION ?= latest
ACTUATED_CLI = $(MLIB_LOCAL_BIN)/_arkade/actuated-cli_$(ACTUATED_CLI_VERSION)
ARGOCD_VERSION ?= latest
ARGOCD = $(MLIB_LOCAL_BIN)/_arkade/argocd_$(ARGOCD_VERSION)
ARGOCD_AUTOPILOT_VERSION ?= latest
ARGOCD_AUTOPILOT = $(MLIB_LOCAL_BIN)/_arkade/argocd-autopilot_$(ARGOCD_AUTOPILOT_VERSION)
ATUIN_VERSION ?= latest
ATUIN = $(MLIB_LOCAL_BIN)/_arkade/atuin_$(ATUIN_VERSION)
AUTOK3S_VERSION ?= latest
AUTOK3S = $(MLIB_LOCAL_BIN)/_arkade/autok3s_$(AUTOK3S_VERSION)
BUILDX_VERSION ?= latest
BUILDX = $(MLIB_LOCAL_BIN)/_arkade/buildx_$(BUILDX_VERSION)
BUN_VERSION ?= latest
BUN = $(MLIB_LOCAL_BIN)/_arkade/bun_$(BUN_VERSION)
BUTANE_VERSION ?= latest
BUTANE = $(MLIB_LOCAL_BIN)/_arkade/butane_$(BUTANE_VERSION)
CADDY_VERSION ?= latest
CADDY = $(MLIB_LOCAL_BIN)/_arkade/caddy_$(CADDY_VERSION)
CILIUM_VERSION ?= latest
CILIUM = $(MLIB_LOCAL_BIN)/_arkade/cilium_$(CILIUM_VERSION)
CIVO_VERSION ?= latest
CIVO = $(MLIB_LOCAL_BIN)/_arkade/civo_$(CIVO_VERSION)
CLUSTERAWSADM_VERSION ?= latest
CLUSTERAWSADM = $(MLIB_LOCAL_BIN)/_arkade/clusterawsadm_$(CLUSTERAWSADM_VERSION)
CLUSTERCTL_VERSION ?= latest
CLUSTERCTL = $(MLIB_LOCAL_BIN)/_arkade/clusterctl_$(CLUSTERCTL_VERSION)
CMCTL_VERSION ?= latest
CMCTL = $(MLIB_LOCAL_BIN)/_arkade/cmctl_$(CMCTL_VERSION)
CONFTEST_VERSION ?= latest
CONFTEST = $(MLIB_LOCAL_BIN)/_arkade/conftest_$(CONFTEST_VERSION)
COPA_VERSION ?= latest
COPA = $(MLIB_LOCAL_BIN)/_arkade/copa_$(COPA_VERSION)
COSIGN_VERSION ?= latest
COSIGN = $(MLIB_LOCAL_BIN)/_arkade/cosign_$(COSIGN_VERSION)
CR_VERSION ?= latest
CR = $(MLIB_LOCAL_BIN)/_arkade/cr_$(CR_VERSION)
CRANE_VERSION ?= latest
CRANE = $(MLIB_LOCAL_BIN)/_arkade/crane_$(CRANE_VERSION)
CROC_VERSION ?= latest
CROC = $(MLIB_LOCAL_BIN)/_arkade/croc_$(CROC_VERSION)
DAGGER_VERSION ?= latest
DAGGER = $(MLIB_LOCAL_BIN)/_arkade/dagger_$(DAGGER_VERSION)
DEVSPACE_VERSION ?= latest
DEVSPACE = $(MLIB_LOCAL_BIN)/_arkade/devspace_$(DEVSPACE_VERSION)
DIVE_VERSION ?= latest
DIVE = $(MLIB_LOCAL_BIN)/_arkade/dive_$(DIVE_VERSION)
DOCKER_COMPOSE_VERSION ?= latest
DOCKER_COMPOSE = $(MLIB_LOCAL_BIN)/_arkade/docker-compose_$(DOCKER_COMPOSE_VERSION)
DOCTL_VERSION ?= latest
DOCTL = $(MLIB_LOCAL_BIN)/_arkade/doctl_$(DOCTL_VERSION)
EKSCTL_VERSION ?= latest
EKSCTL = $(MLIB_LOCAL_BIN)/_arkade/eksctl_$(EKSCTL_VERSION)
EKSCTL_ANYWHERE_VERSION ?= latest
EKSCTL_ANYWHERE = $(MLIB_LOCAL_BIN)/_arkade/eksctl-anywhere_$(EKSCTL_ANYWHERE_VERSION)
ETCD_VERSION ?= latest
ETCD = $(MLIB_LOCAL_BIN)/_arkade/etcd_$(ETCD_VERSION)
FAAS_CLI_VERSION ?= latest
FAAS_CLI = $(MLIB_LOCAL_BIN)/_arkade/faas-cli_$(FAAS_CLI_VERSION)
FIRECTL_VERSION ?= latest
FIRECTL = $(MLIB_LOCAL_BIN)/_arkade/firectl_$(FIRECTL_VERSION)
FLUX_VERSION ?= latest
FLUX = $(MLIB_LOCAL_BIN)/_arkade/flux_$(FLUX_VERSION)
FLYCTL_VERSION ?= latest
FLYCTL = $(MLIB_LOCAL_BIN)/_arkade/flyctl_$(FLYCTL_VERSION)
FSTAIL_VERSION ?= latest
FSTAIL = $(MLIB_LOCAL_BIN)/_arkade/fstail_$(FSTAIL_VERSION)
FZF_VERSION ?= latest
FZF = $(MLIB_LOCAL_BIN)/_arkade/fzf_$(FZF_VERSION)
GH_VERSION ?= latest
GH = $(MLIB_LOCAL_BIN)/_arkade/gh_$(GH_VERSION)
GOLANGCI_LINT_VERSION ?= latest
GOLANGCI_LINT = $(MLIB_LOCAL_BIN)/_arkade/golangci-lint_$(GOLANGCI_LINT_VERSION)
GOMPLATE_VERSION ?= latest
GOMPLATE = $(MLIB_LOCAL_BIN)/_arkade/gomplate_$(GOMPLATE_VERSION)
GORELEASER_VERSION ?= latest
GORELEASER = $(MLIB_LOCAL_BIN)/_arkade/goreleaser_$(GORELEASER_VERSION)
GRAFANA_AGENT_VERSION ?= latest
GRAFANA_AGENT = $(MLIB_LOCAL_BIN)/_arkade/grafana-agent_$(GRAFANA_AGENT_VERSION)
GRYPE_VERSION ?= latest
GRYPE = $(MLIB_LOCAL_BIN)/_arkade/grype_$(GRYPE_VERSION)
HADOLINT_VERSION ?= latest
HADOLINT = $(MLIB_LOCAL_BIN)/_arkade/hadolint_$(HADOLINT_VERSION)
HELM_VERSION ?= latest
HELM = $(MLIB_LOCAL_BIN)/_arkade/helm_$(HELM_VERSION)
HELMFILE_VERSION ?= latest
HELMFILE = $(MLIB_LOCAL_BIN)/_arkade/helmfile_$(HELMFILE_VERSION)
HEY_VERSION ?= latest
HEY = $(MLIB_LOCAL_BIN)/_arkade/hey_$(HEY_VERSION)
HOSTCTL_VERSION ?= latest
HOSTCTL = $(MLIB_LOCAL_BIN)/_arkade/hostctl_$(HOSTCTL_VERSION)
HUBBLE_VERSION ?= latest
HUBBLE = $(MLIB_LOCAL_BIN)/_arkade/hubble_$(HUBBLE_VERSION)
HUGO_VERSION ?= latest
HUGO = $(MLIB_LOCAL_BIN)/_arkade/hugo_$(HUGO_VERSION)
INFLUX_VERSION ?= latest
INFLUX = $(MLIB_LOCAL_BIN)/_arkade/influx_$(INFLUX_VERSION)
INLETS_PRO_VERSION ?= latest
INLETS_PRO = $(MLIB_LOCAL_BIN)/_arkade/inlets-pro_$(INLETS_PRO_VERSION)
INLETSCTL_VERSION ?= latest
INLETSCTL = $(MLIB_LOCAL_BIN)/_arkade/inletsctl_$(INLETSCTL_VERSION)
ISTIOCTL_VERSION ?= latest
ISTIOCTL = $(MLIB_LOCAL_BIN)/_arkade/istioctl_$(ISTIOCTL_VERSION)
JQ_VERSION ?= latest
JQ = $(MLIB_LOCAL_BIN)/_arkade/jq_$(JQ_VERSION)
JUST_VERSION ?= latest
JUST = $(MLIB_LOCAL_BIN)/_arkade/just_$(JUST_VERSION)
K0S_VERSION ?= latest
K0S = $(MLIB_LOCAL_BIN)/_arkade/k0s_$(K0S_VERSION)
K0SCTL_VERSION ?= latest
K0SCTL = $(MLIB_LOCAL_BIN)/_arkade/k0sctl_$(K0SCTL_VERSION)
K10MULTICLUSTER_VERSION ?= latest
K10MULTICLUSTER = $(MLIB_LOCAL_BIN)/_arkade/k10multicluster_$(K10MULTICLUSTER_VERSION)
K10TOOLS_VERSION ?= latest
K10TOOLS = $(MLIB_LOCAL_BIN)/_arkade/k10tools_$(K10TOOLS_VERSION)
K3D_VERSION ?= latest
K3D = $(MLIB_LOCAL_BIN)/_arkade/k3d_$(K3D_VERSION)
K3S_VERSION ?= latest
K3S = $(MLIB_LOCAL_BIN)/_arkade/k3s_$(K3S_VERSION)
K3SUP_VERSION ?= latest
K3SUP = $(MLIB_LOCAL_BIN)/_arkade/k3sup_$(K3SUP_VERSION)
K9S_VERSION ?= latest
K9S = $(MLIB_LOCAL_BIN)/_arkade/k9s_$(K9S_VERSION)
KAIL_VERSION ?= latest
KAIL = $(MLIB_LOCAL_BIN)/_arkade/kail_$(KAIL_VERSION)
KANCTL_VERSION ?= latest
KANCTL = $(MLIB_LOCAL_BIN)/_arkade/kanctl_$(KANCTL_VERSION)
KGCTL_VERSION ?= latest
KGCTL = $(MLIB_LOCAL_BIN)/_arkade/kgctl_$(KGCTL_VERSION)
KIM_VERSION ?= latest
KIM = $(MLIB_LOCAL_BIN)/_arkade/kim_$(KIM_VERSION)
KIND_VERSION ?= latest
KIND = $(MLIB_LOCAL_BIN)/_arkade/kind_$(KIND_VERSION)
KOPS_VERSION ?= latest
KOPS = $(MLIB_LOCAL_BIN)/_arkade/kops_$(KOPS_VERSION)
KREW_VERSION ?= latest
KREW = $(MLIB_LOCAL_BIN)/_arkade/krew_$(KREW_VERSION)
KTOP_VERSION ?= latest
KTOP = $(MLIB_LOCAL_BIN)/_arkade/ktop_$(KTOP_VERSION)
KUBE_BENCH_VERSION ?= latest
KUBE_BENCH = $(MLIB_LOCAL_BIN)/_arkade/kube-bench_$(KUBE_BENCH_VERSION)
KUBE_BURNER_VERSION ?= latest
KUBE_BURNER = $(MLIB_LOCAL_BIN)/_arkade/kube-burner_$(KUBE_BURNER_VERSION)
KUBE_LINTER_VERSION ?= latest
KUBE_LINTER = $(MLIB_LOCAL_BIN)/_arkade/kube-linter_$(KUBE_LINTER_VERSION)
KUBEBUILDER_VERSION ?= latest
KUBEBUILDER = $(MLIB_LOCAL_BIN)/_arkade/kubebuilder_$(KUBEBUILDER_VERSION)
KUBECM_VERSION ?= latest
KUBECM = $(MLIB_LOCAL_BIN)/_arkade/kubecm_$(KUBECM_VERSION)
KUBECONFORM_VERSION ?= latest
KUBECONFORM = $(MLIB_LOCAL_BIN)/_arkade/kubeconform_$(KUBECONFORM_VERSION)
KUBECTL_VERSION ?= latest
KUBECTL = $(MLIB_LOCAL_BIN)/_arkade/kubectl_$(KUBECTL_VERSION)
KUBECTX_VERSION ?= latest
KUBECTX = $(MLIB_LOCAL_BIN)/_arkade/kubectx_$(KUBECTX_VERSION)
KUBENS_VERSION ?= latest
KUBENS = $(MLIB_LOCAL_BIN)/_arkade/kubens_$(KUBENS_VERSION)
KUBESCAPE_VERSION ?= latest
KUBESCAPE = $(MLIB_LOCAL_BIN)/_arkade/kubescape_$(KUBESCAPE_VERSION)
KUBESEAL_VERSION ?= latest
KUBESEAL = $(MLIB_LOCAL_BIN)/_arkade/kubeseal_$(KUBESEAL_VERSION)
KUBESTR_VERSION ?= latest
KUBESTR = $(MLIB_LOCAL_BIN)/_arkade/kubestr_$(KUBESTR_VERSION)
KUBETAIL_VERSION ?= latest
KUBETAIL = $(MLIB_LOCAL_BIN)/_arkade/kubetail_$(KUBETAIL_VERSION)
KUBEVAL_VERSION ?= latest
KUBEVAL = $(MLIB_LOCAL_BIN)/_arkade/kubeval_$(KUBEVAL_VERSION)
KUMACTL_VERSION ?= latest
KUMACTL = $(MLIB_LOCAL_BIN)/_arkade/kumactl_$(KUMACTL_VERSION)
KUSTOMIZE_VERSION ?= latest
KUSTOMIZE = $(MLIB_LOCAL_BIN)/_arkade/kustomize_$(KUSTOMIZE_VERSION)
KWOK_VERSION ?= latest
KWOK = $(MLIB_LOCAL_BIN)/_arkade/kwok_$(KWOK_VERSION)
KWOKCTL_VERSION ?= latest
KWOKCTL = $(MLIB_LOCAL_BIN)/_arkade/kwokctl_$(KWOKCTL_VERSION)
KYVERNO_VERSION ?= latest
KYVERNO = $(MLIB_LOCAL_BIN)/_arkade/kyverno_$(KYVERNO_VERSION)
LAZYGIT_VERSION ?= latest
LAZYGIT = $(MLIB_LOCAL_BIN)/_arkade/lazygit_$(LAZYGIT_VERSION)
LINKERD2_VERSION ?= latest
LINKERD2 = $(MLIB_LOCAL_BIN)/_arkade/linkerd2_$(LINKERD2_VERSION)
MC_VERSION ?= latest
MC = $(MLIB_LOCAL_BIN)/_arkade/mc_$(MC_VERSION)
METAL_VERSION ?= latest
METAL = $(MLIB_LOCAL_BIN)/_arkade/metal_$(METAL_VERSION)
MINIKUBE_VERSION ?= latest
MINIKUBE = $(MLIB_LOCAL_BIN)/_arkade/minikube_$(MINIKUBE_VERSION)
MIXCTL_VERSION ?= latest
MIXCTL = $(MLIB_LOCAL_BIN)/_arkade/mixctl_$(MIXCTL_VERSION)
MKCERT_VERSION ?= latest
MKCERT = $(MLIB_LOCAL_BIN)/_arkade/mkcert_$(MKCERT_VERSION)
NATS_VERSION ?= latest
NATS = $(MLIB_LOCAL_BIN)/_arkade/nats_$(NATS_VERSION)
NATS_SERVER_VERSION ?= latest
NATS_SERVER = $(MLIB_LOCAL_BIN)/_arkade/nats-server_$(NATS_SERVER_VERSION)
NERDCTL_VERSION ?= latest
NERDCTL = $(MLIB_LOCAL_BIN)/_arkade/nerdctl_$(NERDCTL_VERSION)
NOVA_VERSION ?= latest
NOVA = $(MLIB_LOCAL_BIN)/_arkade/nova_$(NOVA_VERSION)
OC_VERSION ?= latest
OC = $(MLIB_LOCAL_BIN)/_arkade/oc_$(OC_VERSION)
OH_MY_POSH_VERSION ?= latest
OH_MY_POSH = $(MLIB_LOCAL_BIN)/_arkade/oh-my-posh_$(OH_MY_POSH_VERSION)
OP_VERSION ?= latest
OP = $(MLIB_LOCAL_BIN)/_arkade/op_$(OP_VERSION)
OPA_VERSION ?= latest
OPA = $(MLIB_LOCAL_BIN)/_arkade/opa_$(OPA_VERSION)
OPENSHIFT_INSTALL_VERSION ?= latest
OPENSHIFT_INSTALL = $(MLIB_LOCAL_BIN)/_arkade/openshift-install_$(OPENSHIFT_INSTALL_VERSION)
OPERATOR_SDK_VERSION ?= latest
OPERATOR_SDK = $(MLIB_LOCAL_BIN)/_arkade/operator-sdk_$(OPERATOR_SDK_VERSION)
OSM_VERSION ?= latest
OSM = $(MLIB_LOCAL_BIN)/_arkade/osm_$(OSM_VERSION)
PACK_VERSION ?= latest
PACK = $(MLIB_LOCAL_BIN)/_arkade/pack_$(PACK_VERSION)
PACKER_VERSION ?= latest
PACKER = $(MLIB_LOCAL_BIN)/_arkade/packer_$(PACKER_VERSION)
POLARIS_VERSION ?= latest
POLARIS = $(MLIB_LOCAL_BIN)/_arkade/polaris_$(POLARIS_VERSION)
POPEYE_VERSION ?= latest
POPEYE = $(MLIB_LOCAL_BIN)/_arkade/popeye_$(POPEYE_VERSION)
PORTER_VERSION ?= latest
PORTER = $(MLIB_LOCAL_BIN)/_arkade/porter_$(PORTER_VERSION)
PROMTOOL_VERSION ?= latest
PROMTOOL = $(MLIB_LOCAL_BIN)/_arkade/promtool_$(PROMTOOL_VERSION)
REKOR_CLI_VERSION ?= latest
REKOR_CLI = $(MLIB_LOCAL_BIN)/_arkade/rekor-cli_$(REKOR_CLI_VERSION)
REPLICATED_VERSION ?= latest
REPLICATED = $(MLIB_LOCAL_BIN)/_arkade/replicated_$(REPLICATED_VERSION)
RPK_VERSION ?= latest
RPK = $(MLIB_LOCAL_BIN)/_arkade/rpk_$(RPK_VERSION)
RUN_JOB_VERSION ?= latest
RUN_JOB = $(MLIB_LOCAL_BIN)/_arkade/run-job_$(RUN_JOB_VERSION)
SCALEWAY_CLI_VERSION ?= latest
SCALEWAY_CLI = $(MLIB_LOCAL_BIN)/_arkade/scaleway-cli_$(SCALEWAY_CLI_VERSION)
SEAWEEDFS_VERSION ?= latest
SEAWEEDFS = $(MLIB_LOCAL_BIN)/_arkade/seaweedfs_$(SEAWEEDFS_VERSION)
SKUPPER_VERSION ?= latest
SKUPPER = $(MLIB_LOCAL_BIN)/_arkade/skupper_$(SKUPPER_VERSION)
SNOWMACHINE_VERSION ?= latest
SNOWMACHINE = $(MLIB_LOCAL_BIN)/_arkade/snowmachine_$(SNOWMACHINE_VERSION)
SOPS_VERSION ?= latest
SOPS = $(MLIB_LOCAL_BIN)/_arkade/sops_$(SOPS_VERSION)
STERN_VERSION ?= latest
STERN = $(MLIB_LOCAL_BIN)/_arkade/stern_$(STERN_VERSION)
SYFT_VERSION ?= latest
SYFT = $(MLIB_LOCAL_BIN)/_arkade/syft_$(SYFT_VERSION)
TALOSCTL_VERSION ?= latest
TALOSCTL = $(MLIB_LOCAL_BIN)/_arkade/talosctl_$(TALOSCTL_VERSION)
TASK_VERSION ?= latest
TASK = $(MLIB_LOCAL_BIN)/_arkade/task_$(TASK_VERSION)
TCTL_VERSION ?= latest
TCTL = $(MLIB_LOCAL_BIN)/_arkade/tctl_$(TCTL_VERSION)
TERRAFORM_VERSION ?= latest
TERRAFORM = $(MLIB_LOCAL_BIN)/_arkade/terraform_$(TERRAFORM_VERSION)
TERRAGRUNT_VERSION ?= latest
TERRAGRUNT = $(MLIB_LOCAL_BIN)/_arkade/terragrunt_$(TERRAGRUNT_VERSION)
TERRASCAN_VERSION ?= latest
TERRASCAN = $(MLIB_LOCAL_BIN)/_arkade/terrascan_$(TERRASCAN_VERSION)
TFSEC_VERSION ?= latest
TFSEC = $(MLIB_LOCAL_BIN)/_arkade/tfsec_$(TFSEC_VERSION)
TILT_VERSION ?= latest
TILT = $(MLIB_LOCAL_BIN)/_arkade/tilt_$(TILT_VERSION)
TIMONI_VERSION ?= latest
TIMONI = $(MLIB_LOCAL_BIN)/_arkade/timoni_$(TIMONI_VERSION)
TKN_VERSION ?= latest
TKN = $(MLIB_LOCAL_BIN)/_arkade/tkn_$(TKN_VERSION)
TRIVY_VERSION ?= latest
TRIVY = $(MLIB_LOCAL_BIN)/_arkade/trivy_$(TRIVY_VERSION)
VAGRANT_VERSION ?= latest
VAGRANT = $(MLIB_LOCAL_BIN)/_arkade/vagrant_$(VAGRANT_VERSION)
VAULT_VERSION ?= latest
VAULT = $(MLIB_LOCAL_BIN)/_arkade/vault_$(VAULT_VERSION)
VCLUSTER_VERSION ?= latest
VCLUSTER = $(MLIB_LOCAL_BIN)/_arkade/vcluster_$(VCLUSTER_VERSION)
VHS_VERSION ?= latest
VHS = $(MLIB_LOCAL_BIN)/_arkade/vhs_$(VHS_VERSION)
VIDDY_VERSION ?= latest
VIDDY = $(MLIB_LOCAL_BIN)/_arkade/viddy_$(VIDDY_VERSION)
WAYPOINT_VERSION ?= latest
WAYPOINT = $(MLIB_LOCAL_BIN)/_arkade/waypoint_$(WAYPOINT_VERSION)
YQ_VERSION ?= latest
YQ = $(MLIB_LOCAL_BIN)/_arkade/yq_$(YQ_VERSION)
YT_DLP_VERSION ?= latest
YT_DLP = $(MLIB_LOCAL_BIN)/_arkade/yt-dlp_$(YT_DLP_VERSION)
CHANNEL ?= master
ifeq ($(filter master alpha beta stable,$(CHANNEL)),)
$(error invalid channel $(CHANNEL))
endif
GIT_COMMIT_HASH = $(shell git rev-parse --short HEAD 2>/dev/null)
GIT_BRANCH_NAME != git branch --show-current 2> /dev/null || git config --get init.defaultBranch
GIT_REMOTE_NAME ?= origin
GIT_REMOTE_URL != git remote get-url --push $(GIT_REMOTE_NAME) 2>/dev/null || echo ""
ifdef GIT_REMOTE_URL
GIT_REMOTE_URL != echo $(GIT_REMOTE_URL) | sed -E \
	-e "s/(https?\:\/\/).*@/\1/" \
	-e "s%.*git@(.*)\:(.*)%\1/\2%" \
	-e "s%.*ssh://(.*)\:(.*)%\1/\2%" 
GIT_PROJECT_REPO = $(shell echo $(GIT_REMOTE_URL) | sed -E \
				-e 's%(https?://|ssh://git@)%%'  \
				-e 's%^[0-9A-Za-z\-\_\.\:]*@/(.*)%\1%' \
				-e 's%\:[0-9]*/%/%' \
				 | sed -Ee "s%\.git$$%%")
GIT_PROJECT_NAME = $(notdir $(GIT_PROJECT_REPO))
GIT_REMOTE_HOST = $(shell repo=$(GIT_PROJECT_REPO) && echo $${repo%%/*})
GIT_REMOTE_PORT = $(shell echo $(GIT_REMOTE_HOST) | gcut -d ":" -s -f 2 -)
GIT_PROJECT_NAMESPACE = $(shell echo $(GIT_PROJECT_REPO) | xargs dirname | sed -Ee 's%^[0-9A-Za-z\-\_\.]*/(.*)%\1%' 2>/dev/null)
else
GIT_PROJECT_NAME ?= $(shell echo $(call lc,$(notdir $(MLIB_ROOT_HOME))) | tr "-" "_")
GIT_PROJECT_NAMESPACE ?= 
GIT_REMOTE_HOST ?= 
GIT_PROJECT_REPO ?=
GIT_REMOTE_PORT ?=
endif
GIT_CONFIG_USER_NAME = $(shell git config --get user.name)
GIT_CONFIG_USER_EMAIL = $(shell git config --get user.email)
GITIGNORE := $(MLIB_ROOT_HOME)/.gitignore
$(GITIGNORE):
	@$(INFO) Writing default gitignore
	@echo -e "## Ignore files\n$(MLIB_CACHE_HOME:$(MLIB_ROOT_HOME)/%=%)/*\n" > $@ && $(STATUS_OK) || $(STATUS_KO)
	
_GIT_IS_DIRTY = $(shell [[ -n "$$(git status --porcelain 2>/dev/null)" ]] && printf "true" || :)
GIT_REPO_COMMITSCOUNT := 
ifeq ($(origin VERSION),command line) 
_GIT_LAST_TAG  != echo $(VERSION) 2>/dev/null 
else  
_GIT_LAST_TAG !=  git describe --tags --abbrev=0 2>/dev/null || echo ""
ifdef _GIT_LAST_TAG
_GIT_NCOMMITS_SINCE_TAG != git rev-list "$$(git describe --tags --abbrev=0 2>/dev/null)..HEAD" --count 2>/dev/null || printf 0
_GIT_LAST_TAG_HASH != git rev-parse --short $(_GIT_LAST_TAG) 2>/dev/null || printf ""
else
_GIT_LAST_TAG := 0.0.0
GIT_REPO_COMMITSCOUNT != git rev-list --all --count 2> /dev/null || echo ""
_GIT_NCOMMITS_SINCE_TAG := $(GIT_REPO_COMMITSCOUNT)
_GIT_LAST_TAG_HASH :=
endif
endif
VERSION_MAJOR = $(shell printf "$(_GIT_LAST_TAG)" | $(AWK) -F'.' '{print $$1}' | $(SED) -e s/^v//)
VERSION_MINOR = $(shell printf "$(_GIT_LAST_TAG)" | $(AWK) -F'.' '{print $$2}')
VERSION_PATCH = $(shell printf "$(_GIT_LAST_TAG)" | $(AWK) -F'.' '{print $$3}' | $(SED) -e 's/\([[:digit:]]*\).*/\1/')
VERSION := $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)
ifneq ($(origin VERSION),command line) 
_GIT_LAST_COMMIT_HASH != git rev-parse --short HEAD 2>/dev/null || printf 0000000
ifneq ($(_GIT_LAST_COMMIT_HASH),$(_GIT_LAST_TAG_HASH))
VERSION != printf "$(VERSION)+%s%s%s" \
	"$(if $(_GIT_NCOMMITS_SINCE_TAG),$(_GIT_NCOMMITS_SINCE_TAG),)" \
	".$(_GIT_LAST_COMMIT_HASH)" 
endif
else
endif
ifdef _GIT_IS_DIRTY
VERSION := $(VERSION).dirty
endif
VERSION ?= ##ro The version information for binaries and releases.
export VERSION
_GIT_NCOMMITS_SINCE_TAG ?=
_VERSION_REGEX := ^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*).*$$
VERSION_VALID = $(shell echo "$(VERSION)" | grep -Eq '$(_VERSION_REGEX)' && echo true || echo false)
common.buildvars:
	@echo GIT_PROJECT_NAME=$(GIT_PROJECT_NAME)
	@echo GIT_PROJECT_NAMESPACE=$(GIT_PROJECT_NAMESPACE)
	@echo GIT_PROJECT_REPO=$(GIT_PROJECT_REPO)
	@echo GIT_REMOTE_HOST=$(GIT_REMOTE_HOST)
	@echo BUILD_HOST=$(HOSTNAME)
	@echo MLIB_OUTPUT_HOME=$(subst $(MLIB_PROJECT_HOME),\$$\{MLIB_PROJET_HOME},$(MLIB_OUTPUT_HOME))
	@echo MLIB_CONFIG_HOME=$(subst $(MLIB_PROJECT_HOME),\$$\{MLIB_PROJET_HOME},$(MLIB_CONFIG_HOME))
	@echo MLIB_DATA_HOME=$(subst $(MLIB_ROOT_HOME),\$$\{MLIB_ROOT_HOME},$(MLIB_DATA_HOME))
	@echo MLIB_ROOT_HOME=$(MLIB_ROOT_HOME)
	@echo MLIB_PROJECT_HOME=$(MLIB_PROJECT_HOME)
	@echo MLIB_WORK_HOME=$(subst $(MLIB_DATA_HOME),\$$\{MLIB_DATA_HOME},$(MLIB_WORK_HOME))
	@echo MLIB_CACHE_HOME=$(subst $(MLIB_ROOT_HOME),\$$\{MLIB_ROOT_HOME},$(MLIB_CACHE_HOME))
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
$(foreach stage,init check code done,$(call bind_target_to_parent,img,build.$(stage)))
endif
_IS_IMAGE_CONTAINER_ENGINE_ON_SYSTEM = $(shell command -v $(IMAGE_CONTAINER_ENGINE))
.PHONY: img.registry.login img.push img.push.%
img.registry.login:
ifneq ($(filter-out img.%,$(MAKECMDGOALS)),$(MAKECMDGOALS))
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
.PHONY: promote.init promote.artifacts promote
promote.init: ; @:
promote.artifacts: ; @:
promote:
	@$(MAKE) promote.init
	@$(MAKE) promote.artifacts
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
RYE_USE_UV ?= true
RYE_DEFAULT_TOOLCHAIN ?= cpython@3.11.8
RYE_SYNC_NOLOCK ?=#-prevent the lock step from automatically running
RYE_SYNC_NODEV ?=#-sync based on the production lockfile
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
	echo -e "$(_TIME) $(_BLUE)[ ⛵ ]$(_CNONE_BOLD) Init project $(PYTHON_PROJECT_NAME) $*$(_CNone)"
	$(INFO) Python provided by $(strip $(PYTHON_PROVIDER)) in $(dir $(@D))
ifeq ($(strip $(PYTHON_PROVIDER)),micromamba)
	$(MICROMAMBA) create -y --root-prefix $(MLIB_WORK_HOME) --prefix $(PYTHON_PREFIX) $${PYTHON_PROVIDER_INSTALLOPTS:-python} && $(STATUS_OK) || $(FAIL)
endif
	$(RYE) sync $(RYE_SYNC_NOLOCK) $(RYE_SYNC_NODEV)
_PYTHON_BINS := COVERAGE MYPY MEMRAY PYRIGHT PYTEST TWINE RUFF SPHINX-AUTOBUILD YAMLLINT MKDOCS SQLFLUFF
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
	$(DASEL) -f pyproject.toml .tool.rye.dev-dependencies 2> /dev/null | $(GREP) ${*:%sphinx-build=%sphinx} > /dev/null && : || \
		($(INFO) Add $(@F) as dev feature && $(RYE) add --quiet --dev ${*:%sphinx-build=%sphinx} || :)
	$(RYE) sync --all-features --quiet && $(STATUS_OK) || $(STATUS_KO)
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
	@$(RYE) sync $(RYE_SYNC_NOLOCK) $(RYE_SYNC_NODEV) --quiet --all-features && $(STATUS_OK) || $(FAIL)
endif
RUFF_FORMAT_SRC ?= $(PYTHON_SRC_HOME) $(TEST_SRC_HOME)
$(call new_hooked_target,python.fmt)
RUFF_CHECK_OPTS := #- --select I --fixable I --fix
RUFF_FORMAT_OPTS := 
python.fmt.init: | $(RUFF) ; @: #- make sure they are installed in not present in pyproject.toml 
python.fmt.run: 
	$(INFO) Formating code with ruff 'format $(RUFF_FORMAT_OPTS)'
	msg=$$($(RUFF) format --config pyproject.toml $(RUFF_FORMAT_OPTS) $(RUFF_FORMAT_SRC)) && $(STATUS_OK) || $(STATUS_KO); echo "$${msg}"
RUFF_CHECK_SRC ?= $(PYTHON_SRC_HOME) $(TEST_SRC_HOME)
$(call new_hooked_target,python.lint.ruff)
python.lint.ruff.init: | $(RUFF); @:
python.lint.ruff.run: | $(PYTHON_SRC_HOME)
	@$(INFO) Running ruff
	msg=$$($(RUFF) check --config pyproject.toml $(RUFF_CHECK_OPTS) $(RUFF_CHECK_SRC)) && $(STATUS_OK) || $(STATUS_KO); echo "$${msg}"
$(call insert_hooked_target,ruff,python.lint)
$(call new_hooked_target,python.test.mypy)
$(call insert_hooked_target,mypy,python.test)
MYPY_OPTS ?=
PYTHON_TYPE_CHECK := false
ifeq ($(PYTHON_TYPE_CHECK),true)
python.test.mypy.init: | $(MYPY)
python.test.mypy.run:
	@$(INFO) Running mypy
	@$(MYPY) $(MYPY_OPTS) $(PYTHON_SRC_HOME) $(TEST_SRC_HOME) 
endif#
PYTEST_OPTS ?=
COVERAGE_FILE ?= $(MLIB_DATA_HOME)/python/coverage
COVERAGE_OPTS ?=
COVERAGE_OUTPUT_ ?= coverage.xml
COVERAGE_REPORT ?= $(MLIB_DATA_HOME)/python/coverage_report.xml
PYTHON_DISABLE_COVERAGE ?=
$(call new_hooked_target,python.test.pytest)
$(call new_hooked_target,python.test.coverage)
ifneq ($(PYTHON_DISABLE_COVERAGE),true)
$(call insert_hooked_target,coverage,python.test)
python.test: python.test.coverage
else
$(call insert_hooked_target,pytest,python.test)
python.test: python.test.pytest
endif
python.test: python.test.mypy
python.test.coverage.init: | $(COVERAGE) $(PYTEST)
python.test.coverage.run:
	mkdir -p $(dir COVERAGE_FILE)
	$(INFO) Running pytest with coverage report
	$(COVERAGE) run -m pytest -m "not e2e" --junitxml=$(COVERAGE_REPORT) $(PYTEST_OPTS) 5>/dev/null && : || ([[ $$? == 5 ]] && exit 0 || exit $$?)
python.test.coverage.done: 
		( $(INFO) Coverage report: ; \
		$(COVERAGE) report -m ) \
		|| $(WARN) No test in coverage report
python.test.pytest.init: | $(PYTEST)
python.test.pytest.run:
	@$(INFO) Running pytest
	@$(PYTEST) -m "not e2e" $(PYTEST_OPTS) \
		|| ([ $$? = 5 ] && exit 0 || exit $$?)
python.e2e.init: | $(PYTEST) $(BATS)
python.e2e.pytest.run:
	@$(INFO) Running e2e test with pytest
	$(PYTEST) -m "e2e" $(PYTEST_OPTS) || ([ $$? = 5 ] && exit 0 || exit $$?)
python.e2e.run: python.e2e.pytest.run
MEMRAY_OPTS ?=
python.test.memray.init: | $(MEMRAY)
python.test.memray.run:
	$(INFO) Running memray
ifndef MEMRAY_OPTS
	$(ERROR) MEMRAY_OPTS is not set
endif
	$(MEMRAY) $(MEMRAY_OPTS)
PYTHON_BUILD_SDIST ?= True
$(MLIB_OUTPUT_HOME)/pkg:
	@mkdir -p $@
RYE_BUILD_ALL ?= true
RYE_BUILD_CLEAN ?= 
RYE_BUILD_WHEEL ?= true
RYE_BUILD_SDIST ?= 
RYE_BUILD_OUTDIR ?= $(MLIB_OUTPUT_HOME)/pkg
RYE_BUILD_QUIET ?= true
RYE_BUILD_OPTS ?= 
RYE_BUILD_OPTS += $(if $(RYE_BUILD_ALL),--all,)
RYE_BUILD_OPTS += $(if $(RYE_BUILD_CLEAN),--clean,)
RYE_BUILD_OPTS += $(if $(RYE_BUILD_WHEEL),--wheel,)
RYE_BUILD_OPTS += $(if $(RYE_BUILD_SDIST),--sdist,)
RYE_BUILD_OPTS += --out $(RYE_BUILD_OUTDIR)
RYE_BUILD_OPTS += $(if $(RYE_BUILD_QUIET),--quiet,)
python.build.init: 
ifndef _IS_PYTHON_VIRTUALPROJECT
python.build.code: $(PYTHON_VERSION_PY) | $(MLIB_OUTPUT_HOME)/pkg
python.build.code: | $(PYTHON_PREFIX)/bin/python 
	@$(INFO) Building  
	$(RYE) build $(RYE_BUILD_OPTS) && $(STATUS_OK) || $(FAIL)
endif
python.version: tag
	$(INFO) Bump python project to $(VERSION)
	$(RYE) version $(VERSION) && $(STATUS_OK) || $(FAIL)
ifdef _IS_PYTHON_PROJECT
version: python.version
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
	@-$(RM) -Rf {**/,}__pycache__
python.distclean:
	@$(RM) -Rf \
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
$(foreach verb,$(MLIB_BASE_VERBS),$(call new_hooked_target,$(verb),:))
init: ; @: ##pr Init a new project
MLIB_INIT_LICENSE ?=
MLIB_INIT_CONTRIBUTING ?=
.gitignore:
	$(INFO) "Creating $@"
	echo ".git" >| $@
	echo $(subst $(MLIB_PROJECT_HOME)/,,$(MLIB_CACHE_HOME) $(MLIB_DATA_HOME) $(MLIB_OUTPUT_HOME) $(MLIB_LOCAL_BIN) $(MLIB_WORK_HOME)) .venv | tr " " "\n" >> $@  
	$(STATUS_OK) 
.git/config:
	$(INFO) "Initializing git repository"
	git init --quiet && ${STATUS_OK} || ${FAIL}
ifdef MLIB_INIT_CONTRIBUTING
CONTRIBUTING.md:
	$(INFO) "Creating $@"
	case "${MLIB_INIT_CONTRIBUTING}" in \
		http*) \
			$(CURL) -fsSL -o $@ "${MLIB_INIT_CONTRIBUTING}" \
			&& $(STATUS_OK) \
			|| $(STATUS_KO) \
			;; \
		*) \
			[[ -f "${MLIB_INIT_CONTRIBUTING}" ]] \
				&& cp "${MLIB_INIT_CONTRIBUTING}" $@ \
				&& $(STATUS_OK) \
				|| $(STATUS_KO) \
			;; \
	esac
endif
LICENSE:
ifdef MLIB_INIT_LICENSE
	$(INFO) "Creating $@"
	case "${MLIB_INIT_LICENSE}" in \
		http*) \
			$(CURL) -fsSL -o $@ "${MLIB_INIT_LICENSE}" \
			&& $(STATUS_OK) \
			|| $(STATUS_KO) \
			;; \
		*) \
			[[ -f "${MLIB_INIT_CONTRIBUTING}" ]] \
				&& cp "${MLIB_INIT_CONTRIBUTING}" CONTRIBUTING.md \
				&& $(STATUS_OK) \
				|| $(STATUS_KO) \
			;; \
	esac
else
endif
%.md:
	$(INFO) "Creating $@"
	 echo "# $*" >| $@  \
		&& $(STATUS_OK) \
		|| $(STATUS_KO)
init: | .gitignore .git/config README.md CHANGELOG.md CONTRIBUTING.md LICENSE 
sync:##pr Synchronize the projet data and dependencies
 
DISABLE_YAML_LINT ?=
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
lint.yaml.init: | $(YAMLLINT)
lint.yaml.run: 
	@$(INFO) Running yamllint
	@$(YAMLLINT) -c $(YAMLLINT_CONFIG_FILE) . && $(STATUS_OK) || $(STATUS_KO)
lint.yaml.done:
ifndef DISABLE_YAML_LINT
$(call insert_hooked_target,yaml,lint)
endif
SQLFLUFF_LINT_OPTS ?= 
lint.sql.init: | $(SQLFLUFF) ; @:
lint.sql.run: 
	@$(INFO) Running sqlfluff
	@[ -n "$(filter --dialect,$(SQLFLUFF_LINT_OPTS))" ] && : || ( $(STATUS_KO) && $(ERR) --dialect option is required in $$\(SQLFLUFF_LINT_OPTS\))
	@$(SQLFLUFF) lint $(SQLFLUFF_LINT_OPTS) . > /dev/null && $(STATUS_OK) || $(STATUS_KO)
DISABLE_SQL_LINT ?=
ifdef DISABLE_SQL_LINT
$(call insert_hooked_target,sql,lint)
endif
 
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
$(call new_hooked_target,sphinx)
sphinx.init: | $(SPHINX_CONF_PY); @:
ifdef _IS_SPHINX_CONFIGURED
SPHINX_LINKCHECK_ENABLE ?=#- set to check links
SPHINX_LINKCHECK_HOME ?= $(MLIB_OUTPUT_HOME)/linkcheck#- path to linkcheck output
SPHINX_AUTOBUILD_OPTS += --watch $(PYTHON_SRC_HOME)#- sphinx_autobuild options passed to the cli
SPHINX_BUILD_OPTS += -b html#- sphinx_build options passed to the cli 
sphinx.watch: | $(SPHINX_AUTOBUILD)
	@$(INFO) Building doc with sphinx 
	@$(SPHINX_AUTOBUILD) $(SPHINX_AUTOBUILD_OPTS) "$(DOC_SRC_HOME)" "$(MLIB_OUTPUT_HOME)/doc" 
sphinx.run:
	@$(INFO) Building doc with sphinx
	@$(SPHINX_BUILD) $(SPHINX_BUILD_OPTS) "$(DOC_SRC_HOME)" "$(MLIB_OUTPUT_HOME)/doc" 
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
.PHONY: mkdocs.init
mkdocs.init: $(MKDOCS_CONF_PY); @:
docs.publish:
 
.PHONY: tag
tag: ##rt Tag a release
ifeq ($(GIT_REPO_COMMITSCOUNT),0)
	$(ERR) Please initialize HEAD by commiting first; exit 1
endif
ifneq ($(origin VERSION),command line)
ifdef _GIT_IS_DIRTY
	$(WARN) "git is dirty, tag to $(VERSION)."
	read -p "Are you sure (y/n) " confirm; \
		[ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ] || (echo "Aborted" && exit 1)
endif
endif
ifneq ($(VERSION_VALID),true)
	$(error invalid version $(VERSION). must be a semantic version with v[Major].[Minor].[Patch] only)
endif
	git tag --list | $(GREP) -q "^$(VERSION)$$" \
		&& $(ERR) $(VERSION) already exists \
		|| ( $(INFO) tagging commit $(GIT_COMMIT_HASH) with $(VERSION) && \
			git tag -f -m "Release $(VERSION)" $(VERSION) >/dev/null \
			&& ${STATUS_OK} \
			|| ( git tag -d $(VERSION); $(FAIL) ) )
	$(INFO) Pushing to remote $(GIT_REMOTE_NAME)
	git push --tags $(GIT_REMOTE_NAME) >/dev/null 2>&1 \
		&& $(STATUS_OK) \
		|| ( $(ERR) Could not push tag to remote $(GIT_REMOTE_NAME); $(FAIL) )
.PHONY: release release.CHANGELOG release.src release.vcs release.gh release.glab 
release: build ##rt Create a release on the server
release%: VERSION=$(_GIT_LAST_TAG:v%=%)
release.src:
ifeq ($(origin VERSION),command line)
	$(MAKE) tag VERSION=v$(VERSION:v%=%)
else
ifneq ($(_GIT_NCOMMITS_SINCE_TAG),0)
	$(ERR) Release must be done on a tag; exit 1
endif
endif
	[[ $(VERSION_MAJOR) =~ ^[0-9]+$$ ]] || ( $(ERR) "VERSION_MAJOR must be an integer" && exit 1 )
	[[ $(VERSION_MINOR) =~ ^[0-9]+$$ ]] || ( $(ERR) "VERSION_MINOR must be an integer" && exit 1 )
	_RELEASE_BRANCH="release-$(VERSION_MAJOR).$(VERSION_MINOR)" && \
		if [[ -z "$$(git branch --list $${_RELEASE_BRANCH})" ]]; then \
			$(INFO) Creating branch $${_RELEASE_BRANCH} && \
			( git branch $${_RELEASE_BRANCH} && $(STATUS_OK) || $(FAIL) ); \
		fi && \
		git branch -f $${_RELEASE_BRANCH} $(GIT_COMMIT_HASH) && \
		$(INFO) Push to branch $(GIT_BRANCH_NAME) && \
		git push --quiet -u $(GIT_REMOTE_NAME) HEAD > /dev/null 2>&1 \
			&& $(STATUS_OK) \
			|| $(FAIL) && \
		$(INFO) Push to branch $${_RELEASE_BRANCH} && \
		git push --quiet $(GIT_REMOTE_NAME) $${_RELEASE_BRANCH} > /dev/null \
			&& $(STATUS_OK) \
			|| $(FAIL)
MLIB_RELEASE_ARTIFACTS ?= $(wildcard $(MLIB_CONFIG_HOME)/mlib/release_artifacts.yml)
_RELEASE_FILES_LIST = $(shell $(YQ) e '.release.files[]' $(MLIB_RELEASE_ARTIFACTS))
release.gh: | $(GH)
	$(GH) release create \
		v$(VERSION:v%=%) \
		--latest \
		-F CHANGELOG.md
ifdef MLIB_RELEASE_ARTIFACTS
	$(GH) release upload \
		v$(VERSION:v%=%) 
endif
release.glab: | $(GLAB)
	NO_PROMPT=1 $(GLAB) release create \
		v$(VERSION:v%=%) \
		--name "$(GIT_PROJECT_NAME) v$(VERSION:v%=%)" \
		--notes-file release.CHANGELOG
release.vcs: release.CHANGELOG | $(YQ)
	( curl -LIs $(GIT_REMOTE_HOST) | grep -q github ) \
		&& $(MAKE) release.gh \
		|| $(MAKE) release.glab
release: release.src release.vcs
.INTERMEDIATE:
release.CHANGELOG:
	case $$(git tag --sort=creatordate | $(TAIL) -n 2 | $(WC) -l) in \
		0) ( $(ERR) There should be at least one tag ) ;; \
		1) git_refs=$$(git tag --list) \
			&& git diff $${git_refs}..HEAD -- CHANGELOG.md | \
				$(GREP) '^+' | $(SED) 's/^+//' | $(TAIL) -n +2 \
				$(SED) '/^## v$(VERSION:v%=%)$$/d'> $@ ;; \
		2) git_refs=$$(git tag --sort=creatordate | \
			$(TAIL) -n 2 | $(XARGS) | $(SED) -E 's/\s/../') \
			&& git diff $${git_refs} -- CHANGELOG.md | \
				$(GREP) '^+' | $(SED) 's/^+//' | $(TAIL) -n +2 |\
				$(SED) '/^## v$(VERSION:v%=%)$$/d'> $@ ;; \
		*) $(ERR) There should be only one tag && $(FAIL) ;; \
	esac
version.isdirty:
ifeq ($(ALLOW_DIRTY),)
	@if [[ $(VERSION) = *.dirty ]]; then \
		$(ERR) version '$(VERSION)' is dirty aborting publish. The following files changed: ;\
		git status --short;\
		exit 1; \
	fi
endif
.PHONY: clean distclean
clean: ##ct Remove files created during build.
	@$(INFO) Removing output directory $(call rel_path,$(MLIB_OUTPUT_HOME))
	@rm -fr $(MLIB_OUTPUT_HOME) && $(STATUS_OK) || $(STATUS_KO)
distclean: clean ##ct Remove files created during build including cached
	@$(INFO) Removing cache
	@rm -fr $(MLIB_CACHE_HOME) && $(STATUS_OK) || $(STATUS_KO)
ifneq ($(call normalize-bool,$(USE_SYSTEM_TOOLS)),true)
	@$(INFO) Removing tools
	@rm -fr $(MLIB_LOCAL_BIN) && $(STATUS_OK) || $(STATUS_KO)
endif
	@$(INFO) Removing working directory
	@rm -fr $(MLIB_WORK_HOME) && $(STATUS_OK) || $(STATUS_KO)
 
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
$(call new_hooked_target,bash.fmt)
bash.fmt.init: | $(SHFMT)
bash.fmt.run:
	$(ERR) Not implemented
$(call new_hooked_target,bash.test)
bash.test.init: | $(BATS)
WM != command -v watchman-make
WM_TEST_TARGET ?=
WM_TEST_PATTERN ?= bash.test
bash.test.watch:
ifndef WM
	$(ERR) Please install watchman-make
endif
	[[ -z "$(WM_TEST_PATTERN)" ]] && \
		$(ERR) WM_TEST_PATTERN is not defined || :
	$(WM) -p $(WM_TEST_PATTERN) -t $(WM_TEST_TARGET)
 
JUPYTER_CONFIG_PATH ?= $(MLIB_CONFIG_HOME)/jupyter
JUPYTER_KERNEL_SPEC := /tmp/_fixme/kernel.json
$(JUPYTER_KERNEL_SPEC):
	$(INFO) Installing ipykernel
	$(PYTHON_PREFIX)/bin/python -m ipykernel install \
		--user \
		--name=$(GIT_PROJECT_NAME) \
		--env JUPYTER_CONFIG_PATH "$(JUPYTER_CONFIG_PATH)" >/dev/null && \
		${STATUS_OK} || ${FAIL}
$(JUPYTER_CONFIG_PATH)/jupyter_lab_config.py:
	mkdir -p $(@D) || ${FAIL}
	$(INFO) Creating empty juputer lab configuration
	JUPYTER_CONFIG_DIR=$(@D) \
		$(JUPYTERLAB) \
		--generate-config \
		-y >/dev/null \
		&& ${STATUS_OK} || ${FAIL}
jupyter.init: $(JUPYTER_CONFIG_PATH)/jupyter_lab_config.py $(JUPYTER_KERNEL_SPEC)
MPLCONFIGDIR ?=
MATPLOTLIBRC ?=
MATPLOTLIB_CONFIG_PATH := $(if $(MPLCONFIGDIR),$(MPLCONFIGDIR),$(if $(MATPLOTLIBRC),$(MATPLOTLIBRC:/matplotlibrc=),$(MLIB_CONFIG_HOME)/matplotlib))
MATPLOTLIBRC := $(MATPLOTLIB_CONFIG_PATH)/matplotlibrc
$(MATPLOTLIBRC):
	mkdir -p $(@D)
	$(CURL) -L https://raw.githubusercontent.com/matplotlib/matplotlib/main/lib/matplotlib/mpl-data/matplotlibrc -o $@
matplotlib.init: $(MATPLOTLIBRC)
DUCKDB_VERSION := 0.10.1
_DUCKDB_REMOTE_SRC := https://github.com/duckdb/duckdb/releases/download/v$(DUCKDB_VERSION)/duckdb_cli-$(if ifeq($(HOST_ARCH), darwin),osx-universal,$(HOST_OS)-$(HOST_ARCH)).zip
DUCKDB := $(MLIB_LOCAL_BIN)/duckdb
$(DUCKDB): 
	@$(INFO) Install duckdb $(DUCKDB_VERSION)
	@mkdir -p $(MLIB_CACHE_HOME)/scm
	@$(CURL) -s -C - -L $(_DUCKDB_REMOTE_SRC) -o ${MLIB_CACHE_HOME}/scm/$(@F).zip
	@mkdir -p $(MLIB_LOCAL_BIN)
	@msg=$$(unzip -d $(@D) ${MLIB_CACHE_HOME}/scm/$(@F).zip 2>&1) && $(STATUS_OK) || $(FAIL)
	@chmod +x $@
KAGGLE := $(RYE_HOME)/tools/kaggle/bin/kaggle
KAGGLE_COMPETITION ?= titanic
KAGGLE_DATA_HOME := $(MLIB_CACHE_HOME)/kaggle/$(KAGGLE_COMPETITION)
KAGGLE_RAWDATA_HOME := $(KAGGLE_DATA_HOME)/raw
KAGGLE_TRAINDATA_HOME := $(KAGGLE_DATA_HOME)/train
KAGGLE_TESTDATA_HOME := $(KAGGLE_DATA_HOME)/test
KAGGLE_DEVDATA_HOME := $(KAGGLE_DATA_HOME)/dev
KAGGLE_TRADEV_HOME := $(KAGGLE_DATA_HOME)/train+dev
_KAGGLE_COMPETITION_FILE_LIST := $(KAGGLE_DATA_HOME)/competition_file_list.csv
.INTERMEDIATE: $(_KAGGLE_COMPETITION_FILE_LIST)
$(_KAGGLE_COMPETITION_FILE_LIST):
	mkdir -p $(@D)
	$(KAGGLE) competitions files -c $(KAGGLE_COMPETITION) -v > $@
$(KAGGLE_RAWDATA_HOME)/%: $(KAGGLE)
	$(INFO) downloading $*
	mkdir -p $(@D)
	$(KAGGLE) competitions download \
		-q -f "$*" \
		-c $(KAGGLE_COMPETITION) \
		-p $(@D) \
	&& $(STATUS_OK) \
	|| $(STATUS_KO)
.PHONY: kaggle
$(call new_hooked_target,kaggle)
kaggle.init: | $(KAGGLE) $(MLR)
kaggle.run: $(_KAGGLE_COMPETITION_FILE_LIST) 
	$(INFO) Retrieving raw data
	$(MAKE) -j 4 $(addprefix $(KAGGLE_RAWDATA_HOME)/,$(shell cat $< | $(MLR) --csv --headerless-csv-output cut -f "name" | xargs ))
ifdef _IS_GOLANG_PROJECT
$(call register_mlib_namespace,go)
endif
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
GO_TEST_DIR = $(abspath $(MLIB_OUTPUT_HOME)/test)
GO_TEST_OUTPUT = $(GO_TEST_DIR)/$(PLATFORM)
GO_LINT_DIR = $(abspath $(MLIB_OUTPUT_HOME)/lint)
GO_LINT_OUTPUT = $(GO_LINT_DIR)/$(PLATFORM)
ifneq ($(GO_PKG_DIR),)
GO_PKG_BASE_DIR := $(abspath $(GO_PKG_DIR)/$(PLATFORM))
GO_PKG_STATIC_FLAGS := -pkgdir $(GO_PKG_BASE_DIR)_static
endif
GO_COMMON_FLAGS = $(GO_BUILDFLAGS) -tags '$(GO_TAGS)'
GO_STATIC_FLAGS = $(GO_COMMON_FLAGS) $(GO_PKG_STATIC_FLAGS) -installsuffix static  -ldflags '$(GO_LDFLAGS)'
GO_GENERATE_FLAGS = $(GO_BUILDFLAGS) -tags 'generate $(GO_TAGS)'
GO_STATIC_PACKAGES ?= 
.PHONY: go.init 
go.init:
ifndef _IS_GOLANG_PROJECT
	$(GO) mod init $(GO_PROJECT)
endif
	if ! `$(GO) version | grep -q -E '\bgo($(GO_SUPPORTED_VERSIONS))\b'`; then \
		$(ERR) unsupported go version. Please make install one of the following supported version: '$(GO_SUPPORTED_VERSIONS)' ;\
		exit 1 ;\
	fi
ifdef _IS_GOLANG_PROJECT
_CMD_TO_BUILD := $(foreach cmd,$(GO_CMD_PATH),$(MLIB_LOCAL_BIN)/$(notdir $(cmd:/=)))
.SECONDEXPANSION:
$(MLIB_LOCAL_BIN)/%: $$(wildcard cmd/%/*.go) $$(wildcard cmd/%/**/*.go)
	@$(INFO) go build $(_MAGENTA)$(@F)$(_CNone) # $(subst $(MLIB_OUTPUT_HOME)/,'',$@)
	@$(GO) build -o $@ "./cmd/$(subst $(MLIB_LOCAL_BIN)/,,$@)" && $(STATUS_OK) || $(FAIL)
go.build: $(_CMD_TO_BUILD)
go.install:
	@$(INFO) go install $(PLATFORM)
	$(foreach p,$(GO_STATIC_PACKAGES),@$(GO) install -v $(GO_STATIC_FLAGS) $(p) || $(FAIL) ${\n})
	@$(OK) go install $(PLATFORM)
ifdef CI
go.test.unit: $(GOJUNIT)
endif
go.test.unit:
	$(INFO) go test unit-tests
ifeq ($(GO_NOCOV),true)
	$(WARN) coverage analysis is disabled
	$(GOHOST) test $(GO_TEST_FLAGS) $(GO_STATIC_FLAGS) $(GO_PACKAGES) || $(FAIL)
else
	@mkdir -p $(GO_TEST_OUTPUT)
	@$(GOHOST) test -cover $(GO_STATIC_FLAGS) $(GO_PACKAGES) || $(FAIL)
	@$(GOHOST) test -v -covermode=$(GO_COVER_MODE) -coverprofile=$(GO_TEST_OUTPUT)/coverage.txt $(GO_TEST_FLAGS) $(GO_STATIC_FLAGS) $(GO_PACKAGES) 2>&1 | tee $(GO_TEST_OUTPUT)/unit-tests.log || $(FAIL)
ifdef CI
	@cat $(GO_TEST_OUTPUT)/unit-tests.log | $(GOJUNIT) -set-exit-code > $(GO_TEST_OUTPUT)/unit-tests.xml || $(FAIL)
endif
endif
	@$(OK) go test unit-tests
go.test.run: go.test.unit
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
ifdef CI
GOLANGCI_LINT_OPTS := --timeout 10m0s --out-format=checkstyle > $(GO_LINT_OUTPUT)/checkstyle.xml
else
GOLANGCI_LINT_OPTS :=
endif
GOLANGCI_LINT_CONFIG := $(MLIB_CONFIG_HOME)/golangci/golangci.yml
$(GOLANGCI_LINT_CONFIG):
	$(INFO) Creating golangci-lint config file
	mkdir -p $(@D)
	touch $@ && $(STATUS_OK) || $(STATUS_KO)
$(call new_hooked_target,go.lint.golangci)
go.lint.golangci.init: | $(GOLANGCI_LINT) $(GOLANGCI_LINT_CONFIG)
go.lint.golangci.run: 
	@$(INFO) Running golangci-lint
	@mkdir -p $(GO_LINT_OUTPUT)
	@$(GOLANGCI_LINT) run \
		-c $(GOLANGCI_LINT_CONFIG) \
		$(GOLANGCI_LINT_OPTS) \
		&& $(STATUS_OK) || $(FAIL)
$(call insert_hooked_target,golangci,go.lint)
go.vet:
	@$(INFO) Running $(_MAGENTA)go vet $(PLATFORM)$(_CNone)
	@echo $(GO_PACKAGES)
	@$(GOHOST) vet $(GO_COMMON_FLAGS) $(GO_PACKAGES) $(GO_INTEGRATION_TEST_PACKAGES) && $(STATUS_OK) || $(FAIL)
go.lint: go.vet
go.fmt.init: 
go.fmt.run: 
	@$(INFO) Running $(_MAGENTA)gofmt$(_CNone)
	@gofmt_out=$$($(GOFMT) -l $(GO_SUBDIRS) $(GO_INTEGRATION_TESTS_SUBDIRS) 2>&1) && ([ -z "$${gofmt_out}" ] && $(STATUS_OK) || ($(STATUS_KO) && printf "Files would be modified by gofmt:\n$${gofmt_out}")) || $(FAIL)
go.fmt.done: 
.PHONY: go.build go.install go.test.unit go.test.integration go.test.codecov go.lint go.vet 
.PHONY: go.vendor go.vendor.check go.vendor.update 
go.vendor.check:
	@$(INFO) Verify dependencies have expected content
	@$(GOHOST) mod verify 1>/dev/null  && $(STATUS_OK) || $(STATUS_KO)
go.vendor.update:
	@$(INFO) Update go modules
	@$(GOHOST) get -u ./... && $(STATUS_OK) || $(STATUS_KO)
go.vendor:
	@$(INFO) go mod vendor
	@$(GOHOST) mod vendor && $(STATUS_OK) || $(STATUS_KO)
.PHONY: go.clean go.distclean go.generate 
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
ifeq ($(call normalize-bool,$(USE_SYSTEM_TOOLS)),true)
NVMSH := $(XDG_CACHE_HOME)/nvm/nvm.sh
else
NVMSH := $(MLIB_CACHE_HOME)/nvm/nvm.sh
endif
NVM = source $(NVMSH) && nvm
NODE = $(NVM) use $(NODE_VERSION) > /dev/null; node
NPM = $(NVM) use $(NODE_VERSION) > /dev/null; npm
YARN = $(NVM) use $(NODE_VERSION) > /dev/null; yarn
DEFAULT_JS_RUNTIME := $(NODE)
DEFAULT_JS_PKGMGR := $(NPM)
TAILWINDCSS := $(BUN) x tailwindcss
ifdef _IS_NODEJS_PROJECT 
$(call register_mlib_namespace,node)
endif
ifndef USE_SYSTEM_TOOLS
$(NVMSH):
	@$(INFO) Installing $(@F)
	@git clone --quiet --depth 1 https://github.com/nvm-sh/nvm $(@D) && $(STATUS_OK) || $(STATUS_KO)
	@chmod +x $@
node.init: init | $(NVMSH) $(BUN)
endif
node.init: 
ifeq ($(DEFAULT_JS_RUNTIME),$(NODE))
ifeq ($(DEFAULT_JS_PKGMGR),$(NPM))
	$(NPM) init -y
else ifeq ($(DEFAULT_JS_PKGMGR),$(YARN))
	$(YARN) init -y
else
$(error unsupported default js package manager: $(DEFAULT_JS_PKGMGR))
endif
else
$(error unsupported default js runtime: $(DEFAULT_JS_RUNTIME))
endif
bun.sync: $(BUN)
	$(BUN) install
ESBUILD := $(MLIB_CACHE_HOME)/bun/esbuild
ESLINT := $(MLIB_CACHE_HOME)/bun/eslint
NODEMON := $(MLIB_CACHE_HOME)/bun/nodemon
TAILWINDCSS := $(MLIB_CACHE_HOME)/bun/tailwindcss
BROWSER_SYNC  := $(MLIB_CACHE_HOME)/bun/browser-sync
_NODE_BIN := $(ESBUILD) $(ESLINT) $(BROWSER_SYNC) $(NODEMON) $(TAILWINDCSS)
.INTERMEDIATE: $(_NODE_BIN)
$(_NODE_BIN): $(BUN)
	$(INFO) Making $@
	mkdir -p $(@D)
	echo '$(BUN) x $(@F) $$@' > $@
	chmod +x $@
BROWSER_SYNC_OPTS += start --server --files '$(DOC_SRC_HOME)/**/*' --no-open
ESLINT_CONF_HOME := $(MLIB_CONFIG_HOME)/eslint
$(ESLINT_CONF_HOME)/eslintrc.js:
	$(INFO) Creating eslint config file
	mkdir -p $(@D)
	touch $@ \
		&& $(STATUS_OK) \
		|| $(STATUS_KO)
ESLINT_OPTS += --config $(ESLINT_CONF_HOME)/eslintrc.js
ESLINT_OPTS += --cache-location $(MLIB_CACHE_HOME)/eslint
$(call new_hooked_target,node.lint)
$(call insert_hooked_target,eslint,node.lint)
PRETTIER_RUN_CONF := $(MLIB_CONFIG_HOME)/prettier/prettierrc.yml
$(PRETTIER_RUN_CONF):
	$(INFO) Creating prettier config file
	mkdir -p $(@D)
	touch $@ \
		&& $(STATUS_OK) \
		|| $(STATUS_KO)
PRETTIER_OPTS += --config $(PRETTIER_RUN_CONF)
$(call new_hooked_target,node.fmt)
$(call insert_hooked_target,prettier,node.fmt)
node.fmt.prettier.init: $(BUN) $(PRETTIER_RUN_CONF) ; :
node.fmt.prettier.run: 
	$(INFO) format ts and js files
	#- $(BUN) x prettier $(PRETTIER_OPTS) $(shell find $(DOC_SRC_HOME) -iname "*.js" -o -iname "*.ts") 
	#- $(BUN) x prettier $(PRETTIER_OPTS) $(shell find $(TS_SRC_HOME) -iname "*.js" -o -iname "*.ts") 
	# \
	# 	&& $(STATUS_OK) \
	# 	|| $(STATUS_KO)
node.fmt.prettier.done: 
	$(INFO) done formatting ts and js files
TYPEDOC_RUN_CONF := $(MLIB_CONFIG_HOME)/node/typedoc.json
NODEMON_RUN_CONF := $(MLIB_CONFIG_HOME)/node/nodemon.json
$(TYPEDOC_RUN_CONF) $(NODEMON_RUN_CONF):
	$(INFO) Creating $(@AF) config file
	mkdir -p $(@D)
	echo "{}" >| $@ \
		&& $(STATUS_OK) \
		|| $(STATUS_KO)
TYPEDOC := $(BUN) x typedoc
TYPEDOC_OPTS += --options $(TYPEDOC_RUN_CONF)
TYPEDOC_OPTS += --out $(MLIB_OUTPUT_HOME)/doc
TYPEDOC_CMD = $(TYPEDOC) $(TYPEDOC_OPTS)
NODEMON := $(BUN) x nodemon
NODEMON_OPTS += --config $(NODEMON_RUN_CONF)
NODEMON_OPTS += -e ts,tsx,js,jsx,json,html,css,htmx
NODEMON_CMD = $(NODEMON) $(NODEMON_OPTS)
$(call new_hooked_target,node.doc)
node.doc.typedoc.init: $(BUN) | $(TYPEDOC_RUN_CONF) ; :
node.doc.typedoc.run: 
	$(INFO) Generate documentation for ts files
	$(TYPEDOC_CMD)
node.doc.watch:
	$(INFO) Watching $(MLIB_PROJECT_HOME)
	$(INFO) Serve $(DOC_SRC_HOME)
	$(NODEMON_CMD) \
		--watch src \
		--exec "$(BROWSER_SYNC) start --server --files '$(DOC_SRC_HOME)/**/*' --no-open"
$(call new_hooked_target,observable)
OBSERVABLE_FRAMEWORK_CONFIG := $(DOC_SRC_HOME)/observablehq.config.js
OBSERVABLE_CACHE_HOME := $(DOC_SRC_HOME)/src/.observablehq/cache
$(OBSERVABLE_FRAMEWORK_CONFIG):
	$(INFO) Creating empty observablehq config file
	mkdir -p $(@D)
ifdef https_proxy
	echo "import { ProxyAgent, setGlobalDispatcher } from 'undici';" >> $@
	echo "const proxyAgent = new ProxyAgent({ uri: process.env.https_proxy });" >> $@
	echo "setGlobalDispatcher(proxyAgent);" >> $@
endif
	echo -e "export default {\n    title: '$(GIT_PROJECT_NAME)',\n    root: 'src'}" >> $@ && $(STATUS_OK) || $(STATUS_KO)
$(DOC_SRC_HOME)/node_modules/@observablehq/framework/package.json: | $(BUN)
	mkdir -p $(DOC_SRC_HOME)
	$(INFO) Add ObservableHQ framework
ifdef https_proxy
	$(BUN) add --silent --cwd $(DOC_SRC_HOME) undici 
endif
	$(BUN) add --silent --cwd $(DOC_SRC_HOME) @observablehq/framework d3-dsv d3-time-format
$(DOC_SRC_HOME)/index.md:
	touch $@
observable.init: | $(DOC_SRC_HOME)/node_modules/@observablehq/framework/package.json $(BUN) $(OBSERVABLE_FRAMEWORK_CONFIG) $(DOC_SRC_HOME)/index.md
	$(BUN) install --cwd $(DOC_SRC_HOME) --silent
observable.watch: observable.init 
	cd $(DOC_SRC_HOME) && \
		$(BUN) x observable preview
observable.clean:
	[[ -d $(OBSERVABLE_CACHE_HOME) ]] \
		&& rm -Rf $(OBSERVABLE_CACHE_HOME) \
		|| true
	[[ -d $(DOC_SRC_HOME)/node_modules ]] \
		&& rm -Rf $(DOC_SRC_HOME)/node_modules \
		|| true
ifdef _IS_OBSERVABLE_CONFIGURED
doc.watch: observable.watch
endif
YARN_MODULE_HOME := node_modules
YARN_PACKAGE_FILE := package.json
YARN_PACKAGE_LOCK_FILE := yarn.lock
YARN_DIST_HOME := dist
YARN_SRC_HOME := bundle
YARN_DOC_HOME := doc
YARN_TEST_HOME := test
TS_SRC_HOME ?= src
YARN_OUTDIR ?= $(MLIB_OUTPUT_HOME)/yarn
$(YARN_SRC_HOME)/main.ts:
	@mkdir -p $(@D)
	@touch $@
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
PLUGIN_SRC_DIR = $(realpath .) #- Should not be changed
NVIM_TEST_INIT = $(MLIB_WORK_HOME)/init.lua
NVIM_TEST_HOME ?= $(TEST_SRC_HOME)
PACK_PATH=$(MLIB_WORK_HOME)
PLENARY_DIR ?= $(PACK_PATH)/pack/foobar/start/plenary.nvim
PLENARY_OPTIONS ?= PlenaryBustedDirectory ${NVIM_TEST_HOME} { \
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
ifdef USE_SYSTEM_TOOLS
STYLUA := $(shell command -v stylua 2> /dev/null)
else
STYLUA_VERSION ?= v0.20.0
STYLUA := $(MLIB_LOCAL_BIN)/stylua-$(DASEL_VERSION)
STYLUA_URL := https://github.com/JohnnyMorganz/StyLua/releases/download/$(STYLUA_VERSION)/stylua-$(HOST_OS:darwin%=macos%)-$(patsubst arm64,aarch64,$(HOST_ARCH:amd64%=x86_64%)).zip
$(STYLUA):
	@$(INFO) Installing stylua
	@$(LUAROCKS) install --tree $(MLIB_LOCAL_BIN) stylua
endif
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
CI_BASE_IMAGE := debian:latest
CI_WORKDIR := /build
define DOCKERFILE = 
FROM $(CI_BASE_IMAGE) as ci-image
ARG MAKE_VERSION=4.4.1
RUN apt-get update && \
    apt-get install -y make bash coreutils \
    git ncurses-bin curl gcc gh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN curl -LO http://ftp.gnu.org/gnu/make/make-$${MAKE_VERSION}.tar.gz && \
    tar -xzf make-$${MAKE_VERSION}.tar.gz && \
    cd make-$${MAKE_VERSION} && \
    ./configure &&  make && make install &&  cd .. && \
    rm -Rf make-$${MAKE_VERSION}.tar.gz make-$${MAKE_VERSION} && \
    cd
FROM ci-image as build
$(if $(TEST_SRC_HOME),COPY $(TEST_SRC_HOME:$(THIS_DIR)/%=%) /$(CI_WORKDIR:/%=%)/$(TEST_SRC_HOME:$(THIS_DIR)/%=%))
$(if $(DOC_SRC_HOME),COPY $(DOC_SRC_HOME:$(THIS_DIR)/%=%) $(CI_WORKDIR:/%=%)/$(DOC_SRC_HOME:$(THIS_DIR)/%=%))
$(if $(_IS_PYTHON_PROJECT),COPY $(PYTHON_SRC_HOME:$(THIS_DIR)/%=%) /$(CI_WORKDIR:/%=%)/$(PYTHON_SRC_HOME:$(THIS_DIR)/%=%))
$(if $(wildcard pyproject.toml),COPY pyproject.toml /$(CI_WORKDIR:/%=%)/)
$(if $(wildcard _own_version_helper.py),COPY _own_version_helper.py /$(CI_WORKDIR:/%=%)/)
$(if $(wildcard package.json),COPY package.json /$(CI_WORKDIR:/%=%)/)
$(if $(wildcard go.mod),COPY go.mod /$(CI_WORKDIR:/%=%)/)
$(if $(THIS),COPY $(THIS) /$(CI_WORKDIR:/%=%)/Makefile)
$(shell if [ "$(THIS)" = "$(MLIB)" ]; then echo "COPY $(MLIB) /$(CI_WORKDIR:/%=%)/Makefile";else echo "COPY $(MLIB) /$(CI_WORKDIR:/%=%)/$(shell dirname $(MLIB))/"; fi)
$(if $(MAKEFILES),ENV MAKEFILES $(MAKEFILES))
WORKDIR /$(CI_WORKDIR:/%=%)
ENV USE_GLOBAL_TOOLS=true
RUN git init && make info && make sync 
FROM ci-image
COPY --from=build /root /root
RUN mkdir /build
WORKDIR /build
endef
export DOCKERFILE
ci.build:
	$(INFO) "Building CI image"
ifndef CI
	echo "$$DOCKERFILE" | $(PODMAN) build -t ci-image -f- .
else
	echo "$$DOCKERFILE" | $(DOCKER) build -t ci-image -f- .
endif
FOOFOO :=
foofoo: 
	echo "$$DOCKERFILE"
 
.git/hooks/pre-commit:
	echo "make precommit.run" > $@
precommit.init: .git/hook/pre-commit ; @:
precommit.run: ; @:
precommit.done: ; @:
else
$(warning MAKEFILES is set and some files are included in the Makefile you run, skipping loading mlib to avoid overloads)
endif