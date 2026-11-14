import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


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
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GreetingScreen()));
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


class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});
  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}


class _GreetingScreenState extends State<GreetingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF0F5), Color(0xFFF8BBD0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('💖✨', style: TextStyle(fontSize: 60)),
            SizedBox(height: 16),
            Text('Hello Beautiful!', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF880E4F))),
            SizedBox(height: 10),
            Text('Your Daily Companion for Care & Joy 🌸', style: TextStyle(fontSize: 16, color: Color(0xFFAD1457))),
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


  @override
  void initState() {
    super.initState();
    _checkAlreadyLoggedIn();
  }


  Future<void> _checkAlreadyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_phone') != null && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboard()));
    }
  }


  void _showTerms() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('📜 Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text('1. SheCare Sakhi is designed for women safety, health & home utility.\n2. Period Tracker & Health Tips are for general awareness only; consult a doctor for medical advice.\n3. Your Secret Diary PIN, notes & emergency contacts stay securely on your own device.\n4. Use SOS only during real emergencies.'),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('I Agree ✅'))],
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
            const Text('Login with your mobile number for alerts & safety', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(prefixText: '+91 ', labelText: 'Enter 10-Digit Mobile Number', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
            Row(
              children: [
                Checkbox(value: agreed, activeColor: const Color(0xFFE91E63), onChanged: (v) => setState(() => agreed = v!)),
                Expanded(child: InkWell(onTap: _showTerms, child: const Text('I agree to Terms & Conditions (Read)', style: TextStyle(decoration: TextDecoration.underline, fontSize: 12, color: Color(0xFF880E4F))))),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white),
                onPressed: () async {
                  if (_phoneCtrl.text.length == 10 && agreed) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('user_phone', _phoneCtrl.text);
                    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboard()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid 10-digit number & accept Terms')));
                  }
                },
                child: const Text('Login & Continue 🚀', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  String lang = 'EN';
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
    "Believe in yourself; you can turn every challenge into a triumph. 💪💖",
    "Your smile is your prettiest ornament, wear it every day. 🌸✨",
    "Every new morning is a fresh chance to fulfill your dreams. 🌟🦋",
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


  Future<void> shareDirectWhatsApp(String text) async {
    final String encoded = Uri.encodeComponent(text);
    final Uri waUri = Uri.parse("whatsapp://send?text=$encoded");
    if (await canLaunchUrl(waUri)) {
      await launchUrl(waUri);
    } else {
      await launchUrl(Uri.parse("https://whatsapp.com"), mode: LaunchMode.externalApplication);
    }
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
              const Text('⚙️ Display Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
              const SizedBox(height: 16),
              Text('Font Size: ${(fontScale * 100).toInt()}%'),
              Slider(value: fontScale, min: 0.85, max: 1.35, divisions: 5, activeColor: const Color(0xFFE91E63), onChanged: (v) { setModal(() => fontScale = v); setState(() => fontScale = v); }),
              Text('Heart & Icon Size: ${iconSize.toInt()} px'),
              Slider(value: iconSize, min: 24.0, max: 40.0, divisions: 4, activeColor: const Color(0xFFE91E63), onChanged: (v) { setModal(() => iconSize = v); setState(() => iconSize = v); }),
              ElevatedButton(onPressed: () => Navigator.pop(c), child: const Text('Save & Close ✅')),
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
      {'title': t['alarm']!, 'icon': '⏰', 'page': const AlarmPage()},
      {'title': t['water']!, 'icon': '🥤', 'page': const WaterPage()},
      {'title': t['tiffin']!, 'icon': '🍱', 'page': const KidsTiffinPage()},
      {'title': t['recipe']!, 'icon': '🍲', 'page': const RecipePage()},
      {'title': t['kitchen']!, 'icon': '🏡', 'page': const KitchenPage()},
      {'title': t['beauty']!, 'icon': '💄', 'page': const BeautyPage()},
      {'title': t['salon']!, 'icon': '💅', 'page': const HomeSalonPage()},
      {'title': t['bhakti']!, 'icon': '🛕', 'page': const BhaktiPathPage()},
      {'title': t['period']!, 'icon': '🌸', 'page': const PeriodPage()},
      {'title': t['diary']!, 'icon': '📔', 'page': const SecretDiaryPage()},
      {'title': t['grocery']!, 'icon': '🛒', 'page': const GroceryPage()},
      {'title': t['video']!, 'icon': '🎬', 'page': const VideoPage()},
      {'title': t['budget']!, 'icon': '💰', 'page': const BudgetPage()},
      {'title': t['rate']!, 'icon': '⭐', 'page': const RatePage()},
    ];
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(fontScale)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE91E63),
          titleSpacing: 10,
          title: const Text('🌸 SheCare Sakhi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          actions: [
            DropdownButton<String>(
              value: lang,
              dropdownColor: const Color(0xFFE91E63),
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.white, size: 17),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
              items: const [
                DropdownMenuItem(value: 'EN', child: Text('EN')),
                DropdownMenuItem(value: 'HI', child: Text('हिंदी')),
                DropdownMenuItem(value: 'MR', child: Text('मराठी')),
                DropdownMenuItem(value: 'PA', child: Text('ਪੰਜਾਬੀ')),
                DropdownMenuItem(value: 'TA', child: Text('தமிழ்')),
                DropdownMenuItem(value: 'KN', child: Text('ಕನ್ನಡ')),
                DropdownMenuItem(value: 'UR', child: Text('اردو')),
              ],
              onChanged: (v) { if (v != null) setState(() => lang = v); },
            ),
            IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.share, color: Colors.white, size: 18), onPressed: () => shareDirectWhatsApp("🌸 Download SheCare Sakhi App - Your Daily Companion for Safety, Health & Home! 💖")),
            const SizedBox(width: 8),
            IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.settings, color: Colors.white, size: 18), onPressed: _openSettings),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red.shade900, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), minimumSize: const Size(55, 30)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSPage())),
                child: const Text('🚨 SOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF5F7), Color(0xFFFCE4EC)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.pink.shade100)),
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
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.pink.shade100)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text('✨ ${t['quoteTitle']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
                        const SizedBox(height: 6),
                        Text(quotes[quoteIndex], textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(onPressed: () => setState(() => quoteIndex = (quoteIndex + 1) % quotes.length), child: const Text('Next 🌸')),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, foregroundColor: Colors.white),
                              onPressed: () => shareDirectWhatsApp("${quotes[quoteIndex]}\n\nSent via SheCare Sakhi App 🌸"),
                              icon: const Icon(Icons.share, size: 16),
                              label: const Text('WhatsApp'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(icon: Icon(isGridView ? Icons.view_list : Icons.grid_view, color: const Color(0xFFE91E63)), onPressed: () => setState(() => isGridView = !isGridView)),
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
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.pink.shade100), boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.08), blurRadius: 6)]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Icons.favorite, color: const Color(0xFFF8BBD0), size: iconSize + 28),
                                      Text(item['icon'], style: TextStyle(fontSize: iconSize * 0.65)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(item['title'], textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF4A0E2E))),
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
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.pink.shade100)),
                            child: ListTile(
                              leading: Stack(alignment: Alignment.center, children: [Icon(Icons.favorite, color: const Color(0xFFF8BBD0), size: iconSize + 18), Text(item['icon'], style: TextStyle(fontSize: iconSize * 0.55))]),
                              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A0E2E))),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xFFE91E63)),
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
  String savedStatus = "";
  String statusMsg = "Press 3-TAP SOS button 3 times quickly in emergency 👇";


  @override
  void initState() {
    super.initState();
    _loadSavedNumbers();
  }


  Future<void> _loadSavedNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _num1Ctrl.text = prefs.getString('sos_num1') ?? '';
      _num2Ctrl.text = prefs.getString('sos_num2') ?? '';
      if (_num1Ctrl.text.isNotEmpty) savedStatus = "Saved Primary: +91 ${_num1Ctrl.text} ✅";
    });
  }


  Future<void> _saveNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sos_num1', _num1Ctrl.text.trim());
    await prefs.setString('sos_num2', _num2Ctrl.text.trim());
    setState(() => savedStatus = "Numbers Permanently Saved! ✅");
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Emergency Contacts Saved!')));
  }


  Future<void> _pickContact(TextEditingController ctrl) async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null && contact.phones.isNotEmpty) {
        String raw = contact.phones.first.number.replaceAll(RegExp(r'\D'), '');
        if (raw.length > 10) raw = raw.substring(raw.length - 10);
        setState(() => ctrl.text = raw);
      }
    }
  }
  Future<void> _handleTripleTap() async {
    setState(() => tapCount++);
    if (tapCount < 3) {
      setState(() => statusMsg = "Tap ${3 - tapCount} more times to send Live Location Alert...");
      return;
    }
    setState(() {
      tapCount = 0;
      statusMsg = "🚨 Silent Alert Triggered! Fetching GPS Location...";
    });


    String locLink = "GPS disabled on device";
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
        Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        locLink = "https://google.com{pos.latitude},${pos.longitude}";
      }
    } catch (_) {}


    final String fam1 = _num1Ctrl.text.trim();
    final String msg = Uri.encodeComponent("🚨 URGENT EMERGENCY! I need immediate help! My Live GPS Location: $locLink - Sent via SheCare Sakhi");


    if (fam1.length == 10) {
      final Uri waDirect = Uri.parse("whatsapp://send?phone=91$fam1&text=$msg");
      if (await canLaunchUrl(waDirect)) {
        await launchUrl(waDirect);
      } else {
        await launchUrl(Uri.parse("sms:$fam1?body=$msg"));
      }
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
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.red.shade200)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('Save Trusted Family Numbers:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15)),
                    if (savedStatus.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(savedStatus, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))),
                    const SizedBox(height: 10),
                    Row(children: [Expanded(child: TextField(controller: _num1Ctrl, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(labelText: 'Family Number 1', border: OutlineInputBorder()))), IconButton(icon: const Icon(Icons.contacts, color: Colors.red, size: 30), onPressed: () => _pickContact(_num1Ctrl))]),
                    const SizedBox(height: 8),
                    Row(children: [Expanded(child: TextField(controller: _num2Ctrl, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(labelText: 'Family Number 2', border: OutlineInputBorder()))), IconButton(icon: const Icon(Icons.contacts, color: Colors.red, size: 30), onPressed: () => _pickContact(_num2Ctrl))]),
                    const SizedBox(height: 8),
                    SizedBox(width: double.infinity, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white), onPressed: _saveNumbers, icon: const Icon(Icons.save), label: const Text('Save Family Numbers ✅'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(statusMsg, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _handleTripleTap,
              child: CircleAvatar(radius: 72, backgroundColor: Colors.red.shade800, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('🚨', style: TextStyle(fontSize: 40)), const Text('3-TAP SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)), Text('Taps: $tapCount / 3', style: const TextStyle(color: Colors.white70, fontSize: 12))])),
            ),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white), onPressed: () => launchUrl(Uri(scheme: 'tel', path: '112')), icon: const Icon(Icons.local_police), label: const Text('Police (112)')), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () => launchUrl(Uri(scheme: 'tel', path: '1091')), icon: const Icon(Icons.support_agent), label: const Text('Helpline (1091)'))])
          ],
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
    final tagCtrl = TextEditingController(text: '⏱️ 10 Mins • 🌟 Special');
    final ingCtrl = TextEditingController();
    final stepCtrl = TextEditingController();
    final ytCtrl = TextEditingController();


    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(widget.adminOnlyAdd ? '🔒 Admin Verification Required' : '➕ Add New Content'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.adminOnlyAdd) TextField(controller: pinCtrl, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Enter Secret Admin PIN')),
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title (with Emoji)')),
              TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: 'Badge (e.g. 10 Mins • Healthy)')),
              TextField(controller: ingCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Ingredients / Key Highlights')),
              TextField(controller: stepCtrl, maxLines: 6, decoration: const InputDecoration(labelText: 'Paste Full Steps / Method / Article')),
              TextField(controller: ytCtrl, decoration: const InputDecoration(labelText: 'YouTube Video Link (Optional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (widget.adminOnlyAdd && pinCtrl.text != '2026') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Incorrect Admin PIN!')));
                return;
              }
              final link = ytCtrl.text.trim();
              if (link.isNotEmpty && !link.contains('youtube.com') && !link.contains('youtu.be')) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Only valid YouTube links allowed!')));
                return;
              }
              if (titleCtrl.text.isNotEmpty && stepCtrl.text.isNotEmpty) {
                setState(() => items.insert(0, {'title': titleCtrl.text, 'tag': tagCtrl.text, 'ing': ingCtrl.text, 'steps': stepCtrl.text, 'yt': link}));
                Navigator.pop(c);
              }
            },
            child: const Text('Publish ✅'),
          ),
        ],
      ),
    );
  }
  void _playVideoInApp(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return;
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
    final filtered = items.where((e) => e['title']!.toLowerCase().contains(query.toLowerCase()) || e['steps']!.toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: widget.color, foregroundColor: Colors.white, actions: [IconButton(icon: const Icon(Icons.add_circle, size: 28), onPressed: _openAddDialog)]),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10), child: TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search...', border: OutlineInputBorder(), filled: true, fillColor: Colors.white))),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: filtered.length,
              itemBuilder: (c, i) {
                final item = filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: widget.color.withOpacity(0.12), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['title']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.color)), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(10)), child: Text(item['tag'] ?? '✨ Featured', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item['ing'] != null && item['ing']!.isNotEmpty) ...[Container(width: double.infinity, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Text("📌 Key Ingredients / Highlights:\n${item['ing']!}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))), const SizedBox(height: 10)],
                            Text("📝 Method / Details:\n${item['steps']!}", style: const TextStyle(fontSize: 14, height: 1.45)),
                            if (item['yt'] != null && item['yt']!.isNotEmpty) ...[const SizedBox(height: 10), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () => _playVideoInApp(item['yt']!), icon: const Icon(Icons.play_circle_fill), label: const Text('Watch Video in App ▶️'))]
                          ],
                        ),
                      ),
                    ],
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
class SecretDiaryPage extends StatefulWidget {
  const SecretDiaryPage({super.key});
  @override
  State<SecretDiaryPage> createState() => _SecretDiaryPageState();
}


