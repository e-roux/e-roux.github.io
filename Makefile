serve: doc.watch

this.build: .EXTRA_PREREQS += $(NPM)
this.build:
	$(INFO) "Building documentation"
	$(NPM) run build

build.code: this.build
