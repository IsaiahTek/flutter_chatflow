## 2.0.0
BREAKING CHANGES:
* 1. Renamed FluChatNotifier to UserTypingStateStream
```dart
// If you encounter an issue of FluChatNotifier, just rename from
// old
FluChatNotifier
// to new
UserTypingStateStream
```

OTHERS:
* Added some utility functions such as
* Added an optional onMessageDoubleTapped callback
* Implemented onImageMessageTapped and it applies to each grouped image when opened and tapped.
* Implemented callback for onMessageLongPressed.

NOTE: For all message gesture callbacks, by registering a callback, you can run your custom code alone (or prevent the default action) or run it together with the default action. If provided, you must call the default action if you want that to also run. Otherwise, omit it and the default action would still run.

```dart
updateMessageUri(Message message, String uri)
```
and 

```dart
getFileUrlFromMessage(Message message)
```


MINOR FIX:
* Added minimum container size to contain message delivery overflow


## 1.0.0
* BREAKING CHANGES:
* 1. Removed the `onDeleteMessages` callback with the top floating menu for deleting messages that have been selected by the user.
* 2. Added a `onMessageSelectionChanged` callback that passes all the selected messages. Use this callback to get all the selected messages and build a context menu of your choice and have full control of customization and manipulation.
* 3. Added a flag `shouldGroupConsecutiveImages` to allow grouping of four (4) or more consecutive images into a grid-like view. The default is true. So turn it off if you don't want it by passing false to it.
* 4. Added an optional `minImagesToGroup` property to configure the minimum number of consecutive images by the same author/sender and on the same day to take as a group of images displayed in a grid-like view.
* Other Changes:
* Fixed color for image_upload_preview_with_text_input to white on a dark background.
* Added repliedTo message to onAttachmentPress callback argument for replying marked message when handling attachment callback.
* Fixed repliedMessage widget overflow to make it look good and responsive (fluid).
<!-- * Added `shouldOverrideDefaultMessageLongPress` to either ovveride the default message long press effect. -->

* Added ChatFlowEvent class to help with ChatFlow handling event emitted from your Widget like your custom context menu for showing options/actions for selected messages
Example:
```dart
handleOnExitMenu(){
    ChatFlowEvent.unselectAllMessages();    // This is the part ChatFlowEvent is used.
    // Add other logic here
  }
```

* Fixed all issues found in previous version.

## 0.1.0
* Fixed minor issue of typing notifier stream to avoid updating typing state when input field just loss focus.
* Fixed minor `onSendPressed` button visibility to be instantly reactive to typing activity.
* Added Message Swipe
* Added Reply To Message Model
* Added RepliedTo Widget To Input Section If Marked
* Added RepliedTo Widget to MessageWidget

## 0.0.5
* Showing `onSendPressed` Button only when text field is not empty
* Showing `onAttachmentPressed` Button only if onAttachmentPressed callback is provided
* Fixed time partition for intervals with different months
* Added missing documentations more

## 0.0.4

* Updated the description.

## 0.0.3

* Updated the description.
* Formated the codebase

## 0.0.2

* Added documentation.


## 0.0.1

* This is the first release and comes with all the features described below.

