import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final gemini = Gemini.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> chatHistory = [];
  bool searching = false;

  // Define a ScrollController
  final ScrollController _scrollController = ScrollController();

  void search(String query) {
    setState(() {
      searching = true;
    });
    gemini.text(query).then((value) {
      setState(() {
        chatHistory.add({'input': query, 'result': value?.output ?? ''});
        _searchController.clear();
        searching = false;

        // Scroll to the bottom when new results are added
        _scrollToBottom();
      });
    }).catchError((e) {
      debugPrint(e.toString());
      setState(() {
        searching = false;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the ScrollController when it's no longer needed
    _scrollController.dispose();
    super.dispose();
  }

  // Function to scroll to the bottom of the list
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 29, 42),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Gemini Demo"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: chatHistory.length,
              itemBuilder: (BuildContext context, int index) {
                const bgColor = Color.fromARGB(255, 14, 19, 29);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Card(
                        child: ListTile(
                          tileColor: bgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          title: const Text(
                            'You:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          subtitle: Text(
                            chatHistory[index]['input'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Card(
                        child: ListTile(
                          tileColor: bgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          title: const Text(
                            'Gemini:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          subtitle: Text(
                            chatHistory[index]['result'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ask Gemini...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    searching
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send_rounded,
                                color: Colors.white),
                            onPressed: () {
                              search(_searchController.text);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Flutter Gemini by M Saad Khan",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
