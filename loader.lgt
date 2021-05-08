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
	]),
	set_logtalk_flag(events, allow),
	define_events(after, frames, add_frame(_, _, _, _), _, frames_persistency),
	define_events(after, frames, update_frame(_, _, _, _), _, frames_persistency),
	define_events(after, frames, delete_frame(_, _, _, _), _, frames_persistency),
	define_events(after, frames, delete_frame(_, _, _), _, frames_persistency)
)).
