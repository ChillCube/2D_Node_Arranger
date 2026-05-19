@tool
@icon("res://addons/2d_node_arranger/icon_list.png")
## This node will sort / arrange the child nodes in a certain way, that you can define yourself with the variables.
extends Node2D
class_name NodeArranger

@export var continous_arranging : bool = true ## If not true the elements won't arrange automatically

@export_group("Grid Settings")
@export var max_vertical : int = 1 ## Sets the maximum for how many nodes can be arranged by this node vertically
@export var max_horizontal : int = 10 ## Sets the maximum for how many nodes can be arranged by this node horizontally
@export var offset : Vector2 ## Offsets the position of all nodes being arranged by this node
@export var centered : bool = true ## (Attempts) to center the elements at the position of the arranger

@export_group("Spacing")
@export var distance_vertical : float = 100 ## Determines the vertical distance between each column
@export var distance_horizontal : float = 100 ## Determines the horizontal distance between each row

@export_subgroup("Auto Distance")
@export var auto_distance : bool = false ## When enabled, spacing is derived from each element's measured size instead of fixed distances.
@export var gap_horizontal : float = 0.0 ## Horizontal gap between elements when auto_distance is enabled.
@export var gap_vertical : float = 0.0 ## Vertical gap between elements when auto_distance is enabled.
@export var min_distance_horizontal : float = 0.0 ## Minimum horizontal spacing per element when auto_distance is enabled. 0 = no minimum.
@export var min_distance_vertical : float = 0.0 ## Minimum vertical spacing per element when auto_distance is enabled. 0 = no minimum.

@export_group("Visual FX")
## These variables are used by sub-classes like CardHand for "fanning" effects
@export var curve_intensity : float = 0.0
@export var rotation_intensity : float = 0.0

@export_group("Node List")
@export var nodes_to_exclude : Array[Node] ## Use if the nodes being sorted are not the child nodes (like sub-children)
@export var ignore_node_exclusion : bool = false ## Ignores the excluded nodes and includes them.
@export var alternative_node_list : Array[Node] = [] ## By default, this node arranges their children.
@export var ignore_alternative_node_list : bool = false ## Ignores the alternative node list.

@export_group("Adaptive Positioning")
@export var use_relative_positioning: bool = false ## When enabled, the arranger's own position is defined as a fraction of the viewport size, keeping it consistent across different resolutions.
@export var anchor_point: Vector2 = Vector2(0.5, 0.5) ## Normalized screen coordinate (0.0–1.0) used as the arranger's origin.
@export var _position: Vector2 = Vector2.ZERO ## Normalized offset from the anchor point.

@export_group("Entry / Exit Animation")
@export var animate_entry_exit: bool = false ## When enabled, the arranger slides in on spawn and slides out before freeing.
@export var _off_screen_position: Vector2 = Vector2(0.0, 0.6) ## Normalized viewport offset for the hidden position (same convention as SmoothButton).
@export var entry_exit_speed: float = 10.0 ## Speed of the entry/exit lerp.

var mover: SmoothMovement = null
var original_position: Vector2
var current_off_screen_pixels: Vector2
var _is_hidden: bool = false
var _is_despawning: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		get_tree().get_root().size_changed.connect(_update_anchor_position)
	original_position = global_position
	_update_anchor_position()
	if not Engine.is_editor_hint() and animate_entry_exit:
		current_off_screen_pixels = get_viewport_rect().size * _off_screen_position
		global_position = original_position + current_off_screen_pixels
		mover = SmoothMovement.init(self)
		mover.speed = entry_exit_speed
		mover.tilt_on = false
		mover.rotation_on = false
		mover.scale_on = false

func _update_anchor_position() -> void:
	if not use_relative_positioning:
		return
	var viewport_size := get_viewport_rect().size
	if viewport_size == Vector2.ZERO:
		return
	original_position = viewport_size * anchor_point + viewport_size * _position
	current_off_screen_pixels = viewport_size * _off_screen_position
	if not animate_entry_exit:
		global_position = original_position

func close() -> void:
	if not animate_entry_exit or not mover:
		queue_free()
		return
	_is_hidden = true
	_is_despawning = true

