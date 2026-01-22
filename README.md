# Bazel rules for creating self-extracting archives (shar)

[![Test](https://github.com/filmil/rules_shar/actions/workflows/test.yml/badge.svg)](https://github.com/filmil/rules_shar/actions/workflows/test.yml)
[![Publish to BCR](https://github.com/filmil/rules_shar/actions/workflows/publish-bcr.yml/badge.svg)](https://github.com/filmil/rules_shar/actions/workflows/publish-bcr.yml)
[![Tag and Release](https://github.com/filmil/rules_shar/actions/workflows/tag-and-release.yml/badge.svg)](https://github.com/filmil/rules_shar/actions/workflows/tag-and-release.yml)

This repository provides Bazel rules for creating self-extracting archives
("shar"s) out of shell binaries.

See section "what is this" below for details.

## Usage

To use the rules, add the following to your `MODULE.bazel` file:

```bzl
bazel_dep(name = "rules_shar", version = "0.0.0") # Select your version, of course.
```

Then, in your `BUILD.bazel` file, you can use the `shar_binary` rule to create
a self-extracting archive, as a drop-in replacement for the rule `sh_binary`.

```bzl
load("@rules_shar//:rules.bzl", "shar_binary")

shar_binary(
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

This will create the target `:binary`, but also the target `:binary_shar`. The
former is the usual shell binary, while the latter is an archive containing all
the runfiles defined by `:binary`, and when started behaves the same as
`:binary`.  Mostly this means you get a standalone executable that you may use
elsewhere.

If you want a drop-in replacement for `sh_binary`, you can overload the name:

```python
load("@rules_shar//:rules.bzl", sh_binary = "shar_binary")
```

## What is this?

This repository contains a shell binary build rule which creates a
self-extracting archive of a shell binary and all its runfiles.

This means that you could then copy the resulting archive elsewhere, and under
a certain set of circumstances, it could work independently.

I use it to create scripts that I can deploy via `ssh` to remote systems I own
and therefore avoid installing expensive control plane software such as
[Kubernetes][ks].

[ks]: https://k8s.io

Kubernetes is free to take and deploy, but it will cost you CPU cycles to use
on your cloud provider, and those are not free! Similarly, any other control
plane requires background activity, which all costs money. All I want is
`docker compose`, but without manual `ssh` into remote.

### Limitations

Ideally, it would be possible to take any shell script and move it this way.

However, since the script is tied to your bazel repository, there are some
limitations to what this rules set can do.

If you can work with those limitations, then this rule set may be useful to
you.

Limitations are:

* The resulting archives may be inefficient and/or large.

  Space is not a thing I optimized for. If you have and want ways to save on
  space, pull requests are always welcome.
* The target system must have `bash`, `awk` and `tar` preinstalled.
* You can in principle bundle binaries too, but they should match the target
  system. I like go binaries since they are almost always self-contained.
* If you bundle binaries in, you must ensure that your archive is built for
  the target system's architecture.

  I usually only work on `x86_64`, so I don't really need to provide multiarch
  builds. But it is possible, and if you need this, send PRs.
* Bundling C++ or any other dynamically linked binaries is a coin toss.

  There are products such as [`clodl` from Tweag][cft] which promise to bundle
  in a closure of libraries, but there are sharp corners when using it too.

  I had success with bundling static go binaries.
* It creates a temporary directory to unpack itself before starting, and removes
  it once done. There may be environments where this is not acceptable.
* The script runtime is tied closely to your repo's structure as described by
  its `RUNFILES_DIR`.  You should not depend on `$PWD`.

[cft]: https://github.com/tweag/clodl


## Build and test

### Prerequisites
Install [`bazel`][bzl] via the [`bazelisk` method][bzk].

[bzl]: https://bazel.build
[bzk]: https://www.hdlfactory.com/note/2024/08/24/bazel-installation-via-the-bazelisk-method/

### To build

```shell
bazel build //...
```

### To test

```
bazel test //... && cd integration && bazel test //...
```

### Example use

See the stand-alone module in `//integration` for an example of use.

