const w4 = @import("wasm4.zig");
const utils = @import("utils.zig");
const Ship = @import("lander.zig").Ship;

const ground = [_]utils.Line(i32){
    utils.Line(i32).init(utils.Vec2(i32).init(0, 130), utils.Vec2(i32).init(80, 130)),
    utils.Line(i32).init(utils.Vec2(i32).init(80, 130), utils.Vec2(i32).init(160, 140)),
};

/// Checks ship for collisions with the world
pub fn check(ship: *Ship) void {
    var points = Ship.getPoints(ship);
    for (ground) |line| {
        if (!line.verifyPoints(points)) {
            w4.trace("Collision Detected: Reseting");
            ship.reset();
        }
    }
}

///Draws world
pub fn draw() void {
    for (ground) |line| {
        line.draw();
    }
}
