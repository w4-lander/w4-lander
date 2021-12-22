//! On screen, display stats such as altitude, angular direction, velocity, fuel, etc.

const w4 = @import("wasm4.zig");
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
            draw_char('3', STAT_NAME_X_POS, self.y);
        }
    };


pub fn initialize() void {
    altitude = Stat {
        .stat = 3,
        .y = 0,
        .sprite = sprites.altitudeSprite,
    };
    fuel = Stat {
        .stat = 3,
        .y = 7,
        .sprite = sprites.fuelSprite,
    };
}

pub fn draw() void {
    altitude.draw();
    fuel.draw();
    // utils.log("sprite array = {}", .{charSpriteArray[0].width});
}


/// Draws a lower-case, alphanumeric character c at position (x, y).
/// Every character is displayed with a m x 7 grid of pixels, where we manually create them in sprites.zig.
/// Position (x, y) would then correspond to the top-left corner of this grid of pixels.
fn draw_char(c: u8, x: i32, y: i32) void {
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
}
