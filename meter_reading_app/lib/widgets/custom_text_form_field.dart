import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final textController;
  final TextInputType textInputType;
  final String labelText;
  final String errorMessage;
  final bool canFieldBeEmpty;
  final int maxLine;
  final TextCapitalization textCap;

  const CustomTextFormField({
    Key key,
    this.textController,
    this.textInputType,
    this.labelText,
    this.errorMessage,
    this.maxLine = 1,
    this.canFieldBeEmpty = false,
    this.textCap = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            textCapitalization: textCap,
            maxLines: maxLine,
            minLines: 1,
            controller: textController,
            keyboardType: textInputType,
            validator: (value) =>
                value.isEmpty && !canFieldBeEmpty ? errorMessage : null,
            decoration: InputDecoration(labelText: labelText),
          ),
        ),
      ),
    );
  }
}
