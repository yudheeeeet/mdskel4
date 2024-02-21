library(datamodelr)
file_path <- "/Users/ydth/Desktop/erd.yml"
dm <- dm_read_yaml(file_path)

graph <- dm_create_graph(dm,rankdir = "BT", col_attr = c("column", "type"),
                         view_type = "keys-only" )

dm_render_graph(graph)

