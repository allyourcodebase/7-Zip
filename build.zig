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
            // unaligned access utilized, see C/CpuArch.h
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
    {
        const exe = b.addExecutable(.{
            .name = "7z",
            .target = target,
            .optimize = optimize,
        });
        const flags = [_][]const u8 {
            // unaligned access utilized, see C/CpuArch.h
            "-fno-sanitize=alignment",
        };
        exe.addCSourceFiles(&(
            common_src ++
            console_src ++
            ui_common_src ++
            _7z_common_src ++
            ar_common_src ++
            [_][]const u8 {
                //
                "CPP/Windows/DLL.cpp",
                "CPP/Windows/ErrorMsg.cpp",
                "CPP/Windows/FileDir.cpp",
                "CPP/Windows/FileFind.cpp",
                "CPP/Windows/FileIO.cpp",
                "CPP/Windows/FileLink.cpp",
                "CPP/Windows/FileName.cpp",
                "CPP/Windows/FileSystem.cpp",
                "CPP/Windows/MemoryLock.cpp",
                "CPP/Windows/PropVariant.cpp",
                "CPP/Windows/PropVariantConv.cpp",
                "CPP/Windows/Registry.cpp",
                "CPP/Windows/System.cpp",
                "CPP/Windows/SystemInfo.cpp",
                "CPP/Windows/TimeUtils.cpp",
                //
                "CPP/7zip/Compress/CopyCoder.cpp",
                //
                "C/Alloc.c",
                "C/CpuArch.c",
                "C/Sort.c",
                "C/Threads.c",
                //
                "C/DllSecur.c",
                //
                "C/7zCrc.c",
                // TODO: I think there is an assembly version on some platforms
                //     i.e. ASM/x86/7xCrcOpt.asm
                "C/7zCrcOpt.c",
            }
        ), &flags);
        exe.linkLibCpp();
        exe.linkSystemLibrary("oleaut32");
        b.installArtifact(exe);
    }
}

const common_src = [_][]const u8 {
    "CPP/Common/CommandLineParser.cpp",
    "CPP/Common/CRC.cpp",
    "CPP/Common/DynLimBuf.cpp",
    "CPP/Common/IntToString.cpp",
    "CPP/Common/ListFileUtils.cpp",
    "CPP/Common/NewHandler.cpp",
    "CPP/Common/StdInStream.cpp",
    "CPP/Common/StdOutStream.cpp",
    "CPP/Common/MyString.cpp",
    "CPP/Common/StringConvert.cpp",
    "CPP/Common/StringToInt.cpp",
    "CPP/Common/UTFConvert.cpp",
    "CPP/Common/MyVector.cpp",
    "CPP/Common/Wildcard.cpp",
};

const console_src = [_][]const u8 {
    "CPP/7zip/UI/Console/BenchCon.cpp",
    "CPP/7zip/UI/Console/ConsoleClose.cpp",
    "CPP/7zip/UI/Console/ExtractCallbackConsole.cpp",
    "CPP/7zip/UI/Console/HashCon.cpp",
    "CPP/7zip/UI/Console/List.cpp",
    "CPP/7zip/UI/Console/Main.cpp",
    "CPP/7zip/UI/Console/MainAr.cpp",
    "CPP/7zip/UI/Console/OpenCallbackConsole.cpp",
    "CPP/7zip/UI/Console/PercentPrinter.cpp",
    "CPP/7zip/UI/Console/UpdateCallbackConsole.cpp",
    "CPP/7zip/UI/Console/UserInputUtils.cpp",
};

const ui_common_src = [_][]const u8 {
    "CPP/7zip/UI/Common/ArchiveCommandLine.cpp",
    "CPP/7zip/UI/Common/ArchiveExtractCallback.cpp",
    "CPP/7zip/UI/Common/ArchiveOpenCallback.cpp",
    "CPP/7zip/UI/Common/Bench.cpp",
    "CPP/7zip/UI/Common/DefaultName.cpp",
    "CPP/7zip/UI/Common/EnumDirItems.cpp",
    "CPP/7zip/UI/Common/Extract.cpp",
    "CPP/7zip/UI/Common/ExtractingFilePath.cpp",
    "CPP/7zip/UI/Common/HashCalc.cpp",
    "CPP/7zip/UI/Common/LoadCodecs.cpp",
    "CPP/7zip/UI/Common/OpenArchive.cpp",
    "CPP/7zip/UI/Common/PropIDUtils.cpp",
    "CPP/7zip/UI/Common/SetProperties.cpp",
    "CPP/7zip/UI/Common/SortUtils.cpp",
    "CPP/7zip/UI/Common/TempFiles.cpp",
    "CPP/7zip/UI/Common/Update.cpp",
    "CPP/7zip/UI/Common/UpdateAction.cpp",
    "CPP/7zip/UI/Common/UpdateCallback.cpp",
    "CPP/7zip/UI/Common/UpdatePair.cpp",
    "CPP/7zip/UI/Common/UpdateProduce.cpp",
};

const _7z_common_src = [_][]const u8 {
    "CPP/7zip/Common/CreateCoder.cpp",
    "CPP/7zip/Common/FilePathAutoRename.cpp",
    "CPP/7zip/Common/FileStreams.cpp",
    "CPP/7zip/Common/FilterCoder.cpp",
    "CPP/7zip/Common/LimitedStreams.cpp",
    "CPP/7zip/Common/MethodProps.cpp",
    "CPP/7zip/Common/MultiOutStream.cpp",
    "CPP/7zip/Common/ProgressUtils.cpp",
    "CPP/7zip/Common/PropId.cpp",
    "CPP/7zip/Common/StreamObjects.cpp",
    "CPP/7zip/Common/StreamUtils.cpp",
    "CPP/7zip/Common/UniqBlocks.cpp",
};

const ar_common_src = [_][]const u8 {
    "CPP/7zip/Archive/Common/ItemNameUtils.cpp",
    "CPP/7zip/Archive/Common/OutStreamWithCRC.cpp",
};
