import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


void main() => runApp(const SheCareApp());


class SheCareApp extends StatelessWidget {
  const SheCareApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SheCare Sakhi',
      theme: ThemeData(primaryColor: const Color(0xFFE91E63), scaffoldBackgroundColor: const Color(0xFFFFF5F7), useMaterial3: true),
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
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFF48FB1), Color(0xFFE91E63)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 55, backgroundColor: Colors.white, child: Text('🌸', style: TextStyle(fontSize: 55))),
            SizedBox(height: 20),
            Text('SheCare Sakhi', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Text('Har Nari Ki Sacchi Saheli ✨', style: TextStyle(fontSize: 16, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneCtrl = TextEditingController();
  bool agreed = true;


  void _showTerms() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('📜 Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text('1. SheCare Sakhi mahilaon ki suvidha, suraksha aur jankari ke liye banaya gaya hai.\n2. Period Tracker aur Health Tips keval samanya jankari ke liye hain, medical salah ke liye doctor se milein.\n3. Aapki Secret Diary aur mobile number aapke phone me surakshit rehte hain.\n4. SOS feature ka upyog keval aapatkalin sthiti me karein.'),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Samajh Gayi ✅'))],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF0F5), Color(0xFFFCE4EC)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌸', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 10),
            const Text('Welcome to SheCare Sakhi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF880E4F))),
            const SizedBox(height: 6),
            const Text('Notifications aur suraksha ke liye login karein', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(prefixText: '+91 ', labelText: 'Apna Mobile Number Dalein', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
            Row(
              children: [
                Checkbox(value: agreed, activeColor: const Color(0xFFE91E63), onChanged: (v) => setState(() => agreed = v!)),
                Expanded(child: InkWell(onTap: _showTerms, child: const Text('Main Terms & Conditions se sahmat hoon (Padhein)', style: TextStyle(decoration: TextDecoration.underline, fontSize: 12, color: Color(0xFF880E4F))))),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white),
                onPressed: () {
                  if (_phoneCtrl.text.length == 10 && agreed) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboard()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kripya 10-anko ka mobile number dalein aur Terms accept karein')));
                  }
                },
                child: const Text('Login & Start App 🚀', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
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
  String lang = 'HI';
  bool isGridView = true;
  double fontScale = 1.0;
  double iconSize = 30.0;
  String timeStr = '';
  Timer? _clockTimer;
  int quoteIndex = 0;


  final Map<String, Map<String, String>> tr = {
    'EN': {'welcome': 'Hello Beautiful! ✨', 'quoteTitle': 'Thought of the Day', 'alarm': 'Alarm & Reminder', 'water': 'Water Tracker', 'tiffin': 'Kids Tiffin', 'recipe': 'Quick Recipes', 'kitchen': 'Kitchen & Home', 'beauty': 'Health & Beauty', 'salon': 'Home Salon', 'bhakti': 'Bhakti Path', 'period': 'Period Tracker', 'diary': 'Secret Diary', 'grocery': 'Grocery List', 'video': 'AI Video Guide', 'budget': 'Smart Budget', 'rate': 'Rate & Review'},
    'HI': {'welcome': 'नमस्ते सखी! ✨', 'quoteTitle': 'आज का सुविचार', 'alarm': 'अलार्म व रिमाइंडर', 'water': 'वाटर ट्रैकर', 'tiffin': 'किड्स टिफिन', 'recipe': 'झटपट रेसिपी', 'kitchen': 'किचन और होम', 'beauty': 'हेल्थ और ब्यूटी', 'salon': 'होम सैलून', 'bhakti': 'भक्ति पथ', 'period': 'पीरियड ट्रैकर', 'diary': 'सीक्रेट डायरी', 'grocery': 'राशन लिस्ट', 'video': 'AI वीडियो गाइड', 'budget': 'स्मार्ट बजट', 'rate': 'रेटिंग व सुझाव'},
    'MR': {'welcome': 'नमस्कार सखी! ✨', 'quoteTitle': 'आजचा सुविचार', 'alarm': 'अलार्म आणि रिमाइंडर', 'water': 'वॉटर ट्रॅकर', 'tiffin': 'किड्स टिफिन', 'recipe': 'झटपट रेसिपी', 'kitchen': 'किचन आणि होम', 'beauty': 'हेल्थ आणि ब्युटी', 'salon': 'होम सलून', 'bhakti': 'भक्ती पथ', 'period': 'मासिक पाळी ट्रॅकर', 'diary': 'सीक्रेट डायरी', 'grocery': 'किराणा यादी', 'video': 'AI व्हिडिओ गाईड', 'budget': 'स्मार्ट बजेट', 'rate': 'रेटिंग आणि अभिप्राय'},
    'PA': {'welcome': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ ਸਖੀ! ✨', 'quoteTitle': 'ਅੱਜ ਦਾ ਵਿਚਾਰ', 'alarm': 'ਅਲਾਰਮ ਤੇ ਰਿਮਾਈਂਡਰ', 'water': 'ਪਾਣੀ ਟਰੈਕਰ', 'tiffin': 'ਕਿਡਜ਼ ਟਿਫਿਨ', 'recipe': 'ਝਟਪਟ ਰੈਸਿਪੀ', 'kitchen': 'ਰਸੋਈ ਤੇ ਘਰ', 'beauty': 'ਸਿਹਤ ਤੇ ਬਿਊਟੀ', 'salon': 'ਹੋਮ ਸੈਲੂਨ', 'bhakti': 'ਭਗਤੀ ਮਾਰਗ', 'period': 'ਪੀਰੀਅਡ ਟਰੈਕਰ', 'diary': 'ਸੀਕ੍ਰੇਟ ਡਾਇਰੀ', 'grocery': 'ਰਾਸ਼ਨ ਲਿਸਟ', 'video': 'AI ਵੀਡੀਓ ਗਾਈਡ', 'budget': 'ਸਮਾਰਟ ਬਜਟ', 'rate': 'ਰੇਟਿੰਗ ਤੇ ਸੁਝਾਅ'},
    'TA': {'welcome': 'வணக்கம் தோழி! ✨', 'quoteTitle': 'இன்றைய சிந்தனை', 'alarm': 'அலாரம் & நினைவூட்டல்', 'water': 'தண்ணீர் அளவு', 'tiffin': 'குழந்தைகள் டிபன்', 'recipe': 'சமையல் குறிப்புகள்', 'kitchen': 'சமையலறை & வீடு', 'beauty': 'ஆரோக்கியம் & அழகு', 'salon': 'ஹோம் சலூன்', 'bhakti': 'பக்தி பாதை', 'period': 'மாதவிடாய் கண்காணிப்பு', 'diary': 'ரகசிய நாட்குறிப்பு', 'grocery': 'மளிகை பட்டியல்', 'video': 'AI வீடியோ வழிகாட்டி', 'budget': 'ஸ்மார்ட் பட்ஜெட்', 'rate': 'மதிப்பீடு & கருத்து'},
    'KN': {'welcome': 'ನಮಸ್ಕಾರ ಗೆಳತಿ! ✨', 'quoteTitle': 'ಇಂದಿನ ಸುಭಾಷಿತ', 'alarm': 'ಅಲಾರಂ ಮತ್ತು ರಿಮೈಂಡರ್', 'water': 'ನೀರಿನ ಟ್ರ್ಯಾಕರ್', 'tiffin': 'ಕಿಡ್ಸ್ ಟಿಫಿನ್', 'recipe': 'ತ್ವರಿತ ಅಡುಗೆ', 'kitchen': 'ಕಿಚನ್ ಮತ್ತು ಹೋಮ್', 'beauty': 'ಹೆಲ್ತ್ ಮತ್ತು ಬ್ಯೂಟಿ', 'salon': 'ಹೋಮ್ ಸಲೂನ್', 'bhakti': 'ಭಕ್ತಿ ಪಥ', 'period': 'ಪಿರಿಯಡ್ ಟ್ರ್ಯಾಕರ್', 'diary': 'ಸೀಕ್ರೆಟ್ ಡೈರಿ', 'grocery': 'ದಿನಸಿ ಪಟ್ಟಿ', 'video': 'AI ವಿಡಿಯೋ ಗೈಡ್', 'budget': 'ಸ್ಮಾರ್ಟ್ ಬಜೆಟ್', 'rate': 'ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆ'},
    'UR': {'welcome': 'آداب سہیلی! ✨', 'quoteTitle': 'آج کی اچھی بات', 'alarm': 'الارم اور ریمائنڈر', 'water': 'واٹر ٹریکر', 'tiffin': 'کڈز ٹفن', 'recipe': 'فوری پکوان', 'kitchen': 'کچن اور ہوم', 'beauty': 'ہیلتھ اور بیوٹی', 'salon': 'ہوم سیلون', 'bhakti': 'بھکتی پاتھ', 'period': 'پیریڈ ٹریکر', 'diary': 'سیکریٹ ڈائری', 'grocery': 'راشن کی فہرست', 'video': 'AI ویڈیو گائیڈ', 'budget': 'اسمارٹ بجٹ', 'rate': 'ریٹنگ اور رائے'},
  };


  final List<String> quotes = [
    "Khud par vishwas rakhein, aap har mushkil ko aasan bana sakti hain. 💪💖",
    "Muskurahat aapka sabse khubsurat gehna hai, ise hamesha pehne rakhein. 🌸✨",
    "Har naya din ek naya mauka hai apne sapno ko pura karne ka. 🌟🦋",
  ];


  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
  }


  void _updateClock() {
    final now = DateTime.now();
    final h = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    if (mounted) setState(() => timeStr = "$h:$m:$s $ampm");
  }


  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }
Future<void> shareText(String text) async {
    final String encoded = Uri.encodeComponent(text);
    final Uri url = Uri.parse("https://whatsapp.com");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }


  void _openSettings() {
    showModalBottomSheet(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚙️ App Display Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
              const SizedBox(height: 16),
              Text('Font Size: ${(fontScale * 100).toInt()}%'),
              Slider(value: fontScale, min: 0.85, max: 1.35, divisions: 5, activeColor: const Color(0xFFE91E63), onChanged: (v) { setModal(() => fontScale = v); setState(() => fontScale = v); }),
              Text('Icon Size: ${iconSize.toInt()} px'),
              Slider(value: iconSize, min: 22.0, max: 42.0, divisions: 5, activeColor: const Color(0xFFE91E63), onChanged: (v) { setModal(() => iconSize = v); setState(() => iconSize = v); }),
              ElevatedButton(onPressed: () => Navigator.pop(c), child: const Text('Done ✅')),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final t = tr[lang]!;
    final List<Map<String, dynamic>> menuItems = [
      {'title': t['alarm']!, 'icon': '⏰', 'color': const Color(0xFFFFF8E1), 'page': const AlarmPage()},
      {'title': t['water']!, 'icon': '🥤', 'color': const Color(0xFFE3F2FD), 'page': const WaterPage()},
      {'title': t['tiffin']!, 'icon': '🍱', 'color': const Color(0xFFE8F5E9), 'page': const KidsTiffinPage()},
      {'title': t['recipe']!, 'icon': '🍲', 'color': const Color(0xFFFFF3E0), 'page': const RecipePage()},
      {'title': t['kitchen']!, 'icon': '🏡', 'color': const Color(0xFFE0F2F1), 'page': const KitchenPage()},
      {'title': t['beauty']!, 'icon': '💄', 'color': const Color(0xFFFCE4EC), 'page': const BeautyPage()},
      {'title': t['salon']!, 'icon': '💅', 'color': const Color(0xFFF8BBD0), 'page': const HomeSalonPage()},
      {'title': t['bhakti']!, 'icon': '🛕', 'color': const Color(0xFFFFECB3), 'page': const BhaktiPathPage()},
      {'title': t['period']!, 'icon': '🌸', 'color': const Color(0xFFFCE4EC), 'page': const PeriodPage()},
      {'title': t['diary']!, 'icon': '📔', 'color': const Color(0xFFF3E5F5), 'page': const SecretDiaryPage()},
      {'title': t['grocery']!, 'icon': '🛒', 'color': const Color(0xFFFFFDE7), 'page': const GroceryPage()},
      {'title': t['video']!, 'icon': '🎬', 'color': const Color(0xFFEDE7F6), 'page': const VideoPage()},
      {'title': t['budget']!, 'icon': '💰', 'color': const Color(0xFFE0F7FA), 'page': const BudgetPage()},
      {'title': t['rate']!, 'icon': '⭐', 'color': const Color(0xFFFFEBEE), 'page': const RatePage()},
    ];


    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(fontScale)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE91E63),
          title: const Text('🌸 SheCare Sakhi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          actions: [
            DropdownButton<String>(
              value: lang,
              dropdownColor: const Color(0xFFE91E63),
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.white, size: 18),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              items: const [
                DropdownMenuItem(value: 'HI', child: Text('हिंदी')),
                DropdownMenuItem(value: 'MR', child: Text('मराठी')),
                DropdownMenuItem(value: 'EN', child: Text('EN')),
                DropdownMenuItem(value: 'PA', child: Text('ਪੰਜਾਬੀ')),
                DropdownMenuItem(value: 'TA', child: Text('தமிழ்')),
                DropdownMenuItem(value: 'KN', child: Text('ಕನ್ನಡ')),
                DropdownMenuItem(value: 'UR', child: Text('اردو')),
              ],
              onChanged: (v) { if (v != null) setState(() => lang = v); },
            ),
            IconButton(icon: const Icon(Icons.share, color: Colors.white, size: 19), tooltip: 'Share App', onPressed: () => shareText("🌸 SheCare Sakhi App download karein - Har Nari Ki Sacchi Saheli! 💖")),
            IconButton(icon: const Icon(Icons.settings, color: Colors.white, size: 19), tooltip: 'Settings', onPressed: _openSettings),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red.shade900, padding: const EdgeInsets.symmetric(horizontal: 8)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSPage())),
                child: const Text('🚨 SOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF0F5), Color(0xFFFCE4EC), Color(0xFFF3E5F5)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t['welcome']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF880E4F))),
                      Row(children: [const Icon(Icons.access_time_filled, size: 16, color: Color(0xFFE91E63)), const SizedBox(width: 4), Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF880E4F)))]),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text('✨ ${t['quoteTitle']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                        const SizedBox(height: 6),
                        Text(quotes[quoteIndex], textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(onPressed: () => setState(() => quoteIndex = (quoteIndex + 1) % quotes.length), child: const Text('Next 🌸')),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                              onPressed: () => shareText("${quotes[quoteIndex]}\n\nSent via SheCare Sakhi App 🌸"),
                              icon: const Icon(Icons.share, size: 16),
                              label: const Text('WhatsApp'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(isGridView ? Icons.view_list : Icons.grid_view, color: const Color(0xFFE91E63)),
                              tooltip: 'Switch Grid/List View',
                              onPressed: () => setState(() => isGridView = !isGridView),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                isGridView
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menuItems.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.92),
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          return InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['page'])),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: item['color'], borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 5)]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Icons.favorite, color: Colors.white.withOpacity(0.9), size: iconSize + 24),
                                      Text(item['icon'], style: TextStyle(fontSize: iconSize * 0.72)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(item['title'], textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          return Card(
                            color: item['color'],
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Stack(alignment: Alignment.center, children: [Icon(Icons.favorite, color: Colors.white, size: iconSize + 14), Text(item['icon'], style: TextStyle(fontSize: iconSize * 0.6))]),
                              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['page'])),
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
class SOSPage extends StatefulWidget {
  const SOSPage({super.key});
  @override
  State<SOSPage> createState() => _SOSPageState();
}


class _SOSPageState extends State<SOSPage> {
  final TextEditingController _num1Ctrl = TextEditingController();
  final TextEditingController _num2Ctrl = TextEditingController();
  int tapCount = 0;
  String statusMsg = "Emergency me niche wale button ko 3 baar tezi se dabayein 👇";


  Future<void> _handleTripleTap() async {
    setState(() => tapCount++);
    if (tapCount < 3) {
      setState(() => statusMsg = "Alert trigger hone me ${3 - tapCount} touch baki hain...");
      return;
    }
    setState(() {
      tapCount = 0;
      statusMsg = "🚨 Silent Alert Active! Location nikali ja rahi hai...";
    });


    String locLink = "Location unavailable";
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
        Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        locLink = "https://google.com{pos.latitude},${pos.longitude}";
      }
    } catch (_) {}


    final String fam1 = _num1Ctrl.text.trim();
    final String msg = Uri.encodeComponent("🚨 URGENT EMERGENCY! Mujhe turant madad chahiye! Meri Live Location: $locLink - Sent via SheCare Sakhi");


    if (fam1.length == 10) {
      await launchUrl(Uri.parse("https://whatsapp.com"), mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(Uri(scheme: 'tel', path: '112'));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🚨 Emergency SOS Control'), backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('Apne Trusted Family Numbers Save Karein:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    const SizedBox(height: 10),
                    TextField(controller: _num1Ctrl, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(labelText: 'Family Number 1 (WhatsApp Alert)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
                    const SizedBox(height: 8),
                    TextField(controller: _num2Ctrl, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(labelText: 'Family Number 2 (Backup)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(statusMsg, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _handleTripleTap,
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.red.shade800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🚨', style: TextStyle(fontSize: 42)),
                    const Text('3-TAP SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('Taps: $tapCount / 3', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white), onPressed: () => launchUrl(Uri(scheme: 'tel', path: '112')), icon: const Icon(Icons.local_police), label: const Text('Call Police (112)')),
                ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () => launchUrl(Uri(scheme: 'tel', path: '1091')), icon: const Icon(Icons.support_agent), label: const Text('Women Helpline')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});
  @override
  State<AlarmPage> createState() => _AlarmPageState();
}


class _AlarmPageState extends State<AlarmPage> {
  final TextEditingController _taskCtrl = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  final List<Map<String, String>> alarms = [
    {'task': '💊 Morning Vitamin / Medicine', 'time': '09:00 AM'},
    {'task': '🍱 Kids Tiffin Packing', 'time': '07:30 AM'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⏰ Alarm & Smart Reminder'), backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    TextField(controller: _taskCtrl, decoration: const InputDecoration(labelText: 'Kaam likhein (Medicine, Meeting...)', border: OutlineInputBorder())),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(onPressed: () async { final t = await showTimePicker(context: context, initialTime: selectedTime); if (t != null) setState(() => selectedTime = t); }, icon: const Icon(Icons.access_alarm), label: Text('Time: ${selectedTime.format(context)}')),
                        ElevatedButton(onPressed: () { if (_taskCtrl.text.isNotEmpty) { setState(() { alarms.insert(0, {'task': _taskCtrl.text, 'time': selectedTime.format(context)}); _taskCtrl.clear(); }); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⏰ Reminder Set Ho Gaya!'))); } }, child: const Text('+ Set Alarm')),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: ListView.builder(itemCount: alarms.length, itemBuilder: (c, i) => Card(child: ListTile(leading: const Icon(Icons.notifications_active, color: Colors.amber), title: Text(alarms[i]['task']!, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('Time: ${alarms[i]['time']}'), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => alarms.removeAt(i)))))))
          ],
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
                  onPressed: () {
                    setState(() => glasses++);
                    if (glasses == 8) {
                      showDialog(context: context, builder: (c) => AlertDialog(title: const Text('🎉 Badhai Ho Sakhi!'), content: const Text('Aaj ka 8 glass pani peene ka target pura hua! 💧✨'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Shukriya 💖'))]));
                    }
                  },
                  child: const Text('+ 1 Glass Piya'),
                ),
                const SizedBox(width: 12),
                TextButton(onPressed: () => setState(() => glasses = 0), child: const Text('Reset')),
              ],
            ),
          ],
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
                Text('Kul Kharch: ₹${total.toStringAsFixed(0)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: total >= 5000 ? Colors.red : Colors.teal)),
                const SizedBox(height: 12),
                TextField(controller: _ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rakam likhein (₹)', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final val = double.tryParse(_ctrl.text);
                        if (val != null && val > 0) {
                          setState(() { total += val; _ctrl.clear(); });
                          if (total >= 5000) {
                            showDialog(context: context, builder: (c) => AlertDialog(title: const Text('⚠️ Budget Warning!'), content: const Text('Savdhan! Aapka kul kharch ₹5000 se upar chala gaya hai. Kripya kharch par dhyan dein.'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Theek Hai'))]));
                          }
                        }
                      },
                      child: const Text('+ Kharch Jodein'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(onPressed: () => setState(() => total = 0), child: const Text('Reset')),
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


class SmartContentPage extends StatefulWidget {
  final String title;
  final Color color;
  final bool adminOnlyAdd;
  final List<Map<String, String>> initialItems;
  const SmartContentPage({super.key, required this.title, required this.color, required this.initialItems, this.adminOnlyAdd = false});
  @override
  State<SmartContentPage> createState() => _SmartContentPageState();
}


class _SmartContentPageState extends State<SmartContentPage> {
  late List<Map<String, String>> items;
  String query = '';


  @override
  void initState() {
    super.initState();
    items = List.from(widget.initialItems);
  }


  void _openAddDialog() {
    final pinCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final ytCtrl = TextEditingController();


    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(widget.adminOnlyAdd ? '🔒 Admin Add (PIN: 9999)' : '➕ Naya Content Jodein'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.adminOnlyAdd) TextField(controller: pinCtrl, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Admin PIN Dalein')),
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title (Emoji ke sath)')),
              TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Samagri / Tarika / Details')),
              TextField(controller: ytCtrl, decoration: const InputDecoration(labelText: 'YouTube Link (Optional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (widget.adminOnlyAdd && pinCtrl.text != '9999') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Galat Admin PIN!')));
                return;
              }
              final link = ytCtrl.text.trim();
              if (link.isNotEmpty && !link.contains('youtube.com') && !link.contains('youtu.be')) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Keval valid YouTube link hi allowed hai!')));
                return;
              }
              if (titleCtrl.text.isNotEmpty && descCtrl.text.isNotEmpty) {
                setState(() => items.insert(0, {'title': titleCtrl.text, 'desc': descCtrl.text, 'yt': link}));
                Navigator.pop(c);
              }
            },
            child: const Text('Save ✅'),
          ),
        ],
      ),
    );
  }


  void _playVideoInApp(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video ID nahi mil payi')));
      return;
    }
    final ytController = YoutubePlayerController(initialVideoId: videoId, flags: const YoutubePlayerFlags(autoPlay: true));
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        contentPadding: const EdgeInsets.all(8),
        content: YoutubePlayer(controller: ytController, showVideoProgressIndicator: true),
        actions: [TextButton(onPressed: () { ytController.dispose(); Navigator.pop(c); }, child: const Text('Close Video ❌'))],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final filtered = items.where((e) => e['title']!.toLowerCase().contains(query.toLowerCase()) || e['desc']!.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.add_circle, size: 28), onPressed: _openAddDialog)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search karein...', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filtered.length,
              itemBuilder: (c, i) {
                final item = filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.color)),
                        const SizedBox(height: 6),
                        Text(item['desc']!, style: const TextStyle(fontSize: 14, height: 1.4)),
                        if (item['yt'] != null && item['yt']!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                            onPressed: () => _playVideoInApp(item['yt']!),
                            icon: const Icon(Icons.play_circle_fill),
                            label: const Text('Watch Video in App ▶️'),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
class KidsTiffinPage extends StatelessWidget {
  const KidsTiffinPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🍱 Kids Tiffin Special', color: Colors.green.shade700, initialItems: const [
      {'title': '🌮 Mini Aloo-Paneer Paratha Roll (15 Mins)', 'desc': 'Samagri: Gehu aata, uble aloo, paneer, hara dhaniya.\nTarika: Patli roti belkar aloo-paneer stuffing bharein aur roll banakar sek lein.', 'yt': ''},
      {'title': '🥞 Suji-Veggie Mini Uttapam (10 Mins)', 'desc': 'Samagri: 1 cup suji, dahi, barik kati gajar, shimla mirch.\nTarika: Batter banakar chote-chote uttapam tave par sek lein.', 'yt': ''},
      {'title': '🥪 Tricolor Veg Mayo Sandwich (10 Mins)', 'desc': 'Samagri: Brown bread, gajar, kheera, mayonnaise, kali mirch.\nTarika: Sabziyon me mayo milakar bread par lagayein aur triangle kaat lein.', 'yt': ''},
    ]);
  }
}


class RecipePage extends StatelessWidget {
  const RecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🍲 Quick Recipes', color: Colors.orange.shade800, initialItems: const [
      {'title': '🍜 5-Min Hostel Masala Oats', 'desc': 'Samagri: Masala oats, 1 cup pani, tamatar, pyaz.\nTarika: Sabziyon ko 1 min bhunein, pani aur oats dalkar 3 min pakayein.', 'yt': ''},
      {'title': '🥗 Protein Sprouts Chaat Bowl', 'desc': 'Samagri: Uble moong sprouts, kheera, nimbu ras, chaat masala.\nTarika: Sabko ek bowl me milayein, healthy nashta taiyar hai!', 'yt': ''},
    ]);
  }
}


class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🏡 Kitchen & Home Hacks', color: Colors.teal.shade700, initialItems: const [
      {'title': '🍋 Fridge Ki Badbu Hatane Ka Hack', 'desc': 'Ek choti katori me thoda baking soda ya kata hua nimbu fridge ke kone me rakhein.', 'yt': ''},
      {'title': '🍚 Chawal Ko Keedon Se Bachayein', 'desc': 'Chawal ke dibbe me 4-5 sukhi neem ki pattiyan ya tej patta rakh dein.', 'yt': ''},
    ]);
  }
}


