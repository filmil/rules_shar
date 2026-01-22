load("@rules_shell//shell:sh_binary.bzl", "sh_binary")
load(":rules.bzl", "gen_shar_stub")
load("@rules_pkg//pkg/private/tar:tar.bzl", "pkg_tar")


def shar_binary(name, args=None, deps=[], data=[], **kw):
    sh_binary(name=name, deps=deps, data=data, **kw)
    gen_shar_stub(
        name="{}_stub".format(name),
        src=":{}".format(name),
        args=args,
    )
    pkg_tar(
        name="{}_tar".format(name),
        srcs=[
            ":{}".format(name),
        ],
        mode="0755",
        include_runfiles=True,
    )
    native.genrule(
        name="{}_shar".format(name),
        srcs=[
            ":{}_tar".format(name),
            ":{}_stub".format(name),
        ],
        outs=[ "{}.shar".format(name)],
        cmd="""
            cat $(location :{name}_stub) $(locations :{name}_tar) > $@ && chmod +x $@
        """.format(name=name),
        executable = True,
    )
