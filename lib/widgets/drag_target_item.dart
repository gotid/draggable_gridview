part of draggable_gridview;

/// DragTargetItem 表示一个拖拽目标的网格项。
class DragTargetItem extends StatefulWidget {
  final int index;
  /// 空回调，用于 draggable_gridview 更新状态
  final VoidCallback voidCallback;
  final MoveCallback moveCallback;
  final Widget? feedback;
  final Widget? childWhenDragging;
  final PlaceholderItem? placeholder;
  final DragCompletion dragCompletion;
  final Duration? longPressDelay;

  const DragTargetItem({
    Key? key,
    required this.index,
    required this.voidCallback,
    required this.moveCallback,
    required this.dragCompletion,
    this.feedback,
    this.childWhenDragging,
    this.placeholder,
    this.longPressDelay,
  }) : super(key: key);

  @override
  _DragTargetItemState createState() => _DragTargetItemState();
}

class _DragTargetItemState extends State<DragTargetItem> {
  /// 最后一次被拖动的索引
  static int _lastIndex = -1;

  /// 被拖拽的索引
  static int _draggedIndex = -1;

  /// 拖拽索引是否已被移除
  static bool _draggedIndexRemoved = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (BuildContext context, List<Object?> candidateData,
          List<dynamic> rejectedData) {
        return (_isOnlyLongPress)
            ? LongPressDraggableItem(
                index: widget.index,
                delay: widget.longPressDelay,
                feedback: widget.feedback,
                childWhenDragging: widget.childWhenDragging,
                onDragCancelled: () {
                  _onDragComplete(_lastIndex);
                },
              )
            : PressDraggableItem(
                index: widget.index,
                feedback: widget.feedback,
                childWhenDragging: widget.childWhenDragging,
                onDragCancelled: () {
                  _onDragComplete(_lastIndex);
                },
              );
      },
      onWillAccept: (index) {
        // 此段可用于控制特殊选中项是否可拖拽
        debugPrint("onWillAccept: " + index.toString());
        return true;
      },
      onMove: (details) {
        // 更新移动状态
        setState(() {
          debugPrint("onMove: data-${details.data} offset-${details.offset}");

          _setDragStartedData(details, widget.index);
          _checkIndexesAreDifferent(details, widget.index);
          widget.voidCallback();
        });

        // TODO 触发翻屏操作。
      },
      onAccept: (data) {
        // TODO 判断加入目标还是重排序
        // for (var i=0; i<_list.length; i++) {
        //   debugPrint('$i ${_list[i].canJoin}');
        // }

        debugPrint(
            'onAccept(${widget.index})');  //: $data 目标id是否可加入 ${_list[_lastIndex - 1].id}： ${_list[_lastIndex - 1].canJoin}');
        _onDragComplete(widget.index);
      },
      onLeave: (details) {
        debugPrint("onLeave: " + details.toString());
      },
    );
  }

  /// 在拖拽完成或取消时被调用
  void _onDragComplete(int index) {
    if (_draggedIndex == -1) return;

    _list.removeAt(index);
    _list.insert(index, _orgList[_draggedIndex]);

    _orgList = [..._list];
    _dragStarted = false;
    _draggedIndex = -1;
    _lastIndex = -1;
    _draggedGridItem = null;

    widget.voidCallback();
    widget.dragCompletion.onDragAccept(_orgList);
  }

  /// 设置拖拽数据
  void _setDragStartedData(DragTargetDetails details, int index) {
    if (_dragStarted) {
      _dragStarted = false;
      _draggedIndexRemoved = false;
      _draggedIndex = details.data;
      _draggedGridItem = const DraggableGridItem(
        id: -1,
        child: EmptyItem(),
        isDraggable: true,
      );
      _lastIndex = _draggedIndex;
    }
  }

  /// 当 [_draggedIndex] 和 [_lastIndex] 不同，意味着被拖到了另一个地方
  void _checkIndexesAreDifferent(DragTargetDetails details, int index) {
    if (_draggedIndex == -1) return;
    if (index == _lastIndex) return; // 没动的不管

    // 移除 PlaceHolderItem 或 EmptyItem
    _list.removeWhere((element) => (widget.placeholder != null)
        ? element.child is PlaceholderItem
        : element.child is EmptyItem);

    // 将 index 存入 _lastIndex
    // 即 draggedIndex=6 拖入 index=4 时，设置 _lastIndex=4
    _lastIndex = index;

    // 此处检测 _draggedIndex 是否大于 _lastIndex
    // 如 _draggedIndex=6 且 _lastIndex=4，则 _draggedGridItem 为索引项 5
    if (_draggedIndex > _lastIndex) {
      _draggedGridItem = _orgList[_draggedIndex - 1];
    } else {
      var idx = (_draggedIndex + 1 >= _list.length)
          ? _draggedIndex
          : _draggedIndex + 1;
      _draggedGridItem = _orgList[idx];
    }

    // 拖动索引和当前索引相同时，优先展示自定义 Placeholder，如无则展示默认的 EmptyItem。
    if (_draggedIndex == _lastIndex) {
      _draggedGridItem = DraggableGridItem(
        id: -1,
        child: widget.placeholder ?? const EmptyItem(),
        isDraggable: true,
      );
    }

    // 从列表中移除拖拽项
    if (!_draggedIndexRemoved) {
      _draggedIndexRemoved = true;
      _list.removeAt(_draggedIndex);
    }

    _list.insert(
      _lastIndex,
      DraggableGridItem(
        id: -1,
        child: widget.placeholder ?? const EmptyItem(),
        isDraggable: true,
      ),
    );


    widget.moveCallback(details);
  }
}