class _SecretDiaryPageState extends State<SecretDiaryPage> {
  bool unlocked = false;
  String? storedPin;
  double diaryFontSize = 15.0;
  bool isItalic = false;
  final TextEditingController _pinCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  List<String> notes = [];


  @override
  void initState() {
    super.initState();
    _loadDiaryData();
  }


  Future<void> _loadDiaryData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      storedPin = prefs.getString('diary_pin');
      notes = prefs.getStringList('diary_notes') ?? [];
    });
  }


  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('diary_notes', notes);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📔 Personal Secret Diary'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: unlocked
            ? [
                IconButton(icon: const Icon(Icons.text_decrease), onPressed: () => setState(() { if (diaryFontSize > 12) diaryFontSize -= 2; })),
                IconButton(icon: const Icon(Icons.text_increase), onPressed: () => setState(() { if (diaryFontSize < 24) diaryFontSize += 2; })),
                IconButton(icon: const Icon(Icons.format_italic), onPressed: () => setState(() => isItalic = !isItalic)),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: !unlocked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_person, size: 65, color: Colors.purple),
                  const SizedBox(height: 12),
                  Text(storedPin == null ? 'Create Your New 4-Digit Diary PIN' : 'Enter Your Secret 4-Digit PIN', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(controller: _pinCtrl, obscureText: true, keyboardType: TextInputType.number, maxLength: 4, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: '4-Digit PIN')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                    onPressed: () async {
                      if (_pinCtrl.text.length != 4) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a 4-digit PIN')));
                        return;
                      }
                      if (storedPin == null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('diary_pin', _pinCtrl.text);
                        setState(() { storedPin = _pinCtrl.text; unlocked = true; });
                      } else if (_pinCtrl.text == storedPin) {
                        setState(() => unlocked = true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Wrong PIN! Try again.')));
                      }
                    },
                    child: Text(storedPin == null ? 'Set PIN & Open Diary 🔐' : 'Unlock Diary 🔓'),
                  )
                ],
              )
            : Column(
                children: [
                  TextField(controller: _noteCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Write your private thoughts...', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white), onPressed: () { if (_noteCtrl.text.isNotEmpty) { setState(() { notes.insert(0, _noteCtrl.text); _noteCtrl.clear(); }); _saveNotes(); } }, icon: const Icon(Icons.save), label: const Text('Save Private Note 💖')),
                  const Divider(),
                  Expanded(
                    child: notes.isEmpty
                        ? const Center(child: Text('Your diary is completely empty & private. ✨', style: TextStyle(color: Colors.black54)))
                        : ListView.builder(itemCount: notes.length, itemBuilder: (c, i) => Card(child: ListTile(leading: const Text('🔒'), title: Text(notes[i], style: TextStyle(fontSize: diaryFontSize, fontStyle: isItalic ? FontStyle.italic : FontStyle.normal)), trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () { setState(() => notes.removeAt(i)); _saveNotes(); })))),
                  ),
                ],
              ),
      ),
    );
  }
}
class KidsTiffinPage extends StatelessWidget {
  const KidsTiffinPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🍱 Kids Tiffin Special', color: Colors.green.shade700, initialItems: const [
      {'title': '🌮 Mini Aloo-Paneer Paratha Roll', 'tag': '⏱️ 15 Mins • 🌟 Kids Favourite', 'ing': '• Whole wheat dough\n• Boiled mashed potatoes & grated paneer\n• Fresh coriander & mild spices', 'steps': '1. Roll a thin chapati and roast lightly.\n2. Spread spiced aloo-paneer filling.\n3. Roll tightly and cut into bite-sized pieces.', 'yt': ''},
      {'title': '🥞 Suji-Veggie Mini Uttapam', 'tag': '⏱️ 10 Mins • 🥗 Healthy', 'ing': '• 1 cup Semolina (Suji) & 1/2 cup curd\n• Finely chopped carrots & capsicum', 'steps': '1. Mix suji, curd, and water into a smooth batter.\n2. Pour small rounds on a greased tawa, top with veggies & roast golden.', 'yt': ''},
    ]);
  }
}


