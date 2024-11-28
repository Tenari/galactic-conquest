const std = @import("std");

const Self = @This();
// unit of distance is the light-minute
// solar systems are a disk of radius 250 light-minutes
// 1 AU = 149,597,870,700 m
// 1 AU = ~8.3 light minutes
//const AU_RATIO = 8.3167463973;
// 1 light minute = 17,987,547,480 m
// 1 solar radius = 0.00465047 AU
// 1 solar radius = 695,700,000 m
// 1 solar radius = 0.0386767568 light minutes
const SOLAR_RADIUS_RATIO: f64 = 0.0386767568;
// unit of mass is earth mass
// 5.9722  x 10^24 kg = earth mass
// 1.98847 x 10^30 kg = solar mass
//const SOLAR_MASS_RATIO = 332954.355178996;

pub const Printable = struct {
    x: f64, y: f64, z: f64,
    kind: Kind,
    radius: f64,
};

const Kind = enum {
    o, b, a, f, g, k, m,

    pub fn radius(self: Kind, seed: f64) f64 {
        return switch (self) {
            .o => 6.6 + @rem(seed, 6.0),
            .b => 1.8 + @rem(seed, 4.8),
            .a => 1.4 + @rem(seed, 0.4),
            .f => 1.15 + @rem(seed, 0.25),
            .g => 0.96 + @rem(seed, 0.19),
            .k => 0.70 + @rem(seed, 0.26),
            .m => 0.08 + @rem(seed, 0.62),
        };
    }
};

// fields
id: u64,
kind: Kind,
radius: f64,
x: f64 = 0.0,
y: f64 = 0.0,
z: f64 = 0.0,

// fns
pub fn init(kind: Kind, seed: f64) Self {
    return .{
        .id = 0,
        .kind = kind,
        .radius = kind.radius(seed),
    };
}

