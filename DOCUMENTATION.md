# 2D_Node_Arranger API Reference
Generated on: Mon Mar  9 12:43:06 AM CET 2026

A node that you can use to arrange node in certain patterns. Useful for UI elements, cards for a card game, etc

---

## Properties
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **continous_arranging** | `Variant` | `true; ## If not true the elements won't arrange automatically` | No description provided. |
| **max_vertical** | `` | `1 ## Sets the maximum for how many nodes can be arranged by this node vertically` | No description provided. |
| **max_horizontal** | `` | `10 ## Sets the maximum for how many nodes can be arranged by this node horizontally` | No description provided. |
| **offset** | `` | `-` | No description provided. |
| **centered** | `` | `true; ## (Attempts) to center the elements at the position of the arranger` | No description provided. |
| **distance_vertical** | `` | `100; ## Determines the vertical distance between each column` | No description provided. |
| **distance_horizontal** | `` | `100; ## Determines the horisontal distance between each row` | No description provided. |
| **** | `Variant` | `-` | No description provided. |
| **nodes_to_exclude** | `` | `-` | No description provided. |
| **ignore_node_exclusion** | `` | `false; ## Ignores the excluded nodes and includes them.` | No description provided. |
| **alternative_node_list** | `` | `[] ## By default, this node arranges their children. With this you can use an alternative list of nodes to arrange instead of the children.` | No description provided. |
| **ignore_alternative_node_list** | `` | `false; ## Ignores the alternative node list.` | No description provided. |

## Methods
| Method | Returns | Description |
| :--- | :--- | :--- |
| **_process()** | `void` | No description provided. |
| **arrange()** | `void` | No description provided. |
| **_arrange_nodes()** | `void` | No description provided. |
| **_arrange_node()** | `void` | No description provided. |

## Signals
| Signal | Description |
| :--- | :--- |
