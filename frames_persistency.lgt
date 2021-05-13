:- object(frames_persistency,
	implements([frames_on_add, frames_on_update, frames_on_delete])).

	:- info([
		version is 2:0:0,
		author is 'Paul Brown',
		date is 2021-05-08,
		comment is 'File based persistency for Frames using Event-Driven framework'
	]).

	:- uses(navltree, [
		as_curly_bracketed/2,
		as_nested_dictionary/2
		]).
	:- uses(avltree, [
		lookup/3,
		new/1 as new_dict/1,
		insert/4
		]).

	:- initialization((
		storage_path(Path),
		os::make_directory_path(Path)
	)).

	% Protocol predicates
	after_add(Frames, Subject) :-
		persist(Frames, Subject).
	after_update(Frames, Subject) :-
		persist(Frames, Subject).
	after_delete_slots(Frames, Subject) :-
		persist(Frames, Subject).
	after_delete_frame(_Frames, Subject) :-
		persist_delete(Subject).

    storage_path(Path) :-
        logtalk::expand_library_path(storage, Path).
    storage_file(Subject, File) :-
        storage_path(Path),
        atomic_list_concat([Path, Subject, '.json'], File).

	% Not ISO standard, so can't depend on it
	atomic_list_concat(List, Concatonated) :-
		once(phrase(atomic_list_concat_(Concatonated), List)).
	atomic_list_concat_(Concatonated) -->
		[Concatonated].
	atomic_list_concat_(Concatonated) -->
		[Atom],
		atomic_list_concat_(Rest),
		{atom_concat(Atom, Rest, Concatonated)}.
	atomic_list_concat(List, Sep, Concatonated) :-
		once(phrase(atomic_list_concat_(Concatonated, Sep), List)).
	atomic_list_concat_(Concatonated, _Sep) -->
		[Concatonated].
	atomic_list_concat_(Concatonated, Sep) -->
		[Atom],
		atomic_list_concat_(Rest, Sep),
		{
			atom_concat(Sep, Rest, Seperated),
			atom_concat(Atom, Seperated, Concatonated)
		}.

	:- public(persist/1).
	:- mode(persist(++nested_dictionary), one).
	:- info(persist/1, [
		comment is 'Persist a Frames Collection',
		argnames is ['Frames']
	]).
	persist(Frames) :-
		frames::subjects(Frames, Subjects),
		once(persist_subjects(Frames, Subjects)).

	:- public(restore/1).
	:- mode(restore(--nested_dictionary), one).
	:- info(restore/1, [
		comment is 'Restore a Frame Collection from persistent storage',
		argnames is ['Frames']
	]).
	restore(Frames) :-
		storage_path(Dir),
		os::directory_files(Dir, Files, [suffixes([json])]),
		new_dict(Empty),
		once(restore_files(Empty, Files, Frames)).

	persist_subjects(_Frames, []).
	persist_subjects(Frames, [Subject|Subjects]) :-
		persist(Frames, Subject),
		persist_subjects(Frames, Subjects).

	persist(Frames, Subject) :-
		lookup(Subject, Frame, Frames),
		as_curly_bracketed(Frame, JSON),
		storage_file(Subject, File),
		json::generate(file(File), JSON).

	persist_delete(Subject) :-
		storage_file(Subject, File),
		os::delete_file(File).

	restore_files(Frames, [], Frames).
	restore_files(InFrames, [File|Files], Frames) :-
		atom_concat(Subject, '.json', File),
		restore_subject(InFrames, Subject, AccFrames),
		restore_files(AccFrames, Files, Frames).

	restore_subject(OldFrames, Subject, NewFrames) :-
		storage_file(Subject, Path),
		json::parse(file(Path), JSON),
		as_nested_dictionary(JSON, Frame),
		insert(OldFrames, Subject, Frame, NewFrames).

:- end_object.
