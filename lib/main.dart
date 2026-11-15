import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const String kGoogleSheetCsvUrl = "https://google.com";


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: initAndroid));
  runApp(const SheCareApp());
}


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
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('image_280732b5.jpg'), fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade900.withOpacity(0.5), Colors.pink.shade700.withOpacity(0.75)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('SheCare Sakhi', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 8, color: Colors.black54)])),
              SizedBox(height: 8),
              Text('Har Nari Ki Sacchi Saheli ✨', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500)),
              SizedBox(height: 70),
            ],
          ),
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
          child: Text('1. SheCare Sakhi is designed for women safety, health & home utility.\n2. Period Tracker, BMI & Health Tips are for general awareness only; consult a doctor for medical advice.\n3. Your Secret Diary PIN, notes & emergency contacts stay securely on your own device.\n4. Use SOS only during real emergencies.'),
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
    'EN': {'welcome': 'Hello Beautiful! ✨', 'quoteTitle': 'आज का सुविचार', 'alarm': 'Alarm & Reminder', 'water': 'Water Tracker', 'tiffin': 'Kids Tiffin', 'recipe': 'Quick Recipes', 'kitchen': 'Kitchen & Home', 'beauty': 'Health & Beauty', 'salon': 'Home Salon', 'bhakti': 'Bhakti Path', 'period': 'Period Tracker', 'bmi': 'BMI Calculator', 'yoga': 'Yoga & Exercise', 'diary': 'Secret Diary', 'grocery': 'Grocery List', 'video': 'AI Video Guide', 'budget': 'Smart Budget', 'rate': 'Rate & Review'},
    'HI': {'welcome': 'नमस्ते सखी! ✨', 'quoteTitle': 'आज का सुविचार', 'alarm': 'अलार्म व रिमाइंडर', 'water': 'वाटर ट्रैकर', 'tiffin': 'किड्स टिफिन', 'recipe': 'झटपट रेसिपी', 'kitchen': 'किचन और होम', 'beauty': 'हेल्थ और ब्यूटी', 'salon': 'होम सैलून', 'bhakti': 'भक्ति पथ', 'period': 'पीरियड ट्रैकर', 'bmi': 'BMI कैलकुलेटर', 'yoga': 'योगा व एक्सरसाइज', 'diary': 'सीक्रेट डायरी', 'grocery': 'राशन लिस्ट', 'video': 'AI वीडियो गाइड', 'budget': 'स्मार्ट बजट', 'rate': 'रेटिंग व सुझाव'},
    'MR': {'welcome': 'नमस्कार सखी! ✨', 'quoteTitle': 'आजचा सुविचार', 'alarm': 'अलार्म आणि रिमाइंडर', 'water': 'वॉटर ट्रॅकर', 'tiffin': 'किड्स टिफिन', 'recipe': 'झटपट रेसिपी', 'kitchen': 'किचन आणि होम', 'beauty': 'हेल्थ आणि ब्युटी', 'salon': 'होम सलून', 'bhakti': 'भक्ती पथ', 'period': 'मासिक पाळी ट्रॅकर', 'bmi': 'BMI कॅल्क्युलेटर', 'yoga': 'योगा आणि व्यायाम', 'diary': 'सीक्रेट डायरी', 'grocery': 'किराणा यादी', 'video': 'AI व्हिडिओ गाईड', 'budget': 'स्मार्ट बजेट', 'rate': 'रेटिंग आणि अभिप्राय'},
    'PA': {'welcome': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ ਸਖੀ! ✨', 'quoteTitle': 'ਅੱਜ ਦਾ ਵਿਚਾਰ', 'alarm': 'ਅਲਾਰਮ ਤੇ ਰਿਮਾਈਂਡਰ', 'water': 'ਪਾਣੀ ਟਰੈਕਰ', 'tiffin': 'ਕਿਡਜ਼ ਟਿਫਿਨ', 'recipe': 'ਝਟਪਟ ਰੈਸਿਪੀ', 'kitchen': 'ਰਸੋਈ ਤੇ ਘਰ', 'beauty': 'ਸਿਹਤ ਤੇ ਬਿਊਟੀ', 'salon': 'ਹੋਮ ਸੈਲੂਨ', 'bhakti': 'ਭਗਤੀ ਮਾਰਗ', 'period': 'ਪੀਰੀਅਡ ਟਰੈਕਰ', 'bmi': 'BMI ਕੈਲਕੁਲੇਟਰ', 'yoga': 'ਯੋਗਾ ਤੇ ਕਸਰਤ', 'diary': 'ਸੀਕ੍ਰੇਟ ਡਾਇਰੀ', 'grocery': 'ਰਾਸ਼ਨ ਲਿਸਟ', 'video': 'AI ਵੀਡੀਓ ਗਾਈਡ', 'budget': 'ਸਮਾਰਟ ਬਜਟ', 'rate': 'ਰੇਟਿੰਗ ਤੇ ਸੁਝਾਅ'},
    'TA': {'welcome': 'வணக்கம் தோழி! ✨', 'quoteTitle': 'இன்றைய சிந்தனை', 'alarm': 'அலாரம் & நினைவூட்டல்', 'water': 'தண்ணீர் அளவு', 'tiffin': 'குழந்தைகள் டிபன்', 'recipe': 'சமையல் குறிப்புகள்', 'kitchen': 'சமையலறை & வீடு', 'beauty': 'ஆரோக்கியம் & அழகு', 'salon': 'ஹோம் சலூன்', 'bhakti': 'பக்தி பாதை', 'period': 'மாதவிடாய் கண்காணிப்பு', 'bmi': 'BMI கணிப்பான்', 'yoga': 'யோகா & உடற்பயிற்சி', 'diary': 'ரகசிய நாட்குறிப்பு', 'grocery': 'மளிகை பட்டியல்', 'video': 'AI வீடியோ வழிகாட்டி', 'budget': 'ஸ்மார்ட் பட்ஜெட்', 'rate': 'மதிப்பீடு & கருத்து'},
    'KN': {'welcome': 'ನಮಸ್ಕಾರ ಗೆಳತಿ! ✨', 'quoteTitle': 'ಇಂದಿನ ಸುಭಾಷಿತ', 'alarm': 'ಅಲಾರಂ ಮತ್ತು ರಿಮೈಂಡರ್', 'water': 'ನೀರಿನ ಟ್ರ್ಯಾಕರ್', 'tiffin': 'ಕಿಡ್ಸ್ ಟಿಫಿನ್', 'recipe': 'ತ್ವರಿತ ಅಡುಗೆ', 'kitchen': 'ಕಿಚನ್ ಮತ್ತು ಹೋಮ್', 'beauty': 'ಹೆಲ್ತ್ ಮತ್ತು ಬ್ಯೂಟಿ', 'salon': 'ಹೋಮ್ ಸಲೂನ್', 'bhakti': 'ಭಕ್ತಿ ಪಥ', 'period': 'ಪಿರಿಯಡ್ ಟ್ರ್ಯಾಕರ್', 'bmi': 'BMI ಕ್ಯಾಲ್ಕುಲೇಟರ್', 'yoga': 'ಯೋಗ ಮತ್ತು ವ್ಯಾಯಾಮ', 'diary': 'ಸೀಕ್ರೆಟ್ ಡೈರಿ', 'grocery': 'ದಿನಸಿ ಪಟ್ಟಿ', 'video': 'AI ವಿಡಿಯೋ ಗೈಡ್', 'budget': 'ಸ್ಮಾರ್ಟ್ ಬಜೆಟ್', 'rate': 'ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆ'},
    'UR': {'welcome': 'آداب سہیلی! ✨', 'quoteTitle': 'آج کی اچھی بات', 'alarm': 'الارم اور ریمائنڈر', 'water': 'واٹر ٹریکر', 'tiffin': 'کڈز ٹفن', 'recipe': 'فوری پکوان', 'kitchen': 'کچن اور ہوم', 'beauty': 'ہیلتھ اور بیوٹی', 'salon': 'ہوم سیلون', 'bhakti': 'بھکتی پاتھ', 'period': 'پیریڈ ٹریکر', 'bmi': 'BMI کیلکولیٹر', 'yoga': 'یوگا اور ورزش', 'diary': 'سیکریٹ ڈائری', 'grocery': 'راشن کی فہرست', 'video': 'AI ویڈیو گائیڈ', 'budget': 'اسمارٹ بجٹ', 'rate': 'ریٹنگ اور رائے'},
  };


  final List<String> quotes = [
    "खुद पर विश्वास रखें, आप हर मुश्किल को आसान बना सकती हैं। 💪💖",
    "मुस्कराहट आपका सबसे खूबसूरत गहना है, इसे हमेशा पहने रखें। 🌸✨",
    "हर नया दिन एक नया मौका है अपने सपनों को पूरा करने का। 🌟🦋",
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
      {'title': t['bmi']!, 'icon': '⚖️', 'page': const BMIPage()},
      {'title': t['yoga']!, 'icon': '🧘‍♀️', 'page': const YogaPage()},
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
          titleSpacing: 8,
          title: const Text('🌸 SheCare Sakhi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          actions: [
            DropdownButton<String>(
              value: lang,
              dropdownColor: const Color(0xFFE91E63),
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.white, size: 16),
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
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
              onPressed: () {
                setState(() => quoteIndex = (quoteIndex + 1) % quotes.length);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔄 App Refreshed & Synced! ✅'), duration: Duration(seconds: 1)));
              },
            ),
            const SizedBox(width: 6),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.share, color: Colors.white, size: 17),
              onPressed: () => shareDirectWhatsApp("🌸 Download *SheCare Sakhi* App - Your Daily Companion for Women Safety, Health & Home! 💖\n\n📲 Download Link:\nhttps://github.com\n\n✨ Har Nari Ki Sacchi Saheli!"),
            ),
            const SizedBox(width: 6),
            IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.settings, color: Colors.white, size: 17), onPressed: _openSettings),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red.shade900, padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0), minimumSize: const Size(50, 28)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSPage())),
                child: const Text('🚨 SOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFF5F7), Color(0xFFFCE4EC)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: RefreshIndicator(
            color: const Color(0xFFE91E63),
            onRefresh: () async {
              setState(() => quoteIndex = (quoteIndex + 1) % quotes.length);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔄 App Refreshed! ✅'), duration: Duration(seconds: 1)));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF8A80), Color(0xFFF48FB1)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]),
                    child: Column(
                      children: [
                        Text(t['welcome']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
                        const SizedBox(height: 6),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Aapka din shubh ho.  •  ', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)), const Icon(Icons.access_time_filled, size: 15, color: Colors.white), const SizedBox(width: 4), Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: Colors.purple.shade100, width: 1.5)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('✨ ${t['quoteTitle']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF8E24AA))),
                          const SizedBox(height: 10),
                          Text('"${quotes[quoteIndex]}"', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Color(0xFF311B92), height: 1.4)),
                          const SizedBox(height: 14),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E24AA), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)), onPressed: () => setState(() => quoteIndex = (quoteIndex + 1) % quotes.length), icon: const Text('🌸'), label: const Text('Next Thought', style: TextStyle(fontWeight: FontWeight.bold))), const SizedBox(width: 10), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF43A047), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)), onPressed: () => shareDirectWhatsApp("${quotes[quoteIndex]}\n\nSent via SheCare Sakhi App 🌸"), icon: const Icon(Icons.share, size: 17), label: const Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.bold))), const SizedBox(width: 6), IconButton(icon: Icon(isGridView ? Icons.view_list : Icons.grid_view, color: const Color(0xFFE91E63)), onPressed: () => setState(() => isGridView = !isGridView))])
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
  String savedNum1 = '';
  String savedNum2 = '';
  int tapCount = 0;
  String statusMsg = "आपातकाल (Emergency) में नीचे लाल बटन को 3 बार तेज़ी से दबाएं 👇";


  @override
  void initState() {
    super.initState();
    _loadSavedNumbers();
  }


  Future<void> _loadSavedNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedNum1 = prefs.getString('sos_num1') ?? '';
      savedNum2 = prefs.getString('sos_num2') ?? '';
    });
  }


  Future<void> _saveNumbers() async {
    final n1 = _num1Ctrl.text.trim();
    final n2 = _num2Ctrl.text.trim();
    if (n1.length != 10 && n2.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कृपया कम से कम एक 10-अंकों का मोबाइल नंबर डालें')));
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (n1.length == 10) { await prefs.setString('sos_num1', n1); savedNum1 = n1; _num1Ctrl.clear(); }
    if (n2.length == 10) { await prefs.setString('sos_num2', n2); savedNum2 = n2; _num2Ctrl.clear(); }
    setState(() {});
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ फैमिली नंबर स्थायी रूप से सेव हो गए!')));
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
      setState(() => statusMsg = "अलर्ट भेजने के लिए ${3 - tapCount} बार और टच करें...");
      return;
    }
    setState(() {
      tapCount = 0;
      statusMsg = "🚨 लोकेशन निकाली जा रही है, कृपया 2 सेकंड रुकें...";
    });


    String locLink = "GPS Location Off";
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
        Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium, timeLimit: const Duration(seconds: 4));
        final double lat = pos.latitude;
        final double lng = pos.longitude;
        locLink = "https://google.com";
      }
    } catch (_) {}


    final String target = savedNum1.length == 10 ? savedNum1 : savedNum2;
    final String msg = Uri.encodeComponent("🚨 URGENT EMERGENCY! मुझे तुरंत मदद चाहिए! मेरी लाइव लोकेशन: $locLink - Sent via SheCare Sakhi");


    if (target.length == 10) {
      final Uri waDirect = Uri.parse("whatsapp://send?phone=91$target&text=$msg");
      if (await canLaunchUrl(waDirect)) {
        await launchUrl(waDirect);
      } else {
        await launchUrl(Uri.parse("sms:$target?body=$msg"));
      }
    } else {
      await launchUrl(Uri(scheme: 'tel', path: '112'));
    }
  }


  @override
  Widget build(BuildContext context) {
    final String activeTarget = savedNum1.length == 10 ? savedNum1 : savedNum2;
    return Scaffold(
      appBar: AppBar(title: const Text('🚨 Emergency SOS Control'), backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (savedNum1.isNotEmpty || savedNum2.isNotEmpty)
              Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.green.shade300)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✅ Saved Trusted Family Contacts:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(height: 6),
                      if (savedNum1.isNotEmpty) Text('👤 Primary Contact: +91 $savedNum1', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      if (savedNum2.isNotEmpty) Text('👤 Backup Contact: +91 $savedNum2', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      if (activeTarget.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(width: double.infinity, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white), onPressed: () => launchUrl(Uri(scheme: 'tel', path: activeTarget)), icon: const Icon(Icons.phone_in_talk), label: Text('📞 Call Family Now (+91 $activeTarget)'))),
                      ]
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.red.shade200)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const Text('Add / Update Family Numbers:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15)),
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
            const SizedBox(height: 14),
            Text(statusMsg, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _handleTripleTap,
              child: CircleAvatar(radius: 68, backgroundColor: Colors.red.shade800, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('🚨', style: TextStyle(fontSize: 38)), const Text('3-TAP SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), Text('Taps: $tapCount / 3', style: const TextStyle(color: Colors.white70, fontSize: 12))])),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white), onPressed: () => launchUrl(Uri(scheme: 'tel', path: '112')), icon: const Icon(Icons.local_police), label: const Text('Police (112)')), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: () => launchUrl(Uri(scheme: 'tel', path: '1091')), icon: const Icon(Icons.support_agent), label: const Text('Helpline (1091)'))])
          ],
        ),
      ),
    );
  }
}
class SmartContentPage extends StatefulWidget {
  final String storageKey;
  final String title;
  final Color color;
  final bool adminOnlyAdd;
  final List<Map<String, String>> initialItems;
  const SmartContentPage({super.key, required this.storageKey, required this.title, required this.color, required this.initialItems, this.adminOnlyAdd = false});
  @override
  State<SmartContentPage> createState() => _SmartContentPageState();
}


