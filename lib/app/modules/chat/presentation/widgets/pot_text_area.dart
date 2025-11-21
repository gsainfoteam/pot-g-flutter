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
    this.restorationId,
    this.initialValue,
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
  final String? restorationId;
  final String? initialValue;

  @override
  State<PotTextArea> createState() => _PotTextAreaState();
}

class _PotTextAreaState extends State<PotTextArea> with RestorationMixin {
  RestorableTextEditingController? _restorableController;
  TextEditingController? _plainController;
  bool _restorableRegistered = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _restorableController?.value ?? _plainController!;

  bool get _shouldUseRestoration => widget.restorationId != null;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _shouldUseRestoration
          ? _createRestorableController(_initialTextValue)
          : _createPlainController(_initialTextValue);
    }
  }

  @override
  void didUpdateWidget(covariant PotTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      final value = oldWidget.controller!.value;
      _shouldUseRestoration
          ? _createRestorableController(value)
          : _createPlainController(value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _disposeInternalControllers();
    }

    if (_shouldUseRestoration != (oldWidget.restorationId != null) &&
        widget.controller == null) {
      final currentValue = _effectiveController.value;
      if (_shouldUseRestoration) {
        _createRestorableController(currentValue);
      } else {
        _createPlainController(currentValue);
      }
    }

    if (widget.controller == null &&
        oldWidget.controller == null &&
        widget.initialValue != oldWidget.initialValue) {
      final desiredText = widget.initialValue ?? '';
      if (_effectiveController.text != desiredText) {
        _effectiveController.value = TextEditingValue(
          text: desiredText,
          selection: TextSelection.collapsed(offset: desiredText.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _disposeInternalControllers();
    super.dispose();
  }

  void _createRestorableController([TextEditingValue? value]) {
    _disposeInternalControllers();
    _restorableController = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerRestorableController();
    }
  }

  void _createPlainController([TextEditingValue? value]) {
    _disposeInternalControllers();
    _plainController = value == null
        ? TextEditingController()
        : TextEditingController.fromValue(value);
  }

  void _disposeInternalControllers() {
    if (_restorableController != null) {
      _unregisterRestorableController();
      _restorableController!.dispose();
      _restorableController = null;
    }
    _plainController?.dispose();
    _plainController = null;
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _registerRestorableController();
  }

  @override
  String? get restorationId => widget.restorationId;

  TextEditingValue get _initialTextValue =>
      TextEditingValue(text: widget.initialValue ?? '');

  void _registerRestorableController() {
    if (_restorableController == null ||
        widget.restorationId == null ||
        _restorableRegistered) {
      return;
    }
    registerForRestoration(
      _restorableController!,
      '${widget.restorationId}_controller',
    );
    _restorableRegistered = true;
  }

  void _unregisterRestorableController() {
    if (!_restorableRegistered || _restorableController == null) return;
    unregisterFromRestoration(_restorableController!);
    _restorableRegistered = false;
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
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(color: Palette.primary),
          ),
          controller: _effectiveController,
        ),
        if (widget.maxLength != null)
          Positioned(
            right: 12,
            bottom: 12,
            child: ValueListenableBuilder(
              valueListenable: _effectiveController,
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

  OutlineInputBorder _border({Color color = Palette.borderGrey}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: widget.filled ? BorderSide.none : BorderSide(color: color),
    );
  }
}
