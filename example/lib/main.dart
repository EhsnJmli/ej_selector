import 'package:ej_selector/ej_selector.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selector Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        shadowColor: Colors.grey,
        dialogTheme: DialogTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  /// You can use [EJSelector] in two ways:
  ///
  /// 1. use [EJSelectorButton.string].
  /// 2. use [EJSelectorButton] which you can customize.

  @override
  Widget build(BuildContext context) {
    final childList = <Widget>[
      StringSelector(),
      StringSelectorUsingValue(),
      CustomSelector(),
      CustomSelectorUsingValue(),
    ];
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Selector Example'),
          bottom: TabBar(
            isScrollable: true,
            labelPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            tabs: [
              Text(
                'String',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'String using value',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Custom',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Custom using value',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                childList[selectedIndex],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StringSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EJSelectorButton.string(
      items: List.generate(10, (index) => 'item $index'),
      hint: 'Choose',
      useValue: false,
      divider: Divider(),
      textStyle: TextStyle(fontSize: 18),
      suffix: Icon(Icons.arrow_drop_down),
    );
  }
}

class StringSelectorUsingValue extends StatefulWidget {
  @override
  _StringSelectorUsingValueState createState() =>
      _StringSelectorUsingValueState();
}

class _StringSelectorUsingValueState extends State<StringSelectorUsingValue> {
  String value;

  @override
  Widget build(BuildContext context) {
    return EJSelectorButton.string(
      items: List.generate(10, (index) => 'item $index'),
      value: value,
      onChange: (newValue) {
        value = newValue;
        setState(() {});
      },
      hint: 'Choose',
      divider: Divider(),
      textStyle: TextStyle(fontSize: 18),
      suffix: Icon(Icons.arrow_drop_down),
    );
  }
}

class CustomSelector extends StatelessWidget {
  final items = <ItemModel>[
    ItemModel(1, 'First Item'),
    ItemModel(2, 'Second Item'),
    ItemModel(3, 'Third Item'),
    ItemModel(4, 'Forth Item'),
    ItemModel(5, 'Fifth Item'),
  ];

  @override
  Widget build(BuildContext context) {
    return EJSelectorButton<ItemModel>(
      useValue: false,
      hint: Text(
        'Click to choose',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      buttonBuilder: (child, value) => Container(
        alignment: Alignment.center,
        height: 60,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: value != null
            ? Text(
                value.name,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            : child,
      ),
      selectedWidgetBuilder: (valueOfSelected) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Text(
          valueOfSelected.name,
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
      items: items
          .map(
            (item) => EJSelectorItem(
              value: item,
              widget: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class CustomSelectorUsingValue extends StatefulWidget {
  @override
  _CustomSelectorUsingValueState createState() =>
      _CustomSelectorUsingValueState();
}

class _CustomSelectorUsingValueState extends State<CustomSelectorUsingValue> {
  final items = <ItemModel>[
    ItemModel(1, 'First Item'),
    ItemModel(2, 'Second Item'),
    ItemModel(3, 'Third Item'),
    ItemModel(4, 'Forth Item'),
    ItemModel(5, 'Fifth Item'),
  ];
  int selectedId;

  @override
  Widget build(BuildContext context) {
    return EJSelectorButton<int>(
      value: selectedId,
      onChange: (id) {
        selectedId = id;
        setState(() {});
      },
      hint: Text(
        'Click to choose',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      buttonBuilder: (child, id) => Container(
        alignment: Alignment.center,
        height: 60,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: id != null
            ? Text(
                items.firstWhere((item) => item.id == id).name,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            : child,
      ),
      selectedWidgetBuilder: (selectedId) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Text(
          items.firstWhere((item) => item.id == selectedId).name,
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
      items: items
          .map(
            (item) => EJSelectorItem(
              value: item.id,
              widget: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ItemModel {
  ItemModel(this.id, this.name);

  final int id;
  final String name;
}
