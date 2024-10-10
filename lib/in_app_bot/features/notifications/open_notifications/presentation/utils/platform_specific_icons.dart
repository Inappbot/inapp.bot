import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSpecificIcons {
  static IconData get thumbsUp =>
      Platform.isIOS ? CupertinoIcons.hand_thumbsup : Icons.thumb_up_outlined;
  static IconData get share =>
      Platform.isIOS ? CupertinoIcons.share : Icons.share_outlined;
}
