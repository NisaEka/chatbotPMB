import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:chatbotpmb/color_palette.dart';
import 'package:chatbotpmb/chatbot.dart';


class Intro{
  String image;
  // String title;
  // String description;

  Intro({this.image});
}

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  final List<Intro> introList = [
    Intro(image: "assets/board1.png"),
    Intro(image: "assets/board2.png")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Swiper.children(
        index: 0,
        autoplay: false,
        loop: false,
        pagination: SwiperPagination(
          margin: EdgeInsets.only(bottom: 20.0),
          builder: DotSwiperPaginationBuilder(
            color: ColorPalette.dotColor,
            activeColor: ColorPalette.dotActiveColor,
            size: 10.0,
            activeSize: 10.0,
          ),
        ),
        control: SwiperControl(
          iconNext: null,
          iconPrevious: null,
        ),
        children:
          _buildPage(context),
      ),
    );
  }


  List<Widget> _buildPage(BuildContext context){
    List<Widget> widgets = [];
    for (int i = 0; i < introList.length; i++) {
      Intro intro = introList[i];
      widgets.add(
        Container(
          padding: EdgeInsets.only(
            // top: 30,
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 250, right: 10, top: 10),
                // ignore: deprecated_member_use
                child:  FlatButton(
                  child: Text("Lewati"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black)
                  ),
                  color: Colors.white,
                  textColor: Colors.black,
                  onPressed: () { 
                    // Navigator.pop(context, MaterialPageRoute(builder: (context) => ChatbotPage(),));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotPage(),));
                  }
                ),
              ),
             
              SizedBox(width: 10.0,),
              Image.asset(
                intro.image,
                height: 550,
              ),
              Padding(
                padding: EdgeInsets.only(
                  // top: MediaQuery.of(context).size.height/12.0,
                ),
              ),
            ],
          ),
        )
      );
    }
    return widgets;
  }
}