class RecipePage extends StatelessWidget {
  const RecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🍲 Quick Recipes', color: Colors.orange.shade800, initialItems: const [
      {'title': '🍜 5-Min Veggie Masala Oats', 'tag': '⏱️ 5 Mins • 🔥 Instant', 'ing': '• 1 cup Masala Oats\n• Chopped onion, tomato & peas', 'steps': '1. Saute veggies for 1 minute.\n2. Add 1.5 cups water and oats, cook for 3 minutes.', 'yt': ''},
    ]);
  }
}


class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🏡 Kitchen & Home Hacks', color: Colors.teal.shade700, initialItems: const [
      {'title': '🍋 Fridge Odor Removal Trick', 'tag': '✨ Smart Home Hack', 'ing': '• 2 tbsp Baking Soda OR half cut lemon', 'steps': '1. Place an open bowl of baking soda in the corner of your fridge.\n2. It absorbs all strong food smells within hours.', 'yt': ''},
    ]);
  }
}


class BeautyPage extends StatelessWidget {
  const BeautyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '💄 Health & Beauty Care', color: Colors.pink.shade600, initialItems: const [
      {'title': '✨ Besan & Haldi Natural Glow Pack', 'tag': '🌿 100% Natural • 15 Mins', 'ing': '• 2 tbsp Gram Flour (Besan)\n• Pinch of wild turmeric & rose water', 'steps': '1. Mix into a smooth paste and apply evenly on face.\n2. Wash off with cool water after 15 minutes for instant glow.', 'yt': ''},
    ]);
  }
}


