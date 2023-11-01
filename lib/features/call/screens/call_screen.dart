import 'package:agora_uikit/agora_uikit.dart';
import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/config/agora_config.dart';
import 'package:chat_app/features/call/controller/call_controller.dart';
import 'package:chat_app/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;

  CallScreen(
      {required this.channelId, required this.call, required this.isGroupChat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  // this url was received from Heroku by connecting the github repo (where the congigurations of appId and certificateId were made (received from agora-create app) ) and deploying it

  String baseUrl = 'https://chat-app-r-ff0025b20c01.herokuapp.com/';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: AgoraConfig.appId,
            channelName: widget.channelId,
            tokenUrl: baseUrl));
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
              children: [
                AgoraVideoViewer(
                  client: client!,
                  disabledVideoWidget: const Center(
                      child: Text('The video has been turned off')),
                ),
                AgoraVideoButtons(
                  client: client!,

                  // end call button
                  disconnectButtonChild: IconButton(
                    onPressed: () async {
                      await client!.engine.leaveChannel();
                      if (context.mounted) {
                        ref.read(callControllerProvider).endCall(
                            widget.call.callerId,
                            widget.call.receiverId,
                            context,
                            widget.isGroupChat);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.call_end),
                  ),
                )
              ],
            )),
    );
    // return StreamBuilder<DocumentSnapshot>(
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData && snapshot.data!.data() != null) {
    //       return Scaffold(
    //         body: client == null
    //             ? const Loader()
    //             : SafeArea(
    //                 child: Stack(
    //                 children: [
    //                   AgoraVideoViewer(client: client!),
    //                   AgoraVideoButtons(
    //                     client: client!,
    //                     // end call button
    //                     disconnectButtonChild: IconButton(
    //                       onPressed: () async {
    //                         await client!.engine.leaveChannel();
    //                         if (context.mounted) {
    //                           ref.read(callControllerProvider).endCall(
    //                               widget.call.callerId,
    //                               widget.call.receiverId,
    //                               context,
    //                               widget.isGroupChat);
    //                           Navigator.pop(context);
    //                         }
    //                       },
    //                       icon: const Icon(Icons.call_end),
    //                     ),
    //                   )
    //                 ],
    //               )),
    //       );
    //     } else {
    //       Navigator.of(context).pop();
    //       return const Loader();
    //     }
    //   },
    // );
  }
}
