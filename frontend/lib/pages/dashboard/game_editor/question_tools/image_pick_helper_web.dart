import 'dart:async';
import 'dart:html' as html;

/// Opens the browser/OS file dialog via a hidden file input (works on Flutter web).
Future<String?> pickImageAsDataUrl() async {
  final input = html.FileUploadInputElement()
    ..accept = 'image/*'
    ..multiple = false
    ..style.display = 'none';

  html.document.body?.append(input);

  StreamSubscription<html.Event>? changeSub;
  StreamSubscription<html.Event>? focusSub;

  try {
    final selected = Completer<html.File?>();

    changeSub = input.onChange.listen((_) {
      final files = input.files;
      if (!selected.isCompleted) {
        selected.complete(
          files != null && files.isNotEmpty ? files.first : null,
        );
      }
    });

    input.click();

    // Cancel detection: OS dialog cancel never fires `change`. After the
    // window regains focus, treat missing selection as cancel.
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      focusSub = html.window.onFocus.listen((_) {
        Future<void>.delayed(const Duration(milliseconds: 400), () {
          if (!selected.isCompleted) {
            selected.complete(null);
          }
        });
      });
    });

    final file = await selected.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () => null,
    );

    if (file == null) return null;

    final reader = html.FileReader();
    final loaded = Completer<String?>();
    reader.onLoad.listen((_) => loaded.complete(reader.result as String?));
    reader.onError.listen((_) => loaded.complete(null));
    reader.readAsDataUrl(file);
    return loaded.future;
  } finally {
    await changeSub?.cancel();
    await focusSub?.cancel();
    input.remove();
  }
}
