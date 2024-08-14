/// Message Type
enum MessageType {
  /// Text
  text,

  /// Image
  image,

  /// Audio
  audio,

  /// Video
  video,

  /// PDF
  pdf,

  /// Doc/Docx
  doc,

  /// File
  file,

  /// Info Message type
  info,

  /// Custom/Generic
  custom
}

/// Delivery Status
enum DeliveryStatus {
  /// Sending [Spinning indicator]
  sending,

  /// Single check
  sent,

  /// Double check but no gray
  delivered,

  /// Double check and primary color
  read,
}

/// List of all callbacks
enum CallbackName {
  ///
  onMessageLongPressed,

  ///
  onImageMessageTapped,

  ///
  onMessageDoubleTapped,

  ///
  onReplyToMessage
}
