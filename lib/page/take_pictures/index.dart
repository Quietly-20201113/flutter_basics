import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbasics/page/widget/features/ConciseHeader.dart';

List<CameraDescription> cameras = [];
class TakePictures extends StatefulWidget {
  @override
  _TakePictures createState() => _TakePictures();
}

class _TakePictures extends State<TakePictures> with WidgetsBindingObserver {
  CameraController controller;
  bool enableAudio = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
Future<void> init() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    print("进来没 ${cameras.length}");
  } on CameraException catch (e) {
    print("${e.code} ,${e.description}");
  }
}
  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          ConciseHeader('水印相机样例'),
          Expanded(
              child: Stack(
            children: <Widget>[
              Container(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Center(
                      child: _cameraPreviewWidget(),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: controller != null &&
                              controller?.value?.isRecordingVideo
                          ? Colors.redAccent
                          : Colors.grey,
                      width: 3.0,
                    ),
                  ),
                ),
              )
            ],
          )),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw ArgumentError('Unknown lens direction');
  }
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];
    print("cameras = ${cameras.length}");
    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller.value.isRecordingVideo
                  ? null
                  : onNewCameraSelected,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }
}