class HomeSalonPage extends StatelessWidget {
  const HomeSalonPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '💅 Home Salon & Makeup', color: Colors.purple.shade700, adminOnlyAdd: true, initialItems: const [
      {'title': '💋 5-Min Party Glow Makeup Guide', 'tag': '💄 Party Ready • 5 Mins', 'ing': '• Moisturizer, Primer & BB Cream\n• Kajal, Mascara & Nude Lipstick', 'steps': '1. Prep skin with moisturizer and primer.\n2. Blend BB cream evenly and add soft pink blush.\n3. Finish with kajal, mascara, and lip tint.', 'yt': ''},
    ]);
  }
}


class BhaktiPathPage extends StatelessWidget {
  const BhaktiPathPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🛕 Bhakti Path & Aarti', color: Colors.deepOrange.shade700, adminOnlyAdd: true, initialItems: const [
      {'title': '🪔 Shri Ganesh Ji Ki Aarti', 'tag': '🕉️ Offline Aarti • Puja Vidhi', 'ing': '• Deepak, Kapur, Durva Grass & Modak', 'steps': 'Jai Ganesh Jai Ganesh Jai Ganesh Deva,\nMata Jaki Parvati Pita Mahadeva...\n\nPuja Vidhi: Light a ghee lamp in the morning and offer durva grass.', 'yt': ''},
    ]);
  }
}


