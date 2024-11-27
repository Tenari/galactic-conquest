const std = @import("std");
const User = @import("user.zig");
const Unit = @import("unit.zig");
const Star = @import("star.zig");
const Planet = @import("planet.zig");

const Self = @This();

const MAX_PLAYERS = 16;

pub const Printable = struct {
    id: u64,
    name: []const u8,
    creator: []const u8,
    players: []u64,
    max_players: u8 = MAX_PLAYERS,
    status: Status,
    mode: Mode,
    units: []?Unit,
    star: ?Star,
    planets: [MAX_PLANETS]?Planet,
};

const Status = enum {
    waiting,
    voting,
    playing,
    finished,
};

pub const Mode = enum {
    single_free_for_all,
    single_teams,
};

// fields
id: u64,
name: [64]u8,
name_len: u8,
creator: User.NameType,
players: [MAX_PLAYERS]u64,
status: Status = .waiting,
mode: Mode = .single_free_for_all,
units: [1024]?Unit = [_]?Unit { null } ** 1024,

// fns
pub fn init(n: []const u8, username: User.NameType) Self {
    var name = [_]u8 { 0 } ** 64;
    std.mem.copyForwards(u8, &name, n);
    var players: [MAX_PLAYERS]u64 = [_]u64 { 0 } ** MAX_PLAYERS;
    players[0] = User.nameToId(username);
    return .{
        .id = 0,
        .name = name,
        .name_len = @intCast(n.len),
        .creator = username,
        .players = players,
    };
}

pub fn deinit(self: Self) void {
    _ = self;
}

pub fn toPrintable(self: *Self) Printable {
    var i: usize = 0;
    for (self.creator) |char| {
        if (char == 0) break;
        i += 1;
    }
    var p: usize = 0;
    for (self.players) |pid| {
        if (pid == 0) break;
        p += 1;
    }
    var u: usize = 0;
    for (self.units) |uid| {
        if (uid == null) break;
        u += 1;
    }
    const sector = genSector();
    return .{
        .id = self.id,
        .name = self.name[0..self.name_len],
        .creator = self.creator[0..i],
        .players = self.players[0..p],
        .status = self.status,
        .mode = self.mode,
        .units = self.units[0..u],
        .star = sector.star,
        .planets = sector.planets,
    };
}

pub fn addPlayer(self: *Self, uid: u64) !void {
    if (std.mem.indexOfScalar(u64, &self.players, uid) != null) {
        return error.PlayerAlreadyInGame;
    }
    if (std.mem.indexOfScalar(u64, &self.players, 0)) |index| {
        self.players[index] = uid;
    } else {
        return error.GameIsFull;
    }
}

pub fn start(self: *Self) void {
    self.status = .playing;
    var unit_index: usize = 0;
    for (self.players) |pid| {
        if (pid != 0) {
            // start each player off with 10 units:
            // 3 fighters
            // 3 satellites
            // 2 corvettes
            // 1 frigate
            // 1 cruiser
            self.units[unit_index] = Unit.init(unit_index, .fighter, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .fighter, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .fighter, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .satellite, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .satellite, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .satellite, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .corvette, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .corvette, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .frigate, pid);
            unit_index += 1;
            self.units[unit_index] = Unit.init(unit_index, .cruiser, pid);
            unit_index += 1;
        }
    }
}

const MAX_PLANETS = 16;
const Sector = struct {
    star: Star,
    planets: [MAX_PLANETS]?Planet,
};

fn genSector() Sector {
    var planets = [_]?Planet { null } ** MAX_PLANETS;
    planets[0] = Planet.init(.earth, 200.2);
    planets[1] = Planet.init(.gas, 101.101);
    return .{
        .star = Star.init(.g, 1000.1),
        .planets = planets,
    };
}
