dependencies = ["kzui"]

m = module(project_name)

if build_from_sources:
    m.depends += dependencies
else:
    m.used_libraries += dependencies

m.root = os.path.join("..", "..", "..", "src")

link_font_engine_backends_to_module(m);

del m