const std = @import("std");
const w4 = @import("wasm4.zig");

// Struct point (f32 x, f32 y)
pub const point_t = struct {
    x: f32,
    y: f32,
};

pub fn log(comptime fmt: []const u8, args: anytype) void {
    var buf: [512]u8 = undefined;
    _ = std.fmt.bufPrintZ(&buf, fmt, args) catch @panic("could not format string");
    w4.trace(&buf);
}
