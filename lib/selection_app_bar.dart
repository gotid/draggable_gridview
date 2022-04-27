import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SelectionAppBar({
    Key? key,
    this.title,
    this.selection = const Selection.empty(),
  }) : super(key: key);

  final Widget? title;
  final Selection selection;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: selection.isSelecting
          ? AppBar(
              key: const Key('选择'),
              titleSpacing: 0,
              leading: const CloseButton(),
              title: Text('已选 ${selection.amount} 个'),
            )
          : AppBar(
              key: const Key('not-selecting'),
              title: title,
            ),
    );
  }
}
