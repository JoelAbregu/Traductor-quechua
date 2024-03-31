// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:translator_quechua/config/theme/apptheme.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  //todo traduccion
  String translate = '';
  void translator(String text) {
    final translator = GoogleTranslator();
    translator
        .translate(text, to: 'qu')
        .then((result) => translate = result.toString());
    setState(() {});
  }

  TextEditingController controller = TextEditingController();

  //todo spech
  final _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);

    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      controller.text = result.recognizedWords;
      _confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    return MediaQuery(
      data: query.copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
          backgroundColor: const Color(0xFFF4F7FF),
          appBar: AppBar(
            backgroundColor: AppTheme().color,
            centerTitle: true,
            title: Text(
              'Traductor de Quechua',
              style: TextStyle(
                  fontSize: query.size.width * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: Column(
            children: [
              //TODO: texto entrante
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.translate_sharp),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Español'),
                              const SizedBox(
                                width: 15,
                              ),
                              FloatingActionButton(
                                shape: const StadiumBorder(),
                                onPressed: () {
                                  _speechToText.isListening
                                      ? _stopListening()
                                      : _startListening();
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 136, 201, 255),
                                child: Icon(
                                  _speechToText.isNotListening
                                      ? Icons.mic_off
                                      : Icons.mic,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  size: query.size.width * 0.05,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    controller.clear();
                                    translate = '';
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: controller,
                            maxLines: null,
                            minLines: null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Ingresa el texto a traducir',
                            ),
                            style: TextStyle(
                                fontSize: query.size.width * 0.04,
                                color: Colors.black),
                            onTap: () {
                              if (controller.value.text == '') {
                                translate = '';
                                setState(() {});
                              } else {
                                return;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(controller.text.length.toString()),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (controller.value.text != '') {
                                translator(controller.value.text);
                              } else {
                                return;
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme().color,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 10),
                                child: Text(
                                  'Traducir',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: query.size.width * 0.04,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //TODO: traducido
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.translate_sharp),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Quechua'),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: translate));
                                  },
                                  icon: const Icon(Icons.copy))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            translate,
                            style: TextStyle(
                                fontSize: query.size.width * 0.04,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Text(
                                '${translate.length}',
                                textAlign: TextAlign.end,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
