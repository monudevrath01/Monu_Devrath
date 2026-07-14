import 'package:flutter/material.dart';
import '../theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
            "About Me",
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

          // Main Content Layout
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildStorySection(cyberTheme)),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: _buildPhilosophySection(cyberTheme)),
                  ],
                )
              : Column(
                  children: [
                    _buildStorySection(cyberTheme),
                    const SizedBox(height: 36),
                    _buildPhilosophySection(cyberTheme),
                  ],
                ),
          
          const SizedBox(height: 64),
          
          // Timeline Heading
          Center(
            child: Text(
              "My Journey Timeline",
              style: TextStyle(
                color: cyberTheme.textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Timeline Widget
          _buildJourneyTimeline(cyberTheme, isDesktop),
        ],
      ),
    );
  }

  Widget _buildStorySection(CyberTheme cyberTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Professional Story",
          style: TextStyle(
            color: cyberTheme.accent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I am a passionate Full Stack Engineer specializing in the MERN ecosystem. "
          "My programming journey is rooted in curiosity and fueled by a commitment to build "
          "robust digital experiences that solve real-world problems.\n\n"
          "Through my academic training in Computer Applications and commercial internships, "
          "I have acquired hands-on expertise in structuring clean, scalable database architectures, "
          "developing optimized RESTful microservices, and crafting premium, animated, responsive frontends.\n\n"
          "I approach development with a logical design methodology, focusing heavily on application performance, "
          "security, and developer-friendly codebases. Whether designing intercity ride-sharing architectures "
          "or custom real-time messaging platforms, my goal is always to deliver top-tier engineering quality.",
          style: TextStyle(
            color: cyberTheme.textColor.withOpacity(0.8),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildPhilosophySection(CyberTheme cyberTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Development Philosophy",
          style: TextStyle(
            color: cyberTheme.accent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPhilosophyCard(
          title: "Clean Code & Scalability",
          desc: "Writing maintainable, modular code that scales effortlessly with user demands.",
          icon: Icons.code,
          cyberTheme: cyberTheme,
        ),
        const SizedBox(height: 12),
        _buildPhilosophyCard(
          title: "User-Centric Design",
          desc: "Creating intuitive interfaces that provide delightful interactive experiences.",
          icon: Icons.palette_outlined,
          cyberTheme: cyberTheme,
        ),
        const SizedBox(height: 12),
        _buildPhilosophyCard(
          title: "Continuous Learning",
          desc: "Consistently researching and adopting emerging frameworks to solve complex architecture challenges.",
          icon: Icons.menu_book_outlined,
          cyberTheme: cyberTheme,
        ),
      ],
    );
  }

  Widget _buildPhilosophyCard({
    required String title,
    required String desc,
    required IconData icon,
    required CyberTheme cyberTheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cyberTheme.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cyberTheme.primaryGlow.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cyberTheme.accent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: cyberTheme.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    color: cyberTheme.subtitleColor,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildJourneyTimeline(CyberTheme cyberTheme, bool isDesktop) {
    final List<_TimelineItem> items = [
      _TimelineItem(
        year: "Nov 2025 - Present",
        title: "MERN Stack Developer Intern",
        company: "Seefat Technologies",
        desc: "Developing high-performance user interfaces and robust server endpoints. Building client projects and leading database designs in MongoDB/PostgreSQL.",
      ),
      _TimelineItem(
        year: "May 2025 - Nov 2025",
        title: "MERN Stack Trainee",
        company: "Inventcolabs Pvt Ltd",
        desc: "Underwent intensive practical training in complete full-stack web architectures, REST APIs design, and Git workflow implementations.",
      ),
      _TimelineItem(
        year: "2021 - 2024",
        title: "Bachelor of Computer Applications (BCA)",
        company: "Guru Nanak Dev University, Amritsar",
        desc: "Laid strong academic foundations in core computer science subjects, algorithms, logic systems, and database management.",
      ),
    ];

    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Year
              SizedBox(
                width: isDesktop ? 180 : 100,
                child: Text(
                  item.year,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: cyberTheme.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              
              // Middle Line indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Glow node
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cyberTheme.accent,
                        boxShadow: [
                          BoxShadow(
                            color: cyberTheme.accent.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    ),
                    // Line
                    Container(
                      width: 2,
                      height: 110,
                      color: cyberTheme.primaryGlow.withOpacity(0.2),
                    )
                  ],
                ),
              ),
              
              // Right: Card Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cyberTheme.cardBackgroundColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: cyberTheme.primaryGlow.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: cyberTheme.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.company,
                        style: TextStyle(
                          color: cyberTheme.subtitleColor,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.desc,
                        style: TextStyle(
                          color: cyberTheme.textColor.withOpacity(0.7),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TimelineItem {
  final String year;
  final String title;
  final String company;
  final String desc;

  _TimelineItem({
    required this.year,
    required this.title,
    required this.company,
    required this.desc,
  });
}
