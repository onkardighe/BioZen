import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/utils/constants.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  late var jsonResult = Map<String, dynamic>();
  List<Widget> chatMessages = [];

  @override
  void initState() {
    // loadQueries();
    loadInitialMessages(repeat: false);

    super.initState();
  }

  loadQueries() async {
    await DefaultAssetBundle.of(context)
        .loadString("assets/issues.json")
        .then((jsonString) {
      setState(() {
        jsonResult = jsonDecode(jsonString)[userType];
        print("$userType : ${jsonResult[userType]}");
      });
    });
  }

  loadInitialMessages({required bool repeat}) async {
    if (!repeat) {
      chatMessages.add(SupportMessage(messageData: Text("Hi")));

      chatMessages
          .add(SupportMessage(messageData: Text("This is BioZen Support")));
      chatMessages.add(SupportMessage(
          messageData: Text(
        "What kind of issues you are facing ?",
      )));
    }
    await loadInitialButtons();
  }

  loadInitialButtons() async {
    await loadQueries().then((res) {
      addOptionButtonsInChat();
    }).then((res) {
      setState(() {});
    });
  }

  addMessageToChat({required Widget message, required int delaySeconds}) async {
    await Future.delayed(Duration(seconds: delaySeconds), () {
      setState(() {
        chatMessages.add(message);
      });
    });
  }

  addOptionButtonsInChat() {
    jsonResult.keys.forEach((k) {
      chatMessages.add(GestureDetector(
          onTap: () async {
            for (int i = jsonResult.keys.length; i > 0; i--) {
              chatMessages.removeLast();
            }

            chatMessages.add(UserMessage(messageData: Text(k)));
            if (jsonResult[k].runtimeType == String) {
              chatMessages
                  .add(SupportMessage(messageData: Text(jsonResult[k])));
              jsonResult.clear();
              await addMessageToChat(
                      message: SupportMessage(
                          messageData: Text("Thank you for contacting us !")),
                      delaySeconds: 2)
                  .then((r) async {
                await addMessageToChat(
                        message: SupportMessage(
                            messageData: Text(
                                "Is there anything that we could help you in!")),
                        delaySeconds: 6)
                    .then((res) {
                  loadInitialMessages(repeat: true);
                });
              });
            } else {
              chatMessages.add(SupportMessage(
                  messageData: Text("Sure, please select specific issue")));

              jsonResult = jsonResult[k];
            }
            addOptionButtonsInChat();
            setState(() {});
          },
          child: OptionMessage(optionText: k)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: SingleChildScrollView(
            reverse: true,
            child: jsonResult == null
                ? SizedBox()
                : Column(
                    children: [for (var message in chatMessages) message])),
      ),
    );
  }
}

class SupportMessage extends StatefulWidget {
  Widget messageData;
  SupportMessage({super.key, required this.messageData});

  @override
  State<SupportMessage> createState() => _SupportMessageState();
}

class _SupportMessageState extends State<SupportMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.whatsapp_rounded),
            SizedBox(
              width: 10,
            ),
            Container(
              constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: MediaQuery.of(context).size.width * 0.65),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        blurStyle: BlurStyle.normal)
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              child: widget.messageData,
            ),
          ],
        ),
      ),
    );
  }
}

class OptionMessage extends StatefulWidget {
  final String optionText;
  const OptionMessage({super.key, required this.optionText});

  @override
  State<OptionMessage> createState() => _OptionMessageState();
}

class _OptionMessageState extends State<OptionMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        widget.optionText,
      ),
    );
  }
}

class UserMessage extends StatefulWidget {
  Widget messageData;
  UserMessage({super.key, required this.messageData});

  @override
  State<UserMessage> createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(right: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: MediaQuery.of(context).size.width * 0.65),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        blurStyle: BlurStyle.normal)
                  ],
                  // gradient: AppTheme().themeGradient,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              child: widget.messageData,
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.whatsapp_rounded),
          ],
        ),
      ),
    );
  }
}
