:- initialization((
	logtalk_load([ % stdlib
		json(loader),
		os(loader)
	]),
	logtalk_load([ % third-party
		frames(loader)
	]),
	logtalk_load([ % local
		frames_persistency
	],
	[ optimize(on)
	])
)).
