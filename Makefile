# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

GO=go
BINDIR=$(CURDIR)/bin
DEPS?=true
STATIC?=false
LDFLAGS=

ifeq ($(STATIC), true)
	LDFLAGS=-a -tags netgo -installsuffix netgo
endif

all: ghost overlordd

deps:
	mkdir -p $(BINDIR)
	if $(DEPS); then \
		cd $(CURDIR)/overlord; \
		$(GO) get -d .; \
	fi

overlordd: deps
	cd $(CURDIR)/cmd/$@ && GOBIN=$(BINDIR) $(GO) install $(LDFLAGS) .
	rm -f $(BINDIR)/app
	ln -s $(CURDIR)/overlord/app $(BINDIR)

ghost: deps
	cd $(CURDIR)/cmd/$@ && GOBIN=$(BINDIR) $(GO) install $(LDFLAGS) .

clean:
	rm -f $(BINDIR)/ghost $(BINDIR)/overlordd
