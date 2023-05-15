const raylib = @import("raylib/build.zig");
const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "infic",
        .root_source_file = .{ .path = "main.zig" },
        .optimize = optimize,
    });
    b.installArtifact(exe);
    raylib.addTo(b, exe, target, optimize);
}
