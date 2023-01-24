import 'package:flutter/material.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = 'Translated text...';
  TextEditingController textEditingController = TextEditingController();
  dynamic modelManager;
  bool isEnglishDownloaded = false;
  bool isSpanishDownloaded = false;
  dynamic onDeviceTranslator;
  // String from = lang[11];
  // String to = lang[13];
  dynamic languageIdentifier;

  @override
  void initState() {
    super.initState();
    modelManager = OnDeviceTranslatorModelManager();
    languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.6);
    checkAndDownloadModel();
  }

  checkAndDownloadModel() async {
    //Check if the model are downloaded or not???
    isEnglishDownloaded =
        await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);
    isSpanishDownloaded =
        await modelManager.isModelDownloaded(TranslateLanguage.spanish.bcpCode);

    //if not download, download the model
    if (!isEnglishDownloaded) {
      isEnglishDownloaded =
          await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
    }
    if (!isSpanishDownloaded) {
      isSpanishDownloaded =
          await modelManager.downloadModel(TranslateLanguage.spanish.bcpCode);
    }

    //translate the text if the model are downloaded
    if (isEnglishDownloaded && isSpanishDownloaded) {
      onDeviceTranslator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.english,
          targetLanguage: TranslateLanguage.spanish);
    }
  }

  translateText(String text) async {
    if (isEnglishDownloaded && isSpanishDownloaded) {
      final String response = await onDeviceTranslator.translateText(text);
      setState(() {
        result = response;
      });
    } else {
      result = 'Model Not Downloaded. Please Download the Model First.';
    }
    identifyLanguage(text);
  }

  identifyLanguage(String text) async {
    final String response = await languageIdentifier.identifyLanguage(text);
    textEditingController.text += '($response)';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  height: 50,
                  child: Card(
                    color: Colors.red,
                    elevation: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'FROM: English',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // DropdownButton<String>(
                            //   style: const TextStyle(
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            //   focusColor: Colors.red,
                            //   value: from,
                            //   items: lang.map<DropdownMenuItem<String>>(
                            //       (String value) {
                            //     return DropdownMenuItem<String>(
                            //       value: value,
                            //       child: Text(value),
                            //     );
                            //   }).toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       from = value!;
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                        Container(
                          height: 48,
                          width: 1,
                          color: Colors.white,
                        ),
                        Row(
                          children: const [
                            Text(
                              'TO: Spanish',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // DropdownButton<String>(
                            //   style: const TextStyle(
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            //   value: to,
                            //   items: lang.map<DropdownMenuItem<String>>(
                            //       (String value) {
                            //     return DropdownMenuItem<String>(
                            //         value: value, child: Text(value));
                            //   }).toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       to = value!;
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 2, right: 2),
                  width: double.infinity,
                  height: 250,
                  child: Card(
                    color: Colors.white,
                    elevation: 20,
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Type the Text here...',
                        filled: true,
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.black),
                      maxLines: 100,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 13, right: 13),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.green,
                      shadowColor: Colors.grey,
                    ),
                    child: const Text('Translate'),
                    onPressed: () {
                      translateText(textEditingController.text);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  width: double.infinity,
                  height: 250,
                  child: Card(
                    color: Colors.white,
                    elevation: 20,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        result,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
