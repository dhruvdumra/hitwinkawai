import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'seventeen_letters_page.dart';

// ============================================
// FLOATING BIRTHDAY BUTTON
// ============================================

class FloatingBirthdayButton extends StatefulWidget {
  const FloatingBirthdayButton({super.key});

  @override
  State<FloatingBirthdayButton> createState() => _FloatingBirthdayButtonState();
}

class _FloatingBirthdayButtonState extends State<FloatingBirthdayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  final Random rng = Random();
  late double phase;

  @override
  void initState() {
    super.initState();
    phase = rng.nextDouble() * 2 * pi;
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8 + rng.nextInt(4)),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final t = _floatController.value * 2 * pi + phase;
        final x = 0.5 + cos(t) * 0.35;
        final y = 0.5 + sin(t * 1.3) * 0.35;

        return Positioned(
          left: MediaQuery.of(context).size.width * x - 40,
          top: MediaQuery.of(context).size.height * y - 40,
          child: child!,
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const BirthdayExperience(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0xFFFF69B4).withOpacity(0.4),
                Color(0xFFBA55D3).withOpacity(0.3),
                Color(0xFF9D50BB).withOpacity(0.1),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF69B4).withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Color(0xFFBA55D3).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '🎁',
              style: TextStyle(
                fontSize: 38,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// BIRTHDAY EXPERIENCE PAGE
// ============================================

class BirthdayExperience extends StatefulWidget {
  const BirthdayExperience({super.key});

  @override
  State<BirthdayExperience> createState() => _BirthdayExperienceState();
}

class _BirthdayExperienceState extends State<BirthdayExperience>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _fadeInController;
  late AnimationController _cakeController;
  late AnimationController _candleController;
  late AnimationController _confettiController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _glowController;

  // Birthday Configuration
  final DateTime birthdayDate = DateTime(2025, 1, 6);
  final String birthdayName = "Tejaswini";

  // Server Time Management
  Timer? _countdownTimer;
  Duration _timeRemaining = Duration.zero;
  DateTime? _serverTime;
  DateTime? _serverFetchTime;
  bool _isLoadingTime = true;

  // State Management
  bool _isBirthdayReached = false;
  bool _showCake = false;
  bool _candlesLit = false;
  bool _candlesBlown = false;
  bool _showCelebration = false;
  bool _showLetter = false;

  @override
  void initState() {
    super.initState();

    _fadeInController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _cakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _candleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _confettiController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );

    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _initializeBirthdayExperience();
  }

  Future<void> _initializeBirthdayExperience() async {
    _fadeInController.forward();
    await _fetchServerTime();
    _startCountdownTimer();
  }

  Future<void> _fetchServerTime() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://worldtimeapi.org/api/timezone/Asia/Kolkata'),
          )
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _serverTime = DateTime.parse(data['datetime']);
        _serverFetchTime = DateTime.now();
      } else {
        _serverTime = DateTime.now();
        _serverFetchTime = DateTime.now();
      }
    } catch (e) {
      print('Error fetching server time: $e');
      _serverTime = DateTime.now();
      _serverFetchTime = DateTime.now();
    }

    if (mounted) {
      setState(() {
        _isLoadingTime = false;
      });
      _checkIfBirthdayReached();
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_serverTime == null || _serverFetchTime == null) return;

    final elapsedSinceFetch = DateTime.now().difference(_serverFetchTime!);
    final currentServerTime = _serverTime!.add(elapsedSinceFetch);

    if (currentServerTime.isBefore(birthdayDate)) {
      setState(() {
        _timeRemaining = birthdayDate.difference(currentServerTime);
      });
    } else {
      if (!_isBirthdayReached) {
        _onBirthdayReached();
      }
    }
  }

  void _checkIfBirthdayReached() {
    if (_serverTime == null || _serverFetchTime == null) return;

    final elapsedSinceFetch = DateTime.now().difference(_serverFetchTime!);
    final currentServerTime = _serverTime!.add(elapsedSinceFetch);

    if (!currentServerTime.isBefore(birthdayDate)) {
      _onBirthdayReached();
    }
  }

  void _onBirthdayReached() {
    if (_isBirthdayReached) return;

    setState(() {
      _isBirthdayReached = true;
      _showCake = true;
    });

    _countdownTimer?.cancel();

    // Animation sequence
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) _cakeController.forward();
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() => _candlesLit = true);
      }
    });

    Future.delayed(Duration(milliseconds: 4000), () {
      if (mounted) {
        _blowCandles();
      }
    });
  }

  void _blowCandles() {
    setState(() => _candlesBlown = true);
    _candleController.stop();

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showCelebration = true);
        _confettiController.forward();
        _textController.forward();
      }
    });

    Future.delayed(Duration(milliseconds: 5000), () {
      if (mounted) {
        _transitionToLetter();
      }
    });
  }

  void _transitionToLetter() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GiftSelectionPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _fadeInController.dispose();
    _cakeController.dispose();
    _candleController.dispose();
    _confettiController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A0E2E),
              Color(0xFF0D0C1D),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            if (_isBirthdayReached)
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticlePainter(_particleController.value),
                    size: Size.infinite,
                  );
                },
              ),

            // Confetti Layer
            if (_showCelebration)
              AnimatedBuilder(
                animation: _confettiController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ConfettiPainter(_confettiController.value),
                    size: Size.infinite,
                  );
                },
              ),

            // Close Button
            Positioned(
              top: 50,
              left: 20,
              child: AnimatedBuilder(
                animation: _fadeInController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeInController.value,
                    child: child,
                  );
                },
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white70, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // Main Content
            Center(
              child: _isLoadingTime
                  ? _buildLoadingState()
                  : !_isBirthdayReached
                      ? _buildCountdownState()
                      : _buildBirthdayState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Color(0xFFFF69B4),
          strokeWidth: 3,
        ),
        SizedBox(height: 20),
        Text(
          'Loading...',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownState() {
    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return AnimatedBuilder(
      animation: _fadeInController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeInController.value,
          child: Transform.scale(
            scale: 0.8 + (_fadeInController.value * 0.2),
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🎂',
            style: TextStyle(fontSize: 80),
          ),
          SizedBox(height: 30),
          Text(
            'Birthday Countdown',
            style: GoogleFonts.caveat(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF69B4).withOpacity(0.2),
                  Color(0xFFBA55D3).withOpacity(0.2),
                ],
              ),
              border: Border.all(
                color: Color(0xFFFF69B4).withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF69B4).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimeUnit(days.toString(), 'days'),
                _buildTimeSeparator(),
                _buildTimeUnit(hours.toString().padLeft(2, '0'), 'hours'),
                _buildTimeSeparator(),
                _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'mins'),
                _buildTimeSeparator(),
                _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'secs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white60,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 28,
          color: Colors.white60,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildBirthdayState() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: AnimatedBuilder(
        animation: _cakeController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8 + (_cakeController.value * 0.2),
            child: Opacity(
              opacity: _cakeController.value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStunningCake(),
              if (_showCelebration) ...[
                SizedBox(height: 35),
                _buildCelebrationText(),
                SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStunningCake() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Age display above cake
        _buildCountdownNumber(),
        SizedBox(height: 40),
        // Cake with enhanced glow effects
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer animated glow rings
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  width: 320 + (_glowController.value * 30),
                  height: 320 + (_glowController.value * 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFF1493).withOpacity(0.15),
                        Color(0xFFFF69B4).withOpacity(0.08),
                        Color(0xFFBA55D3).withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            // Inner glow
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  width: 260 + (_glowController.value * 15),
                  height: 260 + (_glowController.value * 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFF69B4).withOpacity(0.25),
                        Color(0xFFFF1493).withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            // Main cake container with enhanced styling
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFB6C1),
                    Color(0xFFFF85C0),
                    Color(0xFFFF1493),
                    Color(0xFFFF69B4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFF1493).withOpacity(0.7),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                  BoxShadow(
                    color: Color(0xFFBA55D3).withOpacity(0.4),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shimmer effect
                  Positioned(
                    top: 20,
                    left: 30,
                    child: Container(
                      width: 40,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '🎂',
                      style: TextStyle(fontSize: 110),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountdownNumber() {
    // Show age instead of days remaining
    final age = 17;

    return Column(
      children: [
        // Sparkle emojis above
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('✨', style: TextStyle(fontSize: 28)),
            SizedBox(width: 15),
            Text('🎀', style: TextStyle(fontSize: 24)),
            SizedBox(width: 15),
            Text('✨', style: TextStyle(fontSize: 28)),
          ],
        ),
        SizedBox(height: 20),
        // Age display with beautiful styling
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color(0xFFFFF0F5),
                Color(0xFFFFE4EC),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF69B4).withOpacity(0.6),
                blurRadius: 35,
                spreadRadius: 8,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 25,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Color(0xFFBA55D3).withOpacity(0.3),
                blurRadius: 50,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                age.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 72,
                  fontWeight: FontWeight.w800,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF1493),
                        Color(0xFFFF69B4),
                        Color(0xFFBA55D3),
                      ],
                    ).createShader(Rect.fromLTWH(0, 0, 100, 90)),
                ),
              ),
              Text(
                'years old',
                style: GoogleFonts.caveat(
                  fontSize: 24,
                  color: Color(0xFFFF69B4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        // Decorative hearts
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💖', style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Text('💫', style: TextStyle(fontSize: 18)),
            SizedBox(width: 10),
            Text('💖', style: TextStyle(fontSize: 20)),
          ],
        ),
      ],
    );
  }

  int _getDaysRemaining() {
    if (_serverTime == null || _serverFetchTime == null) return 0;
    final elapsedSinceFetch = DateTime.now().difference(_serverFetchTime!);
    final currentServerTime = _serverTime!.add(elapsedSinceFetch);
    if (currentServerTime.isBefore(birthdayDate)) {
      return birthdayDate.difference(currentServerTime).inDays;
    }
    return 0;
  }

  Widget _buildCelebrationText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_textController.value * 0.2),
          child: Opacity(
            opacity: _textController.value,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          // Decorative stars above
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🌟', style: TextStyle(fontSize: 24)),
              SizedBox(width: 15),
              Text('💫', style: TextStyle(fontSize: 20)),
              SizedBox(width: 15),
              Text('🌟', style: TextStyle(fontSize: 24)),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF1493).withOpacity(0.35),
                  Color(0xFFBA55D3).withOpacity(0.25),
                  Color(0xFF9D50BB).withOpacity(0.35),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF69B4).withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: Color(0xFFBA55D3).withOpacity(0.3),
                  blurRadius: 60,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🎉', style: TextStyle(fontSize: 36)),
                    SizedBox(width: 12),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFFFB6C1),
                              Colors.white,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Happy Birthday!',
                            style: GoogleFonts.caveat(
                              fontSize: 52,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  blurRadius: 25,
                                  color: Color(0xFFFF69B4),
                                ),
                                Shadow(
                                  blurRadius: 50,
                                  color: Color(0xFFFF1493).withOpacity(0.7),
                                ),
                                Shadow(
                                  blurRadius: 80,
                                  color: Color(0xFFBA55D3).withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('🎉', style: TextStyle(fontSize: 36)),
                  ],
                ),
                SizedBox(height: 18),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Text(
                    birthdayName,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            Colors.white,
                            Color(0xFFFFB6C1),
                            Colors.white,
                          ],
                        ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                      letterSpacing: 3,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('💖', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text('🎀', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('💖', style: TextStyle(fontSize: 22)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// PARTICLE PAINTER
// ============================================

class ParticlePainter extends CustomPainter {
  final double progress;
  final Random rng = Random(123);

  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const particleCount = 50;

    for (int i = 0; i < particleCount; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;

      final x = baseX + sin(progress * 2 * pi + i) * 30;
      final y = baseY + cos(progress * 2 * pi + i) * 30;

      final paint = Paint()
        ..color = Color(0xFFFF69B4)
            .withOpacity(0.2 + (sin(progress * 4 * pi + i) * 0.1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        2 + (sin(progress * 3 * pi + i) * 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// ============================================
// CONFETTI PAINTER
// ============================================

class ConfettiPainter extends CustomPainter {
  final double progress;
  final Random rng = Random(42);

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const confettiCount = 80;
    const colors = [
      Color(0xFFFF1493),
      Color(0xFFFF69B4),
      Color(0xFFBA55D3),
      Color(0xFFFFD700),
      Color(0xFF00CED1),
      Color(0xFFFF6347),
      Color(0xFF98FB98),
      Color(0xFFFFB6C1),
    ];

    for (int i = 0; i < confettiCount; i++) {
      final x = rng.nextDouble() * size.width;
      const startY = -150.0;
      final endY = size.height + 150;
      final y = startY + (endY - startY) * progress;

      final rotation = rng.nextDouble() * 2 * pi * progress * 5;
      final confettiSize = 8.0 + rng.nextDouble() * 14;
      final horizontalDrift = sin(progress * pi * 3 + i) * 40;
      final fallSpeed = 0.8 + (rng.nextDouble() * 0.4);

      canvas.save();
      canvas.translate(x + horizontalDrift, y * fallSpeed);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(0.95)
        ..style = PaintingStyle.fill;

      // Draw different shapes
      if (i % 3 == 0) {
        canvas.drawCircle(Offset.zero, confettiSize / 2, paint);
      } else if (i % 3 == 1) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: confettiSize,
            height: confettiSize * 1.6,
          ),
          paint,
        );
      } else {
        final path = Path();
        path.moveTo(0, -confettiSize);
        path.lineTo(confettiSize, confettiSize);
        path.lineTo(-confettiSize, confettiSize);
        path.close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

// ============================================
// BIRTHDAY LETTER PAGE
// ============================================

class BirthdayLetterPage extends StatefulWidget {
  final String name;

  const BirthdayLetterPage({super.key, required this.name});

  @override
  State<BirthdayLetterPage> createState() => _BirthdayLetterPageState();
}

class _BirthdayLetterPageState extends State<BirthdayLetterPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _breatheController;
  late AnimationController _sparkleController;
  late AnimationController _heartController;

  final String letterContent = """HAPPIESTTTTT BIRTHDAYYY TWINN HAPPY BIRTHDAYYY THANKS U SOSOSOSOOSOS MUCH FOR ALWAYS BEING THERE TWIN. YOU ARE THE LITERAL GOAT LIKE ACTUAL MAIN CHARACTER. TWIN UR 17 U HAVE SURVIVED 17 FUCKING YEARS U HAVE SURVIVED HONESTLY SOSOOSS MUCH UR THE STRONGEST PERSON I HAVE EVER SEEN. Twin i see your efforts and all these efforts all these thing u have went through they were not small your efforts were not small they were enough you always always gave your best. despite so many constant fights so many constant problems every day you used to come up with the same most brightest energy i have ever seen and light up like everyone literally everyone. i wants you to know twin you are so much goated so much best so much wonderful. from everythings u have given me the my drawing (I STILL LOOK AT IT EVERYDAY ITS SOOSOS GOOD) THE BRACELETS AND THE HAIRCLIPS (sorri twin redblue wale bracelet ka color thoda fade hogya 💔) MY BIRTHDAY GIFTTSSS AND DA LITERAL GAME LIKE A LITERAL FULL FLEDGED GAME I GO AT SUCH A AWE WHENEVER I PPLAYS IT AND I CAN SAYSAYYAS SO MUCHH PROUDLY THAT THIS GAME IS MADE BY MY TWINNN ITS SOSOOSOSOSOS GOOD AND BEAUTIFULL. twin you like genuinly the best person i have ever met you are so kind caring like honestly such a goated and fantastic person and what not like ur the literal goatest goat. twin whenever u needs some help or wants to talk you can always like always you can count on me ill be ALWAYSSS there yes like always. thanks you tejaswini for everything thats you for making my 2025 sosoososososo good i cannot even imagine. hope you have the best birthday and a very very great year ahead, god bless you so much tejaswini happy birthday hope all your wishes come true in the future. UR ALWAYS SLAYYYYYYYYYYYY PERIOD HAPPY BIRTHDAYYY TEJASWINIIIIII. THANKS U SO MUCH FOR EVERYTHINGGGG BENNETT SCHOOL PICNIC TUMHARA GHAR AFTERPATY FAREWELL THANKS U FOR MAKING MY 2025 SOSOSOSO SPECIALLLL. :DDDDDDDDDDDDDDDD a very very small gift now sorry twin :( hopes u likes itttttttttt BAIEIIESISEISEIIESISESE.""";

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();

    _breatheController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat();

    _heartController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _breatheController.dispose();
    _sparkleController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A0A2E),
              Color(0xFF2D1B4E),
              Color(0xFF1A0A2E),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Beautiful floating hearts background
            ...List.generate(12, (index) {
              final hearts = ['🔥', '💖', '🔋', '✨', '🌸', "🎀"];
              return AnimatedBuilder(
                animation: _sparkleController,
                builder: (context, child) {
                  final progress = (_sparkleController.value + index * 0.08) % 1.0;
                  final xOffset = sin(progress * 2 * pi + index) * 20;
                  return Positioned(
                    left: (index * 35.0) % MediaQuery.of(context).size.width + xOffset,
                    top: progress * MediaQuery.of(context).size.height,
                    child: Opacity(
                      opacity: (0.4 * sin(progress * pi)).clamp(0.0, 0.4),
                      child: Transform.scale(
                        scale: 0.6 + sin(progress * pi) * 0.4,
                        child: Text(
                          hearts[index % hearts.length],
                          style: TextStyle(fontSize: 16 + (index % 3) * 6.0),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Soft glowing orbs in background
            ...List.generate(5, (index) {
              return AnimatedBuilder(
                animation: _breatheController,
                builder: (context, child) {
                  final scale = 1.0 + sin(_breatheController.value * 2 * pi + index) * 0.3;
                  return Positioned(
                    left: (index * 80.0) % MediaQuery.of(context).size.width,
                    top: 100.0 + (index * 150.0) % (MediaQuery.of(context).size.height - 200),
                    child: Opacity(
                      opacity: 0.15,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                index % 2 == 0 ? Color(0xFFFF69B4) : Color(0xFFE91E8C),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            SafeArea(
              child: AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeController.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _fadeController.value)),
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      // Header with back button and decorative elements
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button with cute styling
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF69B4).withOpacity(0.3),
                                    Color(0xFFE91E8C).withOpacity(0.2),
                                  ],
                                ),
                                border: Border.all(
                                  color: Color(0xFFFF69B4).withOpacity(0.5),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFF69B4).withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          // Floating decorative hearts
                          AnimatedBuilder(
                            animation: _heartController,
                            builder: (context, child) {
                              return Row(
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, sin(_heartController.value * pi) * 4),
                                    child: Text('💅', style: TextStyle(fontSize: 20)),
                                  ),
                                  SizedBox(width: 8),
                                  Transform.translate(
                                    offset: Offset(0, sin(_heartController.value * pi + 1) * 4),
                                    child: Text('✨', style: TextStyle(fontSize: 18)),
                                  ),
                                  SizedBox(width: 8),
                                  Transform.translate(
                                    offset: Offset(0, sin(_heartController.value * pi + 2) * 4),
                                    child: Text('💅', style: TextStyle(fontSize: 20)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Beautiful photo frame with rose gold border
                      AnimatedBuilder(
                        animation: Listenable.merge([_floatController, _breatheController]),
                        builder: (context, child) {
                          final floatY = sin(_floatController.value * 2 * pi) * 6;
                          final scale = 1.0 + sin(_breatheController.value * 2 * pi) * 0.03;
                          return Transform.translate(
                            offset: Offset(0, floatY),
                            child: Transform.scale(
                              scale: scale,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF69B4).withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: Color(0xFFE91E8C).withOpacity(0.3),
                                blurRadius: 60,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFB6C1),
                                  Color(0xFFFF69B4),
                                  Color(0xFFE91E8C),
                                  Color(0xFFFF69B4),
                                ],
                              ),
                            ),
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1A0A2E),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/icon/photo_frame.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          colors: [
                                            Color(0xFF2D1B4E),
                                            Color(0xFF1A0A2E),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '👯‍♀️',
                                          style: TextStyle(fontSize: 50),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Beautiful title with gradient
                      AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment(-1.0 + 3 * _shimmerController.value, 0),
                              end: Alignment(1.0 + 3 * _shimmerController.value, 0),
                              colors: [
                                Color(0xFFFFB6C1),
                                Colors.white,
                                Color(0xFFFF69B4),
                                Colors.white,
                                Color(0xFFFFB6C1),
                              ],
                              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                            ).createShader(bounds),
                            child: child,
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              'From Your Twin',
                              style: GoogleFonts.caveat(
                                fontSize: 42,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('😛', style: TextStyle(fontSize: 24)),
                                SizedBox(width: 8),
                                Text(
                                  'with all my sillyness',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('😃', style: TextStyle(fontSize: 24)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),

                      // Beautiful letter card styled like actual paper
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          final floatY = sin(_floatController.value * 2 * pi) * 3;
                          return Transform.translate(
                            offset: Offset(0, floatY),
                            child: child,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Color(0xFFFF69B4).withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFFF5F8),
                                    Color(0xFFFFE4EC),
                                    Color(0xFFFFF0F5),
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Decorative corner hearts
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Text('🌸', style: TextStyle(fontSize: 20)),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Text('🌸', style: TextStyle(fontSize: 20)),
                                  ),
                                  // Letter content
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(24, 40, 24, 30),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Dear Twin header
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFFF69B4).withOpacity(0.2),
                                                  Color(0xFFE91E8C).withOpacity(0.15),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Color(0xFFFF69B4).withOpacity(0.3),
                                              ),
                                            ),
                                            child: Text(
                                              '~ Dear Twin ~',
                                              style: GoogleFonts.caveat(
                                                fontSize: 28,
                                                color: Color(0xFFE91E8C),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        // Letter text with beautiful styling
                                        Text(
                                          letterContent,
                                          style: GoogleFonts.caveat(
                                            fontSize: 20,
                                            height: 1.6,
                                            color: Color(0xFF4A2040),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 25),
                                        // Signature
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('💖', style: TextStyle(fontSize: 16)),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Forever your twin,',
                                                      style: GoogleFonts.caveat(
                                                        fontSize: 22,
                                                        color: Color(0xFFE91E8C),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFFFF69B4),
                                                        Color(0xFFE91E8C),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0xFFFF69B4).withOpacity(0.4),
                                                        blurRadius: 10,
                                                        spreadRadius: 2,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    'Dhruv :D',
                                                    style: GoogleFonts.caveat(
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Cute gift reminder card
                      AnimatedBuilder(
                        animation: Listenable.merge([_breatheController, _floatController]),
                        builder: (context, child) {
                          final scale = 1.0 + sin(_breatheController.value * 2 * pi) * 0.02;
                          final floatY = sin(_floatController.value * 2 * pi + 1) * 4;
                          return Transform.translate(
                            offset: Offset(0, floatY),
                            child: Transform.scale(
                              scale: scale,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF69B4),
                                Color(0xFFE91E8C),
                                Color(0xFFFF69B4),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF69B4).withOpacity(0.5),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: Color(0xFFE91E8C).withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Animated gift emoji
                              AnimatedBuilder(
                                animation: _heartController,
                                builder: (context, child) {
                                  final scale = 1.0 + sin(_heartController.value * pi) * 0.1;
                                  return Transform.scale(
                                    scale: scale,
                                    child: Text('🎁', style: TextStyle(fontSize: 40)),
                                  );
                                },
                              ),
                              SizedBox(height: 12),
                              // Shimmer text
                              AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, child) {
                                  return ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      begin: Alignment(-1.0 + 3 * _shimmerController.value, 0),
                                      end: Alignment(1.0 + 3 * _shimmerController.value, 0),
                                      colors: [
                                        Colors.white,
                                        Color(0xFFFFE4EC),
                                        Colors.white,
                                      ],
                                    ).createShader(bounds),
                                    child: child,
                                  );
                                },
                                child: Text(
                                  'check your pending robux',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.caveat(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Hearts row with animation
                              AnimatedBuilder(
                                animation: _heartController,
                                builder: (context, child) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Transform.scale(
                                        scale: 1.0 + sin(_heartController.value * pi) * 0.2,
                                        child: Text('💖', style: TextStyle(fontSize: 18)),
                                      ),
                                      SizedBox(width: 10),
                                      Transform.scale(
                                        scale: 1.0 + sin(_heartController.value * pi + 0.5) * 0.2,
                                        child: Text('✨', style: TextStyle(fontSize: 16)),
                                      ),
                                      SizedBox(width: 10),
                                      Transform.scale(
                                        scale: 1.0 + sin(_heartController.value * pi + 1) * 0.2,
                                        child: Text('💖', style: TextStyle(fontSize: 18)),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// GIFT SELECTION PAGE
// ============================================

class GiftSelectionPage extends StatefulWidget {
  const GiftSelectionPage({super.key});

  @override
  State<GiftSelectionPage> createState() => _GiftSelectionPageState();
}

class _GiftSelectionPageState extends State<GiftSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _breatheController;
  late AnimationController _particleController;
  late AnimationController _fadeController;
  late AnimationController _card1Controller;
  late AnimationController _card2Controller;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();

    _breatheController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _card1Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _card2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Staggered entrance animation
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
    });
    Future.delayed(Duration(milliseconds: 600), () {
      if (mounted) _card1Controller.forward();
    });
    Future.delayed(Duration(milliseconds: 900), () {
      if (mounted) _card2Controller.forward();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _shimmerController.dispose();
    _breatheController.dispose();
    _particleController.dispose();
    _fadeController.dispose();
    _card1Controller.dispose();
    _card2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1447),
              Color(0xFF2D1B69),
              Color(0xFF1A0E3F),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles background
            ...List.generate(20, (index) {
              return AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  final progress =
                      (_shimmerController.value + index * 0.08) % 1.0;
                  return Positioned(
                    left: (index * 80.0) % MediaQuery.of(context).size.width,
                    top: progress * MediaQuery.of(context).size.height,
                    child: Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3 * (1 - progress)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent
                                .withOpacity(0.4 * (1 - progress)),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),

            // Orbiting glow particles
            ...List.generate(5, (index) {
              return AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  final progress =
                      (_particleController.value + index * 0.2) % 1.0;
                  final angle =
                      (index * 2 * pi / 5) + (_particleController.value * 2 * pi);
                  final radius = 150.0 + (sin(progress * 2 * pi) * 30);

                  return Positioned(
                    left: MediaQuery.of(context).size.width / 2 +
                        cos(angle) * radius -
                        20,
                    top: MediaQuery.of(context).size.height / 3 +
                        sin(angle) * radius * 0.5 -
                        20,
                    child: Opacity(
                      opacity: (0.15 + sin(progress * pi) * 0.15).clamp(0.0, 0.3),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color(0xFFFF69B4).withOpacity(0.6),
                              Color(0xFFBA55D3).withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildCardSelection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _fadeController.value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Column(
          children: [
            // Decorative emojis with float
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, sin(_floatController.value * 2 * pi) * 4),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('✨', style: TextStyle(fontSize: 26)),
                  SizedBox(width: 12),
                  Text('🎁', style: TextStyle(fontSize: 30)),
                  SizedBox(width: 12),
                  Text('✨', style: TextStyle(fontSize: 26)),
                ],
              ),
            ),
            SizedBox(height: 12),
            // Title with shimmer
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment(-1.0 + 3 * _shimmerController.value, 0),
                    end: Alignment(1.0 + 3 * _shimmerController.value, 0),
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Color(0xFFFFB6C1),
                      Colors.white.withOpacity(0.9),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(bounds),
                  child: child,
                );
              },
              child: Text(
                'Choose Your Gift',
                style: GoogleFonts.caveat(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                      color: Color(0xFFFF69B4).withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'pick one, just for you ✨',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white38,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSelection() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 15),
            // Cards - 90% of available space (10% smaller)
            Expanded(
              flex: 9,
              child: Row(
                children: [
                  Expanded(
                    child: _buildGiftCard(
                      controller: _card1Controller,
                      icon: '💌',
                      secondIcon: '🎁',
                      title: 'Letter + small gift',
                      subtitle: 'GOATED TEJASWINI WWWWWW\nTEJASWINI SIGMA\nTEJASWINI DA GOATTTTTT',
                      gradientColors: [Color(0xFFFF69B4), Color(0xFFFF1493)],
                      heroTag: 'gift_card_1',
                      floatDelay: 0.0,
                      onTap: () => _openCardWithAnimation(
                        heroTag: 'gift_card_1',
                        gradientColors: [Color(0xFFFF69B4), Color(0xFFFF1493)],
                        destination: BirthdayLetterPage(name: 'Twin'),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _buildGiftCard(
                      controller: _card2Controller,
                      icon: '💝',
                      secondIcon: '17',
                      title: '17 Letters',
                      subtitle: 'for 17th birthday from people who forever\nwill want you in their life',
                      gradientColors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
                      heroTag: 'gift_card_2',
                      floatDelay: 0.5,
                      onTap: () => _openCardWithAnimation(
                        heroTag: 'gift_card_2',
                        gradientColors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
                        destination: const SeventeenLettersPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom section with decorations
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decorative floating hearts
                  AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, sin(_floatController.value * 2 * pi) * 4),
                            child: Text('💫', style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(width: 20),
                          Transform.translate(
                            offset: Offset(0, sin(_floatController.value * 2 * pi + 1) * 5),
                            child: Text('💖', style: TextStyle(fontSize: 22)),
                          ),
                          SizedBox(width: 20),
                          Transform.translate(
                            offset: Offset(0, sin(_floatController.value * 2 * pi + 2) * 4),
                            child: Text('✨', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  // Hint text with animation
                  AnimatedBuilder(
                    animation: _breatheController,
                    builder: (context, child) {
                      final opacity = 0.5 + sin(_breatheController.value * 2 * pi) * 0.3;
                      return Opacity(
                        opacity: opacity.clamp(0.4, 0.85),
                        child: Transform.scale(
                          scale: 1.0 + sin(_breatheController.value * 2 * pi) * 0.02,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      '✨ tap a card to unwrap ✨',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Color(0xFFE8B4FF),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Subtle decorative line
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        width: 60,
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          gradient: LinearGradient(
                            begin: Alignment(-1 + _shimmerController.value * 2, 0),
                            end: Alignment(1 + _shimmerController.value * 2, 0),
                            colors: [
                              Colors.transparent,
                              Color(0xFFFF69B4).withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCardWithAnimation({
    required String heroTag,
    required List<Color> gradientColors,
    required Widget destination,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 800),
        reverseTransitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return _CardRevealTransition(
            animation: animation,
            gradientColors: gradientColors,
            child: destination,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  Widget _buildGiftCard({
    required AnimationController controller,
    required String icon,
    required String secondIcon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required String heroTag,
    required double floatDelay,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, _floatController, _breatheController, _shimmerController]),
      builder: (context, child) {
        // Staggered floating animation for each card
        final floatPhase = _floatController.value * 2 * pi + (floatDelay * pi);
        final floatY = sin(floatPhase) * 6;
        final floatX = cos(floatPhase * 0.7) * 2;

        // Gentle breathing/pulsing
        final breatheScale = 1.0 + (sin(_breatheController.value * 2 * pi + floatDelay * pi) * 0.012);
        final glowIntensity = 0.5 + (sin(_breatheController.value * 2 * pi) * 0.25);

        return Transform.translate(
          offset: Offset(floatX, floatY + 20 * (1 - controller.value)),
          child: Transform.scale(
            scale: (0.85 + controller.value * 0.15) * breatheScale,
            child: Opacity(
              opacity: controller.value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    // Main glow
                    BoxShadow(
                      color: gradientColors[0].withOpacity(glowIntensity),
                      blurRadius: 35,
                      spreadRadius: 3,
                    ),
                    // Secondary softer glow
                    BoxShadow(
                      color: gradientColors[1].withOpacity(glowIntensity * 0.4),
                      blurRadius: 50,
                      spreadRadius: 8,
                    ),
                    // Bottom shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      child: _GiftCardTapWrapper(
        onTap: onTap,
        gradientColors: gradientColors,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors[0].withOpacity(0.3),
                gradientColors[1].withOpacity(0.15),
                Color(0xFF0D0B1E).withOpacity(0.9),
              ],
              stops: [0.0, 0.4, 1.0],
            ),
            border: Border.all(
              width: 1.5,
              color: gradientColors[0].withOpacity(0.4),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                // Dark gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1E1645).withOpacity(0.95),
                        Color(0xFF12102A),
                      ],
                    ),
                  ),
                ),
                // Glowing orb at top
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _breatheController,
                    builder: (context, child) {
                      final scale = 1.0 + sin(_breatheController.value * 2 * pi) * 0.1;
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              gradientColors[0].withOpacity(0.35),
                              gradientColors[1].withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Bottom glow
                Positioned(
                  bottom: -30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            gradientColors[1].withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Floating sparkle particles
                ...List.generate(8, (i) {
                  return AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      final offset = (i * 0.9) + (_shimmerController.value * 2 * pi);
                      final opacity = (0.3 + sin(offset) * 0.5).clamp(0.0, 0.7);
                      final yOffset = sin(offset * 1.5) * 10;
                      return Positioned(
                        left: 10.0 + (i * 25.0) % 140,
                        top: 25.0 + (i * 45.0) % 250 + yOffset,
                        child: Opacity(
                          opacity: opacity,
                          child: Transform.scale(
                            scale: 0.7 + sin(offset) * 0.3,
                            child: Transform.rotate(
                              angle: offset * 0.5,
                              child: Icon(
                                i % 2 == 0 ? Icons.auto_awesome : Icons.star_rounded,
                                color: Colors.white.withOpacity(0.7),
                                size: 10 + (i % 4) * 3.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                // Shimmer sweep effect
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Positioned(
                      left: -80 + (_shimmerController.value * 280),
                      top: 0,
                      bottom: 0,
                      width: 50,
                      child: Transform.rotate(
                        angle: 0.25,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Main content - fixed positions for alignment
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        // Top spacer - 18% from top
                        Spacer(flex: 18),
                        // Icon container with beautiful glow
                        AnimatedBuilder(
                          animation: _breatheController,
                          builder: (context, child) {
                            final scale = 1.0 + sin(_breatheController.value * 2 * pi + floatDelay) * 0.06;
                            return Transform.scale(scale: scale, child: child);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  gradientColors[0].withOpacity(0.5),
                                  gradientColors[1].withOpacity(0.3),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors[0].withOpacity(0.6),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(-2, -2),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(icon, style: TextStyle(fontSize: 30)),
                                SizedBox(width: 10),
                                secondIcon.length <= 2
                                    ? Container(
                                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: gradientColors,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: gradientColors[0].withOpacity(0.6),
                                              blurRadius: 12,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          secondIcon,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(secondIcon, style: TextStyle(fontSize: 26)),
                              ],
                            ),
                          ),
                        ),
                        // Spacer between emoji and title - 5%
                        Spacer(flex: 5),
                        // Title with glow
                        Text(
                          title,
                          style: GoogleFonts.caveat(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 15,
                                color: gradientColors[0].withOpacity(0.9),
                              ),
                              Shadow(
                                blurRadius: 30,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Spacer between title and desc - 3%
                        Spacer(flex: 3),
                        // Subtitle with gradient effect - BIGGER
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.95),
                              gradientColors[0].withOpacity(0.85),
                              Colors.white.withOpacity(0.8),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              letterSpacing: 0.2,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: gradientColors[0].withOpacity(0.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Bottom spacer - remaining space
                        Spacer(flex: 50),
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

// Tap wrapper with scale animation
class _GiftCardTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const _GiftCardTapWrapper({
    required this.child,
    required this.onTap,
    required this.gradientColors,
  });

  @override
  State<_GiftCardTapWrapper> createState() => _GiftCardTapWrapperState();
}

class _GiftCardTapWrapperState extends State<_GiftCardTapWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _tapController.forward(),
      onTapUp: (_) {
        _tapController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: _tapController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors[0].withOpacity(0.7 * _glowAnimation.value),
                    blurRadius: 40 * _glowAnimation.value,
                    spreadRadius: 8 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2 * _glowAnimation.value),
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

// Beautiful card reveal transition
class _CardRevealTransition extends StatelessWidget {
  final Animation<double> animation;
  final List<Color> gradientColors;
  final Widget child;

  const _CardRevealTransition({
    required this.animation,
    required this.gradientColors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // Phase 1: 0.0 - 0.4 = Card expands with glow
        // Phase 2: 0.4 - 0.7 = Flash/sparkle effect
        // Phase 3: 0.7 - 1.0 = Reveal content

        final expandProgress = (animation.value / 0.5).clamp(0.0, 1.0);
        final flashProgress = ((animation.value - 0.3) / 0.3).clamp(0.0, 1.0);
        final contentProgress = ((animation.value - 0.6) / 0.4).clamp(0.0, 1.0);

        return Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A0E27),
                    Color(0xFF1A1447),
                    Color(0xFF2D1B69),
                  ],
                ),
              ),
            ),

            // Expanding glow circle
            if (expandProgress > 0 && expandProgress < 1)
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 * expandProgress,
                  height: MediaQuery.of(context).size.height * 2 * expandProgress,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        gradientColors[0].withOpacity(0.4 * (1 - expandProgress)),
                        gradientColors[1].withOpacity(0.2 * (1 - expandProgress)),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Flash effect
            if (flashProgress > 0 && flashProgress < 1)
              Container(
                color: Colors.white.withOpacity(0.3 * (1 - flashProgress) * flashProgress * 4),
              ),

            // Sparkle particles during transition
            if (animation.value > 0.2 && animation.value < 0.8)
              ...List.generate(12, (i) {
                final angle = (i / 12) * 2 * pi;
                final radius = 100 + (animation.value * 200);
                final opacity = (1 - ((animation.value - 0.5).abs() * 2)).clamp(0.0, 0.8);
                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 + cos(angle) * radius - 10,
                  top: MediaQuery.of(context).size.height / 2 + sin(angle) * radius - 10,
                  child: Opacity(
                    opacity: opacity,
                    child: Icon(
                      Icons.auto_awesome,
                      color: gradientColors[0],
                      size: 20,
                    ),
                  ),
                );
              }),

            // Content fades in
            Opacity(
              opacity: contentProgress,
              child: Transform.scale(
                scale: 0.95 + (contentProgress * 0.05),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

