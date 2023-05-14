# Interactive Fiction Engine

An interactive fiction game "engine" written in zig.

## Goals

This engine should allow users to create a project, write script (probably going
to be an extension of Choicescript) and compile the script into a game for
Linux, MacOS, Windows, or WebGL.

The script should allow for the following features:

- Define prompts and choices, both in terms of the actual displayed text and
  as variables within the script.
- Goto another prompt after answering one. The way this is formatted (using
  go-to statements, maybe function calls, maybe a declarative thing...) is crucial
  to how the final script will look and how well it will function.
- Create arbitrary variables, global/persistent or local to a certain scope of a
  prompt(s). This is to allow for tracking the current state of the player and
  their environment- the mood of NPCs, a player's name, etc. The following data
  types should be supported:
  - Integer
  - Bool
  - Float
  - String
  - List (passed by reference) (can contain one (1) type of data so as to avoid
    `if (typeof(x) ==...` and other such javascript-isms)
  - Dictionary (passed by reference) (a hash table, one key type and one value
    type)
- Allow for modifying variables upon player choice. The following operations
  should be supported:
  - assignment (replace the original value of the variable)
  - add/subtract/multiply/divide (floats and integers)
  - modulo (integer)
  - concatenation (strings, lists)
  - insertion (list, dictionary)
  - lookup, with some sort of try/catch or check-able (list, dictionary)
  - cast conversion (int->float, float->int)
  - round conversion (float->int)
  - ceil conversion (float->int)
  - len() function (strings, lists, dictionaries)
  - ! (bool)
  - !=, == (all types)
  - > =, >, <, <= (int, float)
- Declare the visual properties of prompts and choices such as:
  - whether to type the text on screen, letters at a time
    - speed in ms to type each letter
    - path to sound file to play for each type (ie. typewriter clacking noise)
  - whether to pause and wait for keypress/tap before displaying next segment of
    text
  - whether to play a sound when all the text has appeared on the screen
    - path to sound to play

**Additionally**, although totally outside the scope of the scripting language,
it could be necessary for the user to be able to describe the layout of a stats
page of some kind. This could be quite complex, for example with a picture of
what the player character currently looks like and a column of stats next to
them. Describing widgets, nesting, alignment, etc. is beyond the aforementioned
scripting language (probably) so it's best if that could be achieved in a
different language.

**Double additionally** styling things like fonts and the game background is
difficult. HTML/CSS is out of the question because that requires a web rendering
engine to parse and we want to be able to export to windows/mac/linux. Maybe an
extremely simple custom stylesheet language is in order?

## Options

Ways to achieve the goals.

### Build Environment

1. Zig: compile to wasm or to a native arch
2. Nim: compile to JS, wasm, or a native arch
3. C/C++: compile to wasm or native arch
4. TS/JS + portable runtime like nodeJS: No.
5. Dotnet: ???

When compiling to a native arch it is necessary to include a windowing library
of some kind. GLFW is probably best. Zig is listed as number 1 because it has
great raylib bindings, and there are already existing raylib examples which
compile both natively and to WASM. I think raylib might already include an
abstraction for webgl/native gl?

### Scripting language

1. lua
2. python...
3. choicescript??
4. custom language
