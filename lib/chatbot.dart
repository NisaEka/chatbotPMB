import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';
import 'package:spell_checker/spell_checker.dart';


class ChatbotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyChatbotPage(title: 'Chatbot PMB'),
    );
  }
}

class MyChatbotPage extends StatefulWidget {
  MyChatbotPage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyChatbotPageState createState() => _MyChatbotPageState();
}

class _MyChatbotPageState extends State<MyChatbotPage> {

  final messageInsert = TextEditingController();
  // ignore: deprecated_member_use
  final List<Map> messsages = List();
  String markMsg;
  var spellMsg;
  var respMsg;


  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/service.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.indonesian);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getMessage() ??
          CardDialogflow(aiResponse.getListMessage()[0]).title,
      });
    });
    respMsg = aiResponse.getListMessage()[0]['text'].toString();
    print("response:" + respMsg);
   }

  void markRemoval(String textMessage){
    markMsg = textMessage
                .replaceAll("!", "")
                .replaceAll("?", "")
                .replaceAll(";", "")
                .replaceAll(":", "")
                .replaceAll(".", "")
                .replaceAll(",", "")
                .replaceAll("/", "")
                .replaceAll("-", "")
                .replaceAll("(", "")
                .replaceAll(")", "")
                .replaceAll("{", "")
                .replaceAll("}", "")
                .replaceAll("'", "");
    print("mark removal : "+ markMsg);
  }
  
  void spellCorrection(message){
      final checker = SingleWordSpellChecker(distance: 1.0);
      checker.addWords(['apa','siapa','bagaimana','kapan','mengapa','dimana']);
      var listspell = message.split(" ").map().toList();
      spellMsg = checker.find(listspell);
      print("list spell : " + listspell);
      print("spell correction : "+ spellMsg.toString());
  }
  // void similar(message, template){
  //   var similar;
  //   List<Map> b1= List();
  //   List<Map> b2= List();
  //   List<Map> b12= List();
  //   List<Map> b21= List();
  //   Float c1, c2, c12, c21;

  //   b1.add(message);
  //   b2.add(template);

  //   b12 = b1.retainAll(b2);
  //   b21 = b2.retainAll(b1);

  //   c1 = b1.length();
  //   c12 = b2.length();
  //   c12 = b12.length();
  //   c21 = b21.length();

  //   similar = (c12+c21) / (c1+c2);

  //   return similar;

  // }
  
  
  @override
  Widget build(BuildContext context) {
    if(messsages.isEmpty){
        messsages.add({
          "data": 0, 
          "message": "Assalamu'alaikum, apa yang ingin anda ketahui seputar informasi PMB UIN Bandung?"
        });
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text("Chatbot PMB"),
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text("Today, ${DateFormat("Hm").format(DateTime.now())}", style: TextStyle(
                fontSize: 20
              ),), 
            ),
            // chat("test",0),
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => 
                        chat(
                          messsages[index]["message"].toString(),
                          messsages[index]["data"]
                        ),
                ),  
            ),

            Divider(
              height: 5.0,
            ),
            Container(
              child: ListTile(
                  title: Container(
                    // height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                          15)),
                      color: Color.fromRGBO(220, 220, 220, 1),
                    ),
                    padding: EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: messageInsert,
                      decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        hintStyle: TextStyle(
                            color: Colors.black26
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),

                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                      ),
                      onChanged: (value) {

                      },
                    ),
                  ),

                  trailing: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 30.0,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        if (messageInsert.text.isEmpty) {
                          print("empty message");
                          response("hi");
                        } else {
                          setState(() {
                            messsages.insert(0,
                                {"data": 1, "message": messageInsert.text});
                          });
                          markRemoval(messageInsert.text);
                          // spellCorrection(markMsg);
                          response(markMsg);
                          // similar(markMsg);
                          print("input :"+ messageInsert.text);
                          messageInsert.clear();
                        }
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      }),
              ),
            ),

            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
          mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [

            data == 0 ? Container(
              height: 55,
              width: 55,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/robot.png"),
              ),
            ) : Container(),
        Padding(
        padding: EdgeInsets.all(10.0),
        child: Bubble(
            radius: Radius.circular(15.0),
            color: data == 0 ? Colors.blueAccent : Colors.orangeAccent,
            elevation: 0.0,

            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Flexible(
                      child: Container(
                        constraints: BoxConstraints( maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                ],
              ),
            )),
      ),
            data == 1? Container(
              height: 55,
              width: 55,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/default.png"),
              ),
            ) : Container(),

          ],
        ),
    );
  }

  
}
