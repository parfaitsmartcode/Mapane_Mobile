import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

class CustomTextForm extends StatefulWidget {
  final String placeholder;
  final String asset;
  const CustomTextForm({Key key, this.placeholder, this.asset})
      : super(key: key);

  @override
  _CustomTextFormState createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: getSize(18, "height", context),
      ),
      decoration: InputDecoration(
        hintText: "Ma position",
        prefixIcon: SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: getSize(16, "height", context),
                horizontal: getSize(16, "width", context)),
            child: Image.asset(
              'assets/images/iconprofile.png',
              height: getSize(21, "height", context),
              width: getSize(16, "width", context),
            ),
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyle(
          fontSize: getSize(18, "height", context),
          height: 2.9,
          //fontFamily: 'Robotto',
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getSize(25, "height", context)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getSize(25, "height", context)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
