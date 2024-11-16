const std = @import("std");
const User = @import("user.zig");

const Self = @This();

const MAX_PLAYERS = 16;

pub const Printable = struct {
    id: u64,
    name: []const u8,
    creator: []const u8,
    players: [MAX_PLAYERS]u64,
    max_players: u8 = MAX_PLAYERS,
    status: Status,
    mode: Mode,
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
    return .{
        .id = self.id,
        .name = self.name[0..self.name_len],
        .creator = self.creator[0..i],
        .players = self.players,
        .status = self.status,
        .mode = self.mode,
    };
}
