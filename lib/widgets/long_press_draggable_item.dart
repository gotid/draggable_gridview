part of draggable_gridview;

class LongPressDraggableItem extends StatelessWidget {
  /// [index] 用于从列表中获取网格项。
  final int index;

  /// 长按延迟时长
  final Duration? delay;

  /// [onDragCancelled] 取消拖拽的回调函数
  final VoidCallback onDragCancelled;

  /// 用于展示拖拽过程中的反馈部件。
  final Widget? feedback;

  /// 用于展示拖拽过程中的部件。
  final Widget? childWhenDragging;

  const LongPressDraggableItem({
    Key? key,
    required this.index,
    required this.onDragCancelled,
    this.delay,
    this.feedback,
    this.childWhenDragging,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: index,
      child: _list[index].child,
      delay: delay ?? const Duration(milliseconds: 100),
      feedback: feedback ?? _list[index].child,
      childWhenDragging:
          childWhenDragging ?? _draggedGridItem?.child ?? _list[index].child,
      onDraggableCanceled: (velocity, offset) {
        onDragCancelled();
      },
      onDragStarted: () {
        debugPrint("onDragStarted");
        if (_dragEnded) {
          _dragStarted = true;
          _dragEnded = false;
        }
      },
      onDragUpdate: (details) {
        debugPrint(
            "onDragUpdate: delta-${details.delta} globalPosition-${details.globalPosition} localPosition-${details.localPosition} primaryDelta-${details.primaryDelta}");
      },
      onDragEnd: (details) {
        debugPrint("onDragEnd");
        _dragEnded = true;
        _dragStarted = false;
      },
    );
  }
}