class _SmartContentPageState extends State<SmartContentPage> {
  List<Map<String, String>> items = [];
  String query = '';
  bool isSyncing = false;


  @override
  void initState() {
    super.initState();
    _loadAndSyncItems();
  }


  Future<void> _loadAndSyncItems({bool showToast = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedSheet = prefs.getString('sheet_cache_${widget.storageKey}');
    final String? localRaw = prefs.getString('saved_${widget.storageKey}');


    List<Map<String, String>> baseList = localRaw != null
        ? (jsonDecode(localRaw) as List).map((e) => Map<String, String>.from(e)).toList()
        : List.from(widget.initialItems);


    if (cachedSheet != null) {
      final sheetList = (jsonDecode(cachedSheet) as List).map((e) => Map<String, String>.from(e)).toList();
      setState(() => items = [...sheetList, ...baseList]);
    } else {
      setState(() => items = baseList);
    }


    setState(() => isSyncing = true);
    try {
      final res = await http.get(
        Uri.parse(kGoogleSheetCsvUrl),
        headers: {'Cache-Control': 'no-cache, no-store, must-revalidate', 'Pragma': 'no-cache', 'Expires': '0'},
      ).timeout(const Duration(seconds: 10));


      if (res.statusCode == 200) {
        final String body = utf8.decode(res.bodyBytes).replaceAll('\r\n', '\n');
        final List<List<dynamic>> rows = const CsvToListConverter(eol: '\n').convert(body);
        List<Map<String, String>> liveSheetItems = [];
        for (int i = 1; i < rows.length; i++) {
          final r = rows[i];
          if (r.length >= 2 && r.elementAt(0).toString().trim().toLowerCase() == widget.storageKey.toLowerCase()) {
            liveSheetItems.add({
              'title': r.elementAt(1).toString().trim(),
              'tag': r.length > 2 && r.elementAt(2).toString().trim().isNotEmpty ? r.elementAt(2).toString().trim() : '✨ Live Update',
              'ing': r.length > 3 ? r.elementAt(3).toString().trim() : '',
              'steps': r.length > 4 ? r.elementAt(4).toString().trim() : '',
              'yt': r.length > 5 ? r.elementAt(5).toString().trim() : '',
            });
          }
        }
        await prefs.setString('sheet_cache_${widget.storageKey}', jsonEncode(liveSheetItems));
        if (mounted) {
          setState(() => items = [...liveSheetItems.reversed, ...baseList]);
          if (showToast) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Synced! Google Sheet से ${liveSheetItems.length} आइटम लोड हुए।')));
          }
        }
      }
    } catch (e) {
      if (mounted && showToast) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ इंटरनेट धीमा है, ऑफ़लाइन डेटा दिखाया जा रहा है।')));
      }
    }
    if (mounted) setState(() => isSyncing = false);
  }


  Future<void> _saveLocalItems(List<Map<String, String>> updated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_${widget.storageKey}', jsonEncode(updated));
  }


  String? _extractYoutubeId(String url) {
    final reg = RegExp(r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?|shorts)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})');
    final match = reg.firstMatch(url);
    return match != null ? match.group(1) : YoutubePlayer.convertUrlToId(url);
  }


  void _playVideoInApp(String url) {
    final videoId = _extractYoutubeId(url);
    if (videoId == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Invalid YouTube Video Link'))); return; }
    final ytController = YoutubePlayerController(initialVideoId: videoId, flags: const YoutubePlayerFlags(autoPlay: true));
    showDialog(context: context, builder: (c) => AlertDialog(contentPadding: const EdgeInsets.all(8), content: YoutubePlayer(controller: ytController, showVideoProgressIndicator: true), actions: [TextButton(onPressed: () { ytController.dispose(); Navigator.pop(c); }, child: const Text('Close Video ❌'))]));
  }
  void _openAddDialog() {
    final pinCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final tagCtrl = TextEditingController(text: '⏱️ 10 मिनट • 🌟 खास');
    final ingCtrl = TextEditingController();
    final stepCtrl = TextEditingController();
    final ytCtrl = TextEditingController();
    String img1 = '';
    String img2 = '';


    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: Text(widget.adminOnlyAdd ? '🔒 Admin Verification Required' : '➕ नया कंटेंट जोड़ें'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.adminOnlyAdd) TextField(controller: pinCtrl, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Enter Secret Admin PIN')),
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'शीर्षक (Title with Emoji)*')),
                TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: 'बैज (जैसे: 10 मिनट • हेल्दी)')),
                TextField(controller: ingCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'मुख्य सामग्री / हाइलाइट्स')),
                TextField(controller: stepCtrl, maxLines: 5, decoration: const InputDecoration(labelText: 'पूरा तरीका / विधि पेस्ट करें')),
                TextField(controller: ytCtrl, decoration: const InputDecoration(labelText: 'YouTube / Shorts Link (Optional)')),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  OutlinedButton.icon(onPressed: () async { final f = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70); if (f != null) setModal(() => img1 = f.path); }, icon: const Icon(Icons.photo, size: 16), label: Text(img1.isEmpty ? 'Photo 1' : 'Photo 1 ✅')),
                  OutlinedButton.icon(onPressed: () async { final f = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70); if (f != null) setModal(() => img2 = f.path); }, icon: const Icon(Icons.photo, size: 16), label: Text(img2.isEmpty ? 'Photo 2' : 'Photo 2 ✅')),
                ]),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.color, foregroundColor: Colors.white),
              onPressed: () async {
                if (widget.adminOnlyAdd && pinCtrl.text.trim() != '2026') { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ गलत Admin PIN!'))); return; }
                if (titleCtrl.text.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ कृपया शीर्षक लिखें!'))); return; }
                final newItem = {'title': titleCtrl.text.trim(), 'tag': tagCtrl.text.trim(), 'ing': ingCtrl.text.trim(), 'steps': stepCtrl.text.trim(), 'yt': ytCtrl.text.trim(), 'img1': img1, 'img2': img2};
                setState(() => items.insert(0, newItem));
                await _saveLocalItems(items);
                if (mounted) Navigator.pop(c);
              },
              child: const Text('Publish ✅'),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final filtered = items.where((e) => e['title']!.toLowerCase().contains(query.toLowerCase()) || (e['steps'] ?? '').toLowerCase().contains(query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: widget.color, foregroundColor: Colors.white, actions: [
        if (isSyncing) const Padding(padding: EdgeInsets.all(14), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
        IconButton(icon: const Icon(Icons.refresh), tooltip: 'Sync Google Sheet', onPressed: () => _loadAndSyncItems(showToast: true)),
        IconButton(icon: const Icon(Icons.add_circle, size: 28), onPressed: _openAddDialog),
      ]),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10), child: TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'खोजें (Search)...', border: OutlineInputBorder(), filled: true, fillColor: Colors.white))),
          Expanded(
            child: RefreshIndicator(
              color: widget.color,
              onRefresh: () => _loadAndSyncItems(showToast: true),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filtered.length,
                itemBuilder: (c, i) {
                  final item = filtered[i];
                  final img1 = item['img1'] ?? '';
                  final img2 = item['img2'] ?? '';
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
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['title']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.color)), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(10)), child: Text(item['tag'] ?? '✨ खास', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))]),
                        ),
                        if (img1.isNotEmpty || img2.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                            child: Row(children: [
                              if (img1.isNotEmpty && File(img1).existsSync()) Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(img1), height: 120, fit: BoxFit.cover))),
                              if (img1.isNotEmpty && img2.isNotEmpty) const SizedBox(width: 8),
                              if (img2.isNotEmpty && File(img2).existsSync()) Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(img2), height: 120, fit: BoxFit.cover))),
                            ]),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((item['ing'] ?? '').isNotEmpty) ...[Container(width: double.infinity, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Text("📌 मुख्य सामग्री / हाइलाइट्स:\n${item['ing']!}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))), const SizedBox(height: 10)],
                              if ((item['steps'] ?? '').isNotEmpty) Text("📝 बनाने की विधि / विवरण:\n${item['steps']!}", style: const TextStyle(fontSize: 14, height: 1.45)),
                              if ((item['yt'] ?? '').isNotEmpty) ...[const SizedBox(height: 10), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () => _playVideoInApp(item['yt']!), icon: const Icon(Icons.play_circle_fill), label: const Text('ऐप में वीडियो देखें ▶️'))]
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
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
  final List<Map<String, String>> alarms = [{'task': '💊 Morning Vitamin / Medicine', 'time': '09:00 AM'}];


  Future<void> _scheduleFlashNotification(String task, TimeOfDay time) async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    final delay = target.difference(now);


    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'shecare_alarm_channel',
      'SheCare Sakhi Alarms',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      playSound: true,
      enableVibration: true,
    );


    Future.delayed(delay, () async {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        '⏰ SheCare Sakhi Reminder!',
        '🌸 $task (${time.format(context)})',
        const NotificationDetails(android: androidDetails),
      );
    });


    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🔔 अलार्म सेट हो गया! ठीक ${time.format(context)} पर स्क्रीन पर अलर्ट फ्लैश होगा।')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⏰ Alarm & Screen Alert'), backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    TextField(controller: _taskCtrl, decoration: const InputDecoration(labelText: 'Reminder Task (Medicine, Meeting...)', border: OutlineInputBorder())),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(onPressed: () async { final t = await showTimePicker(context: context, initialTime: selectedTime); if (t != null) setState(() => selectedTime = t); }, icon: const Icon(Icons.access_alarm), label: Text('Time: ${selectedTime.format(context)}')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
                          onPressed: () async {
                            if (_taskCtrl.text.isNotEmpty) {
                              final task = _taskCtrl.text;
                              setState(() { alarms.insert(0, {'task': task, 'time': selectedTime.format(context)}); _taskCtrl.clear(); });
                              await _scheduleFlashNotification(task, selectedTime);
                            }
                          },
                          child: const Text('+ Set Alert 🔔'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: ListView.builder(itemCount: alarms.length, itemBuilder: (c, i) => Card(child: ListTile(leading: const Icon(Icons.notifications_active, color: Colors.amber), title: Text(alarms[i]['task']!, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('Time: ${alarms[i]['time']}'), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => alarms.removeAt(i)))))))
          ],
        ),
      ),
    );
  }
}


