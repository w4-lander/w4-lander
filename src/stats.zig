//! On screen, display stats such as altitude, angular direction, velocity, fuel, etc.

const w4 = @import("wasm4.zig");
const Sprite = @import("utils.zig").Sprite;

const STAT_NAME_X_POS = 116;
const altitudeSprite = Sprite{
    .width = 28,
    .height = 8,
    .byteArray = &[56]u8{ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x10,0x41,0x04,0x00,0x01,0x00,0x41,0x10,0x40,0x04,0x00,0x01,0x04,0x55,0x11,0x51,0x15,0x11,0x15,0x11,0x41,0x10,0x41,0x04,0x11,0x11,0x14,0x41,0x10,0x51,0x05,0x15,0x15,0x15 },
};
const fuelSprite = Sprite{
    .width = 16,
    .height = 8,
    .byteArray = &[32]u8{ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x54,0x00,0x00,0x40,0x40,0x00,0x10,0x40,0x54,0x44,0x44,0x40,0x40,0x44,0x50,0x40,0x40,0x54,0x54,0x40 },
};

var altitude: Stat(i32) = undefined;
var fuel: Stat(i32) = undefined;

/// Represents a Line with floating-point coordinates.
pub fn Stat(comptime T: type) type {
    if (T != f32 and T != f64 and T != i32) {
        @compileError("Stat only implemented for f32 and f64 and i32");
    }

    return struct {
        stat: T,
        y: i32,
        sprite: Sprite,

        /// Initialize a new Stat.
        pub fn init(stat: T, y: i32, index: i32) Stat(T) {
            return .{ .stat = stat, .y = y, .index = index };
        }

        ///Draws Stat to be displayed
        pub fn draw(self: Stat(T)) void {
            w4.DRAW_COLORS.* = 0x3240;
            w4.blit(
                self.sprite.byteArray,
                STAT_NAME_X_POS,
                self.y,
                self.sprite.width,
                self.sprite.height,
                w4.BLIT_2BPP,
            );
        }
    };
}

pub fn initialize() void {
    altitude = Stat(i32){
        .stat = 100,
        .y = 0, 
        .sprite = altitudeSprite,
    };
    fuel = Stat(i32){
        .stat = 100,
        .y = 7, 
        .sprite = fuelSprite,
    };
}

pub fn draw() void {
    altitude.draw();
    fuel.draw();
}
