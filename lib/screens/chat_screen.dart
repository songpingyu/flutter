import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_chat_ui_starter/models/access.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_ui_starter/models/conversationManager.dart';
import 'package:flutter_chat_ui_starter/models/message_model.dart';
import 'package:flutter_chat_ui_starter/models/user_model.dart';
import 'package:flutter_chat_ui_starter/services/api_manager.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  ChatScreen({this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String _currentLocaleId = 'en_US';
  int resultListened = 0;
  final SpeechToText speech = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  String _text = '請按下按鈕後說點英文吧';
  double _confidence = 1.0;

  Future<NewModel> _newsModel;
  Future<ConversationManager> _conversation;

  void initState() {
    super.initState();
    initSpeechState();

    _newsModel = API_Manager().getNews();
    _newsModel.then((value) {
      API_Manager.access_token = value.accessToken;
    });
    //_conversation = API_Manager.conversation('');
    //_conversation = API_Manager().conversation();
  }

  speak(String text)async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onStatus: statusListener, onError: errorListener, debugLogging: false);

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void errorListener(SpeechRecognitionError) {
    stopListening();
    print('onError: ' + SpeechRecognitionError.toString());
  }

  void statusListener(String status) {
    print('onStatus: ' + status.toString());
  }

  void stopListening() {
    speech.stop();
    _text = '已取消說話';
    setState(() {
      level = 0.0;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void startListening() {
    _text = '正在聆聽......';
    speech.listen(
        onResult: (val) => setState(() {
              _text = val.recognizedWords;
              _controller.text = _text;
              if (val.hasConfidenceRating && val.confidence > 0) {
                _confidence = val.confidence;
                //顯示訊息
                /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(_confidence.toString()),
                  action: SnackBarAction(label: 'Affirm', onPressed: scaffold.hideCurrentSnackBar),
                ));*/
                Fluttertoast.showToast(
                  gravity: ToastGravity.CENTER,
                  msg: "信心水準:" + _confidence.toString(),
                  toastLength: Toast.LENGTH_LONG,
                );
              }
            }),
        //listenFor: Duration(seconds: 5),
        //pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  //原本的UI設定
  //final ScrollController _scrollController = new ScrollController();
  final TextEditingController _controller = new TextEditingController();

  _buildMessage(Messager message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: message.isLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: message.isLiked
              ? Theme.of(context).primaryColor
              : Colors.blueGrey,
          onPressed: () {},
        )
      ],
    );
  }

  _buildMessageComposer() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a').format(now);
    //print(formattedDate);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
            icon: Icon(Icons.photo),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'send a msg...',
              ),
            ),
          ),
          IconButton(
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              //send
              if (_controller.text != '') {
                setState(() {});
                messages.add(Messager(
                    sender: currentUser,
                    time: formattedDate,
                    text: _controller.text,
                    isLiked: false,
                    unread: false));
                setState(() {});
                await API_Manager.conversation(_controller.text);

                _controller.text = '';
                //await _conversation.then((value) => print(value.text));
                setState(() {});
                if (API_Manager.bot_reply != null) {
                  for (var i = 0; i < API_Manager.bot_reply.length; i++) {

                    if (API_Manager.bot_reply[i] != null) {
                      speak(API_Manager.bot_reply[i]);
                      setState(() {});
                      messages.add(Messager(
                          sender: james,
                          time: formattedDate,
                          text: API_Manager.bot_reply[i],
                          isLiked: false,
                          unread: false));
                      API_Manager.bot_reply[i] = null;
                    }
                  }
                }

                /*_conversation.then((value) {

              });*/
              }
            },
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //語音漂浮按鈕
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: AvatarGlow(
          animate: speech.isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: !_hasSpeech || speech.isListening
                ? stopListening
                : startListening,
            child: Icon(speech.isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        ///////
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            widget.user.name,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: FutureBuilder<NewModel>(
                      future: _newsModel,
                      builder: (context, snapshot) {
                        //get access
                        if (snapshot.hasData) {
                          return ListView.builder(
                            reverse: false,
                            padding: EdgeInsets.only(top: 15.0),
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Messager message = messages[index];
                              final bool isMe =
                                  message.sender.id == currentUser.id;
                              return _buildMessage(message, isMe);
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('${snapshot.error}'),
                          );
                        }
                        return Center(
                          child: Text('Cant get data'),
                        );
                        // By default, show a loading spinner.
                      },
                    ),
                  ),
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ));
  }
}
