.PHONY: help check smoke shellcheck install test

help:
	@echo "targets: check smoke shellcheck install test"

check: shellcheck smoke

smoke:
	chmod +x bin/hs install.sh tests/smoke.sh
	./tests/smoke.sh

shellcheck:
	shellcheck -e SC1091,SC2015,SC2016 bin/hs install.sh tests/smoke.sh

install:
	./install.sh

test: check