func _process(_delta: float) -> void:
	if use_relative_positioning:
		_update_anchor_position()
	if animate_entry_exit and mover:
		current_off_screen_pixels = get_viewport_rect().size * _off_screen_position
		var target := original_position + current_off_screen_pixels if _is_hidden else original_position
		if Engine.is_editor_hint():
			global_position = target
		else:
			mover.global_target_position = target
		if _is_despawning and global_position.distance_to(original_position + current_off_screen_pixels) < 8.0:
			queue_free()
			return
	if continous_arranging:
		arrange()

func arrange() -> void:
	_arrange_nodes(_get_nodes_to_arrange())

func _get_nodes_to_arrange() -> Array[Node]:
	var nodes: Array[Node]
	if alternative_node_list.size() == 0 or ignore_alternative_node_list:
		nodes = get_children()
	else:
		nodes = alternative_node_list
	if not ignore_node_exclusion:
		for node in nodes_to_exclude:
			if node in nodes:
				nodes.erase(node)
	return nodes

## Returns the total bounding size of this arranger's content.
## Used by parent NodeArrangers to measure this node when auto_distance is enabled.
func get_arranged_bounds() -> Vector2:
	var nodes := _get_nodes_to_arrange()
	if nodes.is_empty():
		return Vector2.ZERO
	var grid := _build_grid(nodes)
	if grid.is_empty():
		return Vector2.ZERO

	var max_cols := 0
	for row in grid:
		max_cols = maxi(max_cols, row.size())

	if auto_distance:
		var col_widths: Array[float] = []
		col_widths.resize(max_cols)
		col_widths.fill(0.0)
		var row_heights: Array[float] = []
		for row in grid:
			var row_h := 0.0
			for c in row.size():
				var sz := _get_node_size(row[c])
				col_widths[c] = maxf(col_widths[c], sz.x)
				row_h = maxf(row_h, sz.y)
			row_heights.append(maxf(row_h, min_distance_vertical))
		for c in col_widths.size():
			col_widths[c] = maxf(col_widths[c], min_distance_horizontal)

		var total_w := 0.0
		for w in col_widths:
			total_w += w + gap_horizontal
		var total_h := 0.0
		for h in row_heights:
			total_h += h + gap_vertical
		return Vector2(
			total_w - gap_horizontal if total_w > 0 else 0.0,
			total_h - gap_vertical if total_h > 0 else 0.0
		)
	else:
		# Fixed mode: span between edge element centers + largest element size
		var max_elem := Vector2.ZERO
		for row in grid:
			for node in row:
				max_elem = _max_vec(max_elem, _get_node_size(node))
		var num_rows := grid.size()
		return Vector2(
			(max_cols - 1) * distance_horizontal + max_elem.x,
			(num_rows - 1) * distance_vertical + max_elem.y
		)

func _arrange_nodes(nodes : Array[Node]) -> void:
	if auto_distance:
		_arrange_nodes_auto(nodes)
	else:
		_arrange_nodes_fixed(nodes)

func _arrange_nodes_fixed(nodes : Array[Node]) -> void:
	var node_count_horizontal : int = 0
	var node_count_vertical : int = 0
	var place_node : bool = true

	for node in nodes:
		if node_count_horizontal < max_horizontal:
			node_count_horizontal += 1
		else:
			node_count_horizontal = 1
			node_count_vertical += 1
			if node_count_vertical >= max_vertical:
				place_node = false

		if place_node:
			var placement : Vector2
			if centered:
				placement = global_position + offset + Vector2(
					distance_horizontal * (node_count_horizontal - (max_horizontal + 1) / 2.0),
					distance_vertical * (node_count_vertical - (max_vertical - 1) / 2.0)
				)
			else:
				placement = global_position + offset + Vector2(
					distance_horizontal * node_count_horizontal,
					distance_vertical * node_count_vertical
				)
			# Default rotation is 0 for the base arranger
			_arrange_node(node, placement, 0.0)

