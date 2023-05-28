import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vbforntend/providers/profile_provider.dart';
import 'package:vbforntend/utils/app_url.dart';

import 'user_provider.dart';

class SocketProvider extends ChangeNotifier {
  SocketProvider();

  late IO.Socket socket;

  void setSocket(BuildContext context) {
    print("set socket called");
    socket = IO.io(
        AppUrl.baseurl,
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders({
          'userid':
              Provider.of<ProfileProvider>(context, listen: false).profile.id,
          'username':
              Provider.of<UserProvider>(context, listen: false).user!.username
        }).build());
  }
}
