import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TherapyPage extends StatefulWidget {
  final List<TherapyMessage>? preloadedMessages;

  const TherapyPage({super.key, this.preloadedMessages});

  @override
  State<TherapyPage> createState() => _TherapyPageState();
}

class _TherapyPageState extends State<TherapyPage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _breatheController;
  late AnimationController _particleController;

  TherapyMessage? _selectedMessage;
  bool _isLoading = true;
  String? _errorMessage;

  final String csvUrl =
      'https://docs.google.com/spreadsheets/d/e/2PACX-1vT1zHq4OgxenHRzuBjBH-dfU0bHES2tG4GbFVlMqtjduni4Hic3UMKGG37Vtyy59vBkY6mGWPwrn4qW/pub?output=csv';

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Use preloaded messages if available
    if (widget.preloadedMessages != null &&
        widget.preloadedMessages!.isNotEmpty) {
      print('✅ Using preloaded therapy messages');
      final random = Random();
      setState(() {
        _selectedMessage = widget.preloadedMessages![
            random.nextInt(widget.preloadedMessages!.length)];
        _isLoading = false;
      });
    } else {
      print('⚠️ No preloaded messages, fetching from CSV...');
      _fetchQuotes();
    }
  }

  Future<void> _fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse(csvUrl));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<TherapyMessage> messages = _parseCSV(decodedBody);

        if (messages.isNotEmpty) {
          final random = Random();
          setState(() {
            _selectedMessage = messages[random.nextInt(messages.length)];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No quotes found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load quotes';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Check internet connection';
        _isLoading = false;
      });
    }
  }

  List<TherapyMessage> _parseCSV(String csv) {
    List<TherapyMessage> messages = [];

    try {
      final lines = csv.split('\n');

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

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
        if (currentField.isNotEmpty) {
          parts.add(currentField.trim());
        }

        if (parts.length >= 5) {
          String text = parts[0].replaceAll('"', '').trim();
          String emoji = parts[1].replaceAll('"', '').trim();

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
    _floatController.dispose();
    _shimmerController.dispose();
    _breatheController.dispose();
    _particleController.dispose();
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
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Stack(
      children: [
        ...List.generate(20, (index) {
          return AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final progress = (_shimmerController.value + index * 0.08) % 1.0;
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.purpleAccent,
                strokeWidth: 3,
              ),
              SizedBox(height: 24),
              Text(
                'loading twin therapy...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Stack(
      children: [
        ...List.generate(20, (index) {
          return AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final progress = (_shimmerController.value + index * 0.08) % 1.0;
              return Positioned(
                left: (index * 80.0) % MediaQuery.of(context).size.width,
                top: progress * MediaQuery.of(context).size.height,
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3 * (1 - progress)),
                  ),
                ),
              );
            },
          );
        }),
        SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('😔', style: TextStyle(fontSize: 64)),
                      SizedBox(height: 24),
                      Text(
                        _errorMessage ?? 'Something went wrong',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          _fetchQuotes();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          'try again',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_selectedMessage == null) return SizedBox();

    return Stack(
      children: [
        ...List.generate(20, (index) {
          return AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final progress = (_shimmerController.value + index * 0.08) % 1.0;
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
        ...List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              final progress = (_particleController.value + index * 0.2) % 1.0;
              final angle =
                  (index * 2 * pi / 5) + (_particleController.value * 2 * pi);
              final radius = 150.0 + (sin(progress * 2 * pi) * 30);

              return Positioned(
                left: MediaQuery.of(context).size.width / 2 +
                    cos(angle) * radius -
                    20,
                top: MediaQuery.of(context).size.height / 2 +
                    sin(angle) * radius -
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
                          _selectedMessage!.gradient[0].withOpacity(0.6),
                          _selectedMessage!.gradient[1].withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _selectedMessage!.gradient[0].withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
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
              _buildHeader(context),
              Expanded(
                child: _buildMessagePage(_selectedMessage!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value.clamp(0.0, 1.0),
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _selectedMessage?.gradient[0].withOpacity(0.3) ??
                          Colors.purpleAccent.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, double value, child) {
                final clampedValue = value.clamp(0.0, 1.0);
                return Opacity(
                  opacity: clampedValue,
                  child: Transform.translate(
                    offset: Offset(40 * (1 - clampedValue), 0),
                    child: child,
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment(-1.0 + 3 * _shimmerController.value, 0),
                      end: Alignment(1.0 + 3 * _shimmerController.value, 0),
                      colors: [
                        Colors.white.withOpacity(0.8),
                        _selectedMessage?.gradient[0] ?? Colors.purpleAccent,
                        Colors.white.withOpacity(0.8),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ).createShader(bounds),
                    child: child,
                  );
                },
                child: Text(
                  'twin therapy',
                  style: GoogleFonts.caveat(
                    fontSize: 46,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 25,
                        color: (_selectedMessage?.gradient[0] ??
                                Colors.purpleAccent)
                            .withOpacity(0.6),
                      ),
                      Shadow(
                        blurRadius: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagePage(TherapyMessage message) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: (0.85 + (value * 0.15)).clamp(0.85, 1.0),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 140,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_floatController, _breatheController]),
                  builder: (context, child) {
                    final floatOffset =
                        8 * sin(_floatController.value * 2 * pi);
                    final breatheScale =
                        1.0 + (sin(_breatheController.value * 2 * pi) * 0.08);

                    return Transform.translate(
                      offset: Offset(0, floatOffset),
                      child: Transform.scale(
                        scale: breatheScale,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          message.gradient[0].withOpacity(0.35),
                          message.gradient[1].withOpacity(0.15),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: message.gradient[0].withOpacity(0.5),
                            blurRadius: 50,
                            spreadRadius: 15,
                          ),
                          BoxShadow(
                            color: message.gradient[1].withOpacity(0.3),
                            blurRadius: 80,
                            spreadRadius: 25,
                          ),
                        ],
                      ),
                      child: Text(
                        message.emoji,
                        style: TextStyle(
                          fontSize: 85,
                          shadows: [
                            Shadow(
                              color: message.gradient[0].withOpacity(0.8),
                              blurRadius: 35,
                            ),
                            Shadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          begin: Alignment(
                              -1.0 + 2 * _shimmerController.value, -1.0),
                          end: Alignment(
                              1.0 + 2 * _shimmerController.value, 1.0),
                          colors: [
                            message.gradient[0].withOpacity(0.15),
                            Colors.white.withOpacity(0.08),
                            message.gradient[1].withOpacity(0.15),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: message.gradient[0].withOpacity(0.2),
                            blurRadius: 35,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 25,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(1.5),
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1A1447).withOpacity(0.95),
                              Color(0xFF0A0E27).withOpacity(0.95),
                            ],
                          ),
                        ),
                        child: _AnimatedText(
                          text: message.text,
                          gradient: message.gradient,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TherapyMessage {
  final String text;
  final String emoji;
  final List<Color> gradient;
  final Color accentColor;

  TherapyMessage({
    required this.text,
    required this.emoji,
    required this.gradient,
    required this.accentColor,
  });
}

class _AnimatedText extends StatefulWidget {
  final String text;
  final List<Color> gradient;

  const _AnimatedText({
    required this.text,
    required this.gradient,
  });

  @override
  State<_AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.text.length * 12 + 600),
    );

    _characterCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterCount,
      builder: (context, child) {
        String displayText = widget.text.substring(0, _characterCount.value);

        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              widget.gradient[0].withOpacity(0.9),
              Colors.white,
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            displayText,
            style: GoogleFonts.poppins(
              fontSize: 16.5,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              height: 1.9,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: widget.gradient[0].withOpacity(0.4),
                  blurRadius: 20,
                ),
                Shadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
