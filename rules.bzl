
def _gen_shar_stub_impl(ctx):
    name = ctx.attr.name
    src_file = ctx.attr.src.files.to_list()[0]
    output_file = ctx.actions.declare_file(
        "{}.sh".format(name))

    src = ctx.attr.src.label
    # For //example/package:binary:
    # src.package == "example/package"
    # src.name == "binary"
    src_target_name = "/".join([src.package, src.name])
    subst = {
        "{{BINARY_RELATIVE_PATH}}": src_target_name,
        # Apparently, runfiles are always at the top level
        # in the archive.
        "{{RUNFILES_LOCAL_PATH}}":
            "{}.runfiles/_main".format(src.name),
    }

    template_file = ctx.attr._stub_template.files.to_list()[0]
    ctx.actions.expand_template(
        template = template_file,
        output = output_file,
        substitutions = subst,
        is_executable = True,
    )

    return [
        DefaultInfo(
            files=depset([output_file])
        )
    ]

gen_shar_stub = rule(
    implementation = _gen_shar_stub_impl,
    attrs = {
        "src": attr.label(),
        "_stub_template": attr.label(
            allow_single_file = True,
            default = Label(":stub_template.bash"),
        ),
    },
)
