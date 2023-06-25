part of 'stream_filter.dart';

class RunLengthDecodeFilter extends StreamFilter {
  const RunLengthDecodeFilter._() : super._();

  @override
  List<int> decode(
    List<int> bytes,
    PDFObject? params,
    PDFDictionary streamDictionary,
  ) {
    final out = ByteOutputStream(bytes.length);

    for (int i = 0; i < bytes.length; i++) {
      int n = bytes[i];
      if (n == 128) {
        break;
      }
      if ((n & 0x80) == 0) {
        final bytesToCopy = n + 1;
        out.writeAll(bytes.sublist(i + 1, i + bytesToCopy));
        i += n;
      } else {
        i++;
        for (var j = 0; j < 257 - (n & 0xFF); j++) {
          out.write(bytes[i]);
        }
      }
    }

    return out.getBytes();
  }
}