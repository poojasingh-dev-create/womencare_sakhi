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
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeDashboard()));
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
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});
  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}


class _HomeDashboardState extends State<HomeDashboard> {
  String lang = 'HI';
  String timeStr = '';
  Timer? _clockTimer;
  int quoteIndex = 0;


  final Map<String, Map<String, String>> tr = {
    'EN': {'welcome': 'Hello Beautiful! ✨', 'quoteTitle': 'Thought of the Day', 'period': 'Period Tracker', 'diary': 'Secret Diary', 'alarm': 'Alarm & Reminder', 'tiffin': 'Kids Tiffin', 'recipe': 'Quick Recipes', 'tips': 'Kitchen & Beauty', 'grocery': 'Grocery List', 'video': 'AI Video Hacks', 'budget': 'Smart Budget', 'water': 'Water Tracker', 'rate': 'Rate & Review'},
    'HI': {'welcome': 'नमस्ते सखी! ✨', 'quoteTitle': 'आज का सुविचार', 'period': 'पीरियड ट्रैकर', 'diary': 'सीक्रेट डायरी', 'alarm': 'अलार्म व रिमाइंडर', 'tiffin': 'किड्स टिफिन', 'recipe': 'झटपट रेसिपी', 'tips': 'किचन और ब्यूटी', 'grocery': 'राशन लिस्ट', 'video': 'AI वीडियो गाइड', 'budget': 'स्मार्ट बजट', 'water': 'वाटर ट्रैकर', 'rate': 'रेटिंग व सुझाव'},
    'MR': {'welcome': 'नमस्कार सखी! ✨', 'quoteTitle': 'आजचा सुविचार', 'period': 'मासिक पाळी ट्रॅकर', 'diary': 'सीक्रेट डायरी', 'alarm': 'अलार्म आणि रिमाइंडर', 'tiffin': 'किड्स टिफिन', 'recipe': 'झटपट रेसिपी', 'tips': 'किचन आणि ब्युटी', 'grocery': 'किराणा यादी', 'video': 'AI व्हिडिओ गाईड', 'budget': 'स्मार्ट बजेट', 'water': 'वॉटर ट्रॅकर', 'rate': 'रेटिंग आणि अभिप्राय'},
    'PA': {'welcome': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ ਸਖੀ! ✨', 'quoteTitle': 'ਅੱਜ ਦਾ ਵਿਚਾਰ', 'period': 'ਪੀਰੀਅਡ ਟਰੈਕਰ', 'diary': 'ਸੀਕ੍ਰੇਟ ਡਾਇਰੀ', 'alarm': 'ਅਲਾਰਮ ਤੇ ਰਿਮਾਈਂਡਰ', 'tiffin': 'ਕਿਡਜ਼ ਟਿਫਿਨ', 'recipe': 'ਝਟਪਟ ਰੈਸਿਪੀ', 'tips': 'ਰਸੋਈ ਤੇ ਬਿਊਟੀ', 'grocery': 'ਰਾਸ਼ਨ ਲਿਸਟ', 'video': 'AI ਵੀਡੀਓ ਗਾਈਡ', 'budget': 'ਸਮਾਰਟ ਬਜਟ', 'water': 'ਪਾਣੀ ਟਰੈਕਰ', 'rate': 'ਰੇਟਿੰਗ ਤੇ ਸੁਝਾਅ'},
    'TA': {'welcome': 'வணக்கம் தோழி! ✨', 'quoteTitle': 'இன்றைய சிந்தனை', 'period': 'மாதவிடாய் கண்காணிப்பு', 'diary': 'ரகசிய நாட்குறிப்பு', 'alarm': 'அலாரம் & நினைவூட்டல்', 'tiffin': 'குழந்தைகள் டிபன்', 'recipe': 'சமையல் குறிப்புகள்', 'tips': 'சமையலறை & அழகு', 'grocery': 'மளிகை பட்டியல்', 'video': 'AI வீடியோ வழிகாட்டி', 'budget': 'ஸ்மார்ட் பட்ஜெட்', 'water': 'தண்ணீர் அளவு', 'rate': 'மதிப்பீடு & கருத்து'},
    'KN': {'welcome': 'ನಮಸ್ಕಾರ ಗೆಳತಿ! ✨', 'quoteTitle': 'ಇಂದಿನ ಸುಭಾಷಿತ', 'period': 'ಪಿರಿಯಡ್ ಟ್ರ್ಯಾಕರ್', 'diary': 'ಸೀಕ್ರೆಟ್ ಡೈರಿ', 'alarm': 'ಅಲಾರಂ ಮತ್ತು ರಿಮೈಂಡರ್', 'tiffin': 'ಕಿಡ್ಸ್ ಟಿಫಿನ್', 'recipe': 'ತ್ವರಿತ ಅಡುಗೆ', 'tips': 'ಕಿಚನ್ ಮತ್ತು ಬ್ಯೂಟಿ', 'grocery': 'ದಿನಸಿ ಪಟ್ಟಿ', 'video': 'AI ವಿಡಿಯೋ ಗೈಡ್', 'budget': 'ಸ್ಮಾರ್ಟ್ ಬಜೆಟ್', 'water': 'ನೀರಿನ ಟ್ರ್ಯಾಕರ್', 'rate': 'ರೇಟಿಂಗ್ ಮತ್ತು ವಿಮರ್ಶೆ'},
    'UR': {'welcome': 'آداب سہیلی! ✨', 'quoteTitle': 'آج کی اچھی بات', 'period': 'پیریڈ ٹریکر', 'diary': 'سیکریٹ ڈائری', 'alarm': 'الارم اور ریمائنڈر', 'tiffin': 'کڈز ٹفن', 'recipe': 'فوری پکوان', 'tips': 'کچن اور بیوٹی', 'grocery': 'راشن کی فہرست', 'video': 'AI ویڈیو گائیڈ', 'budget': 'اسمارٹ بجٹ', 'water': 'واٹر ٹریکر', 'rate': 'ریٹنگ اور رائے'},
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
  Future<void> shareOnWhatsApp(String text) async {
    final Uri url = Uri.parse("https://wa.me{Uri.encodeComponent(text)}");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }


  Future<void> triggerSOS() async {
    final Uri telUri = Uri(scheme: 'tel', path: '112');
    await launchUrl(telUri);
  }


  @override
  Widget build(BuildContext context) {
    final t = tr[lang]!;
    final List<Map<String, dynamic>> menuItems = [
      {'title': t['period']!, 'icon': '🌸', 'color': const Color(0xFFFCE4EC), 'page': const PeriodPage()},
      {'title': t['diary']!, 'icon': '📔', 'color': const Color(0xFFF3E5F5), 'page': const SecretDiaryPage()},
      {'title': t['alarm']!, 'icon': '⏰', 'color': const Color(0xFFFFF8E1), 'page': const AlarmPage()},
      {'title': t['tiffin']!, 'icon': '🍱', 'color': const Color(0xFFE8F5E9), 'page': const KidsTiffinPage()},
      {'title': t['recipe']!, 'icon': '🍲', 'color': const Color(0xFFFFF3E0), 'page': const RecipePage()},
      {'title': t['tips']!, 'icon': '🏡', 'color': const Color(0xFFE0F2F1), 'page': const TipsPage()},
      {'title': t['grocery']!, 'icon': '🛒', 'color': const Color(0xFFFFFDE7), 'page': const GroceryPage()},
      {'title': t['video']!, 'icon': '🎬', 'color': const Color(0xFFEDE7F6), 'page': const VideoPage()},
      {'title': t['budget']!, 'icon': '💰', 'color': const Color(0xFFE0F7FA), 'page': const BudgetPage()},
      {'title': t['water']!, 'icon': '🥤', 'color': const Color(0xFFE3F2FD), 'page': const WaterPage()},
      {'title': t['rate']!, 'icon': '⭐', 'color': const Color(0xFFFFEBEE), 'page': const RatePage()},
    ];


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        title: const Text('🌸 SheCare Sakhi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          DropdownButton<String>(
            value: lang,
            dropdownColor: const Color(0xFFE91E63),
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.white),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            items: const [
              DropdownMenuItem(value: 'HI', child: Text('हिंदी')),
              DropdownMenuItem(value: 'MR', child: Text('मराठी')),
              DropdownMenuItem(value: 'EN', child: Text('English')),
              DropdownMenuItem(value: 'PA', child: Text('ਪੰਜਾਬੀ')),
              DropdownMenuItem(value: 'TA', child: Text('தமிழ்')),
              DropdownMenuItem(value: 'KN', child: Text('ಕನ್ನಡ')),
              DropdownMenuItem(value: 'UR', child: Text('اردو')),
            ],
            onChanged: (v) { if (v != null) setState(() => lang = v); },
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10)),
              onPressed: triggerSOS,
              icon: const Icon(Icons.warning_amber_rounded, size: 16),
              label: const Text('SOS', style: TextStyle(fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t['welcome']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF880E4F))),
                    Row(children: [const Icon(Icons.access_time_filled, size: 18, color: Color(0xFFE91E63)), const SizedBox(width: 4), Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF880E4F)))]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: Colors.white.withOpacity(0.95),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      Text('✨ ${t['quoteTitle']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                      const SizedBox(height: 8),
                      Text(quotes[quoteIndex], textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: () => setState(() => quoteIndex = (quoteIndex + 1) % quotes.length), child: const Text('Next 🌸')),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.95),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['page'])),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: item['color'], borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 5)]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['icon'], style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 6),
                          Text(item['title'], textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Apni Pichli Period Date Chunein:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2025), lastDate: DateTime(2028));
                        if (picked != null) setState(() => lastDate = picked);
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Select Date'),
                    ),
                    if (lastDate != null) ...[
                      const SizedBox(height: 16),
                      Text('Agli Expected Date: ${lastDate!.add(const Duration(days: 28)).toString().split(' ')}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
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
                  ElevatedButton(
                    onPressed: () {
                      if (_pinCtrl.text == "1234") {
                        setState(() => unlocked = true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Galat PIN! (1234 try karein)')));
                      }
                    },
                    child: const Text('Unlock Diary 🔓'),
                  )
                ],
              )
            : Column(
                children: [
                  TextField(controller: _noteCtrl, decoration: const InputDecoration(labelText: 'Apni secret baat likhein...', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_noteCtrl.text.isNotEmpty) {
                        setState(() { notes.insert(0, _noteCtrl.text); _noteCtrl.clear(); });
                      }
                    },
                    child: const Text('Save Note 💖'),
                  ),
                  const Divider(),
                  Expanded(child: ListView.builder(itemCount: notes.length, itemBuilder: (c, i) => Card(child: ListTile(leading: const Text('🔒'), title: Text(notes[i]))))),
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
                        TextButton.icon(
                          onPressed: () async {
                            final t = await showTimePicker(context: context, initialTime: selectedTime);
                            if (t != null) setState(() => selectedTime = t);
                          },
                          icon: const Icon(Icons.access_alarm),
                          label: Text('Time: ${selectedTime.format(context)}'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_taskCtrl.text.isNotEmpty) {
                              setState(() {
                                alarms.insert(0, {'task': _taskCtrl.text, 'time': selectedTime.format(context)});
                                _taskCtrl.clear();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⏰ Reminder Set Ho Gaya!')));
                            }
                          },
                          child: const Text('+ Set Alarm'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (c, i) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active, color: Colors.amber),
                    title: Text(alarms[i]['task']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Time: ${alarms[i]['time']}'),
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => alarms.removeAt(i))),
                  ),
                ),
              ),
            )
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
    final tiffins = [
      {'title': '🌮 Mini Aloo-Paneer Paratha Roll', 'desc': 'Samagri: Gehu ka aata, uble aloo, paneer, hara dhaniya.\nTarika: Patli roti belkar aloo-paneer ki stuffing bharein, roll banakar tave par sek lein.'},
      {'title': '🥞 Suji-Veggie Mini Uttapam', 'desc': 'Samagri: 1 cup suji, dahi, barik kati gajar, shimla mirch.\nTarika: Batter banakar chote-chote uttapam tave par sek lein. Bacchon ko bahut pasand aate hain!'},
      {'title': '🥪 Cheesy Corn & Mayo Toast', 'desc': 'Samagri: Brown bread, uble sweet corn, cheese, thoda butter.\nTarika: Corn aur cheese milakar bread par lagayein aur golden hone tak toast karein.'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('🍱 Kids Tiffin Special'), backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: tiffins.length,
        itemBuilder: (c, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(tiffins[i]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(tiffins[i]['desc']!)),
          ),
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
  final List<Map<String, dynamic>> items = [
    {'name': '🥛 Doodh & Dahi', 'done': false},
    {'name': '🍅 Tamatar & Sabziyan', 'done': false},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Smart Grocery List'),
        backgroundColor: Colors.amber.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.delete_sweep), tooltip: 'Clear List', onPressed: () => setState(() => items.clear())),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: _itemCtrl, decoration: const InputDecoration(labelText: 'Saman ka naam likhein...', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_itemCtrl.text.isNotEmpty) {
                      setState(() { items.add({'name': _itemCtrl.text, 'done': false}); _itemCtrl.clear(); });
                    }
                  },
                  child: const Text('+ Add'),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (c, i) => CheckboxListTile(
                  title: Text(items[i]['name'], style: TextStyle(decoration: items[i]['done'] ? TextDecoration.lineThrough : null)),
                  value: items[i]['done'],
                  onChanged: (v) => setState(() => items[i]['done'] = v!),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class RecipePage extends StatelessWidget {
  const RecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    final recipes = [
      {'title': '🍜 5-Min Hostel Masala Oats', 'desc': 'Samagri: Masala oats, 1 cup pani, tamatar, pyaz.\nTarika: Sabziyon ko 1 min bhunein, pani aur oats dalkar 3 min pakayein.'},
      {'title': '🥗 Sprouts Chaat Bowl', 'desc': 'Samagri: Uble moong sprouts, kheera, nimbu ras, chaat masala.\nTarika: Sabko ek bowl me milayein, healthy aur tasty nashta taiyar hai!'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('🍲 Quick Recipes'), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: recipes.length,
        itemBuilder: (c, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(recipes[i]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(recipes[i]['desc']!)),
          ),
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
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('🏡 Kitchen & Beauty'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: tips.length,
        itemBuilder: (c, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(tips[i]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
            subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(tips[i]['desc']!)),
          ),
        ),
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
                TextField(controller: _ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rakam likhein (₹)', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () { final val = double.tryParse(_ctrl.text); if (val != null && val > 0) setState(() { total += val; _ctrl.clear(); }); }, child: const Text('+ Kharch Jodein')),
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
                ElevatedButton(onPressed: () => setState(() => glasses++), child: const Text('+ 1 Glass Piya')),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => IconButton(
                icon: Icon(index < stars ? Icons.star : Icons.star_border, color: Colors.amber, size: 38),
                onPressed: () => setState(() => stars = index + 1),
              )),
            ),
            const SizedBox(height: 12),
            TextField(controller: _revCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Apna sujhav ya review likhein...', border: OutlineInputBorder())),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
              onPressed: () { _revCtrl.clear(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dhanyawad! Aapki $stars-Star rating save ho gayi hai 💖'))); },
              icon: const Icon(Icons.send),
              label: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}