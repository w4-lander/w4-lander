const w4 = @import("wasm4.zig");
const math = @import("std").math;
const utils = @import("utils.zig");
const Vec2 = utils.Vec2;
const ScaledDrawer = @import("scaled_drawer.zig");

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
    landed: i32,

    fn checkProperLanding(self: *Ship) bool {
        const degrees = @mod(self.theta * 57.2958, 360.0);
        return degrees > 265 and degrees < 285 and self.vel.y < 0.02 and self.vel.y < 0.02;
    }

    pub fn land(self: *Ship) void {
        if (checkProperLanding(self)) {
            self.landed = 1;
        } else {
            self.landed = 2;
        }
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
        if (self.landed == 1) {
            w4.text("Success!", 10, 10);
            return;
        }
        if (self.landed == 2) {
            w4.text("Failed!", 10, 10);
            return;
        }

        const gamepad = w4.GAMEPAD1.*;

        w4.DRAW_COLORS.* = 0x0043;

        if (gamepad & w4.BUTTON_UP != 0) {
            w4.DRAW_COLORS.* = 0x0044;
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

        draw(self);
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
        var realPoints = getPoints(self);
        for (realPoints) |_, i| {
            var cur = realPoints[i];
            var next = realPoints[(i + 1) % 3];
            ScaledDrawer.line(cur.x, cur.y, next.x, next.y);
        }
    }
};
