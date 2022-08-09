import 'package:songlib/model/data/enums.dart';
import 'package:songlib/screen/base/simple_screen.dart';
import 'package:songlib/widget/general/styled/songlib_button.dart';
import 'package:songlib/widget/menu_background/menu_box.dart';
import 'package:songlib/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class TutorialWidget extends StatelessWidget {
  final TutorialType tutorialType;
  final VoidCallback onDismiss;

  const TutorialWidget({
    required this.tutorialType,
    required this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) => SimpleScreen(
        transparant: true,
        child: MenuBox(
          title: localization.getTranslation(tutorialType.titleKey),
          child: Container(
            width: 360,
            height: 256,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  localization.getTranslation(tutorialType.descriptionKey),
                  style: theme.coreTextTheme.bodyUltraSmall,
                ),
                const Spacer(),
                SongLibButton(
                  type: SongLibButtonType.green,
                  text: localization.tutorialConfirm,
                  onClick: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}