import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class CaptionController extends GetxController {
  var imgPath = "".obs;
    CameraController? cameraController;
  

  Future<void> initCamera() async {
    var cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    await cameraController!.initialize();
  }

  Future<String> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String dir = "${root.path}/MOCOAI/CAPTION";
    await Directory(dir).create(recursive: true);
    String filePath = "${dir}/${DateTime.now()}.jpg";
    try{
      XFile? pic = await cameraController!.takePicture();
      pic!.saveTo(filePath);
  
    }catch(e){
      log("error : ${e.toString()}");
      throw Exception("kesalahan berfikir");
    }
    return filePath;    


  }


  


}