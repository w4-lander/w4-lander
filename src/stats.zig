//! On screen, display stats such as altitude, angular direction, velocity, fuel, etc.

const w4 = @import("wasm4.zig");
const sprites = @import("sprites.zig");
const utils = @import("utils.zig");

const STAT_NAME_X_POS = 114;
const STAT_VAL_X_POS = 146;

var altitude: Stat = undefined;
var fuel: Stat = undefined;

/// Represents a Sat with floating-point coordinates.
pub const Stat = struct {
        stat: i32,
        y: i32,
        sprite: sprites.Sprite,

        /// Initialize a new Stat.
        pub fn init(stat: i32, y: i32, index: i32) Stat {
            return .{ .stat = stat, .y = y, .index = index };
        }

        ///Draws Stat to be displayed
        pub fn draw(self: Stat) void {
            w4.DRAW_COLORS.* = 0x4230;
            w4.blit(
                self.sprite.byteArray,
                STAT_NAME_X_POS,
                self.y,
                self.sprite.width,
                self.sprite.height,
                w4.BLIT_2BPP,
            );
            var buf = [3]u8{0x00, 0x00, 0x00};
            var buff = utils.intToString(self.stat, &buf);
            draw_digit(buff, STAT_VAL_X_POS, self.y + 3);
        }
    };


pub fn initialize() void {
    altitude = Stat {
        .stat = 100,
        .y = 0,
        .sprite = sprites.altitudeSprite,
    };
    fuel = Stat {
        .stat = 100,
        .y = 7,
        .sprite = sprites.fuelSprite,
    };
}

pub fn draw() void {
    altitude.draw();
    fuel.draw();
}

fn draw_num(buff: []const u8, x: i32, y: i32) void {
    for (buff) |cc| {
        draw_digit(cc, x, y);
    }
}

fn draw_digit(c: u8, x: i32, y: i32) void {
    w4.DRAW_COLORS.* = 0x0043;
    if (c == '1') {
        w4.vline(x, y, 5);
    }
    else if (c == '2') {
        w4.hline(x, y, 3);
        w4.vline(x+2, y, 3);
        w4.hline(x, y+2, 3);
        w4.vline(x, y+2, 3);
        w4.hline(x, y+4, 3);
    }
    else if (c == '3') {
        // TODO: finish rest of drawing logic for digits
        w4.vline(x, y, 5);
    }
    else if (c == '4') {
        w4.vline(x, y, 5);
    }
    else if (c == '5') {
        w4.vline(x, y, 5);
    }
    else if (c == '6') {
        w4.vline(x, y, 5);
    }
    else if (c == '7') {
        w4.vline(x, y, 5);
    }
    else if (c == '8') {
        w4.vline(x, y, 5);
    }
    else if (c == '9') {
        w4.vline(x, y, 5);
    }
    else if (c == '0') {
        w4.vline(x, y, 5);
    }
}
