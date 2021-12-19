/// This feature creates a 16x16 pixel doge "meteor" object which follows the ship around in the game.

const w4 = @import("wasm4.zig");
const math = @import("std").math;
const lander = @import("lander.zig");
const utils = @import("utils.zig");
const point_t = @import("utils.zig").point_t;


/// Struct for doge object
const doge_t = struct {
    pos: point_t,

    /// Initialize starting position coordinates
    pub fn init(x: f32, y: f32) @This() {
        return @This() {
            .pos = point_t {.x = x, .y = y},
        };
    }

    /// Moves doge up by one pixel
    pub fn shift_up(this: *@This()) void {
        if (this.pos.y == 0) {
            this.pos.y = 160;
        }
        else {
            this.pos.y -= 1;
        }
    }

    /// Moves doge towards target object by 1 unit (unit = pixel)
    pub fn move_towards(this: *@This(), target_pos: point_t) void {
        var x_displ = target_pos.x - this.pos.x;
        var y_displ = target_pos.y - this.pos.y;
        var dx = x_displ / math.sqrt(x_displ*x_displ + y_displ*y_displ);
        var dy = y_displ / math.sqrt(x_displ*x_displ + y_displ*y_displ);
        utils.log("x displacement = {}", .{dx});
        this.pos.x = this.pos.x + dx;
        this.pos.y = this.pos.y + dy;
    }
};

pub var doge: doge_t = undefined;

const dogeWidth = 16;
const dogeHeight = 16;
const dogeFlags = 1; // BLIT_2BPP
const dogeSprite = [64]u8{ 0x00,0x40,0x01,0x00,0x01,0xd0,0x07,0x40,0x07,0xf5,0x5f,0xd0,0x06,0xaa,0xaa,0x90,0x18,0x5a,0xaa,0x90,0x18,0x5a,0x16,0xa4,0x1a,0xaa,0x16,0xa4,0x55,0x5a,0xaa,0xa9,0x65,0x6a,0xff,0xa9,0x75,0x6b,0xff,0xa9,0x7d,0xff,0xff,0xe9,0x1f,0x55,0x7f,0xe9,0x1f,0xff,0xff,0xe4,0x07,0xff,0xff,0xa4,0x01,0xff,0xfe,0x90,0x00,0x55,0x55,0x40 };

pub fn start() void {
    doge = doge_t.init(120, 120);
}

pub fn update(frame: u32, ship_pos: point_t) void {
    if (@mod(frame, 10) == 0) {
        move_doge(ship_pos);
    }
    
    w4.DRAW_COLORS.* = 0x3240;
    w4.blit(&dogeSprite,  @floatToInt(i32, doge.pos.x),  @floatToInt(i32, doge.pos.y), dogeWidth, dogeHeight, w4.BLIT_2BPP);
}

/// Moving the doge according to some motion. 
fn move_doge(ship_pos: point_t) void {
    doge.move_towards(ship_pos);
    // utils.log("ship_pos = {}", .{ship_pos});
    // doge.shift_up();
}