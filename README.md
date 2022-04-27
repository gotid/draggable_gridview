# draggable_gridview

该包为 GridView.builder 添加拖拽功能，支持 GridView.build 的所有属性，几行代码即可轻松实现。

## 用法

### 代码示例
```dart
DraggableGridViewBuilder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3),
  ),
  children: _listOfDraggableGridItem,
  dragCompletion: this,
  
  isOnlyLongPress: false,
  dragFeedback: this,
  dragPlaceholder: this,
);
```

### 必填参数

### gridDelegate:
控制 GridView 中子对象布局的代理。

### children:
该属性包含 [DraggableGridItem] 列表，用来显示 GridView.builder 中可拖拽的小部件。
[DraggableGridItem] 小部件支持 `isDraggable` 参数，用于开关拖拽功能。

### dragCompletion:
该属性为拖拽完成的逻辑回调函数。你需要自行实现并按需保存排序后的新列表。

### 可选参数

#### isOnlyLongPress:
该布尔属性指示拖拽识别手势为长按拖拽（默认）还是短按拖拽。

#### dragFeedback:
该属性为拖拽反馈的部件回调函数。如自行实现需返回一个 Widget。 详情见 [Draggable](https://api.flutter.dev/flutter/widgets/Draggable-class.html#:~:text=Draggable%20class%20Null%20safety,user's%20finger%20across%20the%20screen)

#### dragChildWhenDragging:
该属性为拖拽过程中的部件回调函数。如自行实现需返回一个 Widget。 详情见 [Draggable](https://api.flutter.dev/flutter/widgets/Draggable-class.html#:~:text=Draggable%20class%20Null%20safety,user's%20finger%20across%20the%20screen)

### 其他参数
```DraggableGridViewBuilder``` 类支持 ```GridView.builder``` 的全部属性参数。


## 📢 注意事项
拖拽排序的结果以 list 形式返回，如需保存请自行实现。

