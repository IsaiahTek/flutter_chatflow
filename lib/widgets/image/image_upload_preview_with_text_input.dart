import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatflow/widgets/image/image_swipe.dart';
import 'package:flutter_chatflow/widgets/media_selection_with_text.dart';

class ImageUploadPreviewWithTextInput extends StatefulWidget{

  final List<String> imagesUri;
  final int? currentIndex;
  final void Function(List<MediaSelectionWithText> selectionsWithText) setMediaSelectionsWithText;

  const ImageUploadPreviewWithTextInput({
    super.key,
    required this.imagesUri,
    this.currentIndex,
    required this.setMediaSelectionsWithText
  });

  @override
  State<ImageUploadPreviewWithTextInput> createState() => _ImageUploadPreviewWithTextInputState();
}

class _ImageUploadPreviewWithTextInputState extends State<ImageUploadPreviewWithTextInput> {
  
  late int currentIndex;

  late List<MediaSelectionWithText> uploadingMediaWithText = [];
  
  @override
  void initState() {
    currentIndex = widget.currentIndex??0;
    for (var uri in widget.imagesUri) {
      uploadingMediaWithText.add(MediaSelectionWithText(uri: uri));
    }
    textEditingController.text = uploadingMediaWithText[currentIndex].text??"";
    textEditingController.addListener(() {
      MediaSelectionWithText newMediaWithText = MediaSelectionWithText(uri: widget.imagesUri[currentIndex], text: textEditingController.text);
      uploadingMediaWithText.replaceRange(currentIndex, currentIndex, [newMediaWithText]);
    });
    super.initState();
  }

  handleSetCurrentIndex(int index){
    setState(() {
      currentIndex = index;
    });
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image And Buttons below
          ImagesSwipe(currentIndex: currentIndex, setCurrentIndex: handleSetCurrentIndex, uri: widget.imagesUri[currentIndex], imagesLength: widget.imagesUri.length),
          // Text Input below if available
          TextField(
            controller: textEditingController,
            onSubmitted: (e){
              widget.setMediaSelectionsWithText(uploadingMediaWithText);
              Navigator.pop(context);
            },
          )
        ],
      )
    );
  }
}