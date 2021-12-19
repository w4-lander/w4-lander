const std = @import("std");
const w4 = @import("wasm4.zig");

/// Struct point (f32 x, f32 y)
pub const Point = struct {
    x: f32,
    y: f32,
};

/// Prints a formatted message to the debug console.
pub fn log(comptime fmt: []const u8, args: anytype) void {
    var buf: [512]u8 = undefined;
    _ = std.fmt.bufPrintZ(&buf, fmt, args) catch @panic("could not format string");
    w4.trace(&buf);
}
