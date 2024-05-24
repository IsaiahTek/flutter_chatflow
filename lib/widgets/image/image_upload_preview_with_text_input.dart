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
      uploadingMediaWithText.add(
        MediaSelectionWithText(uri: uri, text: null)
      );
    }
    
    super.initState();
  }

  handleSetMediaSelectionWithText(String text){
    uploadingMediaWithText[currentIndex].copyWith(text: text);
  }

  handleSetCurrentIndex(int index){
    setState(() {
      currentIndex = index;
    });
  }

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
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: ControlledInput(
                    setMediaSelectionsWithText: handleSetMediaSelectionWithText
                  )
                ),
                IconButton(
                  onPressed: (){
                    widget.setMediaSelectionsWithText(uploadingMediaWithText);
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      )
    );
  }
}

class ControlledInput extends StatefulWidget{
  final void Function(String text) setMediaSelectionsWithText;
  final String? initialText;

  const ControlledInput({
    super.key,
    required this.setMediaSelectionsWithText,
    this.initialText
  });

  @override
  State<ControlledInput> createState() => _ControlledInputState();
}

class _ControlledInputState extends State<ControlledInput> {

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.initialText??"";
    textEditingController.addListener(() {
      widget.setMediaSelectionsWithText(textEditingController.text);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.white70),
        hintText: "Enter image text here"
      ),
      
      controller: textEditingController,
      onSubmitted: (e){
        widget.setMediaSelectionsWithText(textEditingController.text);
        Navigator.pop(context);
      },
    );
  }
}