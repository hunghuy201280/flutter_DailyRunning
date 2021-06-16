import 'package:async/async.dart';

void main() {
  List<bool> medalAchieved = List.filled(5, false).toList();
  double distance = 60;
  if (distance >= 1000) {
    medalAchieved = List.filled(5, true).toList();
  } else if (distance >= 500) {
    medalAchieved = List.filled(4, true).toList()..add(false);
  } else if (distance >= 200) {
    medalAchieved = List.filled(3, true).toList()
      ..addAll(List.filled(2, false));
  } else if (distance >= 100) {
    medalAchieved = List.filled(2, true).toList()
      ..addAll(List.filled(3, false));
  } else if (distance >= 50) {
    medalAchieved = [true]..addAll(List.filled(4, false));
  }
  medalAchieved.forEach((element) => print(element));
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