class BeautyPage extends StatelessWidget {
  const BeautyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '💄 Health & Beauty Care', color: Colors.pink.shade600, initialItems: const [
      {'title': '✨ Besan & Haldi Natural Glow Pack', 'desc': '2 chammach besan, chutki bhar haldi aur gulab jal milakar 15 min chehre par lagayein.', 'yt': ''},
      {'title': '💇‍♀️ Hair Fall Control Herbal Oil', 'desc': 'Nariyal tel me methi dana aur curry patta garm karke haftey me 2 baar malish karein.', 'yt': ''},
    ]);
  }
}


class HomeSalonPage extends StatelessWidget {
  const HomeSalonPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '💅 Home Salon & Makeup', color: Colors.purple.shade700, adminOnlyAdd: true, initialItems: const [
      {'title': '💋 5-Min Party Glow Makeup Guide', 'desc': 'Step 1: Moisturizer aur Primer lagayein.\nStep 2: BB Cream aur halka Blush lagayein.\nStep 3: Kajal, Mascara aur Nude Lipstick se look pura karein.', 'yt': 'https://youtube.com'},
      {'title': '🧖‍♀️ Ghar Par Fruit Facial Steps', 'desc': 'Step 1: Kacche doodh se cleansing.\nStep 2: Chawal ke aate aur shahad se scrub.\nStep 3: Papita aur dahi ke pack se 15 min massage.', 'yt': ''},
    ]);
  }
}


