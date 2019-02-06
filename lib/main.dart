import 'package:card_swipe/AnchoredOverlay.dart';
import 'package:card_swipe/cards.dart';
import 'package:card_swipe/matches.dart';
import 'package:card_swipe/profiles.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final MatchEngine matchEngine = new MatchEngine(
    matches: demoProfile.map((Profiles profile) {
  return DateMatch(profile: profile);
}).toList());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorBrightness: Brightness.light,
      ),
      home: MyHomePage(title: 'Flutter Base'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: new IconButton(
        icon: new Icon(
          Icons.person,
          color: Colors.grey,
          size: 40.0,
        ),
        onPressed: () {
          // TODO:
        },
      ),
      title: new FlutterLogo(
        size: 30.0,
        colors: Colors.red,
      ),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.chat_bubble,
            color: Colors.grey,
            size: 40.0,
          ),
          onPressed: () {
            // TODO:
          },
        )
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new RoundIconButton.small(
              icon: Icons.refresh,
              iconColor: Colors.orange,
              onPressed: () {
                // TODO:
              },
            ),
            new RoundIconButton.large(
              icon: Icons.clear,
              iconColor: Colors.red,
              onPressed: () {
                matchEngine.currentMatch.nope();
                //matchEngine.currentMatch.nope();
              },
            ),
            new RoundIconButton.small(
              icon: Icons.star,
              iconColor: Colors.blue,
              onPressed: () {
                matchEngine.currentMatch.superLike();
                //matchEngine.currentMatch.superLike();
              },
            ),
            new RoundIconButton.large(
              icon: Icons.favorite,
              iconColor: Colors.green,
              onPressed: () {
                matchEngine.currentMatch.like();
                //matchEngine.currentMatch.like();
              },
            ),
            new RoundIconButton.small(
              icon: Icons.lock,
              iconColor: Colors.purple,
              onPressed: () {
                // TODO:
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBottomBar() {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(-1, -1),
              blurRadius: 3,
              spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: () => print('Izq')),
          TwoStateButton(),
          IconButton(icon: Icon(Icons.chat), onPressed: () => print('Der')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: CardStack(matchEngine: matchEngine),
//      bottomNavigationBar: _buildBottomBar(),
      bottomNavigationBar: _buildAnimatedBottomBar(),
    );
  }
}

//class DraggableButton extends StatefulWidget {
//  @override
//  _DraggableButtonState createState() => _DraggableButtonState();
//}
//
//class _DraggableButtonState extends State<DraggableButton> {
//  Alignment _alignment = Alignment.centerLeft;
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
//        Container(
//          height: 45,
//          width: 100,
//          decoration: BoxDecoration(
//            color: Colors.grey[200],
//            borderRadius: BorderRadius.all(
//              Radius.circular(30),
//            ),
//          ),
//        ),
//        AnimatedContainer(
//          duration: Duration(milliseconds: 500),
//          alignment: _alignment,
//          height: 45,
//          width: 60,
//          decoration: BoxDecoration(
//            color: Colors.white,
//            borderRadius: BorderRadius.all(
//              Radius.circular(30),
//            ),
//            border: Border.all(color: Colors.black12),
//            boxShadow: [
//              BoxShadow(
//                color: Colors.black26,
//                offset: Offset(0, 1),
//                blurRadius: 1,
//                spreadRadius: 1,
//              )
//            ],
//          ),
//          child: Container(height: 10, width: 10, color: Colors.red),
//        ),
//        Row(
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            GestureDetector(
//              onTap: () {
//                print('Lado izq');
//                setState(() {
//                  _alignment = Alignment.centerLeft;
//                });
//              },
//              child: Container(width: 50,),
//            ),
//            GestureDetector(
//              onTap: () {
//                print('Lado derecho');
//                setState(() {
//                  _alignment = Alignment.centerRight;
//                });
//              },
//              child: Container(width: 50,),
//            ),
//          ],
//        )
//      ],
//    );
//  }
//}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double size;
  final VoidCallback onPressed;

  RoundIconButton.large({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 60.0;

  RoundIconButton.small({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 50.0;

  RoundIconButton({
    this.icon,
    this.iconColor,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: const Color(0x11000000),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: new RawMaterialButton(
        shape: new CircleBorder(),
        elevation: 0.0,
        child: new Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class TwoStateButton extends StatefulWidget {
  @override
  _TwoStateButtonState createState() => _TwoStateButtonState();
}

class _TwoStateButtonState extends State<TwoStateButton> {
  Alignment _alignment = Alignment.centerLeft;

  Widget _buildControls() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _alignment = Alignment.centerLeft;
            });
          },
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _alignment = Alignment.centerRight;
            });
          },
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            alignment: _alignment,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: SizedBox(
              height: 50,
              width: 60,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/stake_main.png'),
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }
}
