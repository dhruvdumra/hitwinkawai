import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _openController;
  late AnimationController _letterSlideController;
  late AnimationController _breatheController;
  late AnimationController _floatController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _openAnimation;
  late Animation<double> _letterSlideAnimation;

  bool _showLetter = false;
  bool _envelopeOpened = false;

  final String letterText = """Dear Tejaswini,

What am I writing in this letter? Is it a goodbye letter? Is it a be happy forever letter? Is it a I still like you very much letter? I don't know twin whenever I think about about this I think I have a lot of final things to say but whenever I try to write this final letter I feel like jo kehna tha wo kehdiya and jo hona tha wo ho gaya I feel like kuch bhi nahi h mere bolne ke paas ab. In the end it's me seeking closure that I cannot give to myself and it's me always trying to find peace and comfort in the closure but in the end I cannot really find my closure.

Never tbh thought ki I will have to write this letter itna jaldi ye to pata tha ki kabhi na kabhi likhna padega I was thinking around after jee or board exams but mere andar ki curiousity jaag jati h baat baat pe lmao. Ab age kya, I want you to have a very happy relationship. I want you to forget me forever so nostalgia and memories don't come haunting back :>>>>. Tejaswini I still haven't decided what I want to do now and I don't think I'll ever be able too. There was a question that I asked myself a lot, "when does feelings dissipate" I realised they never do. Feelings never ever dissipate.

I know you were planning to come to school on Thursdays for attendance so don't u skip school cuz of me okay it will not make anything awkward, people like me come and go. Really really sorry for causing fights between you and swastik I know I will never be able to really forgive myself for it but do I regret ever confessing to you or having these feelings ever in the first place? No I do not regret them at all and actually very proud of it and for me it was the best thing that probably happened to me.

I know I have told this before but I really mean it that the last 4 months hold a really really big value for me :DD. I wanted to write this letter ill probably write this in an envelope or yk add it in the app. I tried a lot drawing ur Roblox avatar in an a4 page but it looked so goofy holy shit I never was much of a drawer. I was developing the app from the past 2 weeks and I realised that we don't have really any photos and videos that I can really put also in the memories page of the app 💔💔.

Anyways thankyou twin for always being there for me and always listening to me :DDDD I have been a bitch a lot of times and I know I hurted you a lot because of it but thankyou for still not giving up on me kind of I was expecting to be blocked forever when the "hello cutie" thing happened icl. Always remember ur da goat twin ur da goat never doubt urself for any second trust me. Now that I see this the app looks so weird ass shit I should have thought it more better sorry twin. :((( 😭😭

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

All the above things I wrote was written on 30th October, one day before you told me there isn't a problem and we can stay as friends. Now what I will write is written on 15th November the next day after the picnic. A lot happened in these 2 weeks A LOT AND I AM SOSOSOSOSOOSOS GLAD IT HAPPENED IT WAS SUCH A GOAT TIME OMG.

Twin tbh I think if you and ritu and Ridhima would have stayed with ajinkya and tanav yall would have a LOT LOT more fun than being with us (I think I kinda stole ur day oof) but me I had sosoososososososo much fun with yall it wouldn't have been possible with anyone else kavya vibhu any group it wouldn't have been possible. THANKYOUU SOOSOSOSO MUCH FOR making this picnic sososososo special for me it was da best day of 12th da best day not even wartex was this fun. The app is almost ready oof. I took more than a month but still it turned out to be so weird oof 😭😭😭😭.

I wrote jo bhi mene 30 october ko likha tha in the context of I was going to get blocked the day after (31st october) but I think I am still in the same situation. Twin I know you do not want to lose this friendship that's why you are trying so hard on managing on both the ends for this long and I am sososososo glad and sooooooo thankful for you I wouldn't have made so much memories and had so much fun and like it was so awesome omg.

I know things are kind of falling apart everywhere and yes twin take ur time I know it will require being distant or cutting off now and I know you will tells me before doing anything and I am sosososos happy that u never gave up on me ur da goat twin. I still mean the above things on the 1st half of the letter.

Goodbyes twin I probably would have missed something but always remember I do not overthink I think my overthinking made you not share these problems with me but that just me overthink kinda more that I am a liability for you oof. But I don't feel that way anymore okay twin u will and I am sure of it no matter what it is you will for sure pull through this. I don't know what is happening right now or what you are planning but I know whatever you would have planned now will be for the best.

You know picnic tak and jabtak metro tak I think we were so happy but uske baad I did sense something was off and then you told me your unhelpable and nothing is good, THAT SCARED THE SHIT OUTTA ME TWIN NEVER SAY THINGS LIKE THIS OKAY EVERYTHING WILL TRUST ME TURN OUT TO BE FINE IT SEEMS KIND OF FAR FETCHED TO SAY BUT IT WILL TRUST ME OKAY. Now you didn't explain what exactly happened and I am not going to ask but I am glad that you told me still.

Now I'll wait for you to tell me what you have planned whatever you will have planned I know it will be the best whether its staying like this, being distant or cutting off. I'll wait okay and always always always remember no matter if we are talking or no matter whatever happens you will always always remain my twin.

And do not ever ever ever ever hesitate to rant or ask for help or anything okay jabtak help nahi mangonge tabtak daldal me fase rahoge I'll always remember this. And even if u message me straight after months or years I would still greet you and talk to you exactly like we are talking right now without 1 ounce of awkwardness or anything.

From playing Roblox 3 bje tak to bullying kids in free huga to ragebaiting giga and dish to giving advice to daksh to doing bakchodi in school to getting om and ritu in the relationship to sending random messages to having sosososos much fun thankyou tejaswini I'll never ever forget any of this :D

And yes again the same question does feelings ever dissipate? They never do :>

Your twin ✨""";

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _openController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _letterSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    ));

    _openAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _openController,
      curve: Curves.easeInOutQuad,
    ));

    _letterSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _letterSlideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation sequence
    Future.delayed(Duration(milliseconds: 600), () {
      _rotationController.forward().then((_) {
        Future.delayed(Duration(milliseconds: 400), () {
          _openController.forward().then((_) {
            Future.delayed(Duration(milliseconds: 300), () {
              setState(() => _envelopeOpened = true);
              _letterSlideController.forward().then((_) {
                Future.delayed(Duration(milliseconds: 500), () {
                  setState(() => _showLetter = true);
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _openController.dispose();
    _letterSlideController.dispose();
    _breatheController.dispose();
    _floatController.dispose();
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
            // Background particles
            ...List.generate(15, (index) {
              return AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final progress = (_floatController.value + index * 0.1) % 1.0;
                  return Positioned(
                    left: (index * 90.0) % MediaQuery.of(context).size.width,
                    top: progress * MediaQuery.of(context).size.height,
                    child: Opacity(
                      opacity: 0.3 * (1 - progress),
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purpleAccent.withOpacity(0.4),
                              blurRadius: 6,
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
                    child: _showLetter
                        ? _buildLetterContent()
                        : _buildEnvelopeAnimation(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                      color: Colors.purpleAccent.withOpacity(0.3),
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
          const SizedBox(width: 20),
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
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.purpleAccent.withOpacity(0.8),
                    Colors.white,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ).createShader(bounds),
                child: Text(
                  'letter',
                  style: GoogleFonts.caveat(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 25,
                        color: Colors.purpleAccent.withOpacity(0.6),
                      ),
                      Shadow(
                        blurRadius: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvelopeAnimation() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _openController,
          _letterSlideController,
          _breatheController,
        ]),
        builder: (context, child) {
          final breatheScale =
              1.0 + (sin(_breatheController.value * 2 * pi) * 0.02);

          return Transform.scale(
            scale: breatheScale,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_rotationAnimation.value),
              child: _rotationAnimation.value < pi / 2
                  ? _buildEnvelopeBack()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: _buildEnvelopeFront(),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnvelopeBack() {
    return Container(
      width: 320,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5E6D3),
            Color(0xFFE8D4C0),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Tejaswini',
          style: GoogleFonts.caveat(
            fontSize: 48,
            color: Color(0xFF6E48AA),
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvelopeFront() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Envelope body
        Container(
          width: 320,
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF5E6D3),
                Color(0xFFE8D4C0),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        // Envelope flap
        AnimatedBuilder(
          animation: _openAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_openAnimation.value * pi * 0.35),
              child: Container(
                width: 320,
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFD4C4B0),
                      Color(0xFFE8D4C0),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: CustomPaint(
                  painter: EnvelopeFlapPainter(),
                ),
              ),
            );
          },
        ),
        // Letter peeking out
        if (_envelopeOpened)
          AnimatedBuilder(
            animation: _letterSlideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -80 * _letterSlideAnimation.value),
                child: Container(
                  width: 280,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFAF0),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.purpleAccent.withOpacity(0.3),
                      size: 60,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildLetterContent() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.9 + (value * 0.1),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: AnimatedBuilder(
          animation: _breatheController,
          builder: (context, child) {
            final breatheScale =
                1.0 + (sin(_breatheController.value * 2 * pi) * 0.008);
            return Transform.scale(
              scale: breatheScale,
              child: child,
            );
          },
          child: Container(
            padding: EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: Color(0xFFFFFDFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFE8DDD0).withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Decorative top corner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _AnimatedDoodle(
                      icon: '✨',
                      delay: 0,
                      controller: _floatController,
                    ),
                    _AnimatedDoodle(
                      icon: '🔋',
                      delay: 0.3,
                      controller: _floatController,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Letter text
                _AnimatedLetterText(text: letterText),
                SizedBox(height: 20),
                // Decorative bottom corner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _AnimatedDoodle(
                      icon: '🌙',
                      delay: 0.6,
                      controller: _floatController,
                    ),
                    _AnimatedDoodle(
                      icon: '🔥',
                      delay: 0.9,
                      controller: _floatController,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EnvelopeFlapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFD4C4B0)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AnimatedDoodle extends StatelessWidget {
  final String icon;
  final double delay;
  final AnimationController controller;

  const _AnimatedDoodle({
    required this.icon,
    required this.delay,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offset = 3 * sin((controller.value + delay) * 2 * pi);
        return Transform.translate(
          offset: Offset(0, offset),
          child: Text(
            icon,
            style: TextStyle(
              fontSize: 24,
              shadows: [
                Shadow(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedLetterText extends StatefulWidget {
  final String text;

  const _AnimatedLetterText({required this.text});

  @override
  State<_AnimatedLetterText> createState() => _AnimatedLetterTextState();
}

class _AnimatedLetterTextState extends State<_AnimatedLetterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.text.length * 10 + 800),
    );

    _characterCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: 300), () {
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

        return Text(
          displayText,
          style: GoogleFonts.poppins(
            fontSize: 15.5,
            color: Color(0xFF2A2A2A),
            fontWeight: FontWeight.w400,
            height: 2.0,
            letterSpacing: 0.3,
          ),
        );
      },
    );
  }
}
