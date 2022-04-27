library draggable_gridview;

import 'dart:math';

import 'package:draggable_gridview/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

part 'models/draggable_grid_item.dart';

part 'abstracts/drag_feedback.dart';

part 'abstracts/child_when_dragging.dart';

part 'abstracts/placeholder.dart';

part 'abstracts/drag_completion.dart';

part 'widgets/placeholder_widget.dart';

part 'widgets/drag_target_item.dart';

part 'widgets/long_press_draggable_item.dart';

part 'widgets/press_draggable_item.dart';

part 'widgets/empty_item.dart';

part 'common/global_variables.dart';

typedef MoveCallback = void Function(DragTargetDetails details);

/// 可拖拽排序的 GridView 构建器。
class DraggableGridViewBuilder extends StatefulWidget {
  /// [children] 是显示在 GridView.builder 中的网格项。
  final List<DraggableGridItem> children;

  /// [isOnlyLongPress] 该布尔属性指示拖拽识别手势为长按拖拽（默认）还是短按拖拽。
  final bool isOnlyLongPress;

  /// [dragCompletion] 用于拖拽完成后获取更新后列表的回调
  final DragCompletion dragCompletion;

  /// [dragFeedback] 用于展示拖拽过程中的反馈部件。
  final DragFeedback? dragFeedback;

  /// [dragChildWhenDragging] 用于展示拖拽过程中的部件。
  final DragChildWhenDragging? dragChildWhenDragging;

  /// [dragPlaceholder] 用于在拖拽目标处显示小部件。
  final DragPlaceholder? dragPlaceholder;

  // ===== 以下参数用于 GridView.builder =====

  /// [gridDelegate] 控制 GridView 中子对象布局的代理。
  final SliverGridDelegate gridDelegate;

  /// [scrollDirection] 用于设定 GridView 的滚动方向。
  final Axis scrollDirection;
  final bool reverse;

  /// [controller] 是 GridView 的滚动控制器。
  final ScrollController? controller;
  final bool? primary;

  /// [physics] 控制滚动小部件的物理特性。如触底或停止滚动等。
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// [padding] 用于文本方向感知的解析。
  final EdgeInsetsGeometry? padding;

  /// [addAutomaticKeepAlives] 指示是否自动保活。
  final bool addAutomaticKeepAlives;

  /// [addRepaintBoundaries] 指示是否重绘边界。
  final bool addRepaintBoundaries;

  /// [addSemanticIndexes] 指示是否添加语义化索引。
  final bool addSemanticIndexes;

  /// 缓存范围数值
  final double? cacheExtend;

  /// 语义子部件数量
  final int? semanticChildCount;

  /// 传递给 DragStartDetails 的偏移量配置枚举。
  final DragStartBehavior dragStartBehavior;

  /// 用于 ScrollView 操控屏幕键盘关闭的行为控制类
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// 复位编号
  final String? restorationId;

  /// 剪辑部件内容的不同方式枚举
  final Clip clipBehavior;

  const DraggableGridViewBuilder({
    Key? key,
    required this.gridDelegate,
    required this.children,
    required this.dragCompletion,
    this.isOnlyLongPress = true,
    this.dragFeedback,
    this.dragChildWhenDragging,
    this.dragPlaceholder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtend,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  @override
  _DraggableGridViewBuilderState createState() =>
      _DraggableGridViewBuilderState();
}

class _DraggableGridViewBuilderState extends State<DraggableGridViewBuilder> {
  @override
  void initState() {
    super.initState();
    assert(widget.children.isNotEmpty, 'child 不能为空。');

    /// 拖拽中的网格项列表
    _list = [...widget.children];

    // 拖拽后的网格项列表
    _orgList = [...widget.children];
    _isOnlyLongPress = widget.isOnlyLongPress;

    //监听滚动事件，打印滚动位置
    // widget.controller?.addListener(() {
    //   debugPrint(widget.controller?.offset.toString()); //打印滚动位置
    //   // if (widget.controller?.offset < 1000) {
    //   //   setState(() {
    //   //     debugPrint('showToTopBtn = false');
    //   //   });
    //   // } else if (widget.controller?.offset >= 1000) {
    //   //   setState(() {
    //   //     debugPrint('showToTopBtn = true');
    //   //   });
    //   // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtend,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      gridDelegate: widget.gridDelegate,
      itemBuilder: (_, index) {
        return (!_list[index].isDraggable)
            ? _list[index].child
            : DragTargetItem(
                index: index,
                longPressDelay: const Duration(milliseconds: 100),
                voidCallback: () {
                  debugPrint('voidCallback');
                  setState(() {});
                },
                moveCallback: (details) {
                  debugPrint('moveCallback: data-${details.data} '
                      'distance-${details.offset.distance} '
                      'direction-${details.offset.direction} '
                      'dy-${details.offset.dy} '
                      'screenHeight-$screenHeight '
                      'sc-offset-${widget.controller?.offset} '
                      'sc-viewportdimention-${widget.controller?.position.viewportDimension} '
                      'sc-maxScrollExtend-${widget.controller?.position.maxScrollExtent} ');
                  if (details.offset.dy != 0 &&
                      widget.controller?.position.outOfRange == false) {
                    var offset = details.offset.dy <= 100
                        ? .0
                        : min(
                            details.offset.dy - imageHeight + 40,
                            widget.controller?.position.maxScrollExtent ??
                                screenHeight);

                    widget.controller?.animateTo(
                      offset,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease,
                    );
                  }
                },
                feedback: widget.dragFeedback?.feedback(_list, index),
                childWhenDragging: widget.dragChildWhenDragging
                    ?.childWhenDragging(_orgList, index),
                placeholder:
                    widget.dragPlaceholder?.placeholder(_orgList, index),
                dragCompletion: widget.dragCompletion,
              );
      },
      itemCount: _list.length,
    );
  }
}
