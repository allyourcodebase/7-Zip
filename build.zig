const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    {
        const exe = b.addExecutable(.{
            .name = "7zDec",
            .target = target,
            .optimize = optimize,
        });
        const flags = [_][]const u8 {
            "-fno-sanitize=alignment",
        };
        exe.addCSourceFiles(&[_][]const u8 {
            "C/7zAlloc.c",
            "C/7zBuf.c",
            "C/7zCrc.c",
            "C/7zCrcOpt.c",
            "C/7zFile.c",
            "C/7zDec.c",
            "C/7zArcIn.c",
            "C/7zStream.c",
            "C/Bcj2.c",
            "C/Bra.c",
            "C/Bra86.c",
            "C/BraIA64.c",
            "C/CpuArch.c",
            "C/Delta.c",
            "C/Lzma2Dec.c",
            "C/LzmaDec.c",
            "C/Ppmd7.c",
            "C/Ppmd7Dec.c",
            "C/Util/7z/7zMain.c",
            "C/Util/7z/Precomp.c",
        }, &flags);
        exe.linkLibC();
        b.installArtifact(exe);
    }
}
