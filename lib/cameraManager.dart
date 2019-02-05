import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/imagePickerService.dart';

class CameraExampleHome extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraExampleHome({this.cameras}) : super();

  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
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

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<CameraExampleHome> {
  CameraController controller;
  String imagePath;
  // String videoPath;
  // VideoPlayerController videoController;
  // VoidCallback videoPlayerListener;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();
  //   controller = CameraController(cameras[0], ResolutionPreset.medium);
  //   controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
        key: _scaffoldKey,
        child: SafeArea(
            top: false,
            child: Stack(
              children: <Widget>[
                Center(child: _cameraPreviewWidget()),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => MyApp()),
                              ModalRoute.withName('/'),
                            );
                          },
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.picture_in_picture),
                          onPressed: () {
                            Navigator.pushNamed(context, '/imagePicker');
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      color: Colors.black,
                      child: IconButton(
                        iconSize: 40.0,
                        icon: const Icon(Icons.camera),
                        color: Colors.white,
                        onPressed: controller != null &&
                                controller.value.isInitialized &&
                                !controller.value.isRecordingVideo
                            ? onTakePictureButtonPressed
                            : null,
                      ),
                    )),
                Align(
                    alignment: Alignment.bottomRight,
                    child: imagePath == null
                        ? null
                        : GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/imagePicker');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                      image: ExactAssetImage(imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                width: 44,
                                height: 44,
                              ),
                            ),
                          ))
              ],
            )));
  }

  /// Display the preview from the camera (or a message if the preview is not available).
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

  /// Display the thumbnail of the captured image or video.
  // Widget _thumbnailWidget() {
  //   return Expanded(
  //     child: Align(
  //       alignment: Alignment.centerRight,
  //       child: videoController == null && imagePath == null
  //           ? null
  //           : SizedBox(
  //               child: (videoController == null)
  //                   ? Image.file(File(imagePath))
  //                   : Container(
  //                       child: Center(
  //                         child: AspectRatio(
  //                             aspectRatio: videoController.value.size != null
  //                                 ? videoController.value.aspectRatio
  //                                 : 1.0,
  //                             child: VideoPlayer(videoController)),
  //                       ),
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.pink)),
  //                     ),
  //               width: 64.0,
  //               height: 64.0,
  //             ),
  //     ),
  //   );
  // }

  /// Display the control bar with buttons to take pictures and record videos.
  // Widget _captureControlRowWidget() {
  //   return IconButton(
  //     icon: const Icon(Icons.camera),
  //     color: Colors.black,
  //     onPressed: controller != null &&
  //             controller.value.isInitialized &&
  //             !controller.value.isRecordingVideo
  //         ? onTakePictureButtonPressed
  //         : null,
  //   );
  // }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  // Widget _cameraTogglesRowWidget() {
  //   final List<Widget> toggles = <Widget>[];

  //   if (widget.cameras.isEmpty) {
  //     return const Text('No camera found');
  //   } else {
  //     for (CameraDescription cameraDescription in widget.cameras) {
  //       this.onNewCameraSelected(cameraDescription);
  //       // toggles.add(
  //       //   SizedBox(
  //       //     width: 90.0,
  //       //     child: RadioListTile<CameraDescription>(
  //       //       title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
  //       //       groupValue: controller?.description,
  //       //       value: cameraDescription,
  //       //       onChanged: controller != null && controller.value.isRecordingVideo
  //       //           ? null
  //       //           : onNewCameraSelected,
  //       //     ),
  //       //   ),
  //       // );
  //     }
  //   }

  //   return Row(children: toggles);
  // }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isEmpty) {
      logError('500', 'error');
    } else {
      // for (CameraDescription cameraDescription in widget.cameras) {
      this.onNewCameraSelected(widget.cameras[0]);
      // }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // if (controller != null) {
    //   await controller.dispose();
    // }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

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

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          // videoController?.dispose();
          // videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  // void onVideoRecordButtonPressed() {
  //   startVideoRecording().then((String filePath) {
  //     if (mounted) setState(() {});
  //     if (filePath != null) showInSnackBar('Saving video to $filePath');
  //   });
  // }

  // void onStopButtonPressed() {
  //   stopVideoRecording().then((_) {
  //     if (mounted) setState(() {});
  //     showInSnackBar('Video recorded to: $videoPath');
  //   });
  // }

  // Future<String> startVideoRecording() async {
  //   if (!controller.value.isInitialized) {
  //     showInSnackBar('Error: select a camera first.');
  //     return null;
  //   }

  //   final Directory extDir = await getApplicationDocumentsDirectory();
  //   final String dirPath = '${extDir.path}/Movies/flutter_test';
  //   await Directory(dirPath).create(recursive: true);
  //   final String filePath = '$dirPath/${timestamp()}.mp4';

  //   if (controller.value.isRecordingVideo) {
  //     // A recording is already started, do nothing.
  //     return null;
  //   }

  //   try {
  //     videoPath = filePath;
  //     await controller.startVideoRecording(filePath);
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     return null;
  //   }
  //   return filePath;
  // }

  // Future<void> stopVideoRecording() async {
  //   if (!controller.value.isRecordingVideo) {
  //     return null;
  //   }

  //   try {
  //     await controller.stopVideoRecording();
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     return null;
  //   }

  //   await _startVideoPlayer();
  // }

  // Future<void> _startVideoPlayer() async {
  //   final VideoPlayerController vcontroller =
  //       VideoPlayerController.file(File(videoPath));
  //   videoPlayerListener = () {
  //     if (videoController != null && videoController.value.size != null) {
  //       // Refreshing the state to update video player with the correct ratio.
  //       if (mounted) setState(() {});
  //       videoController.removeListener(videoPlayerListener);
  //     }
  //   };
  //   vcontroller.addListener(videoPlayerListener);
  //   await vcontroller.setLooping(true);
  //   await vcontroller.initialize();
  //   await videoController?.dispose();
  //   if (mounted) {
  //     setState(() {
  //       imagePath = null;
  //       videoController = vcontroller;
  //     });
  //   }
  //   await vcontroller.play();
  // }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.png';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

// class CameraApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CameraExampleHome(),
//     );
//   }
// }

// List<CameraDescription> cameras;

// Future<void> main() async {
//   // Fetch the available cameras before initializing the app.
//   try {
//     cameras = await availableCameras();
//   } on CameraException catch (e) {
//     logError(e.code, e.description);
//   }
//   runApp(CameraApp());
// }
