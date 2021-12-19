const w4 = @import("wasm4.zig");
const math = @import("std").math;
const point_t = @import("utils.zig").point_t;

const GRAVITY = 0.0005;
const TURN_POWER = 0.1;
const THURST_FORCE = 0.001;


const ship_t = struct {
    x: f32,
    y: f32,
    dx: f32,
    dy: f32,
    theta: f32,
    points: [3]point_t,
};

const points = [_]point_t{
    point_t {.x = -2, .y = -4},
    point_t {.x = 10, .y = 0}, 
    point_t {.x = -2, .y = 4},
};

pub var ship = ship_t {
    .x = 10,
    .y = 10,
    .dx = 0.1,
    .dy = 0,
    .theta = 0,
    .points = points,
};

pub fn thrust() void {
    ship.dx += THURST_FORCE * math.cos(ship.theta);
    ship.dy += THURST_FORCE * math.sin(ship.theta);
}

pub fn turnLeft() void {
    ship.theta -= TURN_POWER;
}

pub fn turnRight() void {
    ship.theta += TURN_POWER;
}

pub fn landerUpdate() void {
    const gamepad = w4.GAMEPAD1.*;

    if (gamepad & w4.BUTTON_UP != 0) {
        thrust();
    }
    if (gamepad & w4.BUTTON_RIGHT != 0) {
        turnRight();
    }
    if (gamepad & w4.BUTTON_LEFT != 0) {
        turnLeft();
    }

    //gravity
    ship.dy += GRAVITY;

    ship.x += ship.dx;
    ship.y += ship.dy;

    landerDraw();
}

fn rotate(p: point_t, theta: f32) point_t{
    var rx = p.x * math.cos(theta) - p.y * math.sin(theta);
    var ry = p.y * math.cos(theta) + p.x * math.sin(theta);
    return point_t {.x = rx, .y = ry};
}

pub fn landerDraw() void {
    for (points) | _, i | {
        var cur = rotate(points[i], ship.theta);
        var next = rotate(points[(i + 1) % 3], ship.theta);
        var x1 = @floatToInt(i32, cur.x + ship.x);
        var y1 = @floatToInt(i32, cur.y + ship.y);
        var x2 = @floatToInt(i32, next.x + ship.x);
        var y2 = @floatToInt(i32, next.y + ship.y);
        w4.line(x1, y1, x2, y2);
    }
}