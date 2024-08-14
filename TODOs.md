PENDING:
* Refactoring code to enable package users override each of all the default actions triggered by user events on messages such as `onMessageLongPressed`, `onImageMessageTapped`,  and [NEW] `onMessageDoubleTapped`
* Add lastReadMessageID for displaying `[x] New Message(s)` when the chat user has new message(s) in the chat for the first entrance.

## 2.0.0
DONE:
* Added Sponsor
* Renamed notifier to UserTypingStateStream
* Add Link detector and preview to uri/url text
* Adding option for hiding ChatFlow default input widget. Developers might want to use custom input widget for better controls. Just pass in the `hideDefaultInputWidget:true`;
