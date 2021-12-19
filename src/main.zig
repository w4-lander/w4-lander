const w4 = @import("wasm4.zig");
const lander = @import("lander.zig");
const doge = @import("doge_meteor.zig");

export fn start() void {
    // w4.PALETTE.* = .{
    //     0xfbf7f3,
    //     0xe5b083,
    //     0x426e5d,
    //     0x20283d,
    // };
    doge.start();
}

export fn update() void {
    lander.landerUpdate();
    doge.update();
}

