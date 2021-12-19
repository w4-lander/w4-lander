const w4 = @import("wasm4.zig");
const math = @import("std").math;
const Vec2 = @import("utils.zig").Vec2;

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

    pub fn draw(self: *Ship) void {
        w4.DRAW_COLORS.* = 0x0043;
        for (POINTS) |_, i| {
            var cur = POINTS[i].rotate(self.theta);
            var next = POINTS[(i + 1) % 3].rotate(self.theta);
            var x1 = @floatToInt(i32, cur.x + self.pos.x);
            var y1 = @floatToInt(i32, cur.y + self.pos.y);
            var x2 = @floatToInt(i32, next.x + self.pos.x);
            var y2 = @floatToInt(i32, next.y + self.pos.y);
            w4.line(x1, y1, x2, y2);
        }
    }
};
