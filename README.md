# Reaify - Rewgs' Extension for the Reaper API. 

Reaify is a library that provides a more object-oriented approach for interacting with both the Reaper Lua API, as well as the Ultraschall API. 

Powers the [`rea`](https://github.com/rewgs/rea) script library.

## Setup
<!-- TODO: Handle this in init.lua -->
1. Install the [Ultraschall API](https://github.com/Ultraschall/ultraschall-lua-api-for-reaper). This library heavily relies on it.

<!-- FIXME:  -->
<!-- `require()`-ing files and library such as LFS in Reaper throws an error: -->
<!-- `error loading module 'lfs' from file '/usr/local/lib/lua/5.4/lfs.so': dlopen(/usr/local/lib/lua/5.4/lfs.so, 0x0006): symbol not found in flat namespace '_luaL_argerror'` -->
<!-- Looks like there's an effort to fix this here: https://forums.cockos.com/showthread.php?t=224972 -->
<!-- 2. Install LuaLFS: `luarocks install luafilesystem` -->

## Notes
- [`items`](./reaify/items/) is old. Use [`item`](./reaify/item/) instead.
- [`projects`](./reaify/projects/) is old. Use [`project`](./reaify/project/) instead.
- [`tracks`](./reaify/tracks/) is old. Use [`track`](./reaify/track/) instead.
