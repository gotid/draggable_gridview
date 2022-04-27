part of draggable_gridview;

/// PlaceholderWidget 用于在拖拽目标处显示的小部件。
class PlaceholderItem extends StatelessWidget {
  final Widget child;

  const PlaceholderItem({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
