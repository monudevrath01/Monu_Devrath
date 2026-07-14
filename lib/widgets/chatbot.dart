import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'custom_cursor.dart';
import '../utils/audio_helper.dart';

class ChatbotAssistant extends StatefulWidget {
  final Function(String) onNavigateToSection; // Callback to scroll to sections

  const ChatbotAssistant({super.key, required this.onNavigateToSection});

  @override
  State<ChatbotAssistant> createState() => _ChatbotAssistantState();
}

class _ChatbotAssistantState extends State<ChatbotAssistant> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  bool _isTyping = false;
  final List<_Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Initial Greeting
    _messages.add(_Message(
      text: "Hi 👋 I'm Monu Assistant. Ask me anything about Monu's skills, projects, experience, or resume!",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
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

  void _handleOptionSelected(String option) {
    setState(() {
      _messages.add(_Message(text: option, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();
    AudioHelper.playClick();

    // Simulate typing delay
    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      
      String responseText = "";
      String sectionName = "";

      switch (option) {
        case "Skills 🧠":
          responseText = "Monu is highly proficient in full-stack development. His core skills include:\n\n"
              "• Frontend: React, Redux, JavaScript (ES6+), TypeScript, HTML5/CSS3\n"
              "• Backend: Node.js, Express.js, RESTful APIs, WebSockets (Socket.io)\n"
              "• Databases: MongoDB, PostgreSQL, SQL\n"
              "• Devops & Tools: Docker, Git, Redis, Firebase\n\n"
              "Would you like me to scroll to his Skills Galaxy section?";
          sectionName = "skills";
          break;
        case "Projects 🚀":
          responseText = "Monu has worked on several premium projects, including:\n\n"
              "1. Oho Cab: A comprehensive BlaBlaCar-inspired intercity ride-sharing platform with separate Driver/Passenger apps, Admin Panel, and real-time tracking (PostgreSQL, Socket.io, Docker).\n"
              "2. E-Commerce Platform: MERN stack marketplace featuring full authentication, admin dashboards, cart operations, and payment gateways.\n"
              "3. BEFT Fitness: A sleek fitness and diet planning system with user analytics.\n"
              "4. School Management System: Role-based platform managing attendance, reports, and timetables.\n\n"
              "Would you like to scroll to the Projects showcase?";
          sectionName = "projects";
          break;
        case "Experience 📈":
          responseText = "Monu is currently gaining excellent commercial experience:\n\n"
              "• MERN Stack Developer Intern at Seefat Technologies (Present):\n"
              "  Working on live client projects, API integrations, database management, and production deployments.\n\n"
              "• MERN Stack Trainee at Inventcolabs Pvt Ltd (May 2025 - Nov 2025):\n"
              "  Trained in MongoDB, REST APIs, CRUD systems, Git workflows, and full-stack architecture.\n\n"
              "Would you like to scroll to his career timeline?";
          sectionName = "experience";
          break;
        case "Resume & Contact 📄":
          responseText = "You can download Monu's PDF resume directly from the top navigation bar or the Hero section. His contact details are:\n\n"
              "📍 Abohar, Punjab, India\n"
              "📧 monudevrath2003@gmail.com\n"
              "📞 +91 9888049646\n\n"
              "Would you like to scroll to the Contact section?";
          sectionName = "contact";
          break;
      }

      setState(() {
        _isTyping = false;
        _messages.add(_Message(
          text: responseText,
          isUser: false,
          targetSection: sectionName,
        ));
      });
      _scrollToBottom();
      AudioHelper.playSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyberTheme = theme.extension<CyberTheme>()!;

    return Positioned(
      bottom: 24,
      right: 24,
      child: ZIndexFix(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Chat Window
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isOpen
                  ? Container(
                      width: 350,
                      height: 450,
                      margin: const Duration(milliseconds: 8).isNegative ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: cyberTheme.cardBackgroundColor.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: cyberTheme.primaryGlow.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cyberTheme.primaryGlow.withOpacity(0.15),
                            blurRadius: 16,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  cyberTheme.primaryGlow.withOpacity(0.4),
                                  cyberTheme.secondaryGlow.withOpacity(0.2),
                                ],
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  color: cyberTheme.primaryGlow.withOpacity(0.2),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Status Indicator
                                CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Colors.greenAccent,
                                  child: Container(),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Monu AI Assistant",
                                  style: TextStyle(
                                    color: cyberTheme.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(Icons.close, color: cyberTheme.textColor.withOpacity(0.7), size: 18),
                                  onPressed: () => setState(() => _isOpen = false),
                                )
                              ],
                            ),
                          ),
                          // Messages List
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final msg = _messages[index];
                                return _buildMessageBubble(msg, cyberTheme);
                              },
                            ),
                          ),
                          // Typing Indicator
                          if (_isTyping)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, bottom: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Typing replies...",
                                  style: TextStyle(
                                    color: cyberTheme.subtitleColor.withOpacity(0.6),
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          // Quick Choices Options
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: cyberTheme.backgroundColor.withOpacity(0.6),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                "Skills 🧠",
                                "Projects 🚀",
                                "Experience 📈",
                                "Resume & Contact 📄",
                              ].map((opt) {
                                return CustomCursorArea(
                                  child: InkWell(
                                    onTap: _isTyping ? null : () => _handleOptionSelected(opt),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: cyberTheme.primaryGlow.withOpacity(0.4),
                                        ),
                                        color: cyberTheme.cardBackgroundColor.withOpacity(0.5),
                                      ),
                                      child: Text(
                                        opt,
                                        style: TextStyle(
                                          color: cyberTheme.textColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Floating Button
            CustomCursorArea(
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isOpen = !_isOpen;
                  });
                  AudioHelper.playClick();
                },
                backgroundColor: cyberTheme.cardBackgroundColor,
                shape: CircleBorder(
                  side: BorderSide(
                    color: cyberTheme.primaryGlow,
                    width: 2.0,
                  ),
                ),
                elevation: 10,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulsing outer ring
                        Container(
                          width: 48 + _pulseController.value * 12,
                          height: 48 + _pulseController.value * 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cyberTheme.primaryGlow.withOpacity(1.0 - _pulseController.value),
                              width: 1.5,
                            ),
                          ),
                        ),
                        Icon(
                          _isOpen ? Icons.chat_bubble_outline : Icons.chat_bubble,
                          color: cyberTheme.accent,
                          size: 24,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_Message msg, CyberTheme cyberTheme) {
    final bool isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 270),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
          color: isUser
              ? cyberTheme.primaryGlow.withOpacity(0.2)
              : cyberTheme.backgroundColor.withOpacity(0.9),
          border: Border.all(
            color: isUser
                ? cyberTheme.primaryGlow.withOpacity(0.5)
                : cyberTheme.primaryGlow.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: cyberTheme.textColor,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            if (msg.targetSection != null) ...[
              const SizedBox(height: 8),
              CustomCursorArea(
                child: TextButton(
                  onPressed: () {
                    widget.onNavigateToSection(msg.targetSection!);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: cyberTheme.accent.withOpacity(0.15),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: cyberTheme.accent),
                    ),
                  ),
                  child: Text(
                    "Let's Go! 🚀",
                    style: TextStyle(
                      color: cyberTheme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final String? targetSection;

  _Message({
    required this.text,
    required this.isUser,
    this.targetSection,
  });
}

// Simple wrapper to ensure chatbot floats on top of other elements
class ZIndexFix extends StatelessWidget {
  final Widget child;
  const ZIndexFix({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: child,
    );
  }
}
