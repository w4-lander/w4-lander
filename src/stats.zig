//! On screen, display stats such as altitude, angular direction, velocity, fuel, etc.

const w4 = @import("wasm4.zig");
const sprites = @import("sprites.zig");

const STAT_NAME_X_POS = 114;
const STAT_VAL_X_POS = 145;

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
        sprite: sprites.Sprite,

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
        .sprite = sprites.altitudeSprite,
    };
    fuel = Stat(i32){
        .stat = 100,
        .y = 7,
        .sprite = sprites.fuelSprite,
    };
}

pub fn draw() void {
    altitude.draw();
    fuel.draw();
}
