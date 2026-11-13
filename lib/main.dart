import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SheCareApp());

class SheCareApp extends StatelessWidget {
  const SheCareApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SheCare Sakhi',
      theme: ThemeData(
        primaryColor: const Color(0xFFE91E63),
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeDashboard()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF48FB1), Color(0xFFE91E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: Text('🌸', style: TextStyle(fontSize: 55)),
            ),
            SizedBox(height: 20),
            Text(
              'SheCare Sakhi',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Har Nari Ki Sacchi Saheli ✨',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});
  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int quoteIndex = 0;
  final List<String> quotes = [
    "Khud par vishwas rakhein, aap har mushkil ko aasan bana sakti hain. 💪💖",
    "Muskurahat aapka sabse khubsurat gehna hai, ise hamesha pehne rakhein. 🌸✨",
    "Har naya din ek naya mauka hai apne sapno ko pura karne ka. 🌟🦋",
  ];

  Future<void> shareOnWhatsApp(String text) async {
    final Uri url = Uri.parse("https://wa.me{Uri.encodeComponent(text)}");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp open nahi ho paya')),
        );
      }
    }
  }

  Future<void> triggerSOS() async {
    final Uri telUri = Uri(scheme: 'tel', path: '112');
    await launchUrl(telUri);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Period Tracker', 'icon': '🌸', 'color': const Color(0xFFFCE4EC), 'page': const PeriodPage()},
      {'title': 'Quick Recipes', 'icon': '🍲', 'color': const Color(0xFFFFF3E0), 'page': const RecipePage()},
      {'title': 'Kitchen & Beauty', 'icon': '🏡', 'color': const Color(0xFFE8F5E9), 'page': const TipsPage()},
      {'title': 'AI Video Hacks', 'icon': '🎬', 'color': const Color(0xFFEDE7F6), 'page': const VideoPage()},
      {'title': 'Smart Budget', 'icon': '💰', 'color': const Color(0xFFE0F7FA), 'page': const BudgetPage()},
      {'title': 'Water Tracker', 'icon': '🥤', 'color': const Color(0xFFE3F2FD), 'page': const WaterPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        title: const Text('🌸 SheCare Sakhi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
              onPressed: triggerSOS,
              icon: const Icon(Icons.warning_amber_rounded, size: 18),
              label: const Text('SOS', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('✨ Aaj Ka Suvichar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                    const SizedBox(height: 8),
                    Text(quotes[quoteIndex], textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => quoteIndex = (quoteIndex + 1) % quotes.length),
                          child: const Text('Next 🌸'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          onPressed: () => shareOnWhatsApp("${quotes[quoteIndex]}\n\nSent via SheCare Sakhi App 🌸"),
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('WhatsApp'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['page'])),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item['icon'], style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
class TipsPage extends StatelessWidget {
  const TipsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final tips = [
      {'title': '✨ Besan & Haldi Glow Pack', 'desc': '2 chammach besan, chutki bhar haldi aur gulab jal milakar 15 min chehre par lagayein.'},
      {'title': '💇‍♀️ Strong Hair Oil Hack', 'desc': 'Nariyal tel me methi dana aur curry patta garm karke haftey me 2 baar malish karein.'},
      {'title': '🍋 Kitchen Freshness Tip', 'desc': 'Fridge ki badbu hatane ke liye ek katori me thoda baking soda ya kata nimbu rakhein.'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('🏡 Kitchen & Beauty'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: tips.length,
        itemBuilder: (context, i) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(tips[i]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(tips[i]['desc']!)),
            ),
          );
        },
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int step = 0;
  final List<Map<String, String>> slides = [
    {'emoji': '🥣', 'title': 'Step 1: Instant Face Scrub', 'text': '1 chammach chawal ka aata aur 1 chammach dahi milayein.'},
    {'emoji': '💆‍♀️', 'title': 'Step 2: Gentle Massage', 'text': 'Halke hathon se 2 minute golai me chehre par massage karein.'},
    {'emoji': '✨', 'title': 'Step 3: Fresh Glow', 'text': 'Thande pani se dho lein aur payein turant chamakti tvacha!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎬 AI Smart Video Guide'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: Colors.deepPurple.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(slides[step]['emoji']!, style: const TextStyle(fontSize: 65)),
                  const SizedBox(height: 16),
                  Text(slides[step]['title']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(height: 10),
                  Text(slides[step]['text']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                    onPressed: () => setState(() => step = (step + 1) % slides.length),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Next Video Step ▶️'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});
  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _ctrl = TextEditingController();
  double total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💰 Smart Pocket Budget'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.teal.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Kul Kharch: ₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 12),
                TextField(
                  controller: _ctrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Rakam likhein (₹)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final val = double.tryParse(_ctrl.text);
                    if (val != null && val > 0) {
                      setState(() {
                        total += val;
                        _ctrl.clear();
                      });
                    }
                  },
                  child: const Text('+ Kharch Jodein'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});
  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  int glasses = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🥤 Daily Water Tracker'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💧', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 12),
            Text('$glasses / 8 Glass Pani', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => glasses++),
                  child: const Text('+ 1 Glass Piya'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => setState(() => glasses = 0),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