class BMIPage extends StatefulWidget {
  const BMIPage({super.key});
  @override
  State<BMIPage> createState() => _BMIPageState();
}


class _BMIPageState extends State<BMIPage> {
  final TextEditingController _feetCtrl = TextEditingController();
  final TextEditingController _inchCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  String resultText = '';
  Color resultColor = Colors.pink;


  void _calculateBMI() {
    final feet = double.tryParse(_feetCtrl.text.trim()) ?? 0;
    final inch = double.tryParse(_inchCtrl.text.trim()) ?? 0;
    final wKg = double.tryParse(_weightCtrl.text.trim());
    if (feet <= 0 || wKg == null || wKg <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कृपया सही Feet, Inches और Weight (kg) डालें')));
      return;
    }
    final totalInches = (feet * 12) + inch;
    final hCm = totalInches * 2.54;
    final hM = hCm / 100;
    final bmi = wKg / (hM * hM);


    setState(() {
      if (bmi < 18.5) {
        resultText = 'Height: ${hCm.toStringAsFixed(1)} cm\nBMI: ${bmi.toStringAsFixed(1)} (Underweight - पौष्टिक आहार लें 🥗)';
        resultColor = Colors.orange.shade800;
      } else if (bmi < 25) {
        resultText = 'Height: ${hCm.toStringAsFixed(1)} cm\nBMI: ${bmi.toStringAsFixed(1)} (Normal & Healthy - एकदम फिट! 💖)';
        resultColor = Colors.green.shade700;
      } else {
        resultText = 'Height: ${hCm.toStringAsFixed(1)} cm\nBMI: ${bmi.toStringAsFixed(1)} (Overweight - नियमित योग व वॉक करें 🧘‍♀️)';
        resultColor = Colors.red.shade700;
      }
    });
  }


