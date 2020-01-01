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

remove_symlinks:
	# This was used to fix an issue where symlinks were causing the app to
	# be quarantined by macOS Gatekeeper, this isn't run automatically but
	# documents how the symlinks were deleted.
	find ./Contents/Resources/bundle/ruby/2.4.0/gems/ffi-1.11.3/ext/ffi_c/libffi-x86_64-darwin18/ -type l -delete
