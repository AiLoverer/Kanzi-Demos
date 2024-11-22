dependencies = ["kzui"]

m = module("XMLDataSource_component")
m.type = "a"
if build_from_sources:
    m.depends += dependencies
    if GetOption("build-dynamic-libs"): # This option is set when --dynamic is used
        m.type = "so"
        m.env["SHLINKFLAGS"] += ["-shared"]
else:
    m.used_libraries += dependencies

m.root = os.path.join("..", "..", "..", "src", "plugin")
m.output_path = os.path.join("..", "..", "..", "output", platform_name, profile_string, "plugin")

m.env["CPPDEFINES"] += ["XML_DATA_SOURCE_API="]

del m

m = module(project_name)
m.depends += ["XMLDataSource_component"]

if build_from_sources:
    m.depends += dependencies
else:
    m.used_libraries += dependencies

m.include_paths += [os.path.join("..", "..", "..", "src", "plugin", "src")]

m.root = os.path.join("..", "..", "..", "src", "executable")
m.output_path = os.path.join("..", "..", "..", "output", platform_name, profile_string, "executable")

m.env["CPPDEFINES"] += ["XML_DATA_SOURCE_API="]

link_font_engine_backends_to_module(m);

del m
