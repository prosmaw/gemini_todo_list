class Message {
  String text;
  int type; // 0 for Gemini, 1 for user input, 2 for suggestion
  Message({required this.text, required this.type});
}
