# 2D_Node_Arranger API Reference
Generated on: 2026-03-09

This node will sort / arrange the child nodes in a certain way, that you can define yourself with the variables.

---

## Properties
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **continous_arranging** | `` | `true` | If not true the elements won't arrange automatically |
| **max_vertical** | `` | `1` | Sets the maximum for how many nodes can be arranged by this node vertically |
| **max_horizontal** | `` | `10` | Sets the maximum for how many nodes can be arranged by this node horizontally |
| **offset** | `` | `-` | Offsets the position of all nodes being arranged by this node |
| **centered** | `` | `true` | (Attempts) to center the elements at the position of the arranger |
| **distance_vertical** | `` | `100` | Determines the vertical distance between each column |
| **distance_horizontal** | `` | `100` | Determines the horisontal distance between each row |
| **nodes_to_exclude** | `` | `-` | Use if the nodes being sorted are not the child nodes (like sub-children) |
| **ignore_node_exclusion** | `` | `false` | Ignores the excluded nodes and includes them. |
| **alternative_node_list** | `` | `[]` | By default, this node arranges their children. With this you can use an alternative list of nodes to arrange instead of the children. |
| **ignore_alternative_node_list** | `` | `false` | Ignores the alternative node list. |

## Methods
| Method | Returns | Description |
| :--- | :--- | :--- |
| **arrange()** | `void` | If "continous_arranging" is set to false, you can use this method to manually arrange the nodes inside your script. |

