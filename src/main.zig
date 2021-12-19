const w4 = @import("wasm4.zig");
const lander = @import("lander.zig");
const doge = @import("doge_meteor.zig");
const utils = @import("utils.zig");

var frame: u32 = 0;

export fn start() void {
    doge.start();
}

export fn update() void {
    lander.landerUpdate();
    doge.update(frame, utils.point_t {.x = lander.ship.x, .y = lander.ship.y} );

    if (@mod(frame, 60) == 0) {
        utils.log("Current frame = {}", .{frame});
    }
    frame += 1;
}

