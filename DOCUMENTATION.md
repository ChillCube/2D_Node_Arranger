# 2D_Node_Arranger API Reference
Generated: 2026-05-10

A node that you can use to arrange node in certain patterns. Useful for UI elements, cards for a card game, etc

## Class: NodeArranger
		#
		#
**Inherits:** [Node2D](https://docs.godotengine.org/en/stable/classes/class_node2d.html)

This node will sort / arrange the child nodes in a certain way, that you can define yourself with the variables.

### ⚙️ Inspector Variables (Exported)
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **continous_arranging** | `bool` | `true` | If not true the elements won't arrange automatically |
| **max_vertical** | `int` | `1` | Sets the maximum for how many nodes can be arranged by this node vertically |
| **max_horizontal** | `int` | `10` | Sets the maximum for how many nodes can be arranged by this node horizontally |
| **offset** | `Vector2` | `-` | Offsets the position of all nodes being arranged by this node |
| **centered** | `bool` | `true` | (Attempts) to center the elements at the position of the arranger |
| **distance_vertical** | `float` | `100` | Determines the vertical distance between each column |
| **distance_horizontal** | `float` | `100` | Determines the horizontal distance between each row |
| **auto_distance** | `bool` | `false` | When enabled, spacing is derived from each element's measured size instead of fixed distances. |
| **gap_horizontal** | `float` | `0.0` | Horizontal gap between elements when auto_distance is enabled. |
| **gap_vertical** | `float` | `0.0` | Vertical gap between elements when auto_distance is enabled. |
| **min_distance_horizontal** | `float` | `0.0` | Minimum horizontal spacing per element when auto_distance is enabled. 0 = no minimum. |
| **min_distance_vertical** | `float` | `0.0` | Minimum vertical spacing per element when auto_distance is enabled. 0 = no minimum. |
| **nodes_to_exclude** | `Array[Node]` | `-` | Use if the nodes being sorted are not the child nodes (like sub-children) |
| **ignore_node_exclusion** | `bool` | `false` | Ignores the excluded nodes and includes them. |
| **alternative_node_list** | `Array[Node]` | `[]` | By default, this node arranges their children. |
| **ignore_alternative_node_list** | `bool` | `false` | Ignores the alternative node list. |
| **use_relative_positioning** | `bool` | `false` | When enabled, the arranger's own position is defined as a fraction of the viewport size, keeping it consistent across different resolutions. |
| **anchor_point** | `Vector2` | `Vector2(0.5, 0.5)` | Normalized screen coordinate (0.0–1.0) used as the arranger's origin. |
| **_position** | `Vector2` | `Vector2.ZERO` | Normalized offset from the anchor point. |
| **animate_entry_exit** | `bool` | `false` | When enabled, the arranger slides in on spawn and slides out before freeing. |
| **_off_screen_position** | `Vector2` | `Vector2(0.0, 0.6)` | Normalized viewport offset for the hidden position (same convention as SmoothButton). |
| **entry_exit_speed** | `float` | `10.0` | Speed of the entry/exit lerp. |

---