  void _resetBMI() {
    setState(() {
      _feetCtrl.clear();
      _inchCtrl.clear();
      _weightCtrl.clear();
      resultText = '';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚖️ BMI Health Calculator'), backgroundColor: Colors.pink, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('अपनी हाइट (Feet & Inches) और वज़न डालें:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _feetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Feet (जैसे: 5)', border: OutlineInputBorder()))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: _inchCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Inches (जैसे: 6)', border: OutlineInputBorder()))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: _weightCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Weight in kg (जैसे: 55)', border: OutlineInputBorder())),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white), onPressed: _calculateBMI, child: const Text('Calculate BMI ⚖️')),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(onPressed: _resetBMI, icon: const Icon(Icons.refresh), label: const Text('Reset 🔄')),
                  ],
                ),
                if (resultText.isNotEmpty) ...[const SizedBox(height: 16), Text(resultText, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: resultColor))],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class YogaPage extends StatelessWidget {
  const YogaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'yoga', title: '🧘‍♀️ Yoga & Exercise', color: Colors.deepPurple.shade600, initialItems: const [
      {'title': '☀️ सूर्य नमस्कार (12 स्टेप्स और फायदे)', 'tag': '⏱️ 10 मिनट • 🌿 संपूर्ण स्वास्थ्य', 'ing': '• योगा मैट और खुली हवादार जगह\n• खाली पेट सुबह का समय सबसे उत्तम है', 'steps': '1. प्रणामासन से शुरू करके सभी 12 आसनों को गहरी सांस के साथ धीरे-धीरे करें।\n2. यह वजन घटाने, चेहरे पर चमक लाने और हार्मोन संतुलन के लिए सर्वश्रेष्ठ है।', 'yt': ''},
      {'title': '🦋 तितली आसन (Butterfly Pose - महिलाओं के लिए खास)', 'tag': '⏱️ 5 मिनट • 🌸 पीरियड व कमर दर्द में लाभकारी', 'ing': '• आरामदायक ढीले कपड़े और योगा मैट', 'steps': '1. दोनों पैरों के तलवों को आपस में मिलाकर सीधा बैठें।\n2. दोनों घुटनों को तितली के पंखों की तरह 2-3 मिनट धीरे-धीरे ऊपर-नीचे हिलाएं।', 'yt': ''},
    ]);
  }
}


