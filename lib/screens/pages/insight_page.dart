import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/gemini_controller.dart';
import 'package:todo_list/model/message.dart';
import 'package:todo_list/utils/base_colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class InsightPage extends StatefulWidget {
  const InsightPage({super.key});

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  final GeminiControler geminiControler = Get.find();
  TextEditingController inputController = TextEditingController();
  bool cansend = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<GeminiControler>(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Insight",
            style: TextStyle(color: Colors.white),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const CircleAvatar(
              backgroundColor: BaseColors.primaryColor,
              radius: 28,
              child: Icon(
                Icons.expand_more,
                weight: 600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    bool isUser = false;
                    bool isSuggestion = false;
                    if (geminiControler.messages[index].type == 1 ||
                        geminiControler.messages[index].type == 2) {
                      isUser = true;
                    }
                    if (geminiControler.messages[index].type == 2) {
                      isSuggestion = true;
                    }
                    return Messagecard(
                      width: width,
                      isUser: isUser,
                      message: geminiControler.messages[index].text,
                      isSuggestion: isSuggestion,
                    );
                  },
                  itemCount: geminiControler.messages.length,
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(bottom: 10, top: 5),
                child: TextField(
                  controller: inputController,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        cansend = true;
                      });
                    } else if (value.isEmpty) {
                      setState(() {
                        cansend = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: BaseColors.secondaryColor,
                          )),
                      suffixIcon: cansend
                          ? IconButton(
                              onPressed: () {
                                geminiControler.messages.add(Message(
                                    text: inputController.text, type: 1));
                                geminiControler.insight(inputController.text);
                                inputController.clear();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: BaseColors.secondaryColor,
                              ),
                            )
                          : const SizedBox(),
                      hintText: "Type here to ask something",
                      hintStyle: const TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class Messagecard extends StatefulWidget {
  const Messagecard(
      {super.key,
      required this.width,
      required this.isUser,
      required this.message,
      this.isSuggestion});

  final double width;
  final bool isUser;
  final String message;
  final bool? isSuggestion;

  @override
  State<Messagecard> createState() => _MessagecardState();
}

class _MessagecardState extends State<Messagecard> {
  final GeminiControler geminiControler = Get.find();
  Color borderColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          if (widget.isSuggestion == true) {
            setState(() {
              borderColor = BaseColors.secondaryColor;
            });
            geminiControler.insight(widget.message);
          }
        },
        child: Card(
          margin: widget.isUser
              ? EdgeInsets.only(left: widget.width * 0.1, bottom: 25)
              : EdgeInsets.only(right: widget.width * 0.1, bottom: 25),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: widget.isUser ? borderColor : Colors.transparent),
              borderRadius: BorderRadius.circular(20)),
          color: widget.isUser ? Colors.transparent : BaseColors.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: widget.isUser
                ? Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  )
                : MarkdownBody(
                    data: widget.message,
                    styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(color: Colors.white, fontSize: 18)),
                  ),
          ),
        ),
      ),
    );
  }
}
