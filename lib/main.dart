import 'package:dotted_border/dotted_border.dart';
import 'package:draggable_gridview/constants/colors.dart';
import 'package:draggable_gridview/constants/dimens.dart';
import 'package:draggable_gridview/constants/strings.dart';
import 'package:draggable_gridview/draggable_gridview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: ThemeData(
        primarySwatch: AppColors.primaryColor,
      ),
      home: const MyHomePage(title: Strings.appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with DragFeedback, DragPlaceholder, DragCompletion {
  final List<DraggableGridItem> _listOfDraggableGridItem = [];
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    _generateImageData();
    super.initState();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用controller.dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHalfHeight = (MediaQuery.of(context).size.height / 2);
    imageWidth = (screenWidth / gridViewCrossAxisCount);
    imageHeight = imageWidth * (screenHalfHeight/screenWidth);
    debugPrint("图片高度 $imageHeight");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DraggableGridViewBuilder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridViewCrossAxisCount,
          childAspectRatio: screenWidth / screenHalfHeight,
        ),
        children: _listOfDraggableGridItem,
        controller: controller,
        physics: const ScrollPhysics(),
        dragFeedback: this,
        dragPlaceholder: this,
        dragCompletion: this,
        isOnlyLongPress: true,
      ),
    );
  }

  @override
  Widget feedback(List<DraggableGridItem> list, int index) {
    // debugPrint('feedback: $index');
    return SizedBox(
      child: list[index].child,
      width: imageWidth,
      height: imageHeight,
    );
  }

  @override
  PlaceholderItem placeholder(List<DraggableGridItem> list, int index) {
    return PlaceholderItem(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.paddingSmall,
          vertical: Dimens.paddingSmall,
        ),
        child: DottedBorder(
          color: Colors.green,
          dashPattern: const [8, 4],
          strokeWidth: 2,
          child: Container(
            color: Colors.green.withAlpha(20),
          ),
        ),
      ),
    );
  }

  @override
  void onDragAccept(List<DraggableGridItem> list) {
    var hash = list.map((e) => e.hashCode.toString()).toList().join(" ");
    debugPrint("拖拽排序后新列表为：" + hash);
  }

  void _generateImageData() {
    String directory = 'assets';

    // for (var i = 0; i < 200-1; i++) {
    for (var i = 1; i <= 24; i++) {
      var draggable = true;
      var canJoin = false;

      // if (i == 1) {
      //   draggable = false;
      // } else if (i == 2) {
      //   canJoin = true;
      // }

      var image = '$directory/${i.toString()}.jpeg';
      _listOfDraggableGridItem.add(DraggableGridItem(
        child: _GridItem(image: image),
        id: i,
        isDraggable: draggable,
        canJoin: canJoin,
      ));
    }
  }
}

class _GridItem extends StatelessWidget {
  final String image;

  const _GridItem({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.paddingSmall,
        vertical: Dimens.paddingSmall,
      ),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
