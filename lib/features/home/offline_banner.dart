import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

class OfflineBanner extends StatelessWidget {
  final DateTime updatedAt;
  final Color color;
  const OfflineBanner({super.key, required this.updatedAt, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final time = DateFormat.Hm(Localizations.localeOf(context).toString())
        .format(updatedAt);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(t.offlineBanner(time))),
        ],
      ),
    );
  }
}