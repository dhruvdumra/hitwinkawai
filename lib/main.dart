import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'memories_page.dart';
import 'therapy_page.dart';
import 'letter_page.dart';

void main() => runApp(const TwinApp());

class TwinApp extends StatelessWidget {
  const TwinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// ============================================
// STARRY BACKGROUND WIDGET (Reusable)
// ============================================

class StarryBackground extends StatefulWidget {
  final Widget child;
  final int starCount;
  final int particleCount;

  const StarryBackground({
    super.key,
    required this.child,
    this.starCount = 20,
    this.particleCount = 8,
  });

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground> {
  final rng = Random();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF0D0C1D), Color(0xFF1A1740), Color(0xFF241B59)],
            ),
          ),
        ),
        ...List.generate(widget.starCount, (i) {
          final size = rng.nextDouble() * 2 + 0.8;
          final x = (rng.nextDouble() * 2 - 1) * 0.95;
          final y = (rng.nextDouble() * 2 - 1) * 0.95;
          final duration = 2 + rng.nextInt(3);
          return _Star(size: size, x: x, y: y, duration: duration);
        }),
        ...List.generate(widget.particleCount, (i) {
          final size = rng.nextDouble() * 3 + 1.5;
          final x = rng.nextDouble() * 2 - 1;
          final y = rng.nextDouble() * 2 - 1;
          final duration = 8 + rng.nextInt(6);
          return _Particle(
            size: size,
            startX: x,
            startY: y,
            duration: duration,
          );
        }),
        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.purple.withOpacity(0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Star extends StatefulWidget {
  final double size;
  final double x;
  final double y;
  final int duration;

  const _Star({
    required this.size,
    required this.x,
    required this.y,
    required this.duration,
  });

  @override
  State<_Star> createState() => _StarState();
}

class _StarState extends State<_Star> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _twinkle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..repeat(reverse: true);

    _twinkle = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _twinkle,
      builder: (context, child) {
        return Align(
          alignment: Alignment(widget.x, widget.y),
          child: Opacity(
            opacity: _twinkle.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.6 * _twinkle.value),
                    blurRadius: 2,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Particle extends StatefulWidget {
  final double size;
  final double startX;
  final double startY;
  final int duration;

  const _Particle({
    required this.size,
    required this.startX,
    required this.startY,
    required this.duration,
  });

  @override
  State<_Particle> createState() => _ParticleState();
}

class _ParticleState extends State<_Particle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(widget.startX, widget.startY),
      end: Offset(-widget.startX * 0.8, -widget.startY * 0.8),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.25), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.25, end: 0.1), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: Alignment(_animation.value.dx, _animation.value.dy),
          child: Opacity(
            opacity: _opacity.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.purpleAccent.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================
// SPLASH SCREEN - WITH PRELOADING
// ============================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _textFade;
  late Animation<double> _emojiFade;
  late Animation<double> _pulse;
  late String greeting;
  late String face;
  final rng = Random();

  List<TherapyMessage>? _therapyMessages;

  @override
  void initState() {
    super.initState();

    final greetings = [
      'hi twin',
      'hiee twin',
      'halo twin',
      'konichiwazzup twin',
      'hoii twin',
      'haii twin',
    ];
    final faces = [':DDD', ':>>>', ':3333'];

    greeting = greetings[rng.nextInt(greetings.length)];
    face = faces[rng.nextInt(faces.length)];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _textFade = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 1),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 1.3),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 1),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 2.7),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _emojiFade = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 3.0),
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 1),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 2.0),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _pulse = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // PRELOAD THERAPY DATA HERE
    _preloadTherapyData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _controller.forward();
        }
      });
    });

    Future.delayed(const Duration(milliseconds: 7500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1200),
            pageBuilder: (_, __, ___) =>
                HomePage(therapyMessages: _therapyMessages),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  Future<void> _preloadTherapyData() async {
    try {
      const csvUrl =
          'https://docs.google.com/spreadsheets/d/e/2PACX-1vT1zHq4OgxenHRzuBjBH-dfU0bHES2tG4GbFVlMqtjduni4Hic3UMKGG37Vtyy59vBkY6mGWPwrn4qW/pub?output=csv';

      final response = await http.get(Uri.parse(csvUrl));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // ← ADD THIS
        _therapyMessages = _parseCSV(decodedBody);
        print('✅ Preloaded ${_therapyMessages?.length} therapy messages');
      }
    } catch (e) {
      print('❌ Failed to preload therapy data: $e');
    }
  }

  List<TherapyMessage> _parseCSV(String csv) {
    List<TherapyMessage> messages = [];

    try {
      final lines = csv.split('\n');

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        // Better CSV parsing that handles quotes and commas
        final List<String> parts = [];
        bool inQuotes = false;
        String currentField = '';

        for (int j = 0; j < line.length; j++) {
          final char = line[j];

          if (char == '"') {
            inQuotes = !inQuotes;
          } else if (char == ',' && !inQuotes) {
            parts.add(currentField.trim());
            currentField = '';
          } else {
            currentField += char;
          }
        }
        // Add the last field
        if (currentField.isNotEmpty) {
          parts.add(currentField.trim());
        }

        if (parts.length >= 5) {
          // Clean up the text and emoji
          String text = parts[0].replaceAll('"', '').trim();
          String emoji = parts[1].replaceAll('"', '').trim();

          print('Parsed: emoji="$emoji", text="${text.substring(0, 30)}..."');

          messages.add(TherapyMessage(
            text: text,
            emoji: emoji,
            gradient: [
              _parseColor(parts[2]),
              _parseColor(parts[3]),
            ],
            accentColor: _parseColor(parts[4]),
          ));
        }
      }
    } catch (e) {
      print('Error parsing CSV: $e');
    }

    return messages;
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '').replaceAll('"', '').trim();
    if (hexColor.length == 6) {
      return Color(int.parse('FF$hexColor', radix: 16));
    }
    return Color(0xFF9D50BB);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 25,
        particleCount: 10,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_controller, _pulseController]),
            builder: (context, _) {
              return Transform.scale(
                scale: _pulse.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _textFade.value,
                      child: Text(
                        greeting,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.caveat(
                          fontSize: 64,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              blurRadius: 30,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            Shadow(
                              blurRadius: 50,
                              color: Colors.purpleAccent.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _emojiFade.value,
                      child: Text(
                        face,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.caveat(
                          fontSize: 60,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              blurRadius: 25,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================
// HOME PAGE (Main Menu)
// ============================================

class HomePage extends StatefulWidget {
  final List<TherapyMessage>? therapyMessages;

  const HomePage({super.key, this.therapyMessages});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 20,
        particleCount: 8,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  'hi twin :D',
                  style: GoogleFonts.caveat(
                    fontSize: 52,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        blurRadius: 20,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'choose what you wanna see',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                _buildMenuCard(
                  context,
                  icon: '✨',
                  title: 'memories',
                  subtitle: 'because ill never be able to forget them',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MemoriesPage(),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.08),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  delay: 0,
                ),
                const SizedBox(height: 20),
                // In main.dart, replace the "Letter" card's onTap:
                _buildMenuCard(
                  context,
                  icon: '💌',
                  title: 'letter',
                  subtitle: 'dil ke shabd :)',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LetterPage(),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.08),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  delay: 0.15,
                ),
                const SizedBox(height: 20),
                _buildMenuCard(
                  context,
                  icon: '🔥',
                  title: 'drug yap',
                  subtitle: 'some words ill forever want to say',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            TherapyPage(
                                preloadedMessages: widget.therapyMessages),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.08),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOut,
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  delay: 0.3,
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required double delay,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (delay * 1000).toInt()),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              4 * sin(_floatController.value * 2 * pi + delay * 2),
            ),
            child: child,
          );
        },
        child: _HoverCard(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.3),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverCard({required this.child, required this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(
                      0.3 * _glowAnimation.value,
                    ),
                    blurRadius: 20 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
