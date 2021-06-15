import 'package:async/async.dart';

void main() {
  listenString();
}

void listenString() async {
  StreamGroup<String> a = StreamGroup<String>();
  updateStreamGroup(a);
  a.stream.listen((event) {
    print("stream group value $event");
  });
}

Future updateStreamGroup(StreamGroup streamGroup) async {
  List<int> numbers = [];
  List<Stream<String>> numberStream = [];

  await for (var data in updateNumber()) {
    print(data);
    Stream<String> string =
        Stream<String>.periodic(Duration(seconds: 1), (x) => 'String $data')
            .take(15);
    numberStream.add(string);
    streamGroup.add(string);
  }
}

Stream<int> updateNumber() {
  Stream stream = Stream<int>.periodic(Duration(seconds: 1), (x) => x).take(15);
  return stream;
}
