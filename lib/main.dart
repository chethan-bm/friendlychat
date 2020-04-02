import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
const String _name = "Your Name"; //Can use your own name by replacing "Your Name".
void main() {
  runApp(new FriendlychatApp());
}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Friendlychat",
      theme: defaultTargetPlatform ==TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(                                    //new
        sizeFactor: new CurvedAnimation(                              //new
            parent: animationController, curve: Curves.easeOut),      //new
        axisAlignment: 0.0,                                           //new
        child: new Container(                                    //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )                                                           //new
    );
  }
}
class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController =new TextEditingController();
  bool _isComposing =false;

  void _handleSubmitted(String text){
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(microseconds: 700),
        vsync: this,),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }
  Widget _buildTextComposer() {
    return new IconTheme(data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
            new Flexible(
              child:new TextField(
              controller: _textController,
              onChanged: (String text){
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                  hintText: "Send a message"),
            ),),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ?
                  new CupertinoButton(child: new Text("send"), onPressed: _isComposing ? () => _handleSubmitted(_textController.text):null,):
                  new IconButton(
                    icon: new Icon(Icons.send),onPressed: _isComposing ?() => _handleSubmitted(_textController.text):null,),
            ),
        ],
      ),
    ));
  }
  @override
  void dispose(){
    for(ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendlychat"),backgroundColor: Colors.blue,
      elevation:
        Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,)
        ,
      body: new Column(children: <Widget>[
        new Flexible(child: new ListView.builder(padding: new EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => _messages[index],
        itemCount: _messages.length,
        ),),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(
              color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],)
    );
  }
}
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
); //