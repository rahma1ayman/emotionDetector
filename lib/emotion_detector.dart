import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

class EmotionDetector extends StatefulWidget {
  const EmotionDetector({super.key});

  @override
  State<EmotionDetector> createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  CameraController? cameraController;
  String outPut = '';
  double confidence = 0.0;
  loadCamera() {
    cameraController = CameraController(
      cameras![0],
      ResolutionPreset.high,
    );
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((image) {
            runModel(image);
          });
        });
      }
    });
  }

  runModel(CameraImage img) async {
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map(
          (plane) {
            return plane.bytes;
          },
        ).toList(), // required
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5, // defaults to 127.5
        imageStd: 127.5, // defaults to 127.5
        rotation: 90, // defaults to 90, Android only
        numResults: 2, // defaults to 5
        threshold: 0.1, // defaults to 0.1
        asynch: true // defaults to true
        );
    for (var element in recognitions!) {
      setState(() {
        outPut = element['label'];
        confidence = element['confidence'] * 100;
      });
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Emotion detector',
          style: GoogleFonts.labrada(
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: !(cameraController!.value.isInitialized)
                    ? Container()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CameraPreview(cameraController!),
                      )),
            const SizedBox(
              height: 20,
            ),
            Text(
              outPut,
              style: GoogleFonts.labrada(
                color: Colors.white,
                fontSize: 30,
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "${confidence.toStringAsFixed(2)}%",
              style: GoogleFonts.labrada(
                color: Colors.white,
                fontSize: 30,
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