func _arrange_nodes_auto(nodes: Array[Node]) -> void:
	if nodes.is_empty():
		return

	var grid := _build_grid(nodes)
	if grid.is_empty():
		return

	var max_cols := 0
	for row in grid:
		max_cols = maxi(max_cols, row.size())

	# Per-column widths and per-row heights, clamped to minimums
	var col_widths: Array[float] = []
	col_widths.resize(max_cols)
	col_widths.fill(0.0)
	var row_heights: Array[float] = []

	for row in grid:
		var row_h := 0.0
		for c in row.size():
			var sz := _get_node_size(row[c])
			col_widths[c] = maxf(col_widths[c], sz.x)
			row_h = maxf(row_h, sz.y)
		if min_distance_vertical > 0.0:
			row_h = maxf(row_h, min_distance_vertical)
		row_heights.append(row_h)

	for c in col_widths.size():
		if min_distance_horizontal > 0.0:
			col_widths[c] = maxf(col_widths[c], min_distance_horizontal)

	# Cumulative center positions
	var col_centers: Array[float] = []
	var x := 0.0
	for w in col_widths:
		col_centers.append(x + w / 2.0)
		x += w + gap_horizontal

	var row_centers: Array[float] = []
	var y := 0.0
	for h in row_heights:
		row_centers.append(y + h / 2.0)
		y += h + gap_vertical

	var total_w := x - gap_horizontal
	var total_h := y - gap_vertical

	var center_offset := Vector2.ZERO
	if centered:
		center_offset = Vector2(-total_w / 2.0, -total_h / 2.0)

	for r in grid.size():
		for c in grid[r].size():
			var placement := global_position + offset + center_offset + Vector2(col_centers[c], row_centers[r])
			_arrange_node(grid[r][c], placement, 0.0)

func _build_grid(nodes: Array[Node]) -> Array:
	var rows: Array = []
	var row: Array = []
	var effective_max_h: int = max_horizontal if max_horizontal > 0 else 1

	for node in nodes:
		if row.size() < effective_max_h:
			row.append(node)
		else:
			rows.append(row)
			if max_vertical > 0 and rows.size() >= max_vertical:
				return rows
			row = [node]

	if not row.is_empty() and (max_vertical == 0 or rows.size() < max_vertical):
		rows.append(row)

	return rows

func _get_node_size(node: Node) -> Vector2:
	var best := Vector2.ZERO

	# Nested NodeArranger — use its computed content bounds
	if node is NodeArranger:
		return (node as NodeArranger).get_arranged_bounds()

	# _size property (SmoothButton and subclasses)
	var direct_size = node.get("_size")
	if direct_size is Vector2:
		best = _max_vec(best, direct_size)

	# Control.size
	if node is Control:
		best = _max_vec(best, (node as Control).size)

	# Sprite2D texture
	if node is Sprite2D:
		var spr := node as Sprite2D
		if spr.texture:
			best = _max_vec(best, spr.texture.get_size() * abs(spr.scale))

	for child in node.get_children():
		if child is NinePatchRect:
			best = _max_vec(best, (child as NinePatchRect).size)
		elif child is Sprite2D:
			var spr := child as Sprite2D
			if spr.texture:
				best = _max_vec(best, spr.texture.get_size() * abs(spr.scale))
		elif child is Control:
			best = _max_vec(best, (child as Control).size)
		elif child is CollisionShape2D:
			best = _max_vec(best, _shape_size(child as CollisionShape2D))
		elif child is Area2D:
			for sub in child.get_children():
				if sub is CollisionShape2D:
					best = _max_vec(best, _shape_size(sub as CollisionShape2D))

	return best

func _shape_size(cs: CollisionShape2D) -> Vector2:
	if not cs.shape:
		return Vector2.ZERO
	if cs.shape is RectangleShape2D:
		return (cs.shape as RectangleShape2D).size
	if cs.shape is CircleShape2D:
		var d := (cs.shape as CircleShape2D).radius * 2.0
		return Vector2(d, d)
	if cs.shape is CapsuleShape2D:
		var cap := cs.shape as CapsuleShape2D
		return Vector2(cap.radius * 2.0, cap.height)
	return Vector2.ZERO

func _max_vec(a: Vector2, b: Vector2) -> Vector2:
	return Vector2(maxf(a.x, b.x), maxf(a.y, b.y))

func _arrange_node(node : Node, global_pos: Vector2, global_rot: float) -> void:
	var smooth_mover : Variant = has_smooth_mover(node)

	if smooth_mover:
		smooth_mover.global_target_position = global_pos
		smooth_mover.global_target_rotation = global_rot
	else:
		if node is Node2D:
			node.global_position = global_pos
			node.global_rotation = global_rot
		elif node is Control:
			# UI elements use position relative to parent or global_position
			node.global_position = global_pos
			node.rotation = global_rot

func has_smooth_mover(node : Node):
	for child in node.get_children():
		# This assumes you have a class_name SmoothMovement defined elsewhere
		if child.get_script() and child.get_class() == "SmoothMovement":
			return child
		# Fallback if class_name is properly registered:
		if child is SmoothMovement:
			return child
	return null
