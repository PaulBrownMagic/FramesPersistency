# Frames Persistency

A basic file-based persistency solution for use with frames.

## Requirements

This is an add-on for [frames](https://github.com/PaulBrownMagic/Frames), so
you'll need that! See the included settings.lgt for an example of how to
include third-party libraries, or even better the settings.lgt included in your
installation of Logtalk.

It also depends on a `logtalk_library_path(storage, Path)` having been defined,
where `Path` is the directory the files will be persisted too. See the included
settings.lgt for an example of how to do this.

## How It Works

Most of the actual work should just look like magic. Everytime you send a query
to `frames::add_frame/4`, `frames::update_frame/4`, or
`frames::delete_frame/3-4` the subject of that query will be persisted (or
deleted as appropriate) from the disk. This is done using [Logtalks Event-driven
programming mechanism](https://github.com/PaulBrownMagic/Frames).

Additionally two useful predicates are provided:

- `frames_persistency::persist/1`, which will manually persist a collection of
  frames when that nested dictionary is given as an arguement.
- `frames_persistency::restore/1`, which will load a collection of frames from
  the disk.
