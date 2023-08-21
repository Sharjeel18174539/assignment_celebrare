import 'dart:html';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
enum AppState{
  free,
  picked,
  cropped,
}
class DesignPage extends StatefulWidget {
  const DesignPage({super.key});

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  late AppState state;
  File? imageFile;

  final ImagePicker _picker =ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    state=AppState.free;
  }

  Future<void> _pickedImage() async{
    imageFile= (await _picker.pickImage(source: ImageSource.gallery)) as File?;
    setState(() {
      imageFile;
    });
  }

  Future _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile?.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if(croppedFile!=null){
      imageFile=croppedFile as File?;
      setState(() {
        state= AppState.cropped;
      });
    }
  }

  void _clearImage(){
    imageFile==null;
    setState(() {
      state=AppState.free;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Image/Icon"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 380,
          height: 130,
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(
                color: Colors.black,
              ),
              color: Colors.white
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Upload Image",
                style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  primary: Colors.green,
                ),
                  onPressed: (){

                  if(state== AppState.free){
                    _pickedImage();
                  }else if(state ==AppState.picked){
                    _cropImage();
                  }else if(state==AppState.cropped){
                    _clearImage();
                  }
                  },
                  child: Text("Choose from device",
                  style: TextStyle(color: Colors.white, fontSize: 15,
                  ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }



}

