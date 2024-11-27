const std = @import("std");
const zap = @import("zap");
const User = @import("user.zig");
const Game = @import("game.zig");

const Self = @This();

const UserMap = std.AutoHashMap(u64, User);
const Hash = std.crypto.hash.sha2.Sha256;
const Token = [Hash.digest_length * 2]u8;

// fields
alloc: std.mem.Allocator = undefined,
users: UserMap = undefined,
user_lock: std.Thread.Mutex = .{},
sessions: std.StringHashMap(u64) = undefined, // str -> user id
session_lock: std.Thread.Mutex = .{},
token_name: []const u8 = "gc_token",
games: std.AutoHashMap(u64, Game) = undefined,
game_lock: std.Thread.Mutex = .{},
game_count: u64 = 0,

// fns
pub fn init(alloc: std.mem.Allocator) !Self {
    return .{
        .alloc = alloc,
        .users = UserMap.init(alloc),
        .sessions = std.StringHashMap(u64).init(alloc),
        .games = std.AutoHashMap(u64, Game).init(alloc),
    };
}

pub fn deinit(self: *Self) void {
    self.users.deinit();
    var iter = self.sessions.keyIterator();
    while (iter.next()) |key_str| {
        self.alloc.free(key_str.*);
    }
    self.sessions.deinit();
    self.games.deinit();
}

pub fn addUser(self: *Self, user: User) !void {
    if (self.users.contains(user.id)) {
        return error.UsernameAlreadyTaken;
    } else {
        self.user_lock.lock();
        defer self.user_lock.unlock();
        try self.users.put(user.id, user);
    }
}

pub fn userFromToken(self: *Self, token: []const u8) ?*User {
    // locked or unlocked token lookup
    self.session_lock.lock();
    defer self.session_lock.unlock();
    if (self.sessions.get(token)) |userid| {
        std.debug.print("sessions.get(token): {d}\n", .{userid});
        // cookie is a valid session!
        if (self.users.getPtr(userid)) |user| {
            return user;
        }
        // the `else` case here actually shouldn't happen,
        // since it represents a valid token without a matching user,
        // but I'm fine treating it as if it were just an invalid token
    }
    // unmatching cookie
    // this is not necessarily a bad thing. it could be a
    // stale cookie from a previous session. So let's check
    // if username and password are being sent and correct.
    return null;
}

pub fn createSession(self: *Self, username: User.NameType) ![]const u8 {
    var hasher = Hash.init(.{});
    hasher.update(&username);
    var buf: [16]u8 = undefined;
    const time_nano = std.time.nanoTimestamp();
    const timestampHex = try std.fmt.bufPrint(&buf, "{0x}", .{time_nano});
    hasher.update(timestampHex);

    var digest: [Hash.digest_length]u8 = undefined;
    hasher.final(&digest);
    const token: Token = std.fmt.bytesToHex(digest, .lower);
    const token_str = try self.alloc.dupe(u8, token[0..token.len]);

    self.session_lock.lock();
    defer self.session_lock.unlock();

    if (!self.sessions.contains(token_str)) {
        try self.sessions.put(try self.alloc.dupe(u8, token_str), User.nameToId(username));
    }
    return token_str;
}

pub fn addGame(self: *Self, game: *Game) !void {
    self.game_lock.lock();
    defer self.game_lock.unlock();
    game.id = self.game_count;
    defer self.game_count += 1;
    try self.games.put(game.id, game.*);
}

pub fn writeGamesJson(self: *Self, buf: []u8) ?[]const u8 {
    self.game_lock.lock();
    defer self.game_lock.unlock();
    var game_iter = self.games.valueIterator();
    var games = std.ArrayList(Game.Printable).init(self.alloc);
    defer games.deinit();
    while (game_iter.next()) |game| {
        games.append(game.toPrintable()) catch return null;
    }
    //std.debug.print("len: {d}, games.items {any}", .{games.items.len, games.items});
    return zap.stringifyBuf(buf, games.items, .{});
}
