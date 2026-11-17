lib/main.dart 'योगा और प्राणायाम', 'color': Colors.indigo.shade600, 'page': const LiveCategoryPage(title: '🧘‍♀️ Yoga & Exercise', category: 'yoga', color: Colors.indigo)},
      {'title': '🎬 Video Guide', 'sub': 'उपयोगी वीडियो गाइड', 'color': Colors.red.shade600, 'page': const LiveCategoryPage(title: '🎬 Video Guide', category: 'aivideo', color: Colors.red)},
      {'title': '📔 Secret Diary', 'sub': 'पिन-लॉक्ड निजी डायरी', 'color': Colors.brown.shade700, 'page': const DiaryPage()},
    ];


    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      appBar: AppBar(
        title: const Text('🌸 SheCare Sakhi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFD81B60),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadLiveQuotes();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔄 App Refreshed & Synced! ✅'), duration: Duration(seconds: 1)),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Card(
              color: const Color(0xFFFCE4EC),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hello Beautiful! 💖', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF880E4F))),
                        Text(timeStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFAD1457))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => setState(() => quoteIndex = (quoteIndex + 1) % quotes.length),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: Text('✨ आज का सुविचार: ${quotes[quoteIndex]}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: features.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.45, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, i) {
                final f = features[i];
                final Color c = f['color'] as Color;
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => f['page'] as Widget)),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withValues(alpha: 0.4))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(f['title'] as String, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: c)),
                        const SizedBox(height: 4),
                        Text(f['sub'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black87)),
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
class LiveCategoryPage extends StatefulWidget {
  final String title;
  final String category;
  final Color color;
  const LiveCategoryPage({super.key, required this.title, required this.category, required this.color});
  @override
  State<LiveCategoryPage> createState() => _LiveCategoryPageState();
}


class _LiveCategoryPageState extends State<LiveCategoryPage> {
  List<Map<String, dynamic>> items = [];
  bool loading = true;
  String query = '';
  String selectedSub = 'सभी';


