import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VAvatar', () {
    testWidgets('creates VAvatar.text', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatar.text('KM'),
          ),
        ),
      );

      expect(find.byType(VAvatar), findsOneWidget);
      expect(find.text('KM'), findsOneWidget);
    });

    testWidgets('shows only first 2 characters when text exceeds 2 chars', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatar.text('ABCD'),
          ),
        ),
      );

      expect(find.text('AB'), findsOneWidget);
    });

    testWidgets('renders with each size', (tester) async {
      for (final size in VAvatarSize.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VAvatar.text('T', size: size),
            ),
          ),
        );

        expect(find.byType(VAvatar), findsOneWidget);
      }
    });

    testWidgets('renders with each shape', (tester) async {
      for (final shape in VAvatarShape.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VAvatar.text('T', shape: shape),
            ),
          ),
        );

        expect(find.byType(VAvatar), findsOneWidget);
      }
    });

    testWidgets('onTap callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatar.text('T', onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(VAvatar));
      expect(tapped, isTrue);
    });

    testWidgets('creates VAvatar.icon', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatar.icon(Icons.person),
          ),
        ),
      );

      expect(find.byType(VAvatar), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('does not throw on emoji and keeps grapheme clusters whole', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatar.text('a\u{1F600}b'),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('A\u{1F600}'), findsOneWidget);
    });

    testWidgets('tries a new image provider after the old one failed', (
      tester,
    ) async {
      Widget build(ImageProvider provider) => VTheme(
        data: VThemeData.light(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: VAvatar.image(
            imageProvider: provider,
            errorWidget: const Text('ERR'),
          ),
        ),
      );

      await tester.pumpWidget(build(_FailingProvider()));
      await tester.pump();
      await tester.pump();
      expect(find.text('ERR'), findsOneWidget);

      await tester.pumpWidget(build(_PendingProvider()));
      await tester.pump();

      expect(find.text('ERR'), findsNothing);
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('VAvatarGroup', () {
    testWidgets('creates default group', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatarGroup(
              children: [
                VAvatar.text('A'),
                VAvatar.text('B'),
                VAvatar.text('C'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VAvatarGroup), findsOneWidget);
    });

    testWidgets('shows +N when exceeding max', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatarGroup(
              max: 2,
              children: [
                VAvatar.text('A'),
                VAvatar.text('B'),
                VAvatar.text('C'),
                VAvatar.text('D'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('+2'), findsOneWidget);
    });

    testWidgets('max below zero collapses every avatar into the tile', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatarGroup(
              max: -1,
              children: [VAvatar.text('A'), VAvatar.text('B')],
            ),
          ),
        ),
      );

      expect(find.text('+2'), findsOneWidget);
      expect(find.text('A'), findsNothing);
    });

    testWidgets('every avatar and its ring stay inside the group box', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VAvatarGroup(
                max: 2,
                children: [
                  VAvatar.text('A'),
                  VAvatar.text('B'),
                  VAvatar.text('C'),
                ],
              ),
            ),
          ),
        ),
      );

      final group = tester.getRect(find.byType(VAvatarGroup));
      final stack = find.descendant(
        of: find.byType(VAvatarGroup),
        matching: find.byType(Positioned),
      );
      expect(stack, findsNWidgets(3));
      for (var i = 0; i < 3; i++) {
        final rect = tester.getRect(
          find
              .descendant(of: stack.at(i), matching: find.byType(Container))
              .first,
        );
        expect(rect.left, greaterThanOrEqualTo(group.left - 0.01));
        expect(rect.right, lessThanOrEqualTo(group.right + 0.01));
        expect(rect.top, greaterThanOrEqualTo(group.top - 0.01));
        expect(rect.bottom, lessThanOrEqualTo(group.bottom + 0.01));
      }
    });
  });

  group('theme override', () {
    testWidgets('theme componentOverrides applies to avatar', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VAvatarStyle(backgroundColor: Color(0xFFFF0000)),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAvatar.text('KM'),
          ),
        ),
      );

      expect(find.byType(VAvatar), findsOneWidget);
    });
  });
}

class _FailingProvider extends ImageProvider<_FailingProvider> {
  @override
  Future<_FailingProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    _FailingProvider key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(
    Future<ImageInfo>.error(Exception('load failed')),
  );
}

class _PendingProvider extends ImageProvider<_PendingProvider> {
  @override
  Future<_PendingProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(
    _PendingProvider key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(Completer<ImageInfo>().future);
}
