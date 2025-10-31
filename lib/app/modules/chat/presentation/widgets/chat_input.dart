import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/chat_bloc.dart';
import 'package:pot_g/app/modules/chat/presentation/bloc/pot_info_bloc.dart';
import 'package:pot_g/app/modules/common/presentation/utils/log.dart';
import 'package:pot_g/app/modules/common/presentation/widgets/pot_icon_button.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';
import 'package:pot_g/gen/assets.gen.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _filled = _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = context.select<PotInfoBloc, bool>(
      (bloc) => bloc.state.isArchived,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enabled: !disabled,
              controller: _controller,
              style: TextStyles.description.copyWith(
                height: 19 / 16,
                color: Palette.textGrey,
              ),
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                fillColor: Palette.lightGrey,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          PotIconButton(
            icon: Assets.icons.sendDiagonal.svg(
              colorFilter: ColorFilter.mode(
                _filled ? Palette.primary : Palette.grey,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              L.c('sendMessage');
              context.read<ChatBloc>().add(ChatSendChat(_controller.text));
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
