import 'package:ai_study_assist/aboutScreen.dart';
import 'package:ai_study_assist/ai_service.dart';
import 'package:ai_study_assist/helpSupportScreen.dart';
import 'package:ai_study_assist/loginScreen.dart';
import 'package:ai_study_assist/progressAiScreen.dart';
import 'package:ai_study_assist/searchHistoryScreen.dart';
import 'package:ai_study_assist/studyMaterialScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isDarkMode = false;
  bool _isLoading = false;
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    String userText = _chatController.text.trim();
    if (userText.isEmpty) return;

    FocusScope.of(context).unfocus();
    _chatController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    String aiResponse = await AIService.getAIResponse(userText);

    setState(() {
      _isLoading = false;
      _messages.add(ChatMessage(text: aiResponse, isUser: false));
    });
    _scrollToBottom();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : const Color(0xFF1E293B);
    final accentColor = const Color(0xFF4F46E5);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("AI Study Assist", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, color: textColor),
          ),
        ],
      ),
      drawer: _buildDrawer(cardColor, textColor, accentColor),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty && !_isLoading
                  ? _buildInitialView(textColor, cardColor, accentColor)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return _buildLoadingBubble(accentColor);
                        }
                        return _buildChatBubble(_messages[index], accentColor, cardColor, textColor);
                      },
                    ),
            ),
            _buildChatInput(cardColor, textColor, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialView(Color textColor, Color cardColor, Color accent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hello, Scholar! 👋", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textColor)),
          Text("How can I assist your studies today?", style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.6))),
          const SizedBox(height: 32),
          Text("Learning Tools", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildFeatureCard("Explain Topic", Icons.psychology_outlined, Colors.orange, cardColor, textColor, "Explain: "),
              _buildFeatureCard("Summarize", Icons.auto_stories_outlined, Colors.blue, cardColor, textColor, "Summarize: "),
              _buildFeatureCard("Mock Quiz", Icons.quiz_outlined, Colors.green, cardColor, textColor, "Create Quiz: "),
              _buildFeatureCard("Flashcards", Icons.style_outlined, Colors.purple, cardColor, textColor, "Make Flashcards: "),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, Color accent, Color cardColor, Color textColor) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? accent : cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isUser ? 20 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Text(
          message.text,
          style: TextStyle(color: message.isUser ? Colors.white : textColor, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildLoadingBubble(Color accent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color, Color cardBg, Color txtColor, String prompt) {
    return Container(
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))]),
      child: InkWell(
        onTap: () => setState(() => _chatController.text = prompt),
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, size: 32, color: color)),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: txtColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput(Color cardBg, Color txtColor, Color accent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(color: cardBg, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: _isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _chatController,
                style: TextStyle(color: txtColor),
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(hintText: "Ask AI anything...", border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: accent,
            child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20), onPressed: _sendMessage),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(Color cardBg, Color txtColor, Color accent) {
    return Drawer(
      backgroundColor: cardBg,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: accent),
            currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF4F46E5))),
            accountName: const Text("Study User", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("test@ai.com"),
          ),
          ListTile(leading: const Icon(Icons.book_rounded), title: const Text("Study Material"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StudyMaterialScreen()))),
          ListTile(leading: const Icon(Icons.analytics_rounded), title: const Text("Progress AI"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressAiScreen()))),
          ListTile(leading: const Icon(Icons.history_rounded), title: const Text("Search History"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchHistoryScreen()))),
          const Divider(),
          ListTile(leading: const Icon(Icons.help_outline_rounded), title: const Text("Help & Support"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()))),
          ListTile(leading: const Icon(Icons.info_outline_rounded), title: const Text("About App"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()))),
          const Spacer(),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Logout", style: TextStyle(color: Colors.red)), onTap: _showLogoutDialog),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