class BhaktiPathPage extends StatelessWidget {
  const BhaktiPathPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🛕 Bhakti Path & Aarti', color: Colors.deepOrange.shade700, adminOnlyAdd: true, initialItems: const [
      {'title': '🪔 Shri Ganesh Ji Ki Aarti (Offline)', 'desc': 'Jai Ganesh Jai Ganesh Jai Ganesh Deva,\nMata Jaki Parvati Pita Mahadeva...\nPuja Vidhi: Subah snan ke baad deepak jalakar durva aur modak arpit karein.', 'yt': ''},
      {'title': '🕉️ Mahakal Jyotirlinga Ujjain Darshan', 'desc': 'Madhya Pradesh ke Ujjain me sthit Shri Mahakaleshwar 12 Jyotirlingon me se ekmatra dakshinamukhi Jyotirling hain.', 'yt': ''},
    ]);
  }
}
class PeriodPage extends StatefulWidget {
  const PeriodPage({super.key});
  @override
  State<PeriodPage> createState() => _PeriodPageState();
}


class _PeriodPageState extends State<PeriodPage> {
  DateTime? lastDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌸 Period Tracker'), backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Apni Pichli Period Date Chunein:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(onPressed: () async { final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2025), lastDate: DateTime(2028)); if (picked != null) setState(() => lastDate = picked); }, icon: const Icon(Icons.calendar_month), label: const Text('Select Date')),
                    if (lastDate != null) ...[
                      const SizedBox(height: 16),
                      Text('Agli Expected Date: ${lastDate!.add(const Duration(days: 28)).toString().split(' ')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('⚠️ Medical Disclaimer: Yeh tracker keval samanya jankari ke liye hai.', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}


class SecretDiaryPage extends StatefulWidget {
  const SecretDiaryPage({super.key});
  @override
  State<SecretDiaryPage> createState() => _SecretDiaryPageState();
}


class _SecretDiaryPageState extends State<SecretDiaryPage> {
  bool unlocked = false;
  final TextEditingController _pinCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  final List<String> notes = ["Aaj maine apna khud ka mobile app banaya! 🌸✨"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📔 Secret Diary (PIN)'), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: !unlocked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_person, size: 65, color: Colors.purple),
                  const SizedBox(height: 12),
                  const Text('Apna 4-Digit PIN Dalein (Default: 1234)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(controller: _pinCtrl, obscureText: true, keyboardType: TextInputType.number, maxLength: 4, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Enter PIN')),
                  ElevatedButton(onPressed: () { if (_pinCtrl.text == "1234") { setState(() => unlocked = true); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Galat PIN! (1234 try karein)'))); } }, child: const Text('Unlock Diary 🔓'))
                ],
              )
            : Column(
                children: [
                  TextField(controller: _noteCtrl, decoration: const InputDecoration(labelText: 'Apni secret baat likhein...', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () { if (_noteCtrl.text.isNotEmpty) { setState(() { notes.insert(0, _noteCtrl.text); _noteCtrl.clear(); }); } }, child: const Text('Save Note 💖')),
                  const Divider(),
                  Expanded(child: ListView.builder(itemCount: notes.length, itemBuilder: (c, i) => Card(child: ListTile(leading: const Text('🔒'), title: Text(notes[i]))))),
                ],
              ),
      ),
    );
  }
}


class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});
  @override
  State<GroceryPage> createState() => _GroceryPageState();
}


