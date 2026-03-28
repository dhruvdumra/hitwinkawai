import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================
// DATA MODEL FOR EACH LETTER
// ============================================

class PersonLetter {
  final String name; // "From: [Name]"
  final String photoPath; // Asset path or network URL for photo
  final String letterContent; // The letter text
  final List<Color> themeColors; // 2 colors for gradient theme
  final String emoji; // Decorative emoji

  const PersonLetter({
    required this.name,
    required this.photoPath,
    required this.letterContent,
    required this.themeColors,
    this.emoji = '💖',
  });
}

// ============================================
// LETTER DATA - FILL IN LATER
// ============================================

// TODO: Replace placeholder data with actual names, photos, and letters
final List<PersonLetter> allLetters = [
  PersonLetter(
    name: "Diya didi",
    photoPath: "assets/letters/person1.jpg",
    letterContent: '''
Maru Hijda,

Sometimes when i look at you, i see a glimpse of all you and all the versions you used to be. As soon as I do, a smile comes to my face, seeing who you are becoming.

You've always been the most precious gift in my life. I don't think anything can matchup to that. I cannot be grateful enough for having you in my life, to have a sibling you could open up your heart to and share the silliest of jokes is rather rare.

I know we don't get to spend as much time as we used to now that I'm in college, please know that it will never change the bond we have. We have a lifetime for good memories and so much love. I never call any friend my sister because I don't think anyone can be you, and tbh i like it that way. You mean the world to me and I'm sorry for moments where I get too angry, itna toh chalo jhel hi skti ho abh🤣😘

You are a chakka hijda queen purrrr slayyyy

Love,
Diya didi
    ''',
    themeColors: [Color(0xFFFF69B4), Color(0xFFFF1493)],
    emoji: '💖',
  ),
  PersonLetter(
    name: "Ma",
    photoPath: "assets/letters/person2.jpg",
    letterContent: '''
My Dearest Baby,

Time really flies. Thank you for giving me 17 beautiful years of my life.
I may not be able to give you my whole life, but I'll always give you thoda-thoda hissa of it — because that's what life is.

I'm going to live for many, many years, so I won't write too much now.
Just know this: 86 years main rahungi, 60 saal saath buddhe honge, aur life ke liye bahut saari planning abhi baaki hai.

Always yours,
Ma
    ''',
    themeColors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
    emoji: '💜',
  ),
  PersonLetter(
    name: "Pitaji",
    photoPath: "assets/letters/person3.jpg",
    letterContent: '''
Dear Maru,

Happy 17th birthday to my second daughter, who has always been just as special in her own way. I know I don't always get enough time to say everything I feel, so I'll say this today—having you as my daughter is one of my biggest blessings.

You've always been my little fashion queen, walking around with confidence, style, and attitude that makes me smile (and sometimes shake my head). And yes, all that pitai in mazak—that was just my way of showing love, you know that.

Watching you grow into the person you are today fills my heart with pride. Stay kind, stay strong, stay stylish, and never forget how loved you are.

Always here for you, no matter what.

With all my love,
Pitaji
    ''',
    themeColors: [Color(0xFFFFB347), Color(0xFFFFCC33)],
    emoji: '🌟',
  ),
  PersonLetter(
    name: "Swastik",
    photoPath: "assets/letters/person4.jpg",
    letterContent: '''
happy 15th birthday!!
hahaha you're 15, aww dekho kitna Chhota baccha ho aaap, you're literally 15!!!!
jokes apart
happy birthday babe
i miss i can't make my 15 jokes but yeah 17 jokes ain't gonna stop!!!!
Hahahahha lots of love.
but dude, YOURE LITERALLY 17?!?!?!?!
Hahahahha chhota bacchaa hahahahahahha
17 ke hooo hahahahahaha
i love you tejaswini
Winks
Winks harder
Happy Birthday my girl.
I love you.
🧿
    ''',
    themeColors: [Color(0xFF00CED1), Color(0xFF20B2AA)],
    emoji: '💙',
  ),
  PersonLetter(
    name: "Ridhima",
    photoPath: "assets/letters/person5.jpg",
    letterContent: '''
A very very very Happy 17th Birthday my dearest Tejaswini. I love you so much. We became friends late but I'm really glad we did. That 10th class bus trip that started it all for me, I can never forget it. You were the highlight of that day. Throughout that day we laughed so much, you made me laugh so much and I love you for that. Then I remember there was one day in 10th when we sat together for the first time for whole day otherwise it was always in groups or with someone else. I did not know at that time how that day would pass by since we weren't that close but I remember that at the end I felt like no part of it was boring and I had fun. I also discovered that you are actually so good at drawing. All those stupid stories we wrote and drawings we made, they will always be a core memory of my school life because during each one of them we laughed so much. 9th and 10th were fun because it had you. You were the first person after lock down with whom I felt comfortable enough to rant or vent. At that time it was only you and vidhu to whom I used to actually vent. There were these days when we used to rant to each other almost every night and it was like a night time routine of deep talks and real conversations. I loved having something like that with you. There is this thing about you that makes people comfortable around you. You are so kind and so pretty inside out. You truly deserve the world. I am so sorry for all the times I acted shitty or was shitty to you. Last year was not good and you had to go through a lot. Bachpan se you've seen things and suffered from things but you've always stood strong and never lost hope. You are very strong wini. Always remember that. You have come a long way. From masked face to posting daily stories on priv and main, from one main close friend to having numerous close ones, from being quiet and not so talkative to literally talking your heart out when you feel like it, from being shy and distant to actually open and more social with people. I am so so so proud of you Maru. You really gained the right people by your side who make you happy and I am really glad to see that. I am happy to see that :D. That letter you gave me after 10th ended, I will take it to my grave. It means so much to me. Thankyou so much for that. I really loved growing older with you and I am so grateful that you're still here. Thank you. Thankyou so so much Tejaswana for everything. You will never not be my best friend. "So if you're lonely darling you're glowing, if you're lonely come be lonely with me" :) and I mean it. I am always here and I always will be. Whenever it feels hard you can always turn back to the old ones. I hope this year is truly the happiest for you and you get all the things you want. I wish you the very best for the future. I love you to eternity my dearest best friend tejaswana. Thankyou for being you and most of all thankyou for sticking. Happiest 17th Birthday my love.
    ''',
    themeColors: [Color(0xFFFF6B6B), Color(0xFFEE5A5A)],
    emoji: '❤️',
  ),
  PersonLetter(
    name: "Ritu",
    photoPath: "assets/letters/person6.jpg",
    letterContent: '''
HAPPPPY BIRTHDAYYY WINIWINI

i honestly cannot tell u how much u mean to me, how much love i have in my heart for u. no one understands me better than u, like actually no one. i love u so so so much and sometimes i genuinely dont even have words for it.

years back i used to hope that somehow we'd become good friends. but we were never in the same class then, but i always wished we'd end up together someday. and somehow destiny did that. i got the best person to end my school life with. u were the greatest part of my school life and u always will be.

Thannnk youuuuuuuuu so muchh Teja, for making my life easier and for bringing so much excitement and fun into school. I honestly cannot imagine these years without sitting beside you. You've been my super safe place.. the person I wanted to hug the moment I entered the class. Even seeing you from a distance felt like home.

You deserve every bit of love and happiness. the most beautiful and loving person. and I always feel like running to you. you make me fall in love with you again and again. and i always want to be there for you.

Somehow, the toughest years of school turned into some of the most beautiful and fun ones only and only because of you. I'll miss seeing you every day.. I m so so grateful for you, and I'll cherish each and every memory with you forever.

Happiest 17th to my dearesttt person. i loveee u sooooo muchhh.
HAPPPPIEST BIRTHDAYY MY TEJAA.
    ''',
    themeColors: [Color(0xFF7B68EE), Color(0xFF6A5ACD)],
    emoji: '💜',
  ),
  PersonLetter(
    name: "Khushi",
    photoPath: "assets/letters/person7.jpg",
    letterContent: '''
WINIIIII MY LOVEEEEEE
HAPPPPIESSTTTT BIRTHDAY TO YOUUUU DEAR

Issi saal hamari friendship thodi achi hui hai vrna idts 11th me ham itne ache dost the. You're Always the sweetest and best person I have ever met. Mene tumhe phle bhi promise kia tha aur ab firse krri hu kabhi bhi kisi third person ki vjh se hamare beech kuch bhi khrab nahi hoga. Ham jese hain vese rhenge (lesbians) and maybe more ache. Tum thoda sa gussa hui thi main ek ghante tk roi thi

I love you more than you can imagine. I'll always wish the best for you. Tumhara voice notes, messages sb kuch are soo good ki kisi rote hue insaan ko hasa de

Aur bhi bht cheeze hain jo main tumhe dm krdungi vrna ganda bacha dhrub pdh lega

HAPPIESTT BIRTHDAY ONCE AGAIN
AND I LOVEE YOUU SOO MUCH WINI
    ''',
    themeColors: [Color(0xFFFF85C0), Color(0xFFFF69B4)],
    emoji: '🌸',
  ),
  PersonLetter(
    name: "Om",
    photoPath: "assets/letters/person8.jpg",
    letterContent: '''
Dear Tejasmini,

I hope this letter finds you in good health and high spirits. I am writing to you to formally convey my greetings n best wishes on the special occasion of your birthday - "Happy Birthday"

thank santa he bought you back from the gift factory just in time anyways

I probably didn't make it seem important but this friendship is of very importance, as you were one of the very few people I'd really call my friend or rather my good friend. Even tho I like irritating you and rage bating you is my personal favourite thing to do, I would also like to apologise if it hurt you.

At last I wanna say I GREATLY appreciate you and our friendship

HAPPY BIRTHDAYYYYYYY!!!!!!!!!!!!!!!!!!!!!!!

I really wanted to say many more things but at the time of writing this letter I forgot more than half the things I wanted to say because I am him (obviously).

and yea mb I cant figure out a good gift for you :/
tho enjoy your dayyyyyy
    ''',
    themeColors: [Color(0xFF87CEEB), Color(0xFF4169E1)],
    emoji: '💎',
  ),
  PersonLetter(
    name: "Vibhu",
    photoPath: "assets/letters/person9.jpg",
    letterContent: '''
Dear classmate,

happiest birthday classmate, you are a very good classmate. A classmate who is turning 18 omg so cool imagine being an adult omg WILL THAT MEAN YOU WONT BE ABLE TO HARASS RIDHIMA AND RITU BECAUSE THEYRE UNDERAGE????????????? anyways uhhhh thank you for being my classmate and friend, idk which is cooler, classmate maybe. tbh i never thought id be friends with you and your gang 11th mein because like i thought you guys were rude and 2cool4u type shit BUT NO YOU WERE SO FRIENDLY AFTER ALL AND I WAS LIKE WOW PEOPLE CAN ACTUALLY BE NICE WOWWOOWOW. also ur 18 UNC WINI imagine being an adult ew chee ganda ok boomer unc unc tejaswini more like tejasaunti eewwwwwww imagine having to pay taxes and find a job and work hard.. couldn't be me in another 10 months ANYWAYS THANK YOU AND HAPPY BIRTHDAY

GAY MISHRA
your classmate
    ''',
    themeColors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
    emoji: '🎓',
  ),
  PersonLetter(
    name: "Parineeti",
    photoPath: "assets/letters/person10.jpg",
    letterContent: '''
you're 17 Tjswini! I am so glad we got to know eachother in allen. Even though choosing PCB is torturing me rn but i dont regret it one bit because i got to meet you :333 . I wish hum roz mil paate phirse whenever its rainy outside i miss us i miss you alot I hope this year brings you hope n comfort kyuki you deserve it you deserve the world n iloveyousum there is so much i wanna say to you n i wanna meet you asap you saved me tiswiniHappy birthday! I hope this year brings you joy and laughter: I hope your day goes as perfect as you are I'm wishing you the best for the following year: you are one of my greatest friends and I couldn't imagine life without you. you are such a bright light in this world, you have the most sweetest heart and purest soul. I remember When I first became friends with you Allen and were been close ever since.

Thank you for everything yove done for me and all the times (somya ke tym the people pleaser lore) you've Made me laugh, cheered me up, gave me out standing advice, and supported all my stupid ideas. love you for that.

Sometimes I feel like a lot of people dant realize how Special they are to me. I hore we continue this friendship through out life, you are the best. There is so much I can say and express that I dont even know what to write downSo I'm going to Sign Off by simply Saying. ilysm you are perfect-P
    ''',
    themeColors: [Color(0xFFDDA0DD), Color(0xFFBA55D3)],
    emoji: '🦋',
  ),
  PersonLetter(
    name: "Taani",
    photoPath: "assets/letters/person11.jpg",
    letterContent: '''
yayyy tejaswini is finally 17!!! Happy birthday to the BESTEST people i have met yet. tbh when i first saw you, i wondered "who's that cutie" frrrrr. And i still remember when we first communicated, u were so kind and generous. i swear it did not at all feel like we met for the first time.  you instantly became a family in my heart, someone who i have known for years even tho i didnt. idk its just in u tejaswini, the warmth & comfort you bring to people. I hope you always remain like this<3. I wish the BEST for you and you can rely on me no matter what. Loveyouuuu cutiee🩷
    ''',
    themeColors: [Color(0xFFFFA07A), Color(0xFFFF7F50)],
    emoji: '🧡',
  ),
  PersonLetter(
    name: "Yashika",
    photoPath: "assets/letters/person12.jpg",
    letterContent: '''
Happiest Birthday to the most beautiful soul I've ever met. I don't know where to start from, you're really really special to me. I'm so very grateful to have you in my life. The best thing that has happened to me in amity is you. Even in my life, you're the best person i could have ever asked for. Thankyouuu for always being there and understanding me. I couldn't be more thankful to have such a selfless and gorgeous friend like you. You deserve every happiness and joy. Never ever forget that you're very special to each of us. Thankyouuu for brightening my dull lifee. I hope we always stay connected cuz ily so so muchhhhhhh. Thanks for adding the best memories in my life, every memory with you is so precious to me. I feel soo amazing in your company and to have you by my side. I will always love you, i may not express it a lot, but i do and I'll always be by your side<333
 May your year be filled with lots of happiness.

HAPPYY BDAAYY ONCE AGAINN!!!
LOVEEEEYOUUUU WINNIE<3
    ''',
    themeColors: [Color(0xFF98FB98), Color(0xFF3CB371)],
    emoji: '💚',
  ),
  PersonLetter(
    name: "Karan",
    photoPath: "assets/letters/person13.jpg",
    letterContent: '''
Happy Birthday Wini ,
Such a special day for you , bdays always meant so much to you , the edits you made for me and all the things that you planned on mine , i really wish i could so the same for you , not because i want to reciprocate but actually show how much that day meant to me , you listened to my rants all day we played roblosss together and the moments just dont stop pouring but this is not a day to remind it all , but to appreciate the new upholdings you have in life now , i really wish you continue your story writing and i will for sure play your games in future , i will see the videos you will post on YT too and send you robuzz , you really are a "gem" type of person hoarding everyones problem as you are the one to solve it all and trying your best at it , no one in this generation actually puts up with that but you do and that is really special , never change that about you , keep smiling , keep making those jokes , keep posting and slaying like a tatti queen , dont forget the roleplays , keep appraising others poems too as you did with mine . It will be one heck of a day for you today and it will surely be so fun.

Takes caress
Tatti Boy , Karen
Signing out 😎👌😏🥀🥀🐯🦁🐮💩
    ''',
    themeColors: [Color(0xFFFFDAB9), Color(0xFFFFB6C1)],
    emoji: '🌷',
  ),
  PersonLetter(
    name: "Aaliyah",
    photoPath: "assets/letters/person14.jpg",
    letterContent: '''
happiest birthday to my dearest darling winie💗💗🌻

I still remember how we used to address you as 'cutie' bec we didn't know your name and then our 1 week amity trip me how we became so good friends eating bhel raat me 🌯with soumya and leisha and then doing moj masti during classes, bunking afternoon wali class and yoga, getting late for breakfast bec we overslept and all these happy moments w you💗💗.

I hope this year will bring you insane sigma happiness combo pack and a perfect year w jerry and berry 💗💗

Love,
Aaliyah
    ''',
    themeColors: [Color(0xFFE6E6FA), Color(0xFFD8BFD8)],
    emoji: '✨',
  ),
  PersonLetter(
    name: "Shreyansh",
    photoPath: "assets/letters/person15.jpg",
    letterContent: '''
very very Happiii Birthday winiiii!!!

It feels one of the best felling in world to have someone as kind, and genuinely wonderful as you in my life, and I wanted to take this opportunity to express how much I sincerely value and cherish our friendship. Your presence brings a remarkable sense of warmth and positivity to every situation, and I am constantly impressed by your grace and the thoughtful way you treat everyone around you. I feel incredibly fortunate to call you a friend and to have the chance to celebrate another wonderful year of your life today. As you embark on this next chapter, my hope is that your day is filled with the same joy you so selflessly give to others, surrounded by laughter and the people who hold you dear. May the year ahead be defined by great success, abundant happiness, and the fulfillment of all your most cherished goals. Thank you for being such an exceptional person and for the lasting impact you have on those lucky enough to know you.
    ''',
    themeColors: [Color(0xFFADD8E6), Color(0xFF87CEFA)],
    emoji: '🩵',
  ),
  PersonLetter(
    name: "Soumya",
    photoPath: "assets/letters/person16.jpg",
    letterContent: '''
Wini i love you and I love u, you are soo so so so so sweet aap to guchuguchu insaan ho
I want you to be my friend like forever
Tumhe dekhti he i feel better then ever i love u like u love cats love you love you love you love you bohot positive insaan ho aap n i love you
Wish you a happiest 17th Birthday
    ''',
    themeColors: [Color(0xFFFFC0CB), Color(0xFFFF69B4)],
    emoji: '🌺',
  ),
  PersonLetter(
    name: "Akshot",
    photoPath: "assets/letters/person17.jpg",
    letterContent: '''
happy birthday winnie.

i still laugh thinking about all those times we talked in the dumbest fucking voices possible like fully committed, accents changing every 10 seconds, sounding like idiots. those moments are lowkey my fav because they're so us no filter, no nothing just full on bakloli.

i hope you turn out great and eat lots and lots of good food, make some weird ahh friends, and at least one moment where you laugh so hard you can't breathe. you deserve all of it. never stop being you, and never sybau i'll smbau instead.

happy birthday again, nigga ass

— Akshot
    ''',
    themeColors: [Color(0xFFDEB887), Color(0xFFD2B48C)],
    emoji: '🤎',
  ),
];

