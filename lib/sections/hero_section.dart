import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../widgets/magnetic_button.dart';
import '../widgets/custom_cursor.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onScrollToProjects;
  final VoidCallback onScrollToContact;

  const HeroSection({
    super.key,
    required this.onScrollToProjects,
    required this.onScrollToContact,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  // Animations for floating profile image
  late final AnimationController _floatController;
  late final AnimationController _ringController;
  
  // Role Typing animation variables
  final List<String> _roles = [
    "MERN Stack Developer",
    "Full Stack Engineer",
    "Backend Developer",
    "Freelancer",
    "Problem Solver"
  ];
  final List<String> _taglines = [
    "Building scalable digital experiences.",
    "Crafting APIs that power businesses.",
    "Turning ideas into products."
  ];

  int _roleIndex = 0;
  int _taglineIndex = 0;
  String _typedRole = "";
  Timer? _typewriterTimer;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    
    // Float/breathing controller
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Aura ring rotation controller
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _startRoleTyping();
  }

  void _startRoleTyping() {
    const typeSpeed = Duration(milliseconds: 70);
    const deleteSpeed = Duration(milliseconds: 40);
    const holdDuration = Duration(seconds: 2);

    _typewriterTimer = Timer.periodic(typeSpeed, (timer) {
      if (!mounted) return;
      final currentRole = _roles[_roleIndex];

      if (!_isDeleting) {
        // Typing characters
        if (_typedRole.length < currentRole.length) {
          setState(() {
            _typedRole = currentRole.substring(0, _typedRole.length + 1);
          });
        } else {
          // Finished typing, hold, then switch to deleting
          timer.cancel();
          Future.delayed(holdDuration, () {
            if (!mounted) return;
            _isDeleting = true;
            _typewriterTimer = Timer.periodic(deleteSpeed, (delTimer) {
              if (!mounted) return;
              if (_typedRole.isNotEmpty) {
                setState(() {
                  _typedRole = _typedRole.substring(0, _typedRole.length - 1);
                });
              } else {
                delTimer.cancel();
                _isDeleting = false;
                _roleIndex = (_roleIndex + 1) % _roles.length;
                _taglineIndex = (_taglineIndex + 1) % _taglines.length;
                _startRoleTyping();
              }
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _ringController.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  Future<void> _downloadResume() async {
    final Uri url = Uri.parse('assets/resume/Monu.pdf');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch resume download: $url");
    }
  }

  Future<void> _launchEmailTemplate() async {
    final String subject = Uri.encodeComponent("Project Collaboration Inquiry");
    final String body = Uri.encodeComponent(
      "Hi Monu,\n\nI saw your portfolio and would love to discuss a project collaboration with you.\n\nRegards,\n[Your Name]"
    );
    final Uri url = Uri.parse("mailto:monudevrath2003@gmail.com?subject=$subject&body=$body");
    if (!await launchUrl(url)) {
      debugPrint("Could not launch mail application");
    }
  }

  void _showResumePreview() {
    showDialog(
      context: context,
      builder: (context) {
        final cyberTheme = Theme.of(context).extension<CyberTheme>()!;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Container(
            width: 800,
            height: 900,
            decoration: BoxDecoration(
              color: cyberTheme.cardBackgroundColor.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: cyberTheme.primaryGlow.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: cyberTheme.primaryGlow.withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [
                // Modal Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        "Resume Preview",
                        style: TextStyle(
                          color: cyberTheme.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: cyberTheme.textColor),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
                
                // Content Details
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResumeHeader(cyberTheme),
                        const Divider(color: Colors.white24, height: 32),
                        _buildResumeSectionTitle("Education", cyberTheme),
                        _buildResumeItem(
                          title: "College: Bachelor of Computer Applications (BCA)",
                          subtitle: "Guru Nanak Dev University, Amritsar",
                          time: "2021 - 2024",
                        ),
                        const SizedBox(height: 10),
                        _buildResumeItem(
                          title: "Schooling: Senior Secondary Education (12th & 10th Standard)",
                          subtitle: "PSEB Board, Abohar, Punjab",
                          time: "Graduated: 2021",
                        ),
                        const SizedBox(height: 20),
                        _buildResumeSectionTitle("Professional Certifications", cyberTheme),
                        _buildResumeItem(
                          title: "MERN Stack Developer Certification",
                          subtitle: "Inventcolabs Pvt Ltd",
                          time: "2025",
                        ),
                        const SizedBox(height: 10),
                        _buildResumeItem(
                          title: "Java Programming Certification",
                          subtitle: "Oracle Academy / Verified Training Partner",
                          time: "2024",
                        ),
                        const SizedBox(height: 20),
                        _buildResumeSectionTitle("Experience", cyberTheme),
                        _buildResumeItem(
                          title: "MERN Stack Developer Intern",
                          subtitle: "Seefat Technologies",
                          time: "Nov 2025 - Present",
                          desc: "• Built production components using React and Node.js.\n• Integrated multiple RESTful web services.\n• Managed PostgreSQL & MongoDB databases.",
                        ),
                        const SizedBox(height: 12),
                        _buildResumeItem(
                          title: "MERN Stack Trainee",
                          subtitle: "Inventcolabs Pvt Ltd",
                          time: "May 2025 - Nov 2025",
                          desc: "• Completed comprehensive training on full-stack development.\n• Designed robust REST APIs and database structures.",
                        ),
                        const SizedBox(height: 20),
                        _buildResumeSectionTitle("Personal Interests & Hobbies", cyberTheme),
                        Text(
                          "• Riding: Passionate about highway riding, motorcycle touring, and exploring scenic routes.\n"
                          "• Gaming: Enthusiast in tactical competitive multiplayer and real-time strategy games.\n"
                          "• Music: Listening to synthwave, ambient background soundscapes, and lofi beats while coding.",
                          style: TextStyle(color: cyberTheme.textColor.withOpacity(0.8), fontSize: 13, height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        _buildResumeSectionTitle("Technical Skills Summary", cyberTheme),
                        Text(
                          "Core Stack: MongoDB, Express.js, React.js, Node.js (MERN), TypeScript, JavaScript.\n"
                          "Databases & Caching: PostgreSQL, SQL, Redis.\n"
                          "Additional Programming Languages: Java, HTML/CSS, C.\n"
                          "DevOps & Workflow: Docker, Git, Socket.io, REST APIs.",
                          style: TextStyle(color: cyberTheme.textColor.withOpacity(0.8), fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Modal Footer
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close", style: TextStyle(color: cyberTheme.subtitleColor)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _downloadResume();
                        },
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text("Download PDF", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cyberTheme.primaryGlow,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyberTheme = theme.extension<CyberTheme>()!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1200 ? 120 : (screenWidth > 600 ? 48 : 24),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildHeroText(cyberTheme, isDesktop)),
                Expanded(flex: 2, child: _buildHeroVisual(cyberTheme)),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 48),
                _buildHeroVisual(cyberTheme),
                const SizedBox(height: 48),
                _buildHeroText(cyberTheme, isDesktop),
              ],
            ),
    );
  }

  Widget _buildHeroText(CyberTheme cyberTheme, bool isDesktop) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Welcome
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cyberTheme.primaryGlow.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cyberTheme.primaryGlow.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Text(
            "Hello, I'm",
            style: TextStyle(
              color: cyberTheme.accent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Name
        Text(
          "Monu Devrath",
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            color: cyberTheme.textColor,
            fontSize: isDesktop ? 64 : 44,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            shadows: cyberTheme.glowIntensity > 0.2
                ? [
                    Shadow(
                      color: cyberTheme.primaryGlow.withOpacity(0.4),
                      blurRadius: 20,
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 12),
        
        // Role Typing
        SizedBox(
          height: 38,
          child: Row(
            mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Text(
                _typedRole,
                style: TextStyle(
                  color: cyberTheme.accent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              // cursor
              Container(
                width: 3,
                height: 22,
                color: cyberTheme.accent,
                margin: const EdgeInsets.only(left: 4),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Tagline Animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            _taglines[_taglineIndex],
            key: ValueKey<int>(_taglineIndex),
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: cyberTheme.subtitleColor,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 36),
        
        // Action Buttons Grid
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            MagneticButton(
              onTap: widget.onScrollToProjects,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [cyberTheme.primaryGlow, cyberTheme.secondaryGlow],
                  ),
                ),
                child: const Text(
                  "View Projects 🚀",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            
            MagneticButton(
              onTap: _launchEmailTemplate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: cyberTheme.primaryGlow.withOpacity(0.6),
                    width: 1.5,
                  ),
                  color: cyberTheme.cardBackgroundColor.withOpacity(0.3),
                ),
                child: Text(
                  "Hire Me 🤝",
                  style: TextStyle(
                    color: cyberTheme.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            
            MagneticButton(
              onTap: _showResumePreview,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: cyberTheme.accent.withOpacity(0.5),
                    width: 1.5,
                  ),
                  color: cyberTheme.cardBackgroundColor.withOpacity(0.3),
                ),
                child: Text(
                  "View Resume 📄",
                  style: TextStyle(
                    color: cyberTheme.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            MagneticButton(
              onTap: _downloadResume,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black12,
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  "Download PDF 📥",
                  style: TextStyle(
                    color: cyberTheme.textColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroVisual(CyberTheme cyberTheme) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        // Floating offset translation
        final double translation = _floatController.value * 20.0 - 10.0;
        // Breathing scale multiplier
        final double scale = 1.0 + (_floatController.value * 0.03);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Glowing breathing background
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: cyberTheme.primaryGlow.withOpacity(0.2 + (_floatController.value * 0.15)),
                    blurRadius: 40 + (_floatController.value * 20),
                    spreadRadius: 5,
                  )
                ],
              ),
            ),
            
            // Rotating Ring 1
            RotationTransition(
              turns: _ringController,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cyberTheme.primaryGlow.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            
            // Rotating Ring 2 (opposite direction, tilted)
            RotationTransition(
              turns: ReverseAnimation(_ringController),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(0.4)
                  ..rotateY(0.4),
                alignment: Alignment.center,
                child: Container(
                  width: 290,
                  height: 290,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cyberTheme.secondaryGlow.withOpacity(0.2),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            
            // Profile image container
            Transform.translate(
              offset: Offset(0, translation),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cyberTheme.accent.withOpacity(0.6),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 15),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    "assets/images/profile.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: cyberTheme.cardBackgroundColor,
                        alignment: Alignment.center,
                        child: Icon(Icons.person, size: 80, color: cyberTheme.accent),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResumeHeader(CyberTheme cyberTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MONU DEVRATH",
                style: TextStyle(
                  color: cyberTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "MERN Stack Developer & Full Stack Engineer",
                style: TextStyle(color: cyberTheme.accent, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Abohar, Punjab, India", style: TextStyle(color: cyberTheme.subtitleColor, fontSize: 12)),
            const SizedBox(height: 4),
            Text("monudevrath2003@gmail.com", style: TextStyle(color: cyberTheme.subtitleColor, fontSize: 12)),
            const SizedBox(height: 4),
            Text("+91 9888049646", style: TextStyle(color: cyberTheme.subtitleColor, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildResumeSectionTitle(String title, CyberTheme cyberTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: cyberTheme.accent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 50,
            height: 2,
            color: cyberTheme.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildResumeItem({
    required String title,
    required String subtitle,
    required String time,
    String? desc,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Text(time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
        if (desc != null) ...[
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
          ),
        ],
      ],
    );
  }
}
