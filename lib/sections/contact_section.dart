import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../widgets/custom_cursor.dart';
import '../widgets/magnetic_button.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch url: $urlString");
    }
  }

  Future<void> _launchEmailTemplate() async {
    final String subject = Uri.encodeComponent("Project Collaboration Inquiry");
    final String body = Uri.encodeComponent(
      "Hi Monu,\n\nI reviewed your portfolio and would love to connect to discuss a project collaboration.\n\nRegards,\n[Your Name]"
    );
    final Uri url = Uri.parse("mailto:monudevrath2003@gmail.com?subject=$subject&body=$body");
    if (!await launchUrl(url)) {
      debugPrint("Could not launch mail application");
    }
  }

  Future<void> _launchWhatsApp() async {
    final String url = "https://wa.me/919888049646?text=Hi%2520Monu,%2520I%2520visited%2520your%2520portfolio%2520and%2520would%2520love%2520to%2520collaborate.";
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch WhatsApp");
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent),
            const SizedBox(width: 10),
            Text("$label copied to clipboard!"),
          ],
        ),
        backgroundColor: const Color(0xff140326),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

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
            "Get In Touch",
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

          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Let's Build Something Awesome",
                            style: TextStyle(
                              color: cyberTheme.textColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "I'm currently available for freelance opportunities, full-time "
                            "engineering positions, and interesting backend or full-stack collaborations. "
                            "Feel free to copy my contact information or reach out directly on social platforms!",
                            style: TextStyle(
                              color: cyberTheme.textColor.withOpacity(0.7),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 36),
                          _buildSocialDock(cyberTheme),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        children: [
                          _buildContactCard(
                            title: "Email Me",
                            value: "monudevrath2003@gmail.com",
                            icon: Icons.email_outlined,
                            glowColor: cyberTheme.primaryGlow,
                            cyberTheme: cyberTheme,
                            onTap: _launchEmailTemplate,
                          ),
                          const SizedBox(height: 16),
                          _buildContactCard(
                            title: "Call/WhatsApp",
                            value: "+91 9888049646",
                            icon: Icons.phone_outlined,
                            glowColor: cyberTheme.secondaryGlow,
                            cyberTheme: cyberTheme,
                            onTap: _launchWhatsApp,
                          ),
                          const SizedBox(height: 16),
                          _buildContactCard(
                            title: "Location",
                            value: "Abohar, Punjab, India",
                            icon: Icons.location_on_outlined,
                            glowColor: cyberTheme.accent,
                            cyberTheme: cyberTheme,
                            onTap: () {},
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Text(
                      "Let's Build Something Awesome",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cyberTheme.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "I'm currently available for freelance opportunities, full-time "
                      "engineering positions, and interesting backend or full-stack collaborations.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cyberTheme.textColor.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildContactCard(
                      title: "Email Me",
                      value: "monudevrath2003@gmail.com",
                      icon: Icons.email_outlined,
                      glowColor: cyberTheme.primaryGlow,
                      cyberTheme: cyberTheme,
                      onTap: _launchEmailTemplate,
                    ),
                    const SizedBox(height: 16),
                    _buildContactCard(
                      title: "Call/WhatsApp",
                      value: "+91 9888049646",
                      icon: Icons.phone_outlined,
                      glowColor: cyberTheme.secondaryGlow,
                      cyberTheme: cyberTheme,
                      onTap: _launchWhatsApp,
                    ),
                    const SizedBox(height: 16),
                    _buildContactCard(
                      title: "Location",
                      value: "Abohar, Punjab, India",
                      icon: Icons.location_on_outlined,
                      glowColor: cyberTheme.accent,
                      cyberTheme: cyberTheme,
                      onTap: () {},
                    ),
                    const SizedBox(height: 36),
                    _buildSocialDock(cyberTheme),
                  ],
                ),
          
          // mybottom.png footer silhouette integration
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    'assets/icons/mybottom.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          cyberTheme.backgroundColor,
                          cyberTheme.backgroundColor.withOpacity(0.0),
                          cyberTheme.backgroundColor,
                        ],
                        stops: const [0.0, 0.45, 0.95],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              "© ${DateTime.now().year} Monu Devrath. All Rights Reserved. Crafted with Flutter Web.",
              style: TextStyle(
                color: cyberTheme.subtitleColor.withOpacity(0.55),
                fontSize: 12,
                fontFamily: 'monospace',
                decoration: TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String value,
    required IconData icon,
    required Color glowColor,
    required CyberTheme cyberTheme,
    required VoidCallback onTap,
  }) {
    return CustomCursorArea(
      type: CursorType.click,
      colorOverride: glowColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: cyberTheme.cardBackgroundColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: glowColor.withOpacity(0.15),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: glowColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: glowColor, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: cyberTheme.subtitleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        color: cyberTheme.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.copy, color: cyberTheme.textColor.withOpacity(0.3), size: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialDock(CyberTheme cyberTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildSocialIcon(
          "https://github.com/monudevrath01",
          Icons.code,
          cyberTheme.primaryGlow,
          cyberTheme,
        ),
        const SizedBox(width: 20),
        _buildSocialIcon(
          "https://www.linkedin.com/in/monudevrath?utm_source=share_via&utm_content=profile&utm_medium=member_ios",
          Icons.link,
          cyberTheme.secondaryGlow,
          cyberTheme,
        ),
        const SizedBox(width: 20),
        _buildSocialIcon(
          "https://www.instagram.com/monu_devrath?igsh=bGxubXl5d2J0NXhk",
          Icons.camera_alt_outlined,
          cyberTheme.accent,
          cyberTheme,
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String url, IconData icon, Color color, CyberTheme cyberTheme) {
    return MagneticButton(
      onTap: () => _launchURL(url),
      glowColor: color,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: cyberTheme.cardBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
