part of draggable_gridview;

/// DraggableGridItem 用于管理可拖拽网格项及其拖拽开关。
/// [child] 用于展示在 GridView.builder 中的可拖拽项组件。
/// [isDraggable] 用于开关网格项的拖拽功能。
class DraggableGridItem {
  const DraggableGridItem({
    Key? key,
    required this.id,
    required this.child,
    this.isDraggable = false,
    this.canJoin = false,
  });

  final int id;
  final Widget child;

  /// [isDraggable] 指示该网格项是否可拖拽。
  final bool isDraggable;

  /// [canJoin] 指示该网格项是否可加入子项。
  final bool canJoin;
}
