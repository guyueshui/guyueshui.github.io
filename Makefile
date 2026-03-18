serve:
	hugo server --config even-config.toml --disableLiveReload

generate:
	hugo --config even-config.toml --minify --gc --cleanDestinationDir

article :=
new:
	[ -n "$(article)" ] && \
	hugo --config even-config.toml new content post/$(article).md