class KidsTiffinPage extends StatelessWidget {
  const KidsTiffinPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'tiffin', title: '🍱 Kids Tiffin Special', color: Colors.green.shade700, initialItems: const [
      {'title': '🌮 मिनी आलू-पनीर परांठा रोल', 'tag': '⏱️ 15 मिनट • 🌟 बच्चों का पसंदीदा', 'ing': '• गेहूँ का आटा (गूँथा हुआ)\n• उबले हुए आलू और कद्दूकस किया पनीर\n• बारीक कटा हरा धनिया, जीरा पाउडर और हल्का नमक', 'steps': '1. आटे की पतली रोटी बेलकर तवे पर हल्का सेंक लें।\n2. आलू और पनीर का चटपटा मसाला रोटी पर फैलाएं।\n3. टाइट रोल बनाकर छोटे टुकड़ों में काटें और टिफिन में पैक करें।', 'yt': ''},
    ]);
  }
}


class RecipePage extends StatelessWidget {
  const RecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'recipe', title: '🍲 Quick Recipes', color: Colors.orange.shade800, initialItems: const [
      {'title': '🍜 5-मिनट वेजी मसाला ओट्स', 'tag': '⏱️ 5 मिनट • 🔥 झटपट रेसिपी', 'ing': '• 1 कप मसाला ओट्स\n• बारीक कटा प्याज़, टमाटर और हरी मटर', 'steps': '1. कढ़ाई में थोड़ा तेल गर्म करके सब्ज़ियों को 1 मिनट भूनें।\n2. डेढ़ कप पानी और ओट्स डालकर 3 मिनट तक पकाएं, गरमागरम तैयार है!', 'yt': ''},
    ]);
  }
}


