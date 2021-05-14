:- if(current_logtalk_flag(events, allow)).

:- initialization((
	logtalk_load([ % stdlib
		json(loader),
		os(loader)
	]),
	set_logtalk_flag(events, allow),
	logtalk_load([ % third-party
		frames(loader)
	]),
	logtalk_load([ % local
		frames_persistency
	],
	[ optimize(on)
	])
)).

:- else.

:- initialization((
	logtalk::print_message(warning, frames_persistency, ['Events must be allowed to load frames_persistency']),
	fail
)).

:- endif.
