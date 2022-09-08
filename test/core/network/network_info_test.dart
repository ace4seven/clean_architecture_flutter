import 'package:clean_architecture_tutorial/library/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'network_info_test.mocks.dart';


@GenerateMocks([DataConnectionChecker])
void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(dataConnectionChecker: mockDataConnectionChecker);
  });
  
  group('is connected', () {
    test('should be connected when user is connected into internet', () async {
      // arange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}