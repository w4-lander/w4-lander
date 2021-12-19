const std = @import("std");
const math = std.math;
const w4 = @import("wasm4.zig");

/// Represents a 2D vector with floating-point coordinates.
pub fn Vec2(comptime T: type) type {
    if (T != f32 and T != f64) {
        @compileError("Vec2 only implemented for f32 and f64");
    }

    return struct {
        x: T,
        y: T,

        /// Initialize a new Vec2.
        pub fn init(x: T, y: T) Vec2(T) {
            return .{ .x = x, .y = y };
        }

        /// Rotate the vector counterclockwise by a given angle.
        pub fn rotate(self: Vec2(T), theta: T) Vec2(T) {
            var rx = self.x * math.cos(theta) - self.y * math.sin(theta);
            var ry = self.y * math.cos(theta) + self.x * math.sin(theta);
            return .{ .x = rx, .y = ry };
        }
    };
}

/// Prints a formatted message to the debug console.
pub fn log(comptime fmt: []const u8, args: anytype) void {
    var buf: [512]u8 = undefined;
    _ = std.fmt.bufPrintZ(&buf, fmt, args) catch @panic("could not format string");
    w4.trace(&buf);
}
