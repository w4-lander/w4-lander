const w4 = @import("wasm4.zig");
const std = @import("std");
const point_t = @import("utils.zig").point_t;

pub var doge: point_t = undefined;

const dogeWidth = 16;
const dogeHeight = 16;
const dogeFlags = 1; // BLIT_2BPP
const dogeSprite = [64]u8{ 0x00,0x40,0x01,0x00,0x01,0xd0,0x07,0x40,0x07,0xf5,0x5f,0xd0,0x06,0xaa,0xaa,0x90,0x18,0x5a,0xaa,0x90,0x18,0x5a,0x16,0xa4,0x1a,0xaa,0x16,0xa4,0x55,0x5a,0xaa,0xa9,0x65,0x6a,0xff,0xa9,0x75,0x6b,0xff,0xa9,0x7d,0xff,0xff,0xe9,0x1f,0x55,0x7f,0xe9,0x1f,0xff,0xff,0xe4,0x07,0xff,0xff,0xa4,0x01,0xff,0xfe,0x90,0x00,0x55,0x55,0x40 };

pub fn start() void {
    doge = point_t {.x = 120/dogeWidth, .y = 120/dogeWidth};
}

pub fn update() void {
    // w4.DRAW_COLORS.* = 0x4320;
    w4.blit(dogeSprite, doge.x * dogeWidth, doge.y * dogeHeight, dogeWidth, dogeHeight, w4.BLIT_2BPP);
}