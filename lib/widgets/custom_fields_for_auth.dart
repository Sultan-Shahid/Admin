import 'package:flutter/material.dart';

class CustomFieldsForAuth extends StatefulWidget {
  final double? height;
  final double? width;
  final String? label_txt;
  final TextEditingController? controller;
  final Color? shadowColor;
  final bool? isRead;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool isObscure;

  const CustomFieldsForAuth({
    super.key,
    this.label_txt,
    this.controller,
    this.height,
    this.width,
    this.shadowColor,
    this.onChanged,
    this.validator,
    this.isRead,
    this.onTap,
    this.isObscure = false,
  });

  @override
  State<CustomFieldsForAuth> createState() => _CustomFieldsForAuthState();
}

class _CustomFieldsForAuthState extends State<CustomFieldsForAuth> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.isObscure;
  }

  OutlineInputBorder _borderStyle(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), // Matches container's border
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scaledHeight =
        MediaQuery.of(context).size.height * (widget.height ?? 0.06);
    final double scaledWidth =
        MediaQuery.of(context).size.width * (widget.width ?? 0.8);

    return Container(
      height: scaledHeight,
      width: scaledWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor?.withOpacity(0.5) ??
                Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: widget.isRead ?? false,
        onTap: widget.onTap,
        cursorColor: const Color(0xff1F41BB),
        controller: widget.controller,
        obscureText: isObscured,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label_txt,
          labelStyle: const TextStyle(color: Colors.black),
          border: _borderStyle(Colors.grey), // Show border
          enabledBorder: _borderStyle(Colors.grey),
          focusedBorder: _borderStyle(Colors.black),
          filled: true,
          fillColor: const Color(0xffF1F4FF), // Match container color
          contentPadding: EdgeInsets.symmetric(
              vertical: scaledHeight * 0.25, horizontal: 12),
          isDense: true, // Ensures text field height matches the container
          suffixIcon: widget.isObscure
              ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
