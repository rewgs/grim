# grim

`grim` is a library that significantly speeds up ReaScript development by providing a more object-oriented approach for interacting with the Reaper [ReaScript Lua API](https://www.reaper.fm/sdk/reascript/reascripthelp.html#l). Utilizes the [Ultraschall API](https://mespotin.uber.space/Ultraschall/US_Api_Introduction_and_Concepts.html) for some extra functionality.

All values have type annotations according to the [`lua-language-server` specification](https://github.com/LuaLS/lua-language-server/wiki/Annotations).

<!-- Powers the [`rea`](https://github.com/rewgs/rea) script library. -->

<!-- ## setup -->
<!-- Any ReaScript file that references this library needs to be able to import it from an absolute location that does not change from computer to computer. -->
<!-- 1. Install the [Ultraschall API](https://github.com/Ultraschall/ultraschall-lua-api-for-reaper?tab=readme-ov-file#reapack) via ReaPack. -->

<!-- ## why?

The ReaScript API -->

## use

It is highly recommended that you use VS Code along with [Antoine Balaine](https://www.linkedin.com/in/antoinebalaine/)'s excellent [`REAPER ReaScript`](https://marketplace.visualstudio.com/items?itemName=AntoineBalaine.reascript-docs) extension, as `grim`'s type annotations for Reaper's types are in accordance with this extension.