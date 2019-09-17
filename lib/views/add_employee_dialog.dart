import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployeeDialog extends StatefulWidget {
  @override
  _AddEmployeeDialogState createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  String name;
  File _image;
  String base64;
  Map<String, String> result = new Map<String, String>();

  TextEditingController controller = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    var x = await _image.readAsBytes();
    base64 = base64Encode(x);
    result['image'] = base64;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            // body part
            Container(
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: Consts.padding,
                left: Consts.padding,
                right: Consts.padding,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Consts.padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  //SizedBox(height: 16.0),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Employee Name',
                      hintText: 'eg. Tadjine Mohamed',
                    ),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    onChanged: (value) {
                      name = value;
                      result['name'] = name;
                    },
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          if (controller.text == '') {
                            print('empty text !');
                          } else
                            // To close the dialog and return results
                            Navigator.of(context).pop(result);
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // the top part (image)
            Positioned(
              left: Consts.padding,
              right: Consts.padding,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: Consts.avatarRadius,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    _image == null
                        ? Container()
                        : ClipOval(child: Image.file(_image)),
                    FloatingActionButton(
                      child: Icon(Icons.add_a_photo),
                      onPressed: getImage,
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
