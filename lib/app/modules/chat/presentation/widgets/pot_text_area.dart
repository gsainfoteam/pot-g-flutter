import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

class PotTextArea extends StatefulWidget {
  const PotTextArea({
    super.key,
    this.hintText,
    this.controller,
    this.readOnly = false,
    this.filled = false,
    this.keyboardType = TextInputType.multiline,
    this.inputFormatters,
    this.onChanged,
    this.autoFocus = false,
    this.maxLength,
    this.minLines = 5,
    this.maxLines = 10,
  });

  final String? hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool filled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool autoFocus;
  final int? maxLength;
  final int minLines;
  final int maxLines;

  @override
  State<PotTextArea> createState() => _PotTextAreaState();
}

class _PotTextAreaState extends State<PotTextArea> {
  late TextEditingController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }
  }

  @override
  void didUpdateWidget(covariant PotTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (widget.controller != null) {
        if (_isInternalController) {
          _controller.dispose();
          _isInternalController = false;
        }
        _controller = widget.controller!;
      } else {
        _controller = TextEditingController();
        _isInternalController = true;
      }
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        TextFormField(
          maxLength: widget.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          style: TextStyles.description.copyWith(color: Palette.dark),
          keyboardType: widget.keyboardType,
          textInputAction: TextInputAction.newline,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          textAlignVertical: TextAlignVertical.top,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            counter: const SizedBox.shrink(),
            contentPadding: EdgeInsets.fromLTRB(
              12,
              12,
              12,
              widget.maxLength != null ? 30 : 12,
            ),
            filled: widget.filled,
            fillColor: const Color(0xfff5f5f5),
            hintText: widget.hintText,
            hintStyle: TextStyles.description.copyWith(color: Palette.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: widget.filled
                  ? BorderSide.none
                  : const BorderSide(color: Palette.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: widget.filled
                  ? BorderSide.none
                  : const BorderSide(color: Palette.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: widget.filled
                  ? BorderSide.none
                  : const BorderSide(color: Palette.primary),
            ),
          ),
          controller: _controller,
        ),
        if (widget.maxLength != null)
          Positioned(
            right: 12,
            bottom: 12,
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, child) {
                final length = value.text.characters.length;
                final isOverflow = length > widget.maxLength!;
                return RichText(
                  text: TextSpan(
                    style: TextStyles.caption.copyWith(color: Palette.grey),
                    children: [
                      TextSpan(
                        text: '$length',
                        style: TextStyle(
                          color: isOverflow ? Palette.warning : Palette.grey,
                        ),
                      ),
                      TextSpan(text: '/${widget.maxLength}'),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
