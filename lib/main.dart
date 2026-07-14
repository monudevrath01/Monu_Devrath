import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'widgets/custom_cursor.dart';
import 'widgets/space_background.dart';
import 'widgets/chatbot.dart';
import 'widgets/coding_loader.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_galaxy.dart';
import 'sections/experience_section.dart';
import 'sections/projects_section.dart';
import 'sections/contact_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: _themeController.currentTheme,
      duration: const Duration(milliseconds: 800),
      child: MaterialApp(
        title: 'Monu Devrath - Portfolio',
        debugShowCheckedModeBanner: false,
        theme: _themeController.currentTheme,
        home: MainLayout(themeController: _themeController),
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  final ThemeController themeController;

  const MainLayout({super.key, required this.themeController});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  
  // Section Scroll Target Positions (Estimated offsets)
  final Map<String, double> _sectionOffsets = {
    'home': 0.0,
    'about': 720.0,
    'skills': 1580.0,
    'experience': 2300.0,
    'projects': 3150.0,
    'contact': 4200.0,
  };

  String _activeSection = 'home';
  double _scrollPercent = 0.0;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    
    // Update scroll progress indicator
    setState(() {
      _scrollPercent = (offset / (maxScroll > 0 ? maxScroll : 1.0)).clamp(0.0, 1.0);
      _showBackToTop = offset > 400;
    });

    // Determine currently active section based on scroll offset ranges
    String currentSection = 'home';
    if (offset >= _sectionOffsets['contact']! - 200) {
      currentSection = 'contact';
    } else if (offset >= _sectionOffsets['projects']! - 200) {
      currentSection = 'projects';
    } else if (offset >= _sectionOffsets['experience']! - 200) {
      currentSection = 'experience';
    } else if (offset >= _sectionOffsets['skills']! - 200) {
      currentSection = 'skills';
    } else if (offset >= _sectionOffsets['about']! - 200) {
      currentSection = 'about';
    }

    if (_activeSection != currentSection) {
      setState(() {
        _activeSection = currentSection;
      });
    }
  }

  void _scrollToSection(String sectionKey) {
    double targetOffset = _sectionOffsets[sectionKey] ?? 0.0;
    
    // Dynamically adjust scroll height bounds
    final double maxScroll = _scrollController.position.maxScrollExtent;
    if (targetOffset > maxScroll) {
      targetOffset = maxScroll;
    }

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cyberTheme = Theme.of(context).extension<CyberTheme>()!;
    
    if (_isLoading) {
      return CodingLoader(
        onFinish: () => setState(() => _isLoading = false),
      );
    }

    return Scaffold(
      body: CustomCursor(
        child: SpaceBackground(
          child: Stack(
            children: [
              // Main Scrollable Contents
              Theme(
                data: Theme.of(context).copyWith(
                  textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 120), // Spacing for floating navbar
                      
                      // 1. Hero / Home Section
                      HeroSection(
                        onScrollToProjects: () => _scrollToSection('projects'),
                        onScrollToContact: () => _scrollToSection('contact'),
                      ),
                      
                      const SizedBox(height: 100),
                      
                      // 2. About Section
                      const AboutSection(),
                      
                      const SizedBox(height: 100),
                      
                      // 3. Skills Galaxy Section
                      const SkillsGalaxy(),
                      
                      const SizedBox(height: 100),
                      
                      // 4. Experience Section
                      const ExperienceSection(),
                      
                      const SizedBox(height: 100),
                      
                      // 5. Projects Section
                      const ProjectsSection(),
                      
                      const SizedBox(height: 100),
                      
                      // 6. Contact Section
                      const ContactSection(),
                    ],
                  ),
                ),
              ),

              // Floating Custom Glass Navbar
              _buildNavbar(cyberTheme),

              // Floating Page Scroll Progress Indicator
              _buildProgressIndicator(cyberTheme),

              // Chatbot Floating Assistant
              ChatbotAssistant(
                onNavigateToSection: (section) => _scrollToSection(section),
              ),

              // Floating Back To Top button
              if (_showBackToTop) _buildBackToTopButton(cyberTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavbar(CyberTheme cyberTheme) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 760;

    return Positioned(
      top: 20,
      left: width > 1200 ? 100 : (width > 600 ? 32 : 16),
      right: width > 1200 ? 100 : (width > 600 ? 32 : 16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: cyberTheme.cardBackgroundColor.withOpacity(0.75),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: cyberTheme.primaryGlow.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: cyberTheme.primaryGlow.withOpacity(0.08),
              blurRadius: 16,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            // Logo / Monu Brand
            CustomCursorArea(
              child: GestureDetector(
                onTap: () => _scrollToSection('home'),
                child: Text(
                  "MONU.DEV",
                  style: TextStyle(
                    color: cyberTheme.textColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Spacer(),
            
            // Navigation Links - Hide labels on mobile to prevent overflow
            if (!isMobile)
              Row(
                children: [
                  _buildNavLink("Home", "home", cyberTheme),
                  _buildNavLink("About", "about", cyberTheme),
                  _buildNavLink("Skills", "skills", cyberTheme),
                  _buildNavLink("Experience", "experience", cyberTheme),
                  _buildNavLink("Projects", "projects", cyberTheme),
                  _buildNavLink("Contact", "contact", cyberTheme),
                ],
              ),
            
            if (isMobile)
              // Minimal indicators for mobile navbar
              Row(
                children: [
                  _buildNavLink(".", "home", cyberTheme, size: 28),
                  _buildNavLink(".", "about", cyberTheme, size: 28),
                  _buildNavLink(".", "skills", cyberTheme, size: 28),
                  _buildNavLink(".", "experience", cyberTheme, size: 28),
                  _buildNavLink(".", "projects", cyberTheme, size: 28),
                  _buildNavLink(".", "contact", cyberTheme, size: 28),
                ],
              ),

            const SizedBox(width: 12),
            
            // Light/Dark Theme Switcher Button
            CustomCursorArea(
              child: IconButton(
                icon: Icon(
                  widget.themeController.isDark ? Icons.light_mode : Icons.dark_mode,
                  color: cyberTheme.accent,
                  size: 20,
                ),
                onPressed: () {
                  widget.themeController.toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(String label, String sectionKey, CyberTheme cyberTheme, {double size = 13}) {
    final bool isActive = _activeSection == sectionKey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomCursorArea(
        child: GestureDetector(
          onTap: () => _scrollToSection(sectionKey),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isActive ? cyberTheme.accent : cyberTheme.textColor.withOpacity(0.7),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: size,
                ),
              ),
              const SizedBox(height: 2),
              // Navbar underdot active indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isActive ? 5 : 0,
                height: 5,
                decoration: BoxDecoration(
                  color: cyberTheme.accent,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(CyberTheme cyberTheme) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 3.5,
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child: FractionallySizedBox(
          widthFactor: _scrollPercent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cyberTheme.primaryGlow, cyberTheme.accent],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToTopButton(CyberTheme cyberTheme) {
    return Positioned(
      bottom: 96, // Placed slightly above chatbot
      right: 24,
      child: CustomCursorArea(
        child: FloatingActionButton.small(
          onPressed: () => _scrollToSection('home'),
          backgroundColor: cyberTheme.cardBackgroundColor,
          shape: CircleBorder(
            side: BorderSide(color: cyberTheme.accent.withOpacity(0.5)),
          ),
          child: Icon(Icons.arrow_upward, color: cyberTheme.accent, size: 18),
        ),
      ),
    );
  }
}
