serve:
	hugo server --config even-config.toml --disableLiveReload

generate:
	hugo --config even-config.toml --minify --gc --cleanDestinationDir