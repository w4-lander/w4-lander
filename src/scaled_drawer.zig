const w4 = @import("wasm4.zig");
const ScaledDrawer = @import("scaled_drawer.zig");

pub var SCALE: f32 = 1;

pub var OFF_X: f32 = 0;
pub var OFF_Y: f32 = 0;

/// Returns coordinate scaled with a given offset
fn scale(z: i32, off: f32) i32 {
    return @floatToInt(i32, (@intToFloat(f32, z) - off) * SCALE);
}

/// Wrapped function for w4 line that scales all arguments
pub fn line(x1: i32, y1: i32, x2: i32, y2: i32) void {
    const x1_scaled = scale(x1, OFF_X);
    const y1_scaled = scale(y1, OFF_Y);
    const x2_scaled = scale(x2, OFF_X);
    const y2_scaled = scale(y2, OFF_Y);
    w4.line(x1_scaled, y1_scaled, x2_scaled, y2_scaled);
}
