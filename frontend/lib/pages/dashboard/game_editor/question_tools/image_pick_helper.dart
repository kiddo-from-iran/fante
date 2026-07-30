/// Cross-platform image pick → data URL.
/// Web uses a native `<input type="file">` (no plugin channel).
library;

export 'image_pick_helper_stub.dart'
    if (dart.library.html) 'image_pick_helper_web.dart'
    if (dart.library.io) 'image_pick_helper_io.dart';
