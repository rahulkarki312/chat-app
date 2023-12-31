import 'dart:io';

import 'package:chat_app/colors.dart';
import 'package:chat_app/common/enums/message_enum.dart';
import 'package:chat_app/common/providers/message_reply_provider.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/features/chat/widgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;

  BottomChatField({required this.receiverUserId, required this.isGroupChat});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(ChatControllerProvider).sendTextMessage(
          context,
          _messageController.text.trim(),
          widget.receiverUserId,
          widget.isGroupChat);
      setState(() {
        _messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(ChatControllerProvider).sendFileMessage(
        context, file, widget.receiverUserId, messageEnum, widget.isGroupChat);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGif() async {
    final gif = await pickGIF(context);
    if (gif != null && context.mounted) {
      ref.read(ChatControllerProvider).sendGIFMessage(
          context, gif.url, widget.receiverUserId, widget.isGroupChat);
    }
  }

  void hideEmojiContainer() => setState(() {
        isShowEmojiContainer = false;
      });

  void showEmojiContainer() => setState(() {
        isShowEmojiContainer = true;
      });

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply
            ? MessageReplyPreview(
                receiverUserId: widget.receiverUserId,
                isGroupChat: widget.isGroupChat,
              )
            : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onTap: hideEmojiContainer,
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectGif,
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                              onPressed: selectVideo,
                              icon: const Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                              ))
                        ],
                      ),
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8, right: 2, left: 2),
              child: CircleAvatar(
                  backgroundColor: green,
                  radius: 23,
                  child: GestureDetector(
                    onTap: sendTextMessage,
                    child: Icon(
                      isShowSendButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    ),
                  )),
            )
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 300,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