  @override
  void initState() {
    super.initState();
    _loadData();
  }


  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cat_${widget.category}');
      if (cached != null) {
        final list = List<Map<String, dynamic>>.from(jsonDecode(cached));
        if (mounted) setState(() { items = list; loading = false; });
      }
      final res = await http.get(kContentJsonUri).timeout(const Duration(seconds: 12));
      if (res.statusCode == 200) {
        final List<dynamic> raw = jsonDecode(utf8.decode(res.bodyBytes));
        final filteredCat = raw
            .where((e) => e is Map && (e['category'] ?? '').toString().trim().toLowerCase() == widget.category)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        await prefs.setString('cat_${widget.category}', jsonEncode(filteredCat));
        if (mounted) setState(() { items = filteredCat; loading = false; });
      }
    } catch (_) {
      if (mounted) setState(() => loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final filtered = items.where((e) {
      final subMatch = selectedSub == 'सभी' || (e['sub'] ?? '').toString().trim() == selectedSub;
      final qMatch = (e['title'] ?? '').toString().toLowerCase().contains(query.toLowerCase()) ||
          (e['steps'] ?? '').toString().toLowerCase().contains(query.toLowerCase());
      return subMatch && qMatch;
    }).toList();


    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: widget.color, foregroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: '🔍 खोजें (Search)...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Builder(builder: (_) {
            final subs = <String>{'सभी'};
            for (final it in items) {
              final s = (it['sub'] ?? '').toString().trim();
              if (s.isNotEmpty) subs.add(s);
            }
            if (subs.length <= 1) return const SizedBox.shrink();
            return SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: subs.map((s) {
                  final active = selectedSub == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s, style: TextStyle(color: active ? Colors.white : widget.color, fontWeight: FontWeight.bold)),
                      selected: active,
                      selectedColor: widget.color,
                      backgroundColor: widget.color.withValues(alpha: 0.1),
                      onSelected: (_) => setState(() => selectedSub = s),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('अभी कोई सामग्री उपलब्ध नहीं है।'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final it = filtered[i];
                          final ytUrl = (it['yt'] ?? '').toString().trim();
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ExpansionTile(
                              title: Text(it['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(it['tag'] ?? ''),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if ((it['ing'] ?? '').toString().isNotEmpty) ...[
                                        const Text('📌 आवश्यक सामग्री:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text(it['ing']),
                                        const SizedBox(height: 8),
                                      ],
                                      const Text('📝 संपूर्ण विवरण / विधि:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(it['steps'] ?? ''),
                                      if (ytUrl.isNotEmpty) ...[
                                        const SizedBox(height: 10),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                          onPressed: () => launchUrl(Uri.parse(ytUrl)),
                                          icon: const Icon(Icons.play_arrow),
                                          label: const Text('वीडियो देखें 🎬'),
                                        ),
                                      ]
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
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
  String statusMsg = 'आपातकाल (Emergency) में नीचे लाल बटन को 3 बार तेज़ी से दबाएं 👇';


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
    final prefs = await SharedPreferences.getInstance();
    final n1 = _num1Ctrl.text.trim();
    final n2 = _num2Ctrl.text.trim();
    if (n1.isNotEmpty) {
      await prefs.setString('sos_num1', n1);
      savedNum1 = n1;
      _num1Ctrl.clear();
    }
    if (n2.isNotEmpty) {
      await prefs.setString('sos_num2', n2);
      savedNum2 = n2;
      _num2Ctrl.clear();
    }
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ इमरजेंसी नंबर सेव हो गए!')));
    }
  }


  Future<void> _handleTripleTap() async {
    setState(() => tapCount++);
    if (tapCount >= 3) {
      setState(() {
        tapCount = 0;
        statusMsg = '🚨 SOS अलर्ट भेजा जा रहा है...';
      });
      String locText = 'Location unavailable';
      try {
        LocationPermission p = await Geolocator.checkPermission();
        if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
        if (p == LocationPermission.always || p == LocationPermission.whileInUse) {
          final pos = await Geolocator.getCurrentPosition();
          locText = 'https://google.com{pos.latitude},${pos.longitude}';
        }
      } catch (_) {}
      final target = savedNum1.isNotEmpty ? savedNum1 : savedNum2;
      if (target.isNotEmpty) {
        final msg = Uri.encodeComponent('🚨 EMERGENCY! मुझे तुरंत मदद की ज़रूरत है। मेरी लाइव लोकेशन: $locText');
        await launchUrl(Uri.parse('sms:+91$target?body=$msg'));
      } else {
        await launchUrl(Uri.parse('tel:112'));
      }
    }
  }
    @override
  Widget build(BuildContext context) {
    final activeTarget = savedNum1.isNotEmpty ? savedNum1 : savedNum2;
    return Scaffold(
      appBar: AppBar(title: const Text('🚨 SOS - आपातकालीन मदद'), backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (savedNum1.isNotEmpty || savedNum2.isNotEmpty)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✅ सेव किए गए नंबर (हटाने के लिए 🗑️ दबाएं):', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(height: 6),
                      if (savedNum1.isNotEmpty)
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('👤 Primary: +91 $savedNum1', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red),
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('sos_num1');
                              setState(() => savedNum1 = '');
                            },
                          ),
                        ]),
                      if (savedNum2.isNotEmpty)
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('👤 Backup: +91 $savedNum2', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red),
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('sos_num2');
                              setState(() => savedNum2 = '');
                            },
                          ),
                        ]),
                      if (activeTarget.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                            onPressed: () => launchUrl(Uri.parse('tel:+91$activeTarget')),
                            icon: const Icon(Icons.phone_in_talk),
                            label: Text('📞 Call Family Now (+91 $activeTarget)'),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(statusMsg, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _handleTripleTap,
              child: CircleAvatar(
                radius: 68,
                backgroundColor: Colors.red.shade800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🚨', style: TextStyle(fontSize: 38)),
                    const Text('3-TAP SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Taps: $tapCount / 3', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white),
                  onPressed: () => launchUrl(Uri.parse('tel:112')),
                  icon: const Icon(Icons.local_police),
                  label: const Text('Police 112'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade700, foregroundColor: Colors.white),
                  onPressed: () => launchUrl(Uri.parse('tel:1091')),
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Women 1091'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  if (await FlutterContacts.requestPermission(readonly: true)) {
                    final c = await FlutterContacts.openExternalPick();
                    if (c != null && c.phones.isNotEmpty) {
                      final raw = c.phones.first.number.replaceAll(RegExp(r'\D'), '');
                      final ten = raw.length >= 10 ? raw.substring(raw.length - 10) : raw;
                      setState(() => _num1Ctrl.text = ten);
                    }
                  }
                },
                icon: const Icon(Icons.contacts),
                label: const Text('📱 फ़ोनबुक से नंबर चुनें (Pick from Contacts)'),
              ),
            ),
            const SizedBox(height: 10),
            TextField(controller: _num1Ctrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'नया Primary नंबर जोड़ें (10 अंक)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _num2Ctrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'नया Backup नंबर जोड़ें (10 अंक)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _saveNumbers, child: const Text('💾 नंबर सेव करें (Save Contacts)'))),
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
  bool reminderOn = false;


  @override
  void initState() {
    super.initState();
    _loadWater();
  }


  Future<void> _loadWater() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      glasses = prefs.getInt('water_glasses') ?? 0;
      reminderOn = prefs.getBool('water_rem_on') ?? false;
    });
  }


  Future<void> _addGlass() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => glasses++);
    await prefs.setInt('water_glasses', glasses);
    if (glasses == 8) {
      await showSakhiNotification(
        id: 902,
        title: '🎉 बधाई हो सखी! लक्ष्य पूरा हुआ!',
        body: 'आपका आज का 8 गिलास पानी पीने का टारगेट पूरा हो गया है! 💧🏆',
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('🎉 बधाई हो सखी!'),
            content: const Text('आपका आज का 8 गिलास पानी पीने का लक्ष्य पूरा हुआ! 💧✨'),
            actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('शुक्रिया 💖'))],
          ),
        );
      }
    }
  }


  Future<void> _toggleHourlyReminder(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => reminderOn = val);
    await prefs.setBool('water_rem_on', val);
    if (val) {
      await flutterLocalNotificationsPlugin.periodicallyShow(
        901,
        '💧 पानी पीने का समय हो गया है सखी!',
        'स्वस्थ रहने के लिए अभी 1 गिलास पानी पीएं।',
        RepeatInterval.hourly,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'sakhi_alerts_channel',
            'SheCare Sakhi Alerts & Alarms',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            actions: [AndroidNotificationAction('DRANK_YES', 'हां पी लिया (+1 गिलास) ✅', showsUserInterface: true)],
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      await showSakhiNotification(
        id: 901,
        title: '💧 वाटर रिमाइंडर चालू हो गया है!',
        body: 'हर घंटे आपको पानी पीने की सूचना मिलेगी। नीचे से सीधे काउंट करें!',
        withAction: true,
      );
    } else {
      await flutterLocalNotificationsPlugin.cancel(901);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🥤 Water Tracker & Reminder'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('💧', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 12),
              Text('$glasses / 8 Glasses', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _addGlass,
                    icon: const Icon(Icons.local_drink),
                    label: const Text('+ 1 Glass (हां पी लिया)'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('water_glasses', 0);
                      setState(() => glasses = 0);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.blue.shade50,
                child: SwitchListTile(
                  title: const Text('🔔 हर घंटे पानी पीने का नोटिफिकेशन', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('फ़ोन के बाहर आवाज़ के साथ याद दिलाएगा'),
                  value: reminderOn,
                  onChanged: _toggleHourlyReminder,
                ),
              ),
            ],
          ),
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
  TimeOfDay? selectedTime;
  Timer? _alarmChecker;
  bool triggered = false;


  @override
  void initState() {
    super.initState();
    _alarmChecker = Timer.periodic(const Duration(seconds: 2), (_) {
      if (selectedTime != null && !triggered) {
        final now = TimeOfDay.now();
        if (now.hour == selectedTime!.hour && now.minute == selectedTime!.minute) {
          triggered = true;
          final taskName = _taskCtrl.text.trim().isEmpty ? 'आपका निर्धारित अलार्म समय हो गया है!' : _taskCtrl.text.trim();
          showSakhiNotification(id: 905, title: '⏰ SheCare Sakhi अलार्म!', body: taskName);
          if (mounted) {
            showDialog(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('⏰ अलार्म बज रहा है!'),
                content: Text(taskName, style: const TextStyle(fontSize: 18)),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(c);
                      setState(() => selectedTime = null);
                    },
                    child: const Text('बंद करें (Stop)'),
                  )
                ],
              ),
            );
          }
        }
      }
    });
  }


  @override
  void dispose() {
    _alarmChecker?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⏰ Alarm & Sound Alert'), backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskCtrl,
                  decoration: const InputDecoration(labelText: 'Reminder Task (दवा, मीटिंग, पूजा...)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () async {
                    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (t != null) setState(() { selectedTime = t; triggered = false; });
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(selectedTime == null ? 'समय चुनें (Pick Time)' : 'चुना गया समय: ${selectedTime!.format(context)}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}


class _DiaryPageState extends State<DiaryPage> {
  final TextEditingController _pinCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  String savedPin = '';
  String photoPath = '';
  bool unlocked = false;


  @override
  void initState() {
    super.initState();
    _loadDiary();
  }


  Future<void> _loadDiary() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedPin = prefs.getString('diary_pin') ?? '';
      _noteCtrl.text = prefs.getString('diary_text') ?? '';
      photoPath = prefs.getString('diary_photo') ?? '';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📔 Secret Diary'), backgroundColor: Colors.brown.shade700, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: !unlocked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(savedPin.isEmpty ? 'अपना 4-अंकों का नया PIN सेट करें:' : 'डायरी खोलने के लिए PIN डालें:'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _pinCtrl,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: '4-Digit PIN'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      if (savedPin.isEmpty && _pinCtrl.text.length == 4) {
                        await prefs.setString('diary_pin', _pinCtrl.text);
                        setState(() { savedPin = _pinCtrl.text; unlocked = true; });
                      } else if (_pinCtrl.text == savedPin) {
                        setState(() => unlocked = true);
                      } else {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ गलत PIN!')));
                      }
                    },
                    child: Text(savedPin.isEmpty ? 'PIN सेट करें' : 'खोलें 🔓'),
                  )
                ],
              )
            : Column(
                children: [
                  if (photoPath.isNotEmpty && File(photoPath).existsSync())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(photoPath), height: 140, width: double.infinity, fit: BoxFit.cover),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _noteCtrl,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(hintText: 'अपने मन की बातें यहाँ लिखें...', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (img != null) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('diary_photo', img.path);
                            setState(() => photoPath = img.path);
                          }
                        },
                        icon: const Icon(Icons.photo),
                        label: const Text('📷 फ़ोटो जोड़ें'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('diary_text', _noteCtrl.text);
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ डायरी व फ़ोटो सेव हो गई!')));
                          },
                          child: const Text('💾 सेव करें'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
