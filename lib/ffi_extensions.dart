import 'dart:ffi';
import 'dart:typed_data';

extension PointerUtils on Pointer<NativeType> {
  bool get isNullPointer => address == 0;

  Uint8List copyRange(int length) {
    final list = Uint8List(length);
    list.setAll(0, cast<Uint8>().asTypedList(length));
    return list;
  }
}