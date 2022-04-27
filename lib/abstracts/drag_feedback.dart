part of draggable_gridview;

/// Feedback 用于展示拖拽过程中的反馈部件。
abstract class DragFeedback {
  /// 返回拖拽过程中的自定义包装的反馈部件。
  Widget feedback(List<DraggableGridItem> list, int index);
}