import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vbforntend/controllers/chat_controller.dart';
import 'package:vbforntend/views/widgets/simple_recorder.dart';
import '../../models/chat.dart' as ChatModel;
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/profile_provider.dart';
import 'package:vbforntend/providers/socket_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vbforntend/providers/user_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/flutter_sound.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  late IO.Socket socket;
  late FlutterSoundRecorder recorder;

  @override
  void initState() {
    super.initState();

    ////sound recorder
    recorder = FlutterSoundRecorder();

    socket = context.read<SocketProvider>().socket;
    socket.emit("list online users");
    _loadMessages();

    socket.on("private message", (data) {
      print(data);
      print("========private message called========");
      ChatModel.Chat chatdata = ChatModel.Chat.fromJson(data['chat']);
      print(chatdata.type);

      if (chatdata.type == 'image') {
        print("indide if");
        types.Message msg = types.ImageMessage(
            author: types.User(
                id: chatdata.sender.user.id,
                firstName: chatdata.sender.user.username),
            id: chatdata.id!,
            name: 'b',
            size: 30,
            uri: chatdata.text!);
        _addMessage(msg);
      }

      if (chatdata.type == 'text') {
        types.Message msg = types.TextMessage(
          text: chatdata.text!,
          id: chatdata.id!,
          author: types.User(
              id: chatdata.sender.user.id,
              firstName: chatdata.sender.user.username),
          roomId: widget.data['profile_id'],
        );

        _addMessage(msg);
      }
      if (chatdata.type == 'audio') {
        print("inside audio");
        types.Message msg = types.VideoMessage(
          uri: chatdata.text!,
          name: 'video',
          size: 4,
          id: chatdata.id!,
          author: types.User(
              id: chatdata.sender.user.id,
              firstName: chatdata.sender.user.username),
          roomId: widget.data['profile_id'],
        );

        _addMessage(msg);
      }
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleAudioSelectioin();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Audio'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleAudioSelectioin() async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SimpleRecorder()),
    );
    Map<String, dynamic> data = {
      'sender': context.read<ProfileProvider>().profile.id,
      'receiver': widget.data['profile_id'],
      'to': widget.data['profile_id'],
      'message_type': 'audio',
      'file': result,
      'text': 'a',
    };

    socket = context.read<SocketProvider>().socket;
    socket.emit("private message", jsonEncode(data));
    print(result);
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
      Map<String, dynamic> data = {
        'sender': context.read<ProfileProvider>().profile.id,
        'receiver': widget.data['profile_id'],
        'to': widget.data['profile_id'],
        'message_type': 'image',
        'text': 'hello',
        'file': base64.encode(bytes)
      };

      socket = context.read<SocketProvider>().socket;
      socket.emit("private message", jsonEncode(data));
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    Map<String, dynamic> data = {
      'sender': context.read<ProfileProvider>().profile.id,
      'receiver': widget.data['profile_id'],
      'to': widget.data['profile_id'],
      'message_type': 'text',
      'text': message.text
    };

    socket = context.read<SocketProvider>().socket;
    socket.emit("private message", jsonEncode(data));
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    // _addMessage(textMessage);
  }

  void _loadMessages() async {
    User user = context.read<UserProvider>().user!;
    context
        .read<ChatController>()
        .listChats(context, widget.data['profile_id'])
        .then((msgs) {
      print(msgs);
      for (var m in msgs.data) {
        print("sender: ${m.sender.user.username}");
      }
      final messages = msgs.data.map((e) {
        print("################");
        print(e.sender.user.username);
        Map<String, dynamic> data = {
          'type': types.MessageType.text,
          'author': types.User(
              id: e.sender.user.id, firstName: e.sender.user.username),
          'createdAt': e.created_at,
          'roomId': widget.data['profile_id'],
          'repliedMessage': e.text
        };

        print("+++++++++++++++++++++");
        print(e.text);
        print(e.id);
        print(e.sender.user.id);
        print(e.sender.user.username);
        print(e.created_at);
        if (e.type == 'image') {
          print("indide if");
          return types.ImageMessage(
              author: types.User(
                  id: e.sender.user.id, firstName: e.sender.user.username),
              id: e.id,
              name: 'b',
              size: 30,
              uri: e.text);
        } else {
          return types.TextMessage(
            text: e.text,
            id: e.id,
            author: types.User(
                id: e.sender.user.id, firstName: e.sender.user.username),
            roomId: widget.data['profile_id'],
          );
        }
      }).toList();

      print(msgs);
      print("msg fetch called");

      setState(() {
        _messages = List<types.Message>.from(messages);
      });
    });

    final response = await rootBundle.loadString('assets/messages.json');
    // final messages = (jsonDecode(response) as List)
    // .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
    //     .toList();

    // setState(() {
    //   _messages = messages;
    // });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          widget.data['profile_pic'] != null
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.data['profile_pic']),
                )
              : const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange,
                ),
          Text(widget.data['username'])
        ]),
      ),
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
      ),
    );
  }
}
