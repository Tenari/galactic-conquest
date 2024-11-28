const std = @import("std");

const Self = @This();

pub const Printable = struct {
    kind: Kind,
    user_id: u64,
    x: f64, y: f64, z: f64,
    system: u8,
};

const Kind = enum {
    // carried
    satellite,
    troop_lander,
    fighter,
    bomber,
    // hyperdrive-capable
    corvette,
    frigate,
    cruiser, // meaningful carriers vvv
    destroyer,
    dreadnaught,

    pub fn radius(self: Kind) u32 {
        return switch (self) {
            .satellite => 10,
            .troop_lander => 12,
            .fighter => 7,
            .bomber => 15,
            .corvette => 100,
            .frigate => 250,
            .cruiser => 500,
            .destroyer => 1200,
            .dreadnaught => 5000,
        };
    }

    pub fn crew(self: Kind) u32 {
        return switch (self) {
            .satellite => 0,
            .troop_lander => 120,
            .fighter => 1,
            .bomber => 2,
            .corvette => 25,
            .frigate => 100,
            .cruiser => 500,
            .destroyer => 1000,
            .dreadnaught => 10_000,
        };
    }

    pub fn starting_armor(self: Kind) u32 {
        return switch (self) {
            .satellite => 1,
            .troop_lander => 7,
            .fighter => 10,
            .bomber => 12,
            .corvette => 100,
            .frigate => 500,
            .cruiser => 1_000,
            .destroyer => 10_000,
            .dreadnaught => 50_000,
        };
    }

    pub fn starting_shields(self: Kind) u32 {
        return switch (self) {
            .satellite => 10,
            .troop_lander => 30,
            .fighter => 100,
            .bomber => 90,
            .corvette => 500,
            .frigate => 900,
            .cruiser => 1_000,
            .destroyer => 5_000,
            .dreadnaught => 10_000,
        };
    }
};

// fields
id: u64,
kind: Kind,
user_id: u64,
x: f64 = 0.0,
y: f64 = 0.0,
z: f64 = 0.0,
system: u8 = 0,
shields: u32,
armor: u32,

// fns
pub fn init(id: u64, kind: Kind, user_id: u64) Self {
    return .{
        .id = id,
        .kind = kind,
        .user_id = user_id,
        .armor = kind.starting_armor(),
        .shields = kind.starting_shields(),
    };
}
