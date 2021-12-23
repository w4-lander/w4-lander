const std = @import("std");
const math = std.math;
const w4 = @import("wasm4.zig");
const ScaledDrawer = @import("scaled_drawer.zig");

/// Represents a 2D vector with floating-point coordinates.
pub fn Vec2(comptime T: type) type {
    if (T != f32 and T != f64 and T != i32) {
        @compileError("Vec2 only implemented for f32 and f64 and i32");
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
            if (T != f32 and T != f64) {
                @compileError("Vec2 rotation only implemented for f32 and f64");
            }
            var rx = self.x * math.cos(theta) - self.y * math.sin(theta);
            var ry = self.y * math.cos(theta) + self.x * math.sin(theta);
            return .{ .x = rx, .y = ry };
        }
    };
}

/// Represents a Line with floating-point coordinates.
pub fn Line(comptime T: type) type {
    if (T != i32) {
        @compileError("Line only implemented for i32");
    }

    return struct {
        A: Vec2(T),
        B: Vec2(T),

        /// Initialize a new Line.
        pub fn init(A: Vec2(T), B: Vec2(T)) Line(T) {
            return .{ .A = A, .B = B };
        }

        fn ccw(A: Vec2(T), B: Vec2(T), C: Vec2(T)) bool {
            return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x);
        }

        /// Verify points are all on the same side of the line or at a different x-coordinate
        pub fn verifyPoints(self: Line(T), points: [3]Vec2(i32)) bool {
            var direction = ccw(self.A, self.B, points[0]);
            for (points) |point| {
                if (point.x > self.B.x or point.x < self.A.x) {
                    continue;
                }
                if (ccw(self.A, self.B, point) != direction) {
                    return false;
                }
            }
            return true;
        }

        pub fn draw(self: Line(T)) void {
            ScaledDrawer.line(self.A.x, self.A.y, self.B.x, self.B.y);
        }
    };
}

pub fn charToDigit(c: u8) usize {
    return switch (c) {
        '0'...'9' => c - '0',
        // 'A' ... 'Z' => c - 'A' + 10,
        'a'...'z' => c - 'a' + 10,
        else => math.maxInt(u8),
    };
}

/// courtesy of https://github.com/ziglang/zig/issues/4142
pub fn intToString(int: i32, buf: []u8) ![]const u8 {
    return try std.fmt.bufPrint(buf, "{}", .{int});
}

/// Prints a formatted message to the debug console.
pub fn log(comptime fmt: []const u8, args: anytype) void {
    var buf: [512]u8 = undefined;
    _ = std.fmt.bufPrintZ(&buf, fmt, args) catch @panic("could not format string");
    w4.trace(&buf);
}
