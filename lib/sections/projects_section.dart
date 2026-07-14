import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_cursor.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyberTheme = theme.extension<CyberTheme>()!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;

    final List<_ProjectData> projectsList = [
      _ProjectData(
        title: "Oho Cab (Freelance Showcase)",
        subtitle: "BlaBlaCar-Inspired Intercity Ride Sharing",
        desc: "A highly complex ride-sharing ecosystem. Facilitates long-distance intercity matches, geospatially indexed routing, real-time matching pipelines, and payment settlements.\n\n"
            "Monu architected the database schema using raw PostgreSQL joints, caching coordinates in Redis for sub-millisecond geospatial query matches, and utilizing Socket.IO channels to notify passengers of incoming ride bookings instantly.",
        tech: ["TypeScript", "Node.js", "PostgreSQL", "Redis", "Socket.IO", "Docker"],
        glowColor: cyberTheme.accent,
        isFeatured: true,
        detailedExplanation: "Oho Cab was engineered to solve the problem of expensive intercity travel by matching drivers with spare seats to passengers heading in the same direction.\n\n"
            "• Database Schema: Implemented complex relational mapping in PostgreSQL, detailing riders, publishers, booking statuses, coordinates, ratings, and transactional ledger statements.\n"
            "• Real-Time Matching Engine: Integrated Redis geospatial indices (`GEOADD`, `GEORADIUS`) to query active rides along intermediate highway routes within a 5km radius of a passenger's search trajectory.\n"
            "• WebSocket Communication: Designed robust Socket.IO channels coordinating passenger bookings, driver arpeggiated match requests, and live vehicle coordinates updates.\n"
            "• DevOps Deployment: Containerized services using Docker multi-stage builds, setting up networking channels connecting backend nodes, Redis instances, and PostgreSQL pools.",
      ),
      _ProjectData(
        title: "E-Commerce Platform",
        subtitle: "MERN Stack Marketplace",
        desc: "A commercial-grade retail platform with multi-tenant merchant panels. Includes comprehensive authentication, cart processing, inventories tracking, and checkout gateways.\n\n"
            "Monu developed route middleware verifying JWT web tokens, structured catalog listings with MongoDB text indexes search queries, and configured Stripe webhook callbacks auditing paid order ledgers.",
        tech: ["MongoDB", "Express", "React", "Node.js", "JWT", "Stripe"],
        glowColor: cyberTheme.primaryGlow,
        isFeatured: false,
        detailedExplanation: "This E-Commerce platform provides a robust digital marketplace for multiple merchant vendors.\n\n"
            "• Secure Authentication: Implemented secure cryptographic password hashes, issuing short-lived JSON Web Tokens (JWT) stored in HTTP-only cookies to mitigate CSRF cross-site script risks.\n"
            "• Advanced Search: Implemented MongoDB text indices supporting autocomplete search, spelling-tolerant queries, and dynamic filters by categories and pricing limits.\n"
            "• Ledger Checkout: Integrated Stripe API handlers verifying checkout sessions, listening to webhook events updating MongoDB inventory counts, and creating immutable payment ledger entries.",
      ),
      _ProjectData(
        title: "BEFT Fitness Planner",
        subtitle: "Diet Tracking & Workout Analytics",
        desc: "A personalized wellness suite tracking health metrics. Monu structured workout schedulers, calorie calculator algorithms, and weight progression charts.\n\n"
            "Utilized React components drawing progress analytics with ChartJS, storing micro-nutrients details in MongoDB, and using Node routes querying caloric goals.",
        tech: ["React.js", "Node.js", "Express", "MongoDB", "ChartJS"],
        glowColor: cyberTheme.secondaryGlow,
        isFeatured: false,
        detailedExplanation: "BEFT Fitness acts as an interactive coach monitoring daily metabolic stats.\n\n"
            "• Caloric Math: Designed backend algorithms calculating Total Daily Energy Expenditures (TDEE) based on user demographics and metabolic rates.\n"
            "• Analytics Rendering: Built interactive React widgets utilizing Chart.js rendering user weight charts, metabolic indices, and macro-nutrient breakdowns.\n"
            "• Structured Database: Stored granular details of meals, calories, physical workout routines, and user progression history in MongoDB schemas.",
      ),
      _ProjectData(
        title: "School Management System",
        subtitle: "Role-Based Educational Admin",
        desc: "An enterprise ERP managing school operations. Features role-based access controls for Admins, Teachers, and Students.\n\n"
            "Monu engineered attendance loggers, class schedules generators, and academic report builders using Express backend routing and MongoDB databases.",
        tech: ["JavaScript", "Express", "Node.js", "MongoDB", "EJS"],
        glowColor: cyberTheme.accent,
        isFeatured: false,
        detailedExplanation: "This School ERP handles school administration pipelines.\n\n"
            "• Role-Based Security: Built middleware routers evaluating user credentials roles, restricting student views from modifying class grades or attendance records.\n"
            "• Timetable Scheduler: Structured conflict-free scheduling logic mapping teachers, class locations, and times slots.\n"
            "• Academic Auditing: Designed automated EJS template renderers compile students report cards, attendance ratios, and class announcements.",
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 1200 ? 120 : (screenWidth > 600 ? 48 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            "Featured Projects",
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

          // Projects Grid
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 2 : 1,
              crossAxisSpacing: 28,
              mainAxisSpacing: 28,
              childAspectRatio: isDesktop ? 1.3 : 1.2,
            ),
            itemCount: projectsList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final proj = projectsList[index];
              return _TiltProjectCard(
                project: proj,
                cyberTheme: cyberTheme,
                onTap: () {
                  _showProjectDetails(context, proj, cyberTheme);
                },
              );
            },
          ),
          
          const SizedBox(height: 64),
          
          // Testimonials Section
          Center(
            child: Text(
              "Client Reviews",
              style: TextStyle(
                color: cyberTheme.textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _buildClientReviewsGrid(cyberTheme, screenWidth),
        ],
      ),
    );
  }

  void _showProjectDetails(BuildContext context, _ProjectData proj, CyberTheme cyberTheme) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            width: 850,
            height: 800,
            decoration: BoxDecoration(
              color: cyberTheme.cardBackgroundColor.withOpacity(0.96),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: proj.glowColor.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: proj.glowColor.withOpacity(0.15),
                  blurRadius: 32,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(Icons.terminal, color: proj.glowColor, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proj.title,
                              style: TextStyle(
                                color: cyberTheme.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              proj.subtitle,
                              style: TextStyle(color: cyberTheme.subtitleColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: cyberTheme.textColor),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
                
                // Scrollable details body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Overview",
                          style: TextStyle(color: proj.glowColor, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          proj.desc,
                          style: TextStyle(color: cyberTheme.textColor.withOpacity(0.85), fontSize: 13.5, height: 1.6),
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          "Architectural Engineering Details",
                          style: TextStyle(color: proj.glowColor, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          proj.detailedExplanation,
                          style: TextStyle(color: cyberTheme.textColor.withOpacity(0.8), fontSize: 13, height: 1.6),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        if (proj.isFeatured) ...[
                          Text(
                            "Oho Cab - System Architecture",
                            style: TextStyle(color: proj.glowColor, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 12),
                          _buildArchitectureDiagram(cyberTheme),
                          const SizedBox(height: 24),
                          Text(
                            "Simulated Mobile Dashboards",
                            style: TextStyle(color: proj.glowColor, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 12),
                          _buildScreenshotsCarousel(cyberTheme),
                          const SizedBox(height: 24),
                        ],
                        
                        Text(
                          "Tech Stack Used",
                          style: TextStyle(color: proj.glowColor, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: proj.tech.map((t) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: proj.glowColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: proj.glowColor.withOpacity(0.3)),
                              ),
                              child: Text(t, style: TextStyle(color: cyberTheme.textColor, fontSize: 12)),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArchitectureDiagram(CyberTheme cyberTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cyberTheme.accent.withOpacity(0.2)),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDiagBox("Passenger / Driver Apps\n(React Mobile Web)", cyberTheme.accent, cyberTheme),
              _buildDiagArrow(cyberTheme),
              _buildDiagBox("API Gateway & Server\n(Node.js / Express)", cyberTheme.primaryGlow, cyberTheme),
              _buildDiagArrow(cyberTheme),
              Column(
                children: [
                  _buildDiagBox("PostgreSQL\n(User Data & Rides)", cyberTheme.secondaryGlow, cyberTheme),
                  const SizedBox(height: 8),
                  _buildDiagBox("Redis\n(Geospatial Cache)", cyberTheme.secondaryGlow, cyberTheme),
                  const SizedBox(height: 8),
                  _buildDiagBox("Socket.IO\n(Realtime Pub-Sub)", cyberTheme.secondaryGlow, cyberTheme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiagBox(String label, Color borderColor, CyberTheme cyberTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cyberTheme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: cyberTheme.textColor, fontSize: 11, fontFamily: 'monospace'),
      ),
    );
  }

  Widget _buildDiagArrow(CyberTheme cyberTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(Icons.arrow_forward_ios, color: cyberTheme.subtitleColor.withOpacity(0.5), size: 16),
    );
  }

  Widget _buildScreenshotsCarousel(CyberTheme cyberTheme) {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSimulatedScreen("Find Rides", "From: Amritsar\nTo: Abohar\nSeats: 2\nMap Route matched 98%", Icons.search, cyberTheme),
          const SizedBox(width: 16),
          _buildSimulatedScreen("Active Navigation", "Driver: Rajesh K.\nVehicle: Swift Dzire\nSpeed: 75 km/h\nETA: 45 mins", Icons.navigation, cyberTheme),
          const SizedBox(width: 16),
          _buildSimulatedScreen("Publish Ride", "Date: 18th July\nRoute: NH15\nPrice per seat: ₹350\nRemaining seats: 4", Icons.add_road, cyberTheme),
          const SizedBox(width: 16),
          _buildSimulatedScreen("Driver Earnings", "Today: ₹1,450\nCompleted: 4 rides\nPlatform Commission: 10%", Icons.account_balance_wallet, cyberTheme),
        ],
      ),
    );
  }

  Widget _buildSimulatedScreen(String title, String body, IconData icon, CyberTheme cyberTheme) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: const Color(0xff110526),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cyberTheme.primaryGlow.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Container(
            height: 18,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.black.withOpacity(0.25),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("9:41", style: TextStyle(color: Colors.white54, fontSize: 8)),
                Icon(Icons.wifi, color: Colors.white54, size: 8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(icon, color: cyberTheme.accent, size: 14),
                const SizedBox(width: 6),
                Text(title, style: TextStyle(color: cyberTheme.textColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                body,
                style: TextStyle(color: cyberTheme.textColor.withOpacity(0.8), fontSize: 10, fontFamily: 'monospace', height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientReviewsGrid(CyberTheme cyberTheme, double screenWidth) {
    final int crossAxisCount = screenWidth > 900 ? 2 : 1;
    
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: screenWidth > 900 ? 2.0 : 1.6,
      children: [
        _buildReviewCard(
          clientName: "Siddharth Mehta",
          role: "Co-Founder, CommuteFlow Startup",
          feedback: "Monu engineered the entire backend system of Oho Cab. His integration of Redis geospatial indexes and WebSocket matching was flawless. The platform handles real-time intercity matching with sub-millisecond query responses. Exceptional backend engineering skill!",
          rating: 5,
          cyberTheme: cyberTheme,
        ),
        _buildReviewCard(
          clientName: "Karen D'Souza",
          role: "Operations Manager, RetailExpress India",
          feedback: "We hired Monu to build our custom MERN stack vendor marketplace. His handling of JWT cookie authentications, search indexing optimizations, and Stripe webhook transaction reconciliations was exemplary. Highly recommended!",
          rating: 5,
          cyberTheme: cyberTheme,
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String clientName,
    required String role,
    required String feedback,
    required int rating,
    required CyberTheme cyberTheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cyberTheme.cardBackgroundColor.withOpacity(0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cyberTheme.primaryGlow.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: cyberTheme.accent.withOpacity(0.12),
                child: Text(
                  clientName.substring(0, 1),
                  style: TextStyle(color: cyberTheme.accent, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(clientName, style: TextStyle(color: cyberTheme.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(role, style: TextStyle(color: cyberTheme.subtitleColor, fontSize: 11, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  rating,
                  (index) => Icon(Icons.star, color: Colors.amberAccent, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                "\"$feedback\"",
                style: TextStyle(
                  color: cyberTheme.textColor.withOpacity(0.75),
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String subtitle;
  final String desc;
  final List<String> tech;
  final Color glowColor;
  final bool isFeatured;
  final String detailedExplanation;

  _ProjectData({
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.tech,
    required this.glowColor,
    required this.isFeatured,
    required this.detailedExplanation,
  });
}

class _TiltProjectCard extends StatefulWidget {
  final _ProjectData project;
  final CyberTheme cyberTheme;
  final VoidCallback onTap;

  const _TiltProjectCard({
    required this.project,
    required this.cyberTheme,
    required this.onTap,
  });

  @override
  State<_TiltProjectCard> createState() => _TiltProjectCardState();
}

class _TiltProjectCardState extends State<_TiltProjectCard> with SingleTickerProviderStateMixin {
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isHovered = false;

  // Rotating border animation controllers
  late final AnimationController _borderAnimController;

  @override
  void initState() {
    super.initState();
    _borderAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _borderAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proj = widget.project;
    final cyberTheme = widget.cyberTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _tiltX = 0.0;
          _tiltY = 0.0;
        });
      },
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final size = box.size;
          final localPos = event.localPosition;
          // Increased tilt multiplier (dx/dy ranges -0.5..0.5. multiplied by 32.0 for higher 3D Three.js perspective feeling)
          final dx = (localPos.dx / size.width) - 0.5;
          final dy = (localPos.dy / size.height) - 0.5;
          
          setState(() {
            _tiltX = -dy * 32.0; 
            _tiltY = dx * 32.0;  
          });
        }
      },
      child: CustomCursorArea(
        type: CursorType.hover,
        colorOverride: proj.glowColor,
        child: GestureDetector(
          onTap: widget.onTap,
          child: TweenAnimationBuilder<Matrix4>(
            tween: Tween<Matrix4>(
              begin: Matrix4.identity(),
              end: Matrix4.identity()
                ..setEntry(3, 2, 0.002) // Increased perspective depth ratio
                ..rotateX(_tiltX * 3.14159 / 180)
                ..rotateY(_tiltY * 3.14159 / 180),
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            builder: (context, transform, child) {
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: child,
              );
            },
            child: AnimatedBuilder(
              animation: _borderAnimController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(2), // border width spacer
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    // Rotating Gradient Border
                    gradient: SweepGradient(
                      center: Alignment.center,
                      startAngle: 0.0,
                      endAngle: math.pi * 2,
                      colors: [
                        proj.glowColor.withOpacity(_isHovered ? 0.95 : 0.25),
                        proj.glowColor.withOpacity(0.05),
                        proj.glowColor.withOpacity(_isHovered ? 0.95 : 0.25),
                      ],
                      transform: GradientRotation(_borderAnimController.value * math.pi * 2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered ? proj.glowColor.withOpacity(0.2) : Colors.transparent,
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: cyberTheme.cardBackgroundColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            proj.title,
                            style: TextStyle(
                              color: cyberTheme.textColor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (proj.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: proj.glowColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: proj.glowColor),
                            ),
                            child: Text(
                              "Featured",
                              style: TextStyle(color: cyberTheme.textColor, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      proj.subtitle,
                      style: TextStyle(
                        color: cyberTheme.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: Text(
                        proj.desc,
                        style: TextStyle(
                          color: cyberTheme.textColor.withOpacity(0.72),
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: proj.tech.take(4).map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: proj.glowColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: proj.glowColor.withOpacity(0.2)),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              color: cyberTheme.textColor.withOpacity(0.9),
                              fontSize: 10,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
