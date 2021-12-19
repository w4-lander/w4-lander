const std = @import("std");
const math = std.math;
const w4 = @import("wasm4.zig");

/// Represents a 2D vector with floating-point coordinates.
pub const Vec2 = struct {
    x: f32,
    y: f32,

    /// Initialize a new Vec2.
    pub fn init(x: f32, y: f32) Vec2 {
        return Vec2{ .x = x, .y = y };
    }

    /// Rotate the vector counterclockwise by a given angle.
    pub fn rotate(self: Vec2, theta: f32) Vec2 {
        var rx = self.x * math.cos(theta) - self.y * math.sin(theta);
        var ry = self.y * math.cos(theta) + self.x * math.sin(theta);
        return Vec2{ .x = rx, .y = ry };
    }
};

/// Prints a formatted message to the debug console.
pub fn log(comptime fmt: []const u8, args: anytype) void {
    var buf: [512]u8 = undefined;
    _ = std.fmt.bufPrintZ(&buf, fmt, args) catch @panic("could not format string");
    w4.trace(&buf);
}
