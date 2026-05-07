import 'package:logbook/logbook.dart';
import 'package:ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constant/constant.dart';
import '../../../common/extension/context_extension.dart';

final class UpdateAppDialog extends StatelessWidget {
  const UpdateAppDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    shape: SmoothRectangleBorders(
      smoothness: .7,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      side: BorderSide(color: context.x.colors.divider, width: 1.5),
    ),
    insetPadding: const EdgeInsets.symmetric(horizontal: 40),
    constraints: const BoxConstraints(maxWidth: 600, minWidth: 300),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppText(
                    'New version available',
                    context.x.textStyle.w500s16.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: context.x.colors.text,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: context.x.colors.divider, thickness: 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 12,
              children: [
                Expanded(
                  child: ButtonFill(
                    state: ButtonState.active,
                    color: context.x.colors.buttonBorder,
                    borderSide: BorderSide(color: context.x.colors.gray, width: 1.5),
                    onPressed: () => Navigator.of(context).pop(),
                    child: AppText.w500s14('Cancel', color: context.x.colors.text),
                  ),
                ),
                Expanded(
                  child: ButtonFill(
                    state: ButtonState.active,
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop();
                        await launchUrl(Uri.parse(Constant.appLink), mode: LaunchMode.externalApplication);
                      } on Object catch (error, stackTrace) {
                        l.s(error, stackTrace);
                      }
                    },
                    child: AppText.w500s14('Update', color: context.x.colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
