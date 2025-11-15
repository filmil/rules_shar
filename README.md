# Bazel rules for creating self-extracting archives (shar)

[![Test](https://github.com/filmil/rules_shar/actions/workflows/test.yml/badge.svg)](https://github.com/filmil/rules_shar/actions/workflows/test.yml)
[![Publish BCR](https://github.com/filmil/rules_shar/actions/workflows/publish-bcr.yml/badge.svg)](https://github.com/filmil/rules_shar/actions/workflows/publish-bcr.yml)
[![Tag and Release](https://github.com/filmil/rules_shar/actions/workflows/tag-and-release.yml/badge.svg)](https://github.com/filmil/rules_shar/actions/workflows/tag-and-release.yml)

This repository provides Bazel rules for creating self-extracting archives
("shar"s) out of shell binaries.

## Usage

To use the rules, add the following to your `MODULE.bazel` file:

```bzl
bazel_dep(name = "rules_shar", version = "0.0.0") # Select your version, of course.
```

Then, in your `BUILD.bazel` file, you can use the `sh_binary` rule to create a self-extracting archive,
as a drop-in replacement for the rule `sh_binary`.

```bzl
load("@rules_shar//:rules.bzl", "sh_binary")

sh_binary(
    name = "binary",
    srcs = [
        "binary.sh",
    ],
    deps = [
        ":lib",
    ],
    data = [
        ":data",
    ],
)
```

This will create the target `:binary`, but also the target `:binary_shar`. The former
is the usual shell binary, while the latter is an archive containing all the runfiles
defined by `:binary`, and when started behaves the same as `:binary`.  Mostly this
means you get a standalone executable that you may use elsewhere.

