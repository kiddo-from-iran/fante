import 'dart:async';
import 'dart:html' as html;

/// Opens the browser/OS file dialog via a hidden file input (works on Flutter web).
Future<String?> pickImageAsDataUrl() async {
  final input = html.FileUploadInputElement()
    ..accept = 'image/*'
    ..multiple = false
    ..style.display = 'none';

  html.document.body?.append(input);

  try {
    final selected = Completer<html.File?>();

    late final StreamSubscription<html.Event> changeSub;
    changeSub = input.onChange.listen((_) {
      final files = input.files;
      if (!selected.isCompleted) {
        selected.complete(
          files != null && files.isNotEmpty ? files.first : null,
        );
      }
      changeSub.cancel();
    });

    input.click();

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
    input.remove();
  }
}