class _GroceryPageState extends State<GroceryPage> {
  final TextEditingController _itemCtrl = TextEditingController();
  final List<Map<String, dynamic>> items = [{'name': '🥛 Doodh & Dahi', 'done': false}, {'name': '🍅 Tamatar & Sabziyan', 'done': false}];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🛒 Smart Grocery List'), backgroundColor: Colors.amber.shade900, foregroundColor: Colors.white, actions: [IconButton(icon: const Icon(Icons.delete_sweep), tooltip: 'Clear List', onPressed: () => setState(() => items.clear()))]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [Expanded(child: TextField(controller: _itemCtrl, decoration: const InputDecoration(labelText: 'Saman ka naam likhein...', border: OutlineInputBorder()))), const SizedBox(width: 8), ElevatedButton(onPressed: () { if (_itemCtrl.text.isNotEmpty) { setState(() { items.add({'name': _itemCtrl.text, 'done': false}); _itemCtrl.clear(); }); } }, child: const Text('+ Add'))]),
            const SizedBox(height: 12),
            Expanded(child: ListView.builder(itemCount: items.length, itemBuilder: (c, i) => CheckboxListTile(title: Text(items[i]['name'], style: TextStyle(decoration: items[i]['done'] ? TextDecoration.lineThrough : null)), value: items[i]['done'], onChanged: (v) => setState(() => items[i]['done'] = v!)))),
          ],
        ),
      ),
    );
  }
}


