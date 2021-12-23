//! On screen, display stats such as altitude, angular direction, velocity, fuel, etc.

const w4 = @import("wasm4.zig");
const std = @import("std");
const sprites = @import("sprites.zig");
const utils = @import("utils.zig");
const CharSprite = @import("sprites.zig").CharSprite;
const charSpriteArray = @import("sprites.zig").charSpriteArray;

const STAT_NAME_X_POS = 114;
const STAT_VAL_X_POS = 146;

var altitude: Stat = undefined;
var fuel: Stat = undefined;

/// Represents a Sat with floating-point coordinates.
pub const Stat = struct {
    name: []const u8 = "Stat",
    value: i32,
    y: i32,
    sprite: sprites.Sprite,

    /// Initialize a new Stat.
    pub fn init(value: i32, y: i32, index: i32) Stat {
        return .{ .value = value, .y = y, .index = index };
    }

    /// Draws Stat to be displayed
    pub fn draw(self: Stat) void {
        w4.DRAW_COLORS.* = 0x4230;
        // display text of stat name
        blit_text(self.name, STAT_NAME_X_POS, self.y);
        // TODO: display self.value as well
    }
};

pub fn initialize() void {
    altitude = Stat{
        .name = "altitude",
        .value = 3,
        .y = 1,
        .sprite = sprites.altitudeSprite,
    };
    fuel = Stat{
        .name = "fuel",
        .value = 3,
        .y = 8,
        .sprite = sprites.fuelSprite,
    };
}

pub fn draw() void {
    altitude.draw();
    fuel.draw();
}

/// Blits a string text at position (x, y). Function blit_char describes how characters are blit.
fn blit_text(text: []const u8, x: i32, y: i32) void {
    var cur_x = x;
    for (text) |char| {
        cur_x += (blit_char(char, cur_x, y) + 1);
    }
}

/// Draws a lower-case, alphanumeric character c at position (x, y).
/// Every character is displayed with a m x 7 grid of pixels, where we manually create them in sprites.zig.
/// Position (x, y) would then correspond to the top-left corner of this grid of pixels.
fn blit_char(c: u8, x: i32, y: i32) i32 {
    var index: usize = utils.charToDigit(c);
    const sprite = charSpriteArray[index];
    w4.blitSub(
        sprite.byteArray,
        x,
        y,
        sprite.width,
        sprite.height,
        0,
        0,
        sprite.stride,
        w4.BLIT_2BPP,
    );
    return sprite.width;
}
