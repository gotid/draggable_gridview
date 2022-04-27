part of draggable_gridview;

/// [_orgList] 组织排序后的网格项列表。
late List<DraggableGridItem> _orgList;

/// [_list] 当前网格项列表。
late List<DraggableGridItem> _list;

/// [_draggedGridItem] 上一个被拖拽过的网格项。
DraggableGridItem? _draggedGridItem;

var _dragStarted = false;
var _dragEnded = true;

/// [_isOnlyLongPress] 表示拖拽模式为长按（默认）还是短按。
bool _isOnlyLongPress = true;

/// 屏幕宽度
double screenWidth = .0;
double screenHeight = .0;
double screenHalfHeight = screenHeight / 2;

/// GridView
int gridViewCrossAxisCount = 3;
double imageWidth = 200;
double imageHeight = 200;