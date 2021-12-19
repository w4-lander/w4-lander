const w4 = @import("wasm4.zig");
const lander = @import("lander.zig");
const Doge = @import("doge_meteor.zig").Doge;
const utils = @import("utils.zig");

var frame: u32 = 0;
var doges: [2]Doge = undefined;

export fn start() void {
    doges[0] = Doge.init(100, 100);
    doges[1] = Doge.init(50, 100);
}

export fn update() void {
    if (@mod(frame, 60) == 0) {
        utils.log("Current frame = {}", .{frame});
    }

    lander.landerUpdate();
    if (@mod(frame, 10) == 0) {
        for (doges) |*doge| {
            doge.move_towards(.{ .x = lander.ship.x, .y = lander.ship.y });
        }
    }

    for (doges) |*doge| {
        doge.draw();
    }

    frame += 1;
}
