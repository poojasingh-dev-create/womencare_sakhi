import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: SakhiHomeScreen()));

class SakhiHomeScreen extends StatefulWidget {
  const SakhiHomeScreen({super.key});
  @override
  State<SakhiHomeScreen> createState() => SakhiHomeScreenState();
}

class SakhiHomeScreenState extends State<SakhiHomeScreen> {
  int glassCount = 0;
  int quoteIndex = 0;
  int totalSpend = 0;
  DateTime? lastDate;
  DateTime? nextDate;
  final TextEditingController expCtrl = TextEditingController();

  final List<String> quotes = [
    "Ek naya din, ek nayi shuruaat! Aapki muskaan hi aapki sabse badi taqat hai. ✨",
    "Khubsoorat soch hi khubsoorat jeevan ko janam deti hai. 🌸",
    "Khud par vishwas rakhein, aap har mushkil ko aasan bana sakti hain. 💪💖",
  ];

  void nextQuote() => setState(() => quoteIndex = Random().nextInt(quotes.length));

  void shareQuote() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📲 WhatsApp Share Ready: \"${quotes[quoteIndex]}\""), backgroundColor: Colors.green),
    );
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        lastDate = picked;
        nextDate = picked.add(const Duration(days: 28));
      });
    }
  }

  void playAIVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🎬 AI Quick Tip Video play ho rahi hai! (1-Min Smart Hack) ▶️"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void drinkWater() {
    setState(() => glassCount++);
    if (glassCount == 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🎉 Waah! 8 glass ka target poora hua! 🥳"), backgroundColor: Colors.green),
      );
    }
  }

  void resetWater() => setState(() => glassCount = 0);

  void addExpense() {
    int? amt = int.tryParse(expCtrl.text);
    if (amt != null && amt > 0) {
      setState(() => totalSpend += amt);
      expCtrl.clear();
      if (totalSpend > 5000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Warning: Budget Rs. 5000 se upar chala gaya!"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void resetExpense() => setState(() => totalSpend = 0);

  void triggerSOS() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade50,
        title: const Text("🚨 SILENT SOS ACTIVE!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text("Aapki Live GPS Location aur Emergency Alert aapke Family Contacts aur Police Helpline (112) ko bhej diya gaya hai!"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Theek Hai (Safe)", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F2),
      appBar: AppBar(
        title: const Row(children: [Icon(Icons.favorite, color: Colors.white), SizedBox(width: 8), Text("WomenCare Sakhi 🌸", style: TextStyle(color: Colors.white))]),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: const Color(0xFFFF9999), borderRadius: BorderRadius.circular(15)),
              child: const Column(children: [
                Text("Hello Beautiful! ✨", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 8),
                Text("Aapka din shubh ho.", style: TextStyle(fontSize: 16, color: Colors.white)),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFFCF3FF), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.purple.shade200)),
              child: Column(children: [
                const Text("✨ Aaj Ka Suvichar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                const SizedBox(height: 12),
                Text("\"${quotes[quoteIndex]}\"", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: nextQuote, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), child: const Text("🌸 Next Thought", style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: shareQuote, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text("📲 Share", style: TextStyle(color: Colors.white))),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFFFF0F5), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.pink.shade200)),
              child: Column(children: [
                const Text("🌸 Period & Cycle Tracker", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                  label: const Text("Select Last Period Date", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                ),
                const SizedBox(height: 12),
                if (lastDate != null && nextDate != null) ...[
                  Text("Last Date: ${lastDate!.day}/${lastDate!.month}/${lastDate!.year}", style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 5),
                  Text("📅 Next Expected: ${nextDate!.day}/${nextDate!.month}/${nextDate!.year}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.pink)),
                ] else
                  const Text("Apni aakhiri date chunne ke liye button dabayein.", style: TextStyle(fontSize: 13, color: Colors.black54)),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.orange.shade200)),
              child: const Column(children: [
                Text("🍲 Quick Recipes & Tiffin", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text("🎒 Kids School Tiffin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  children: [Padding(padding: EdgeInsets.all(10), child: Text("Cheese Paneer Roll: Roti par halka ketchup lagayein, paneer aur cheese bhar kar roll karein. Bachchon ka pasandida tiffin!"))],
                ),
                ExpansionTile(
                  title: Text("🍛 Special Home Lunch", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  children: [Padding(padding: EdgeInsets.all(10), child: Text("Shahi Paneer & Dal Tadka: Masale bhun kar gravy banayein aur paneer dalein. Ghar ke sabhi logon ke liye swadisht lunch!"))],
                ),
                ExpansionTile(
                  title: Text("🥪 5-Min Hostel & PG Snack", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  children: [Padding(padding: EdgeInsets.all(10), child: Text("Bread Veggie Sandwich: Bread par dahi ya malai lagayein, kheera-tamatar aur chaat masala dalkar 2 min me khayein!"))],
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.teal.shade200)),
              child: const Column(children: [
                Text("🏡 Kitchen, Health & Beauty Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text("🌶️ Kitchen & Home Smart Hacks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  children: [Padding(padding: EdgeInsets.all(10), child: Text("Masalon ko keedon se bachane ke liye dibbe me 2-3 sukhi neem ki pattiyan daal dein. Daal aur chawal lambe samay tak surakshit rahenge!"))],
                ),
                ExpansionTile(
                  title: Text("💅 Health & Natural Beauty Care", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  children: [Padding(padding: EdgeInsets.all(10), child: Text("Instant Glow Pack: 1 chammach besan, chutki bhar haldi aur dahi milakar 10 min lagayein. Baalon ki chamak ke liye aloe vera gel lagayein!"))],
                ),
              ]),
            ),
            const SizedBox(height: 20),
 Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFF5EEF8), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.deepPurple.shade200, width: 1.5)),
              child: Column(children: [
                const Text("🎬 AI Quick Kitchen & Beauty Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                const SizedBox(height: 12),
                const Icon(Icons.play_circle_fill, size: 55, color: Colors.deepPurple),
                const SizedBox(height: 8),
                const Text("1-Minute Animated Smart Hacks", style: TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: playAIVideo,
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text("Play AI Video", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.shade200)),
              child: Column(children: [
                const Text("💰 Smart Budget & Pocket Money", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 12),
                TextField(controller: expCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Kharcha likhein (Rs.)", border: OutlineInputBorder())),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: addExpense, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text("Save Expense", style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: resetExpense, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text("🔄 Reset", style: TextStyle(color: Colors.white))),
                ]),
                const SizedBox(height: 12),
                Text("Total Spend: Rs. $totalSpend", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: totalSpend > 5000 ? Colors.red : Colors.black87)),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue.shade100)),
              child: Column(children: [
                const Text("🥤 Daily Water Reminder", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 15),
                Text("🥛 $glassCount / 8 Glass", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(onPressed: drinkWater, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), child: const Text("+ 1 Glass Piya", style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: resetWater, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text("🔄 Reset", style: TextStyle(color: Colors.white))),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.red, width: 2)),
              child: Column(children: [
                const Text("🚨 Emergency Silent SOS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(height: 8),
                const Text("Musibat me bina aawaz kiye apni live location bhejein.", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: triggerSOS,
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 26),
                  label: const Text("ACTIVATE SOS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
