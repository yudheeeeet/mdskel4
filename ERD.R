library(datamodelr)
file_path <- "/Users/ydth/Desktop/erd.yml"
dm <- dm_read_yaml(file_path)

graph <- dm_create_graph(dm,rankdir = "BT", col_attr = c("column", "type"),
                         view_type = "keys-only", graph_attrs = "rankdir = RL, bgcolor = '#F4F0EF' ", 
                         edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",)

dm_render_graph(graph)

