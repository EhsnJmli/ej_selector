# EJ Selector Button
A flutter widget that works like dropdown button, except that instead of opening the dropdown to select items, it opens a dialog. Also, You can customize its button and items.

## Usage
You can customize `EJSelectorButton` or use its string factory which is less customizable and easier to use.

<img src="https://i.imgur.com/GN9c96G.gif" width="400" height="700">

```dart
EJSelectorButton.string(
  items: List.generate(10, (index) => 'item $index'),
  hint: 'Choose',
  useValue: false,
  divider: Divider(),
  textStyle: TextStyle(fontSize: 18),
  suffix: Icon(Icons.arrow_drop_down),
)
```


<img src="https://i.imgur.com/vVx7uAF.gif" width="400" height="700">

```dart
final items = <ItemModel>[
  ItemModel(1, 'First Item'),
  ItemModel(2, 'Second Item'),
  ItemModel(3, 'Third Item'),
  ItemModel(4, 'Forth Item'),
  ItemModel(5, 'Fifth Item'),
];

EJSelectorButton<ItemModel>(
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
    ).toList(),
)

class ItemModel {
  ItemModel(this.id, this.name);

  final int id;
  final String name;
}
```