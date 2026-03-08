# 2D_Node_Arranger API Reference
Generated on: Sun Mar  8 07:13:13 PM CET 2026

---

## NodeArranger

This node will sort / arrange the child nodes in a certain way, that you can define yourself with the variables.

   

## Properties
### continous_arranging
**Type:** Variant
**Default:** true

If not true the elements won't arrange automatically

### max_vertical
**Type:** int
**Default:** 1

Sets the maximum for how many nodes can be arranged by this node vertically

### max_horizontal
**Type:** int
**Default:** 10

Sets the maximum for how many nodes can be arranged by this node horizontally

### offset
**Type:** Vector2

Offsets the position of all nodes being arranged by this node

### centered
**Type:** bool
**Default:** true

(Attempts) to center the elements at the position of the arranger

### distance_vertical
**Type:** float
**Default:** 100.0

Determines the vertical distance between each column

### distance_horizontal
**Type:** float
**Default:** 100.0

Determines the horisontal distance between each row

Node[] nodes_to_exclude

Use if the nodes being sorted are not the child nodes (like sub-children)

### ignore_node_exclusion
**Type:** bool
**Default:** false

Ignores the excluded nodes and includes them.

Node[] alternative_node_list = []

By default, this node arranges their children. With this you can use an alternative list of nodes to arrange instead of the children.

### ignore_alternative_node_list
**Type:** bool
**Default:** false

Ignores the alternative node list.

