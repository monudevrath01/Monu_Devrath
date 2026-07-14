import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_cursor.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyberTheme = theme.extension<CyberTheme>()!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 800;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1200 ? 120 : (screenWidth > 600 ? 48 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            "Commercial Experience",
            style: TextStyle(
              color: cyberTheme.textColor,
              fontSize: screenWidth > 800 ? 36 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cyberTheme.primaryGlow, cyberTheme.secondaryGlow],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 36),

          // Statistics Counters Grid
          _buildStatsSection(cyberTheme, screenWidth),
          
          const SizedBox(height: 48),

          // Job Roles Layout
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildJobCard(
                        company: "Seefat Technologies",
                        role: "MERN Stack Developer Intern",
                        time: "Nov 2025 - Present",
                        glowColor: cyberTheme.primaryGlow,
                        responsibilities: [
                          "Developing dynamic React frontend interfaces for enterprise products.",
                          "Designing and maintaining modular REST APIs and middleware validation chains.",
                          "Managing database operations using PostgreSQL and MongoDB.",
                          "Integrating third-party integrations and payment handlers.",
                          "Deploying live client web applications and managing containerized apps.",
                        ],
                        cyberTheme: cyberTheme,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildJobCard(
                        company: "Inventcolabs Pvt Ltd",
                        role: "MERN Stack Trainee",
                        time: "May 2025 - Nov 2025",
                        glowColor: cyberTheme.secondaryGlow,
                        responsibilities: [
                          "Trained intensively on the full MERN development lifecycle.",
                          "Engineered robust CRUD services using Node.js and Express.",
                          "Constructed complex database schemas and model relations in MongoDB.",
                          "Learned clean version control standards and Git branching flows.",
                          "Practiced API payload validation and route optimization rules.",
                        ],
                        cyberTheme: cyberTheme,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildJobCard(
                      company: "Seefat Technologies",
                      role: "MERN Stack Developer Intern",
                      time: "Nov 2025 - Present",
                      glowColor: cyberTheme.primaryGlow,
                      responsibilities: [
                        "Developing dynamic React frontend interfaces for enterprise products.",
                        "Designing and maintaining modular REST APIs and middleware validation chains.",
                        "Managing database operations using PostgreSQL and MongoDB.",
                        "Integrating third-party integrations and payment handlers.",
                        "Deploying live client web applications and managing containerized apps.",
                      ],
                      cyberTheme: cyberTheme,
                    ),
                    const SizedBox(height: 24),
                    _buildJobCard(
                      company: "Inventcolabs Pvt Ltd",
                      role: "MERN Stack Trainee",
                      time: "May 2025 - Nov 2025",
                      glowColor: cyberTheme.secondaryGlow,
                      responsibilities: [
                        "Trained intensively on the full MERN development lifecycle.",
                        "Engineered robust CRUD services using Node.js and Express.",
                        "Constructed complex database schemas and model relations in MongoDB.",
                        "Learned clean version control standards and Git branching flows.",
                        "Practiced API payload validation and route optimization rules.",
                      ],
                      cyberTheme: cyberTheme,
                      
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(CyberTheme cyberTheme, double screenWidth) {
    final int crossAxisCount = screenWidth > 1000 ? 4 : (screenWidth > 600 ? 2 : 1);
    
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: screenWidth > 1000 ? 1.6 : 2.2,
      children: [
        _buildStatCard("Projects Completed", 15, "+", cyberTheme.accent, cyberTheme),
        _buildStatCard("GitHub Commits", 450, "+", cyberTheme.primaryGlow, cyberTheme),
        _buildStatCard("Hours Coding", 1200, "+", cyberTheme.secondaryGlow, cyberTheme),
        _buildStatCard("Technologies Orbiting", 11, "", cyberTheme.accent, cyberTheme),
      ],
    );
  }

  Widget _buildStatCard(String label, int targetValue, String suffix, Color glowColor, CyberTheme cyberTheme) {
    return Container(
      decoration: BoxDecoration(
        color: cyberTheme.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: glowColor.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AnimatedCounter(
              target: targetValue,
              suffix: suffix,
              textStyle: TextStyle(
                color: cyberTheme.textColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: cyberTheme.glowIntensity > 0.2
                    ? [Shadow(color: glowColor.withOpacity(0.6), blurRadius: 10)]
                    : [],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: cyberTheme.subtitleColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required String company,
    required String role,
    required String time,
    required Color glowColor,
    required List<String> responsibilities,
    required CyberTheme cyberTheme,
  }) {
    return CustomCursorArea(
      type: CursorType.hover,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: cyberTheme.cardBackgroundColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: glowColor.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    company,
                    style: TextStyle(
                      color: cyberTheme.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: glowColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: glowColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: cyberTheme.textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            // Role Text
            Text(
              role,
              style: TextStyle(
                color: cyberTheme.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            // Responsibilities Bullet List
            ...responsibilities.map((resp) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, right: 12.0),
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: glowColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        resp,
                        style: TextStyle(
                          color: cyberTheme.textColor.withOpacity(0.75),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCounter extends StatefulWidget {
  final int target;
  final String suffix;
  final TextStyle textStyle;

  const _AnimatedCounter({
    required this.target,
    required this.suffix,
    required this.textStyle,
  });

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = IntTween(begin: 0, end: widget.target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          "${_animation.value}${widget.suffix}",
          style: widget.textStyle,
        );
      },
    );
  }
}