class VideoPage extends StatelessWidget {
  const VideoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(title: '🎬 AI Video Guide', color: Colors.deepPurple, adminOnlyAdd: true, initialItems: const [
      {'title': '🥣 2-Min Rice Flour Instant Glow Scrub', 'tag': '✨ Quick Skincare', 'ing': '• 1 tbsp Rice Flour & 1 tbsp Fresh Curd', 'steps': '1. Mix rice flour and curd.\n2. Massage gently in circular motions for 2 minutes & rinse.', 'yt': ''},
    ]);
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
  final List<Map<String, String>> alarms = [{'task': '💊 Morning Vitamin / Medicine', 'time': '09:00 AM'}];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⏰ Alarm & Reminder'), backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [TextField(controller: _taskCtrl, decoration: const InputDecoration(labelText: 'Reminder Task (Medicine, Meeting...)', border: OutlineInputBorder())), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [TextButton.icon(onPressed: () async { final t = await showTimePicker(context: context, initialTime: selectedTime); if (t != null) setState(() => selectedTime = t); }, icon: const Icon(Icons.access_alarm), label: Text('Time: ${selectedTime.format(context)}')), ElevatedButton(onPressed: () { if (_taskCtrl.text.isNotEmpty) { setState(() { alarms.insert(0, {'task': _taskCtrl.text, 'time': selectedTime.format(context)}); _taskCtrl.clear(); }); } }, child: const Text('+ Set'))])]))),
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
      appBar: AppBar(title: const Text('🥤 Water Tracker'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💧', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 12),
            Text('$glasses / 8 Glasses', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton(onPressed: () { setState(() => glasses++); if (glasses == 8) showDialog(context: context, builder: (c) => AlertDialog(title: const Text('🎉 Goal Achieved!'), content: const Text('Congratulations! You completed your 8-glass daily water target! 💧✨'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Yay! 💖'))])); }, child: const Text('+ 1 Glass')), const SizedBox(width: 12), TextButton(onPressed: () => setState(() => glasses = 0), child: const Text('Reset'))]),
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
      appBar: AppBar(title: const Text('💰 Smart Budget'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total Expense: ₹${total.toStringAsFixed(0)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: total >= 5000 ? Colors.red : Colors.teal)),
                const SizedBox(height: 12),
                TextField(controller: _ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Enter Amount (₹)', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton(onPressed: () { final val = double.tryParse(_ctrl.text); if (val != null && val > 0) { setState(() { total += val; _ctrl.clear(); }); if (total >= 5000) showDialog(context: context, builder: (c) => AlertDialog(title: const Text('⚠️ Budget Warning!'), content: const Text('Alert: Your total expense has crossed ₹5000!'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))])); } }, child: const Text('+ Add Expense')), const SizedBox(width: 10), TextButton(onPressed: () => setState(() => total = 0), child: const Text('Reset'))]),
              ],
            ),
          ),
        ),
      ),
    );
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
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [const Text('Select Last Period Start Date:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 12), ElevatedButton.icon(onPressed: () async { final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2025), lastDate: DateTime(2028)); if (picked != null) setState(() => lastDate = picked); }, icon: const Icon(Icons.calendar_month), label: const Text('Choose Date')), if (lastDate != null) ...[const SizedBox(height: 16), Text('Next Expected Date: ${lastDate!.add(const Duration(days: 28)).toString().split(' ')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)))]]))),
            const SizedBox(height: 16),
            const Text('⚠️ Medical Disclaimer: For general tracking only. Consult a healthcare professional for medical advice.', style: TextStyle(fontSize: 12, color: Colors.black54)),
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
  final List<Map<String, dynamic>> items = [{'name': '🥛 Milk & Curd', 'done': false}, {'name': '🍅 Fresh Vegetables', 'done': false}];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🛒 Grocery List'), backgroundColor: Colors.amber.shade900, foregroundColor: Colors.white, actions: [IconButton(icon: const Icon(Icons.delete_sweep), tooltip: 'Clear List', onPressed: () => setState(() => items.clear()))]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [Expanded(child: TextField(controller: _itemCtrl, decoration: const InputDecoration(labelText: 'Add grocery item...', border: OutlineInputBorder()))), const SizedBox(width: 8), ElevatedButton(onPressed: () { if (_itemCtrl.text.isNotEmpty) { setState(() { items.add({'name': _itemCtrl.text, 'done': false}); _itemCtrl.clear(); }); } }, child: const Text('+ Add'))]),
            const SizedBox(height: 12),
            Expanded(child: ListView.builder(itemCount: items.length, itemBuilder: (c, i) => CheckboxListTile(title: Text(items[i]['name'], style: TextStyle(decoration: items[i]['done'] ? TextDecoration.lineThrough : null)), value: items[i]['done'], onChanged: (v) => setState(() => items[i]['done'] = v!)))),
          ],
        ),
      ),
    );
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
            const Text('How much do you love SheCare Sakhi?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (index) => IconButton(icon: Icon(index < stars ? Icons.star : Icons.star_border, color: Colors.amber, size: 38), onPressed: () => setState(() => stars = index + 1)))),
            const SizedBox(height: 12),
            TextField(controller: _revCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Write your feedback...', border: OutlineInputBorder())),
            const SizedBox(height: 14),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () { _revCtrl.clear(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thank you! Your $stars-Star review has been saved 💖'))); }, icon: const Icon(Icons.send), label: const Text('Submit Review')),
          ],
        ),
      ),
    );
  }
}