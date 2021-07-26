import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/models/people_model.dart';
import 'package:flutter_complete_guide/providers/messages_data.dart';

import 'package:flutter_complete_guide/screens/image_view.dart';
import 'package:flutter_complete_guide/screens/video_view.dart';

import 'package:keyboard_service/keyboard_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_complete_guide/wechat/wechat_camera_picker.dart';

class NewMessage extends StatefulWidget {
  final Person? person;
final  FocusNode? _focusNode ;
  NewMessage(
    this.person,this._focusNode
  );
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enterMessage = '';
  
  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(() {
  //     print(KeyboardService.isVisible(context));
  //   });
  //   widget._focusNode!.unfocus();
  //  widget. _focusNode!.addListener(() {
  //     print("Has focus: ${widget._focusNode!.hasFocus}");
  //   });
  // }

  final _controller = TextEditingController();
  bool _waiting = false;

  void _pickedFile() async {
    if (await Permission.accessMediaLocation.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'mp4', 'png'],
      );
      if (result != null) {
        if (result.files.single.path!.contains('.mp4')) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoViewPage(
                      person: widget.person,
                      path: result.files.single.path!,
                      pop: true)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraViewPage(
                      person: widget.person,
                      path: result.files.single.path!,
                      pop: true)));
        }
      } else {
        print('cancle');
        return;
      }
    } else {
      await Permission.accessMediaLocation.request();
      _pickedFile();
    }
  }

  void _sendMessage([bool? imageOrVideo]) async {
    final user = FirebaseAuth.instance.currentUser!;
    late Map<String, dynamic> data;

    String messageType = 'chat';

    data = {
      'idFrom': user.uid,
      'message': _enterMessage.trim(),
      'idTo': widget.person!.uid,
      'peerImageUrl': widget.person!.photoUrl!,
      'readed': false,
      "imageUrl": '',
      'videoPrefFrom': '',
      'videoPrefTo': '',
      "imagePrefFrom": "",
      "imagePrefTo": "",
      'videoUrl': '',
      'localFrom': true,
      'localTo': true,
      'timestamp': Timestamp.now().millisecondsSinceEpoch,
      'createdAt': DateFormat.Hm().format(DateTime.now()),
      'day': DateFormat.MMMMEEEEd().format(DateTime.now()),
      'groupChatId': widget.person!.groupChatId,
      'messageType': messageType,
    };
    Provider.of<Messages2>(context, listen: false)
        .addMessages(data, true, widget.person);

    setState(() {
      _controller.clear();
      _enterMessage = '';
    });
  }

  Future<void> pick(BuildContext context) async {
    await CameraPicker.pickFromCamera(
      context,
      widget.person!,
      enableRecording: true,
    );

    //   data = await _entity.thumbDataWithSize(
    //     (size.width * scale).toInt(),
    //     (size.height * scale).toInt(),
    //   );
    //   if (mounted) {
    //     setState(() {});
    //   }
    // }

    // File? asu = await _entity!.file;
    // if (asu != null) {
    //   if (asu!.path.contains('.mp4')) {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) =>
    //                 VideoViewPage(person: widget.person, path: asu.path)));
    //   } else {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) =>
    //                 CameraViewPage(person: widget.person, path: asu.path)));
    //   }
    // } else {
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
   
    return Container(
      constraints: BoxConstraints(maxHeight: 170),
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: TextFormField(
                focusNode:widget. _focusNode,
                onTap: () {},
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _controller,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () => pick(context),
                        icon: Icon(Icons.camera_alt)),
                    suffixIcon: IconButton(
                        onPressed: _pickedFile, icon: Icon(Icons.photo)),
                    fillColor: Colors.red,
                    focusColor: Colors.blue,
                    hoverColor: Colors.orange,
                    border: OutlineInputBorder(
                        gapPadding: 2,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    hintText: 'Send Message'),
                onChanged: (val) {
                  setState(() {
                    _enterMessage = val;
                //    print(KeyboardService.isVisible(context));
                  });
                },
              ),
            ),
          ),
          // KeyboardVisibilityBuilder(
          //   builder: (context, child, isKeyboardVisible) {
          //     if (isKeyboardVisible) {
          //       return Text(isKeyboardVisible.toString());
          //     } else {
          //       return Text(isKeyboardVisible.toString());
          //     }
          //   },
          //   // this widget goes to the builder's child property. Made for better performance.
          // ),

          _waiting
              ? CircularProgressIndicator()
              : IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.send_rounded,
                      color: _enterMessage.trim().isEmpty
                          ? Colors.grey
                          : Colors.green),
                  onPressed: _enterMessage.trim() == '' ? null : _sendMessage)
        ],
      ),
    );
  }
}

/// Calls `builder` on keyboard close/open.
/// https://stackoverflow.com/a/63241409/1321917
class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    bool isKeyboardVisible,
  ) builder;

  const KeyboardVisibilityBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() =>
      _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}
