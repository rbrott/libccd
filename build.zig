const std = @import("std");

pub const Precision = enum {
    Single,
    Double,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const precision = b.option(Precision, "precision", "Floating point precision") orelse Precision.Single;

    const libccd = b.addStaticLibrary(.{
        .name = "ccd",
        .target = target,
        .optimize = optimize,
    });
    libccd.addIncludePath(.{
        .path="src",
    });
    libccd.addCSourceFiles(.{
        .files = &.{
            "src/ccd.c",
            "src/polytope.c",
            "src/vec3.c",
            "src/support.c",
            "src/mpr.c",
        },
        .flags = &.{},
    });
    switch (precision) {
        Precision.Single => {
            libccd.root_module.addCMacro("CCD_SINGLE", "");
        },
        Precision.Double => {
            libccd.root_module.addCMacro("CCD_DOUBLE", "");
        },
    }

    b.installArtifact(libccd);
}