class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'kitchen', title: '🏡 Kitchen & Home Hacks', color: Colors.teal.shade700, initialItems: const [
      {'title': '🍋 फ्रिज की बदबू हटाने का आसान उपाय', 'tag': '✨ स्मार्ट किचन हैक', 'ing': '• 2 चम्मच बेकिंग सोडा या आधा कटा नींबू', 'steps': '1. एक छोटी कटोरी में बेकिंग सोडा रखकर फ्रिज के कोने में रख दें।\n2. यह कुछ ही घंटों में फ्रिज की सारी दुर्गंध सोख लेगा।', 'yt': ''},
    ]);
  }
}


class BeautyPage extends StatelessWidget {
  const BeautyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'beauty', title: '💄 Health & Beauty Care', color: Colors.pink.shade600, initialItems: const [
      {'title': '✨ बेसन और हल्दी का नेचुरल ग्लो पैक', 'tag': '🌿 100% प्राकृतिक • 15 मिनट', 'ing': '• 2 चम्मच बेसन और चुटकी भर कस्तूरी हल्दी\n• 2 चम्मच गुलाब जल या कच्चा दूध', 'steps': '1. सभी चीज़ों को मिलाकर गाढ़ा पेस्ट बनाएं और चेहरे पर लगाएं।\n2. 15 मिनट बाद ठंडे पानी से धो लें, चेहरे पर तुरंत निखार आ जाएगा।', 'yt': ''},
    ]);
  }
}


