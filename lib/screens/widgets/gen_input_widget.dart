import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/gemini_controller.dart';
import 'package:todo_list/screens/widgets/custom_text_field.dart';

class GenInputWidget extends StatefulWidget {
  const GenInputWidget({super.key, required this.sendingRequest});
  final Function() sendingRequest;

  @override
  State<GenInputWidget> createState() => _GenInputWidgetState();
}

class _GenInputWidgetState extends State<GenInputWidget> {
  final _input = GlobalKey<FormState>();
  TextEditingController inputController = TextEditingController();
  GeminiControler geminiControler = Get.find();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<GeminiControler>(builder: (_) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "What would you like to do",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Form(
                key: _input,
                child: Column(
                  children: [
                    SizedBox(
                      width: width - 20,
                      child: CustomTextField(
                        controller: inputController,
                        hint: 'Add instruction',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter instructions";
                          } else {
                            return null;
                          }
                        },
                        readOnly: geminiControler.requesting.value,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    FilledButton(
                        onPressed: geminiControler.requesting.value
                            ? null
                            : sendRequest,
                        style: FilledButton.styleFrom(
                            fixedSize: const Size(150, 70)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Send",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            geminiControler.requesting.value
                                ? const CircularProgressIndicator.adaptive()
                                : const Icon(Icons.send),
                          ],
                        )),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void sendRequest() async {
    if (_input.currentState!.validate()) {
      await geminiControler.addTask(inputController.text);
      Get.back();
      widget.sendingRequest();
    }
  }
}
