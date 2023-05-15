const raylib = @import("raylib/build.zig");
const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const exe = "infic";
    raylib.addTo(b, exe, target);
}