class HomeSalonPage extends StatelessWidget {
  const HomeSalonPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'salon', title: '💅 Home Salon & Makeup', color: Colors.purple.shade700, adminOnlyAdd: true, initialItems: const [
      {'title': '💋 5-मिनट पार्टी ग्लो मेकअप गाइड', 'tag': '💄 पार्टी रेडी • 5 मिनट', 'ing': '• मॉइस्चराइज़र, प्राइमर और बीबी क्रीम\n• काजल, मस्कारा और न्यूड लिपस्टिक', 'steps': '1. चेहरे को साफ़ करके मॉइस्चराइज़र और प्राइमर लगाएं।\n2. हल्की बीबी क्रीम ब्लेंड करें और गालों पर हल्का गुलाबी ब्लश लगाएं।\n3. काजल, मस्कारा और लिपस्टिक से अपना पार्टी लुक पूरा करें।', 'yt': ''},
    ]);
  }
}


class BhaktiPathPage extends StatelessWidget {
  const BhaktiPathPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'bhakti', title: '🛕 Bhakti Path & Aarti', color: Colors.deepOrange.shade700, adminOnlyAdd: true, initialItems: const [
      {'title': '🪔 श्री गणेश जी की आरती (ऑफलाइन)', 'tag': '🕉️ संपूर्ण आरती व पूजा विधि', 'ing': '• घी का दीपक, कपूर, दूर्वा घास और मोदक', 'steps': 'जय गणेश जय गणेश जय गणेश देवा,\nमाता जाकी पार्वती पिता महादेवा।\nएकदंत दयावंत चार भुजा धारी,\nमाथे सिंदूर सोहे मूसे की सवारी॥\n\nपूजा विधि: सुबह स्नान के बाद स्वच्छ वस्त्र पहनकर गणपति जी को दूर्वा व मोदक अर्पित करें और आरती करें।', 'yt': ''},
    ]);
  }
}


