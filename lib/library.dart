library library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/platform_implementation/local_image_widget_io.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/widgets/replied_message_widget.dart';
import 'package:flutter_chatflow/widgets/video/video_message.dart';
import 'package:link_utils/link_utils.dart';
import 'platform_implementation/file_io.dart' if (dart.library.html) 'platform_implementation/file_web.dart';

import 'platform_implementation/file_io.dart' if(dart.library.html) 'platform_implementation/file_web.dart';

// part 'notifier.dart';
part 'widgets/chat_input.dart';
part 'widgets/computed_widget.dart';
part 'widgets/audio/audio_message.dart';
part 'widgets/audio/audio_widget.dart';
part 'widgets/image/image_message.dart';
part 'widgets/image/image_widget.dart';
