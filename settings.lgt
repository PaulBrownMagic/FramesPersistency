%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Sample settings file
%
%  This is for reference, please use it to inform your own settings.lgt
%  based upon the one in your local install of Logtalk
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Third-Party Libraries
:- initialization((
	logtalk_load(types(loader)),
	logtalk_load(os(loader))
)).

:- multifile(logtalk_library_path/2).
:- dynamic(logtalk_library_path/2).

logtalk_library_path(third_party_libs, home('Development/MyLogtalkLibs')).
logtalk_library_path(Library, third_party_libs(LibraryPath)) :-
	logtalk::expand_library_path(third_party_libs, MyLibsPath),
	os::directory_files(MyLibsPath, Libraries, [type(directory), dot_files(false)]),
	list::member(Library, Libraries),
	atom_concat(Library, '/', LibraryPath).

% Path to storage, using tmp for testing, but you can use a path like home(storage)
logtalk_library_path(storage, '/tmp/frames_storage').
