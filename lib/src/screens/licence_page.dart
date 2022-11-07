import 'package:flutter/material.dart';

class LicensePageCustom extends StatefulWidget {
  static const String id = 'license_page';

  const LicensePageCustom({super.key});

  @override
  State<LicensePageCustom> createState() => _LicensePageCustomState();
}

class _LicensePageCustomState extends State<LicensePageCustom> {
  @override
  Widget build(BuildContext context) {
    return const LicensePage(
      applicationName: 'Progressable',
      applicationVersion: '1.5.1',
    );
  }
}
