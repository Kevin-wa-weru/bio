import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const KevinPortfolioApp());
}

class KevinPortfolioApp extends StatelessWidget {
  const KevinPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kevin Waweru — Flutter Developer',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050507),
        primaryColor: const Color(0xFFE9F622),
        textTheme: GoogleFonts.soraTextTheme(
          ThemeData.dark().textTheme,
        ).apply(bodyColor: Colors.white70, displayColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF0F1113),
        ),
      ),
      routerConfig: router,
      builder: (context, widget) => ResponsiveBreakpoints.builder(
        child: BouncingScrollWrapper.builder(context, widget!),
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void scrollTo(double pos) {
    _scroll.animateTo(
      pos,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Parallax offset for hero image (based on scroll)
    final heroParallax = (_scroll.hasClients ? (_scroll.offset / 3) : 0.0)
        .clamp(-30.0, 30.0);

    return Stack(
      children: [
        // Animated vibrant gradient background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              final t = (_bgController.value * 2 * 3.14159);
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: const Alignment(0.0, 0.0),
                    startAngle: t,
                    endAngle: t + 3.14159,
                    colors: const [
                      Color(0xFF0B1020),
                      Color(0xFF1B1D2A),
                      Color(0xFF2B1A57),
                      Color(0xFFE9F622),
                      Color(0xFF0B1020),
                    ],
                    stops: const [0.0, 0.35, 0.65, 0.85, 1.0],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                  child: Container(color: Colors.black.withOpacity(0.25)),
                ),
              );
            },
          ),
        ),

        // Subtle floating shapes (motion)
        Positioned.fill(child: FloatingShapes(animation: _bgController)),

        // Content
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black.withOpacity(0.25),
            elevation: 0,
            titleSpacing: 20,
            title: Row(
              children: [
                Text(
                  'Kevin Waweru',
                  style: GoogleFonts.sora(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: const Text(
                    'Flutter Developer.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            actions: [
              NavTextButton(label: 'About', onTap: () => scrollTo(0)),
              NavTextButton(label: 'Experience', onTap: () => scrollTo(580)),
              NavTextButton(label: 'Projects', onTap: () => scrollTo(1180)),
              NavTextButton(label: 'Contact', onTap: () => scrollTo(1980)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FilledButton(
                  onPressed: () {
                    const cvUrl = 'assets/Kevin_waweru_cv.pdf';
                    launchUrl(Uri.parse(cvUrl), webOnlyWindowName: '_blank');
                  },

                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE9F622),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.download, color: Colors.black),
                      SizedBox(width: 6),
                      const Text(
                        'Download CV',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // HERO
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: ResponsiveRow(
                    reverseOnSmall: true,
                    left: HeroIntro(onContactTap: () => scrollTo(1980)),
                    right: Transform.translate(
                      offset: Offset(0, heroParallax),
                      child: HeroImage(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Experience
                SectionTitle(title: 'Experience'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    children: const [
                      ExperienceCard(
                        company: 'Parcel Grid',
                        role: 'Flutter Developer',
                        period: 'Jun 2023 – Present',
                        bullets: [
                          'Lead end-to-end development of the Parcel Grid mobile app, powering real-time parcel delivery,tracking and wallet systems',
                          'Developed a scalable link-sharing and referral feature, improving user engagement by 22% within the first month',
                          'Implemented a modular architecture using Bloc and Hive, reducing app startup time by 30%. ',
                          'Collaborated with backend Engineers to optimize API performance and reduce latency in delivery status updated.',
                          'Oversaw code reviews and mentored two junior developers on best practices in flutter and clean architecture.',
                        ],
                      ),
                      SizedBox(height: 12),
                      ExperienceCard(
                        company: 'Tradepoint Inc',
                        role: 'Flutter Developer & Co-Founder',
                        period: 'Jul 2022 – Jun 2023',
                        bullets: [
                          'Optimized network efficiency by replacing long polling with Server-Sent Events, reducing bandwidth usage significantly.',
                          'Maintained an app size under 12 MB through targeted asset optimization and dependency cleanup.',
                        ],
                      ),
                      SizedBox(height: 12),
                      ExperienceCard(
                        company: 'DiaspoCare',
                        role: 'Software Engineer Intern',
                        period: 'Mar 2021 – Jul 2022',
                        bullets: [
                          'Collaborated with designers and backend developers to refine UI/UX and integrate RESTful APIs.',
                          'Assisted in debugging and resolving production issues under the guidance of senior engineers.',
                          'Supported deployment and release processes for both Android and iOS builds.',
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Projects
                SectionTitle(title: 'Selected Projects'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: ProjectsGrid(),
                ),
                const SizedBox(height: 40),
                // Contact
                SectionTitle(title: 'Contact'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: ContactCard(),
                ),
                const SizedBox(height: 80),
                // Footer
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      '© ${DateTime.now().year} • Kevin Waweru',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ResponsiveRow: left/right layout with stacking on small screens
class ResponsiveRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool reverseOnSmall;
  const ResponsiveRow({
    required this.left,
    required this.right,
    this.reverseOnSmall = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isSmall = width < 900;
    if (isSmall) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: reverseOnSmall
            ? [right, const SizedBox(height: 18), left]
            : [left, const SizedBox(height: 18), right],
      );
    }
    return Row(
      children: [
        Expanded(flex: 6, child: left),
        const SizedBox(width: 36),
        Expanded(flex: 4, child: right),
      ],
    );
  }
}

/// Floating decorative shapes
class FloatingShapes extends StatelessWidget {
  final Animation<double> animation;
  const FloatingShapes({required this.animation, super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final t = animation.value;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 40 + (30 * t),
                top: 40 + (60 * (1 - t)),
                child: Opacity(
                  opacity: 0.08,
                  child: Transform.rotate(
                    angle: t * 3.14,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade900,
                            Colors.pink.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 60 + (40 * t),
                bottom: 120 + (80 * t),
                child: Opacity(
                  opacity: 0.06,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.shade700,
                          Colors.orange.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 180 + (120 * t),
                bottom: 40 + (40 * (1 - t)),
                child: Opacity(
                  opacity: 0.05,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Hero Intro (left)
/// Hero Intro (left)
class HeroIntro extends StatelessWidget {
  final VoidCallback onContactTap;
  const HeroIntro({required this.onContactTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Hi, I\'m', style: TextStyle(color: Colors.white70, fontSize: 18)),
        const SizedBox(height: 6),
        Text(
          'Kevin Waweru',
          style: GoogleFonts.sora(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSubtitle(
          texts: const [
            'Flutter Developer',
            'Mobile & Web Engineer',
            'Performance-focused',
          ],
        ),
        const SizedBox(height: 20),

        // 📞 Contact Info Row
        Row(
          children: [
            Icon(Icons.phone, color: const Color(0xFFE9F622), size: 20),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                final uri = Uri.parse('tel:+254704122812');
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
              child: const Text(
                '+254 704 122 812',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(width: 20),
            Icon(
              Icons.email_outlined,
              color: const Color(0xFFE9F622),
              size: 20,
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                final uri = Uri.parse('mailto:kevinmwangi7881@gmail.com');
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
              child: const Text(
                'kevinmwangi7881@gmail.com',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 700.ms),
        const SizedBox(height: 24),
        // 📍 Location Row
        Row(
          children: const [
            Icon(Icons.location_on, color: Color(0xFFE9F622), size: 20),
            SizedBox(width: 8),
            Text(
              'Nairobi, Kenya',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Action buttons
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onContactTap,
              icon: const Icon(Icons.mail_outline, color: Colors.black),
              label: const Text(
                'Contact Me',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE9F622),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ).animate().slideY(begin: 0.2, delay: 400.ms),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final url = Uri.parse('https://github.com/Kevin-wa-weru');
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
              icon: const Icon(Icons.code, color: Colors.white70),
              label: const Text(
                'View Projects',
                style: TextStyle(color: Colors.white70),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.06)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ).animate().slideY(begin: 0.2, delay: 600.ms),
          ],
        ),
        const SizedBox(height: 18),

        // small highlight stats
        Row(
          children: [
            StatTile(label: 'Years', value: '3+'),
            const SizedBox(width: 12),
            StatTile(label: 'Apps', value: '6+'),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse('https://github.com/Kevin-wa-weru');
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
              child: StatTile(
                label: 'Github',
                value: 'github.com/Kevin-wa-weru',
              ),
            ),
          ],
        ).animate().fadeIn(delay: 900.ms),
      ],
    );
  }
}

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  const StatTile({required this.label, required this.value, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Animated typing-like subtitle (cycles)
class AnimatedSubtitle extends StatefulWidget {
  final List<String> texts;
  const AnimatedSubtitle({required this.texts, super.key});
  @override
  State<AnimatedSubtitle> createState() => _AnimatedSubtitleState();
}

class _AnimatedSubtitleState extends State<AnimatedSubtitle> {
  int idx = 0;
  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return false;
      setState(() => idx = (idx + 1) % widget.texts.length);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.texts[idx],
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        const BlinkingCursor(),
      ],
    ).animate().fadeIn();
  }
}

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});
  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat();
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(c),
      child: Container(width: 8, height: 18, color: Colors.white70),
    );
  }
}

/// Hero Image (right)
/// Hero Image (right)
class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(
                child: Image.asset(
                  'assets/images/me.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _showImageDialog(context),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360, maxHeight: 360),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF2A0E60), Color(0xFFE9F622)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.12,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        Image.asset(
                              'assets/images/me.jpeg',
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            )
                            .animate()
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              delay: 200.ms,
                            )
                            .fadeIn(duration: 900.ms),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flutter_dash,
                          size: 16,
                          color: Color(0xFFE9F622),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Flutter & Dart',
                          style: TextStyle(
                            color: Color(0xFFE9F622),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Section title
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE9F622), Color(0xFFFFD84D)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.sora(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Experience Card
class ExperienceCard extends StatelessWidget {
  final String company;
  final String role;
  final String period;
  final List<String> bullets;
  const ExperienceCard({
    required this.company,
    required this.role,
    required this.period,
    required this.bullets,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company,
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(period, style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          Text(role, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: Color(0xFFE9F622)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}

/// Projects grid with hover effects
class ProjectsGrid extends StatelessWidget {
  const ProjectsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cross = width > 1000 ? 3 : (width > 700 ? 2 : 1);
    return GridView.count(
      crossAxisCount: cross,
      shrinkWrap: true,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      childAspectRatio: 1.1,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        ProjectCard(
          imageUrl: 'assets/images/grid.png',
          title: 'ParcelGrid',
          subtitle: 'Parcel delivery & wallet system.',
          playstore:
              'https://play.google.com/store/apps/details?id=com.escrow.escrowApp&hl=en',
          appstore:
              'https://apps.apple.com/ke/app/parcelgrid-deliver-beyond-nrbi/id6749815954',
          description:
              'ParcelGrid is a real-time parcel delivery app designed for logistics efficiency. '
              'It includes wallet top-ups, agent dashboards, live delivery tracking, and referral-based vendor registration. '
              'Built with Flutter and Firebase for both Android and Web with a focus on scalability and minimal latency.',
        ),
        ProjectCard(
          imageUrl: 'assets/images/trade.png',
          title: 'Tradepoint',
          subtitle: 'E-commerce trading platform',
          playstore:
              'https://play.google.com/store/apps/details?id=co.ke.tradepoint',
          appstore: 'https://apps.apple.com/us/app/tradepoint/id1588681767',
          description:
              'Tradepoint connects merchants and buyers through an optimized marketplace experience. '
              'It supports product listings, wallet transactions, push notifications, and live price feeds integrated via REST APIs. '
              'Engineered using Flutter, Node.js backend, and responsive Material UI for both mobile and web.',
        ),
        ProjectCard(
          title: 'Diaspocare',
          subtitle: 'Tele-health Platform',
          playstore:
              'https://play.google.com/store/apps/details?id=com.diaspocare.app&hl=en',
          appstore:
              'https://apps.apple.com/ke/app/diaspocare-supporter/id1578303718',
          imageUrl: 'assets/images/care.png',
          description:
              'DiaspoCare allows users abroad to sponsor healthcare for their loved ones locally. '
              'It offers remote appointment scheduling, secure payment gateways, and integrated chat for patients and doctors. '
              'Developed with Flutter and Firebase for a seamless cross-platform experience.',
        ),
      ],
    );
  }
}

/// Single project card (hoverable)
class ProjectCard extends StatefulWidget {
  final String title, subtitle, playstore, appstore, imageUrl, description;
  const ProjectCard({
    required this.title,
    required this.subtitle,
    required this.playstore,
    required this.appstore,

    super.key,
    required this.imageUrl,
    required this.description,
  });
  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: 300.ms,
        transform: Matrix4.identity()..scale(hover ? 1.03 : 1.0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: hover
              ? const LinearGradient(
                  colors: [Color(0xFFE9F622), Color(0xFF8A2BE2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: Colors.white.withOpacity(0.03),
          border: Border.all(
            color: hover ? Colors.transparent : Colors.white.withOpacity(0.03),
          ),
          boxShadow: [
            if (hover)
              BoxShadow(
                color: const Color(0xFFE9F622).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: -2,
              ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child:
                      Image.asset(
                            widget.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .scale(begin: const Offset(0.98, 0.98)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(widget.playstore);
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                  icon: const Icon(Icons.android, color: Colors.black),
                  label: const Text(
                    'Play Store',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9F622),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    if (widget.title == 'ParcelGrid' &&
                        widget.appstore.isEmpty) {
                      // 🚀 Show dialog for ParcelGrid only
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF0F1113),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          title: const Text(
                            'Coming Soon',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'ParcelGrid is yet to be uploaded to the Apple App Store.\n\n'
                            'Stay tuned for updates — the iOS version is in progress!',
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Color(0xFFE9F622)),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final uri = Uri.parse(widget.appstore);
                      if (await canLaunchUrl(uri)) await launchUrl(uri);
                    }
                  },
                  icon: const Icon(Icons.apple, color: Colors.white70),
                  label: const Text(
                    'App Store',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Contact card (simple form opens mailto)
class ContactCard extends StatelessWidget {
  const ContactCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Let’s build something together.',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'kevinmwangi7881@gmail.com',
                query: 'subject=Hello Kevin&body=Hi Kevin,', // optional
              );

              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri, mode: LaunchMode.externalApplication);
              } else {
                // fallback for web (open Gmail compose)
                final gmailUrl = Uri.parse(
                  'https://mail.google.com/mail/?view=cm&fs=1&to=kevinmwangi7881@gmail.com',
                );
                await launchUrl(gmailUrl, webOnlyWindowName: '_blank');
              }
            },

            icon: const Icon(Icons.mail_outline, color: Colors.black),
            label: const Text(
              'Send an Email',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE9F622),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small nav text button for top bar
class NavTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const NavTextButton({required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: Colors.white70)),
    );
  }
}