// ============================================
// SEVENTEEN LETTERS PAGE
// ============================================

class SeventeenLettersPage extends StatefulWidget {
  const SeventeenLettersPage({super.key});

  @override
  State<SeventeenLettersPage> createState() => _SeventeenLettersPageState();
}

class _SeventeenLettersPageState extends State<SeventeenLettersPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _breatheController;
  late AnimationController _particleController;
  late AnimationController _fadeController;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _breatheController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = allLetters[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              _darkenColor(currentLetter.themeColors[0], 0.8),
              _darkenColor(currentLetter.themeColors[1], 0.85),
              Color(0xFF0D0C1D),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _LetterParticlePainter(
                    _particleController.value,
                    currentLetter.themeColors,
                  ),
                  size: Size.infinite,
                );
              },
            ),

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
                    top: 200 + sin(angle) * radius * 0.5 - 20,
                    child: Opacity(
                      opacity: (0.15 + sin(progress * pi) * 0.15).clamp(0.0, 0.3),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              currentLetter.themeColors[0].withOpacity(0.6),
                              currentLetter.themeColors[1].withOpacity(0.3),
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

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header with back button and page indicator
                  _buildHeader(currentLetter),

                  // PageView for letters
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: allLetters.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildLetterPage(allLetters[index], index);
                      },
                    ),
                  ),

                  // Bottom section with dots and swipe hint
                  _buildBottomSection(currentLetter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PersonLetter letter) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
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
                    color: letter.themeColors[0].withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: letter.themeColors[0].withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
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

          // Page indicator
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin:
                        Alignment(-1.0 + 2 * _shimmerController.value, -1.0),
                    end: Alignment(1.0 + 2 * _shimmerController.value, 1.0),
                    colors: [
                      letter.themeColors[0].withOpacity(0.3),
                      letter.themeColors[1].withOpacity(0.2),
                      letter.themeColors[0].withOpacity(0.3),
                    ],
                  ),
                  border: Border.all(
                    color: letter.themeColors[0].withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${_currentPage + 1} / ${allLetters.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),

          // Spacer for symmetry
          SizedBox(width: 46),
        ],
      ),
    );
  }

  Widget _buildLetterPage(PersonLetter letter, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: (0.9 + (value * 0.1)).clamp(0.9, 1.0),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // Photo section
            _buildPhotoSection(letter),
            SizedBox(height: 25),

            // Name section
            _buildNameSection(letter),
            SizedBox(height: 25),

            // Letter content
            _buildLetterContent(letter),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(PersonLetter letter) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _breatheController]),
      builder: (context, child) {
        final floatOffset = 8 * sin(_floatController.value * 2 * pi);
        final breatheScale =
            1.0 + (sin(_breatheController.value * 2 * pi) * 0.05);

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Transform.scale(
            scale: breatheScale,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: letter.themeColors[0].withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 10,
            ),
            BoxShadow(
              color: letter.themeColors[1].withOpacity(0.3),
              blurRadius: 60,
              spreadRadius: 20,
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
                letter.themeColors[0],
                letter.themeColors[1],
              ],
            ),
          ),
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A1740),
            ),
            child: ClipOval(
              child: _buildPhoto(letter.photoPath),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto(String photoPath) {
    // Try to load asset, show placeholder if not found
    return Image.asset(
      photoPath,
      fit: BoxFit.cover,
      width: 180,
      height: 180,
      errorBuilder: (context, error, stackTrace) {
        // Placeholder when photo not found
        return Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2D1B69),
                Color(0xFF1A1740),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white30,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameSection(PersonLetter letter) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(-1.0 + 3 * _shimmerController.value, 0),
            end: Alignment(1.0 + 3 * _shimmerController.value, 0),
            colors: [
              Colors.white,
              letter.themeColors[0],
              Colors.white,
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'From: ',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            letter.name,
            style: GoogleFonts.caveat(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 8),
          Text(
            letter.emoji,
            style: TextStyle(fontSize: 24, decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterContent(PersonLetter letter) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(4, 8),
          ),
          BoxShadow(
            color: letter.themeColors[0].withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipPath(
        clipper: _LetterPaperClipper(),
        child: Container(
          padding: EdgeInsets.fromLTRB(28, 32, 28, 36),
          decoration: BoxDecoration(
            // Aged letter paper gradient
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFAF3E0), // Light cream top
                Color(0xFFF5ECD7), // Warm cream
                Color(0xFFEDE4CE), // Aged paper
                Color(0xFFE8DCBF), // Slightly darker bottom edge
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Subtle paper texture/aging effects
              Positioned.fill(
                child: CustomPaint(
                  painter: _LetterPaperTexturePainter(),
                ),
              ),
              // Letter content
              _AnimatedLetterText(
                text: letter.letterContent.trim(),
                themeColors: letter.themeColors,
                useInkStyle: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(PersonLetter letter) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
      child: Column(
        children: [
          // Swipe hint
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.6 + sin(_floatController.value * pi) * 0.3,
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chevron_left,
                  color: Colors.white54,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Swipe to read more letters',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white54,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                  size: 20,
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(allLetters.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? letter.themeColors[0]
                      : Colors.white.withOpacity(0.3),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: letter.themeColors[0].withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _darkenColor(Color color, double factor) {
    return Color.fromRGBO(
      (color.red * factor).round(),
      (color.green * factor).round(),
      (color.blue * factor).round(),
      1,
    );
  }
}

// ============================================
// ANIMATED LETTER TEXT
// ============================================

class _AnimatedLetterText extends StatefulWidget {
  final String text;
  final List<Color> themeColors;
  final bool useInkStyle;

  const _AnimatedLetterText({
    required this.text,
    required this.themeColors,
    this.useInkStyle = false,
  });

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
    _initAnimation();
  }

  @override
  void didUpdateWidget(_AnimatedLetterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.dispose();
      _initAnimation();
    }
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.text.length * 8 + 500),
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

        if (widget.useInkStyle) {
          // Ink style for paper letter
          return Text(
            displayText,
            style: GoogleFonts.caveat(
              fontSize: 20,
              color: Color(0xFF1A1A2E), // Dark ink color
              fontWeight: FontWeight.w500,
              height: 1.7,
              letterSpacing: 0.5,
            ),
          );
        }

        // Original style with shader
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              widget.themeColors[0].withOpacity(0.9),
              Colors.white,
            ],
          ).createShader(bounds),
          child: Text(
            displayText,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              height: 1.9,
              letterSpacing: 0.3,
            ),
          ),
        );
      },
    );
  }
}

// ============================================
// PARTICLE PAINTER
// ============================================

class _LetterParticlePainter extends CustomPainter {
  final double progress;
  final List<Color> themeColors;
  final Random rng = Random(456);

  _LetterParticlePainter(this.progress, this.themeColors);

  @override
  void paint(Canvas canvas, Size size) {
    const particleCount = 35;

    for (int i = 0; i < particleCount; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;

      final x = baseX + sin(progress * 2 * pi + i) * 25;
      final y = baseY + cos(progress * 2 * pi + i * 0.8) * 25;

      final color = i % 2 == 0 ? themeColors[0] : themeColors[1];

      final paint = Paint()
        ..color = color.withOpacity(0.12 + (sin(progress * 4 * pi + i) * 0.08))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        1.5 + (sin(progress * 3 * pi + i) * 0.8),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_LetterParticlePainter oldDelegate) => true;
}

// ============================================
// LETTER PAPER CLIPPER (Realistic letter edges)
// ============================================

class _LetterPaperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Slightly irregular edges like real paper
    const cornerFold = 18.0; // Folded corner size

    // Start from top-left
    path.moveTo(2, 0);

    // Top edge with very slight wave
    path.lineTo(size.width - cornerFold, 0);

    // Folded top-right corner (dog ear effect)
    path.lineTo(size.width, cornerFold);

    // Right edge
    path.lineTo(size.width - 1, size.height - 3);

    // Bottom edge with slight irregularity
    path.lineTo(3, size.height);

    // Left edge
    path.lineTo(0, 2);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ============================================
// LETTER PAPER TEXTURE (Aged paper effects)
// ============================================

class _LetterPaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(789);

    // Draw subtle aging spots/stains
    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 15 + random.nextDouble() * 40;

      final paint = Paint()
        ..color = Color(0xFFD4C4A0).withOpacity(0.08 + random.nextDouble() * 0.06)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.5);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw folded corner shadow
    const cornerSize = 18.0;
    final cornerPath = Path()
      ..moveTo(size.width - cornerSize, 0)
      ..lineTo(size.width, cornerSize)
      ..lineTo(size.width - cornerSize + 2, cornerSize - 2)
      ..close();

    final cornerPaint = Paint()
      ..color = Color(0xFFCDBFA5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(cornerPath, cornerPaint);

    // Add fold crease line
    final creasePaint = Paint()
      ..color = Color(0xFFD9CBAE).withOpacity(0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width - cornerSize, 0),
      Offset(size.width, cornerSize),
      creasePaint,
    );

    // Subtle edge darkening (aged paper edges)
    final edgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Color(0xFFBCA87C).withOpacity(0.15),
        ],
        stops: [0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), edgePaint);
  }

  @override
  bool shouldRepaint(_LetterPaperTexturePainter oldDelegate) => false;
}
