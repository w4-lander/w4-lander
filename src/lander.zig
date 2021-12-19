const w4 = @import("wasm4.zig");
const math = @import("std").math;
const utils = @import("utils.zig");
const Vec2 = utils.Vec2;

const GRAVITY = 0.0005;
const TURN_POWER = 0.1;
const THURST_FORCE = 0.001;

const POINTS = [_]Vec2(f32){
    .{ .x = -2, .y = -4 },
    .{ .x = 10, .y = 0 },
    .{ .x = -2, .y = 4 },
};

pub const Ship = struct {
    pos: Vec2(f32),
    vel: Vec2(f32),
    theta: f32,

    pub fn reset(self: *Ship) void {
        self.pos = .{ .x = 10, .y = 10 };
        self.vel = .{ .x = 0.1, .y = 0 };
    }

    fn thrust(self: *Ship) void {
        self.vel.x += THURST_FORCE * math.cos(self.theta);
        self.vel.y += THURST_FORCE * math.sin(self.theta);
    }

    fn turnLeft(self: *Ship) void {
        self.theta -= TURN_POWER;
    }

    fn turnRight(self: *Ship) void {
        self.theta += TURN_POWER;
    }

    pub fn update(self: *Ship) void {
        const gamepad = w4.GAMEPAD1.*;

        if (gamepad & w4.BUTTON_UP != 0) {
            self.thrust();
        }
        if (gamepad & w4.BUTTON_RIGHT != 0) {
            self.turnRight();
        }
        if (gamepad & w4.BUTTON_LEFT != 0) {
            self.turnLeft();
        }

        //gravity
        self.vel.y += GRAVITY;

        self.pos.x += self.vel.x;
        self.pos.y += self.vel.y;
    }

    pub fn getPoints(self: *Ship) [3]Vec2(i32) {
        var ret: [3]Vec2(i32) = undefined;
        for (POINTS) |point, i| {
            var cur: Vec2(f32) = point.rotate(self.theta);
            const x = @floatToInt(i32, cur.x + self.pos.x);
            const y = @floatToInt(i32, cur.y + self.pos.y);
            const p = Vec2(i32).init(x, y);
            ret[i] = p;
        }
        return ret;
    }

    pub fn draw(self: *Ship) void {
        w4.DRAW_COLORS.* = 0x0043;
        var realPoints = getPoints(self);
        for (realPoints) |_, i| {
            var cur = realPoints[i];
            var next = realPoints[(i + 1) % 3];
            w4.line(cur.x, cur.y, next.x, next.y);
        }
    }
};
