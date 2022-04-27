part of draggable_gridview;

// DragPlaceholder 用于在拖拽目标处显示小部件。
abstract class DragPlaceholder {
  /// 返回拖拽过程中的自定义包装的拖拽目标显示的部件。
  PlaceholderItem placeholder(List<DraggableGridItem> list, int index);
}
