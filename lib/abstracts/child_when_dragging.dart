part of draggable_gridview;

/// DragChildWhenDragging 用于展示拖拽过程中的部件。
abstract class DragChildWhenDragging {
  Widget childWhenDragging(List<DraggableGridItem> list, int index);
}
