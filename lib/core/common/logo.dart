import 'package:academy_management_system/core/config/business_config.dart';
import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: LoginColors.coral,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Color(0x445F6670), offset: Offset(5, 5)),
            ],
          ),
          child: const Center(
            child: Text(
              'م',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Text(
          BusinessConfig.name,
          style: TextStyle(
            color: Color(0xFFFFFBF1),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class MobileLogo extends StatelessWidget {
  const MobileLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            BusinessConfig.name,
            style: TextStyle(
              color: LoginColors.navy,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 10),
          SmallLogoBox(),
        ],
      ),
    );
  }
}

class SmallLogoBox extends StatelessWidget {
  const SmallLogoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: LoginColors.coral,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'م',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
