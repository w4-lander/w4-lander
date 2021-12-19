//! This feature creates a 16x16 pixel doge "meteor" object which follows the ship
//! around in the game.

const w4 = @import("wasm4.zig");
const math = @import("std").math;
const lander = @import("lander.zig");
const utils = @import("utils.zig");
const Vec2 = utils.Vec2;

/// Struct for doge object
pub const Doge = struct {
    pos: Vec2,

    /// Initialize starting position coordinates
    pub fn init(pos: Vec2) Doge {
        return Doge{ .pos = pos };
    }

    /// Moves doge up by one pixel
    pub fn shift_up(self: *Doge) void {
        if (self.pos.y == 0) {
            self.pos.y = 160;
        } else {
            self.pos.y -= 1;
        }
    }

    /// Moves doge towards target object by 1 unit (unit = pixel)
    pub fn move_towards(self: *Doge, target_pos: Vec2) void {
        var x_displ = target_pos.x - self.pos.x;
        var y_displ = target_pos.y - self.pos.y;
        var dx = x_displ / math.sqrt(x_displ * x_displ + y_displ * y_displ);
        var dy = y_displ / math.sqrt(x_displ * x_displ + y_displ * y_displ);
        self.pos.x = self.pos.x + dx;
        self.pos.y = self.pos.y + dy;
    }

    pub fn draw(self: *Doge) void {
        const dogeWidth = 16;
        const dogeHeight = 16;
        const dogeSprite = [64]u8{ 0x00, 0x40, 0x01, 0x00, 0x01, 0xd0, 0x07, 0x40, 0x07, 0xf5, 0x5f, 0xd0, 0x06, 0xaa, 0xaa, 0x90, 0x18, 0x5a, 0xaa, 0x90, 0x18, 0x5a, 0x16, 0xa4, 0x1a, 0xaa, 0x16, 0xa4, 0x55, 0x5a, 0xaa, 0xa9, 0x65, 0x6a, 0xff, 0xa9, 0x75, 0x6b, 0xff, 0xa9, 0x7d, 0xff, 0xff, 0xe9, 0x1f, 0x55, 0x7f, 0xe9, 0x1f, 0xff, 0xff, 0xe4, 0x07, 0xff, 0xff, 0xa4, 0x01, 0xff, 0xfe, 0x90, 0x00, 0x55, 0x55, 0x40 };

        w4.DRAW_COLORS.* = 0x3240;
        w4.blit(
            &dogeSprite,
            @floatToInt(i32, self.pos.x),
            @floatToInt(i32, self.pos.y),
            dogeWidth,
            dogeHeight,
            w4.BLIT_2BPP,
        );
    }
};
