import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


// ------------------- KOSTEN DENIZ -------------------

final List<Map<String, dynamic>> denizKosten = [
  {"Beschreibung": "Schrauben+Schraubendreher, 19.10.2024", "Betrag": 13.89},
  {"Beschreibung": "Chassis v1, 26.08.2024", "Betrag": 33.18},
  {"Beschreibung": "Chassis v3, 16.09.2024", "Betrag": 26.17},
  {"Beschreibung": "Chassis v5, 07.10.2024", "Betrag": 71.55},
  {"Beschreibung": "Chassis v6, 26.10.2024", "Betrag": 85.97},
  {"Beschreibung": "Chassis final (Kleinseriea 10x), 26.02.2025", "Betrag": 598.56},
  {"Beschreibung": "Chassis final (Kleinseriea 10x) NACHZAHLUNG ZOLL, 26.02.2025", "Betrag": 175.74},
  {"Beschreibung": "Domain-Kosten", "Betrag": 27.10},
  {"Beschreibung": "Lötstation mit equipments", "Betrag": 50.00},


];


// ------------------- KOSTEN ABASSIN -------------------

// Listen für Kostenaufschlüsselung
final List<Map<String, dynamic>> abassinKosten = [
  {"Beschreibung": "7x Kabel", "Betrag": 0},
  {"Beschreibung": "4x Batterie", "Betrag": 40.00},
  {"Beschreibung": "Krimpzange", "Betrag": 31.00},
  {"Beschreibung": "Buttons", "Betrag": 7.00},
  {"Beschreibung": "10x Pico Ws", "Betrag": 60.00},
  {"Beschreibung": "Lötstation mit equipments", "Betrag": 100.00},
  {"Beschreibung": "Dioden und andere", "Betrag": 20.00},
  {"Beschreibung": "Kapazitäts sensor", "Betrag": 10.00},
  {"Beschreibung": "NFC sensor", "Betrag": 20.00},
  {"Beschreibung": "LED rings", "Betrag": 10.00},
  {"Beschreibung": "Krokodilklemmen + Jumpers", "Betrag": 10.00},
  {"Beschreibung": "Elektronik kosten prototyping: Cambrera V.0.3 ", "Betrag": 23.00},
  {"Beschreibung": "Elektronik kosten prototyping: LED Rings ", "Betrag": 18.00},
  {"Beschreibung": "Elektronik kosten prototyping: Cambrera V.0.2  ", "Betrag": 23.00},
  {"Beschreibung": "Elektronik kosten prototyping: Cambrera V.0.1  ", "Betrag": 14.00},
  {"Beschreibung": "Elektronik kosten prototyping: Touchsensor  ", "Betrag": 53.00},
  {"Beschreibung": "Visitenkarten  ", "Betrag": 80.00},
  {"Beschreibung": "Touch sensor 2.0  ", "Betrag": 25.00},
  {"Beschreibung": "Kaution Miete", "Betrag": 200.00},
  {"Beschreibung": "Miete April  ", "Betrag": 75.00},
  {"Beschreibung": "Miete Mai  ", "Betrag": 75.00},
  {"Beschreibung": "Test phase equipment (Tablet, Kabel etc.  ", "Betrag": 150}
];


// ------------------- ------------------- -------------------


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kostenaufstellung',
      home: KostenAufstellungScreen(),
    );
  }
}

class KostenAufstellungScreen extends StatelessWidget {


  KostenAufstellungScreen({Key? key}) : super(key: key);

  double get gesamtAbassin =>
      abassinKosten.fold(0, (sum, item) => sum + item["Betrag"]);

  double get gesamtDeniz =>
      denizKosten.fold(0, (sum, item) => sum + item["Betrag"]);

  double get gesamtkosten => gesamtAbassin + gesamtDeniz;

  String get emailBody {
    return '''
Kostenaufschlüsselung:

Abassin:
${abassinKosten.map((eintrag) => "- ${eintrag["Beschreibung"]}: ${eintrag["Betrag"]}€").join("\n")}
Gesamt: $gesamtAbassin€

Deniz:
${denizKosten.map((eintrag) => "- ${eintrag["Beschreibung"]}: ${eintrag["Betrag"]}€").join("\n")}
Gesamt: $gesamtDeniz€

Alle Gesamtkosten zusammen: $gesamtkosten€
''';
  }



  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambrera Kosten'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children:[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Kostenübersicht Abassin:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ...abassinKosten.map((eintrag) {
                  return Text("- ${eintrag["Beschreibung"]}: ${eintrag["Betrag"]}€");
                }).toList(),
                Text("Gesamt: $gesamtAbassin€\n"),
                Text("Kostenübersicht Deniz:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ...denizKosten.map((eintrag) {
                  return Text("- ${eintrag["Beschreibung"]}: ${eintrag["Betrag"]}€");
                }).toList(),
                Text("Gesamt: $gesamtDeniz€\n"),
                Text(
                  "Alle Gesamtkosten zusammen: $gesamtkosten€",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {

                      String emailBody = '''
Kostenübersicht Abassin:
${abassinKosten.map((eintrag) => "- ${eintrag["Beschreibung"]}: ${eintrag["Betrag"]}€").join("\n")}
Gesamt: $gesamtAbassin€

Kostenübersicht Deniz:
${denizKosten.map((eintrag) => "- ${eintrag["Beschreibung"]}: ${eintrag["Betrag"]}€").join("\n")}
Gesamt: $gesamtDeniz€

Alle Gesamtkosten zusammen: $gesamtkosten€
''';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Neue Kostenaufstellung wird versandt.'),
                        ),
                      );


                      await sendEmailWithEmailJS(
                          templateParams: {
                          'kostenstring': emailBody,
                          },
                      );
                    },
                    child: Text("Kosten per E-Mail senden"),
                  ),
                ),
              ],
            ),
          ]
        )
      ),
    );
  }
}


// Same sendEmailWithEmailJS logic as before
Future<void> sendEmailWithEmailJS({
  required Map<String, String> templateParams,
}) async {
  const String emailJSUrl = 'https://api.emailjs.com/api/v1.0/email/send';
  final response = await http.post(
    Uri.parse(emailJSUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': "service_xstzqx9",
      'template_id': 'template_07o9q4v',
      'user_id': 'uMQOeZqPhp4wZMzJK',
      'template_params': templateParams,
    }),
  );

  if (response.statusCode == 200) {
    debugPrint('E-Mail erfolgreich gesendet!');
  } else {
    debugPrint('Fehler beim Senden der E-Mail: ${response.body}');
  }
}
