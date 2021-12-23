const w4 = @import("wasm4.zig");
const Ship = @import("lander.zig").Ship;
const Doge = @import("doge_meteor.zig").Doge;
const utils = @import("utils.zig");
const World = @import("world.zig");
const ScaledDrawer = @import("scaled_drawer.zig");
const Stats = @import("stats.zig");

var frame: u32 = 0;
var doges: [2]Doge = undefined;
var ship: Ship = undefined;

export fn start() void {
    doges = [_]Doge{
        Doge.init(.{ .x = 100, .y = 100 }),
        Doge.init(.{ .x = 50, .y = 100 }),
    };
    ship = Ship{
        .pos = .{ .x = 10, .y = 10 },
        .vel = .{ .x = 0.1, .y = 0 },
        .theta = 0,
        .landed = 0,
    };
    Stats.initialize();
    ScaledDrawer.SCALE = 0.5;
    World.generate();
}

export fn update() void {
    if (@mod(frame, 60) == 0) {
        utils.log("Current frame = {}", .{frame});
    }
    ship.update();
    if (@mod(frame, 10) == 0) {
        for (doges) |*doge| {
            doge.move_towards(ship.pos);
        }
    }
    World.draw();
    World.check(&ship);
    for (doges) |*doge| {
        doge.draw();
    }

    // update stats
    // TODO: actually compute altitude instead of screen_height minus ship.pos.y lol
    if (@mod(frame, 15) == 0) {
        Stats.update(@floatToInt(i32, 160 - ship.pos.y));
    }
    Stats.draw();

    frame += 1;
}
