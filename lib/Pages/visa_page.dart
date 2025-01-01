import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

class VisaPage extends StatefulWidget {
  VisaPage({Key? key}) : super(key: key);

  @override
  _VisaPageState createState() => _VisaPageState();
}

class _VisaPageState extends State<VisaPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // To store conversation messages
  bool _isLoading = false;

  void _sendMessage(String userMessage) async {
    List<OpenAIModelModel> models = await OpenAI.instance.model.list();
    OpenAIModelModel firstModel = models.first;

    print(firstModel.id); // ...
    print(firstModel.permission); // ...
    if (userMessage.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _isLoading = true;
    });

    try {
      final responseStream = OpenAI.instance.chat.createStream(
        model: "gpt-4o-mini",
        messages: _messages.map((msg) {
          return OpenAIChatCompletionChoiceMessageModel(
            role: msg["role"] == "user"
                ? OpenAIChatMessageRole.user
                : OpenAIChatMessageRole.assistant,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(msg["content"]!)
            ],
          );
        }).toList(),
      );

      String assistantResponse = "";

      // Listen to the stream
      await for (var streamChatCompletion in responseStream) {
        final contentList = streamChatCompletion.choices.first.delta.content;
        if (contentList != null) {
          for (var contentItem in contentList) {
            if (contentItem != null && contentItem.text != null) {
              setState(() {
                assistantResponse += contentItem.text!;
              });
            }
          }
        }
      }

      setState(() {
        _messages.add({"role": "assistant", "content": assistantResponse});
        _isLoading = false;
      });
    } on RequestFailedException catch(e) {
      print(e.message);
      print(e.statusCode);
    } catch (e) {
      setState(() {
        print(e);
        _messages.add({
          "role": "assistant",
          "content": "Something went wrong. Please try again."
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visa Information'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message["role"] == "user";
                return Align(
                  alignment:
                  isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(message["content"] ?? ""),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your question here...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final userMessage = _controller.text;
                    _controller.clear();
                    _sendMessage(userMessage);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
