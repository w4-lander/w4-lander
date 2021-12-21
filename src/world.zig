const w4 = @import("wasm4.zig");
const utils = @import("utils.zig");
const Ship = @import("lander.zig").Ship;
const std = @import("std");
const RndGen = std.rand.DefaultPrng;

var ground: [100]utils.Line(i32) = undefined;

pub fn generate() void {
    var rnd = RndGen.init(0);

    var y: i32 = 300;
    var prev_y: i32 = 300;
    var x: i32 = 0;
    const x_inc = 5;
    for (ground) |_, i| {
        ground[i] = utils.Line(i32).init(utils.Vec2(i32).init(x, prev_y), utils.Vec2(i32).init(x + x_inc, y));
        prev_y = y;
        y += @intCast(i32, rnd.random().uintAtMost(u32, 10)) - 4;
        if (y > 300) {
            y = 300;
        }
        x += x_inc;
    }
}

/// Checks ship for collisions with the world
pub fn check(ship: *Ship) void {
    var points = Ship.getPoints(ship);
    for (ground) |line| {
        if (!line.verifyPoints(points)) {
            ship.land();
        }
    }
}

///Draws world
pub fn draw() void {
    w4.DRAW_COLORS.* = 0x0044;
    for (ground) |line| {
        line.draw();
    }
}
