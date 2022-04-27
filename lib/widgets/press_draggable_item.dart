part of draggable_gridview;

class PressDraggableItem extends StatelessWidget {
  /// [index] 用于从列表中获取网格项。
  final int index;

  /// [onDragCancelled] 取消拖拽的回调函数
  final VoidCallback onDragCancelled;

  /// 用于展示拖拽过程中的反馈部件。
  final Widget? feedback;

  /// 用于展示拖拽过程中的部件。
  final Widget? childWhenDragging;

  const PressDraggableItem({
    Key? key,
    required this.index,
    required this.onDragCancelled,
    this.feedback,
    this.childWhenDragging,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: index,
      child: _list[index].child,
      feedback: feedback ?? _list[index].child,
      childWhenDragging:
          childWhenDragging ?? _draggedGridItem?.child ?? _list[index].child,
      onDraggableCanceled: (velocity, offset) {
        onDragCancelled();
      },
      onDragStarted: () {
        if (_dragEnded) {
          _dragStarted = true;
          _dragEnded = false;
        }
      },
      onDragEnd: (details) {
        var h = MediaQuery.of(context).size.height;
        var s = 'wasAccepted: ${details.wasAccepted} velocity: ${details.velocity} offset: ${details.offset} h: $h';
        debugPrint('onDragEnd(id ${_list[index].id}): ' + s);

        _dragEnded = true;
        _dragStarted = false;
      },
    );
  }
}
