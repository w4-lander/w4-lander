# w4-lander

A lunar-lander type retro video game, written in Zig for the WASM-4 fantasy console. Play on the web, or try out the native apps! ✨

## Development

Make sure you have the latest (`master` branch) of [Zig](https://ziglang.org/) installed, as well as [w4](https://wasm4.org/) and [Just](https://github.com/casey/just). Then, run the following commands:

```shell
just             # Build the project to a Wasm cartridge
just run         # Run the game in a browser
just run-native  # Run the game in the native runtime
just watch       # Run the game in a browser, rebuilding on code change
just bundle      # Create HTML, Windows, macOS, and Linux release artifacts
just clean       # Clean all generated files
```
