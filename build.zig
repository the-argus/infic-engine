const raylib = @import("raylib/build.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const exe = ...;
    raylib.addTo(b, exe, target);
}
