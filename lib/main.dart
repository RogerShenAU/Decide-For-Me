import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'widgets.dart';
import 'services.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Decide for me',
      home: new MyHomePage(title: "Decide for me",),
      debugShowCheckedModeBanner: false, // slow mode banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  // initialize
  CustomizeWidget customizeWidget = new CustomizeWidget();
  Services services = new Services();
  
  // text
  String _magicText;

  // default selections
  String _typeValue;
  String _radiusValue;

  // button
  bool _btnStaus;
  Icon _btnIcon;
  String _btnText;
  Function _btnHandler;

  // map settings
  String _placeAPIUrl;
  Map<String,String> params;

  String _displayType;

  // random/magic button handler
  displayPlace(){

    services.getCurrentGeoLocation().then((location){
      
      params = {
        'radius' : _radiusValue,
        'type' : _typeValue,
      };

      _placeAPIUrl = services.getPlaceAPIUrl(location, params);

      if(_placeAPIUrl != ''){
        
        _placeBox = customizeWidget.displayPlace(_placeAPIUrl,_displayType);
      }else{
        _placeBox = customizeWidget.textWithPadding('Cann\'t get current location, please try again');
      }

      setState((){
      });
    });
  }

  typeDropdownhandler(newValue){
    setState((){
      _typeValue = newValue;
    });
  }

  radiusDropdownhandler(newValue){
    setState(
      () => _radiusValue = newValue
    );
  }

  randomSwitchHandler(newValue){
    setState(
      (){
        _btnStaus = newValue;

        if(newValue){
          _magicText = ' magic';
          _btnIcon = new Icon(
            const IconData(0xe3a5, fontFamily: 'MaterialIcons'),
          );
          _btnText = 'Magic';
          _displayType = 'random';
          _placeBox = customizeWidget.textWithPadding('Press Magic button to continue...', 4.0);
        }else{
          _magicText = '';
           _btnIcon = new Icon(
            const IconData(0xe241, fontFamily: 'MaterialIcons', matchTextDirection:true),
          );
          _btnText = 'List';
          _displayType = 'list';
          _placeBox = customizeWidget.textWithPadding('Press button to continue...', 4.0);
        }
      }
    );
  }

  Widget _placeBox = new Container(
    padding: const EdgeInsets.all(4.0),
    child: new Text('Press Magic button to continue...')
  );

  void initState(){
      super.initState();
      _btnHandler = displayPlace;
      _magicText = ' magic';
      _typeValue = 'restaurant';
      _radiusValue = '500';
      _btnStaus = true;
      _btnIcon = new Icon(
        const IconData(0xe3a5, fontFamily: 'MaterialIcons'),
      );
      _btnText = 'Magic';
      _placeAPIUrl = '';
      _displayType = 'random';
  }

  @override
  Widget build(BuildContext context){

    Color primaryColor = Theme.of(context).primaryColor;

    Widget infoText = customizeWidget.textWithPadding('Headache about what to eat, where to go and more? Hit the$_magicText button! \r\n ');

    Widget button = new Container(
      padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
      child: new RaisedButton(
        onPressed: _btnHandler,
        color: primaryColor,
        textColor: Colors.white,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _btnIcon,
            new Text(
              _btnText.toUpperCase(),
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Decide for me!'),
      ),
      body: new ListView(
        children: [
          infoText,
          new Row(
            children: <Widget>[
              customizeWidget.typeDropdownList(_typeValue,typeDropdownhandler),
              customizeWidget.radiusDropdownList(_radiusValue,radiusDropdownhandler),
              customizeWidget.switchWithText(_btnStaus,'Random',randomSwitchHandler),
            ],
          ),
          button,
          new Container(
            margin: const EdgeInsets.all(28.0),
            child: _placeBox,
          ),
        ],
      ),
    );
  }
}