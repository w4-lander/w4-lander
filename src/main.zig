const w4 = @import("wasm4.zig");
const lander = @import("lander.zig");


export fn update() void {
    lander.landerUpdate();
}
