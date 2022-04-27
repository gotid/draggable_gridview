part of draggable_gridview;

/// Completion 用于拖拽完成后获取更新后列表的回调。
abstract class DragCompletion {
  /// 处理拖拽排序后的列表，如保存排序。
  void onDragAccept(List<DraggableGridItem> list);
}