class VideoPage extends StatelessWidget {
  const VideoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SmartContentPage(storageKey: 'aivideo', title: '🎬 AI Video Guide', color: Colors.deepPurple, adminOnlyAdd: true, initialItems: const [
      {'title': '🧘‍♀️ 5-मिनट मॉर्निंग फेस योगा व ग्लो टिप्स', 'tag': '🎬 AI हेल्थ व ब्यूटी गाइड', 'ing': '• साफ़ चेहरा और हल्का मॉइस्चराइज़र', 'steps': '1. गहरी सांस लें और गालों को फुलाकर 10 सेकंड रोकें।\n2. नीचे दिए गए प्ले बटन से ऐप के अंदर ही वीडियो देखें!', 'yt': 'https://youtube.com'},
    ]);
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
        actions: unlocked ? [IconButton(icon: const Icon(Icons.text_decrease), onPressed: () => setState(() { if (diaryFontSize > 12) diaryFontSize -= 2; })), IconButton(icon: const Icon(Icons.text_increase), onPressed: () => setState(() { if (diaryFontSize < 24) diaryFontSize += 2; })), IconButton(icon: const Icon(Icons.format_italic), onPressed: () => setState(() => isItalic = !isItalic))] : null,
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
                      if (_pinCtrl.text.length != 4) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a 4-digit PIN'))); return; }
                      if (storedPin == null) { final prefs = await SharedPreferences.getInstance(); await prefs.setString('diary_pin', _pinCtrl.text); setState(() { storedPin = _pinCtrl.text; unlocked = true; }); }
                      else if (_pinCtrl.text == storedPin) { setState(() => unlocked = true); }
                      else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Wrong PIN! Try again.'))); }
                    },
                    child: Text(storedPin == null ? 'Set PIN & Open Diary 🔐' : 'Unlock Diary 🔓'),
                  )
                ],
              )
            : Column(
                children: [
                  TextField(controller: _noteCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'अपनी निजी बात लिखें...', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white), onPressed: () { if (_noteCtrl.text.isNotEmpty) { setState(() { notes.insert(0, _noteCtrl.text); _noteCtrl.clear(); }); _saveNotes(); } }, icon: const Icon(Icons.save), label: const Text('Save Private Note 💖')),
                  const Divider(),
                  Expanded(child: notes.isEmpty ? const Center(child: Text('आपकी डायरी अभी बिल्कुल खाली और सुरक्षित है। ✨', style: TextStyle(color: Colors.black54))) : ListView.builder(itemCount: notes.length, itemBuilder: (c, i) => Card(child: ListTile(leading: const Text('🔒'), title: Text(notes[i], style: TextStyle(fontSize: diaryFontSize, fontStyle: isItalic ? FontStyle.italic : FontStyle.normal)), trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () { setState(() => notes.removeAt(i)); _saveNotes(); }))))),
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton(onPressed: () { setState(() => glasses++); if (glasses == 8) showDialog(context: context, builder: (c) => AlertDialog(title: const Text('🎉 बधाई हो सखी!'), content: const Text('आपका आज का 8 गिलास पानी पीने का लक्ष्य पूरा हुआ! 💧✨'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('शुक्रिया 💖'))])); }, child: const Text('+ 1 Glass')), const SizedBox(width: 12), TextButton(onPressed: () => setState(() => glasses = 0), child: const Text('Reset'))]),
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton(onPressed: () { final val = double.tryParse(_ctrl.text); if (val != null && val > 0) { setState(() { total += val; _ctrl.clear(); }); if (total >= 5000) showDialog(context: context, builder: (c) => AlertDialog(title: const Text('⚠️ बजट चेतावनी!'), content: const Text('सावधान! आपका कुल खर्च ₹5000 से ऊपर चला गया है।'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('ठीक है'))])); } }, child: const Text('+ Add Expense')), const SizedBox(width: 10), TextButton(onPressed: () => setState(() => total = 0), child: const Text('Reset'))]),
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