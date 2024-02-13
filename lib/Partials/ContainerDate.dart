import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ContainerDate extends StatelessWidget {
  ContainerDate({
    super.key,
    this.tanggal
  });

  String? tanggal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 10.dm,
          left: MediaQuery.of(context).size.width * 0.37,
          right:
              MediaQuery.of(context).size.width * 0.37),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: 25.dm,
        decoration: BoxDecoration(
            color: Color.fromARGB(72, 85, 85, 85),
            borderRadius: BorderRadius.circular(10.dm)),
        child: Padding(
          padding: EdgeInsets.all(4.dm),
          child: Text(
            (tanggal == null)? "${DateFormat("dd-MMM-yyyy").format(DateTime.now())}" : "${tanggal}",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}