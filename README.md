`grim-cli` is a command-line tool similar to `npm` that helps developers write ReaScript. It is designed with the [`grim`](https://github.com/rewgs/grim) ReaScript library in mind, but does not require it.

Because of its use of a preprocessor, all scripts and their dependencies are completely self-contained, meaning that your scripts can now use `require()` statements instead of `dofile()`.

## cli

```
grim
    new <name> <path>: Creates a new ReaScript project. If <path> is ommitted, the current directory is used; if the path already exists but is not empty, an error is raised.
        -l, --lib <path>: Specify the path to the grim library; if ommitted, assumes ./lib; if not present, adds to .grim.json requirements section.
        -L, --no-lib: Do not include `https://github.com/rewgs/grim@latest` as git submodule; if ommitted, the git command to pull down submodules runs automatically if the computer is connected to the internet
    test: Runs tests
        list: Lists all tests
        new <name> <path>: Creates a new test. If <path> is ommitted, the current directory is used; if the path already exists but is not empty, an error is raised.
            -t, --template <template>: The template .rpp file from which to create the nw file.
        run <test>: Runs a test by name or number
            -a, --all: Runs all tests
    build: Builds the source code files via a preprocessor so that no require statements end up in the final code
    dist: The result of `build`
    run: Run a script as defined in .grim.json file "scripts" section
    register: Symlinks the project's `dist` directory to `$REAPER_PREFERENCES/Scripts/grim/$project_name`
    unregister: Deletes the project's symlink created by `grim register`, if present
    init-dev: Creates .grim.json if not present and sets `"dev": true` if not already set; adds developer scripts to `.grim.json` if not already present.
```

The `grim` command line adheres to the settings in the project's [`grim.json`](#.grim.json) file, if present.

### dev commands

Setting `"env": true` in [`.grim.json`](#.grim.json) "unlocks" the following commands which are intended to aid in the development of the [`grim`](https://github.com/rewgs/grim) library:

```
grim
    format <path>: Formats files according to ? formatter
        -a, --all
```

## `.grim.json` file

```jsonc
{
    "dev": true, // enables the use of commands helpful for when working on grim library source code
    "env": true, // reads the .env file, if present
    "offline": true, // runs grim without an commands that require the internet (such as pulling down git submodules)
    "reascript": {},
    "requisites": [
        "github.com/rewgs/grim"
    ]
    "scripts": [
        {
            "name": "format",
            "command": "grim",
            "no-run": false // Enables the user to simply call `grim format` instead of `grim run format`.
        }
    ]
}
```

## anatony of a project created with `grim`

The file hierarchy of new ReaScript project created by `grim` consists of the following.

```
.
    dist/           - The result of `grim build`
    lib/            - Libraries to use with `src`
        grim/       - The grim ReaScript library source code
    src/            - source code
        .gitkeep
    tests/          - test files
        .gitkeep
    .git            - git repo is already initialized
    .gitignore      - Ignores `dist` and `lib` by default
    .grim.json      - Settings for `grim`
    .README.md
```

## tests

Testing an API for a DAW is hard. Until now, the "state of the art" has been reaper print statements. It was clear that a

Just as ReaScript project created with `grim new` results in a project "scaffolding," `grim test new` creates a new test "scaffolding."

```
tests/
    daw/
        templates/      -
            .gitkeep
    0/
        daw/            - Reaper sessions used in testing created via `reaper -new` or `reaper -template filename.rpp`
        main.lua        - The test's entrypoint
        test.json       - The test's config file
```

### `test.json`

```jsonc
{
    "name": "my first test"
    "scripts": { // these are the actual tests
    }
}
```
