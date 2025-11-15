load("@rules_shell//shell:sh_binary.bzl",
    _sh_binary = "sh_binary")
load(":rules.bzl", "gen_shar_stub")
load("@rules_pkg//pkg/private/tar:tar.bzl", "pkg_tar")

def sh_binary(name, **kw):
    _sh_binary(name=name, **kw)
    gen_shar_stub(
        name="{}_stub".format(name),
        src=":{}".format(name)
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
    )
