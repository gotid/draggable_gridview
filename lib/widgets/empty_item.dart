part of draggable_gridview;

/// EmptyItem 当可拖拽部件被拖动时，用在原始位置显示的空部件。
class EmptyItem extends StatelessWidget {
  const EmptyItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: AppColors.red);
  }
}