class VideoPage extends StatelessWidget {
  const VideoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🎬 AI Video Hacks', color: Colors.deepPurple, adminOnlyAdd: true, initialItems: const [
      {'title': '🥣 2-Min Rice Flour Instant Glow Scrub', 'desc': '1 chammach chawal ka aata aur 1 chammach dahi milakar 2 minute halke hathon se massage karein.', 'yt': ''},
    ]);
  }
}


class RatePage extends StatefulWidget {
  const RatePage({super.key});
  @override
  State<RatePage> createState() => _RatePageState();
}


class _RatePageState extends State<RatePage> {
  int stars = 5;
  final TextEditingController _revCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⭐ Rate & Review Us'), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('SheCare Sakhi aapko kaisa laga?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (index) => IconButton(icon: Icon(index < stars ? Icons.star : Icons.star_border, color: Colors.amber, size: 38), onPressed: () => setState(() => stars = index + 1)))),
            const SizedBox(height: 12),
            TextField(controller: _revCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Apna sujhav ya review likhein...', border: OutlineInputBorder())),
            const SizedBox(height: 14),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () { _revCtrl.clear(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dhanyawad! Aapki $stars-Star rating save ho gayi hai 💖'))); }, icon: const Icon(Icons.send), label: const Text('Submit Review')),
          ],
        ),
      ),
    );
  }
}
