.PHONY: ci ac autocorrect lint

ci: lint
ac: autocorrect

lint:
	rubocop

autocorrect:
	rubocop -a

test:
	./Contents/Resources/test/run_tests.sh

bundle_update:
	cd ./Contents/Resources/ &&\
		bundle update repla --full-index &&\
		bundle update &&\
		bundle clean &&\
		bundle install --standalone
