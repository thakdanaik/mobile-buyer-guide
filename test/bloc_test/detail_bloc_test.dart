import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_buyer_guide/bloc/detail/detail_bloc.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/models/mobile_image.dart';
import 'package:mockito/mockito.dart';

import '../mock_service/mobile_service.mocks.dart';

final Mobile mobile = Mobile(id: 1, name: 'Iphone SE', rating: 4.9, brand: 'Apple', price: 499.99, description: 'this is description');
final List<MobileImage> imageList = [
  MobileImage(id: 1, mobileId: 1, url: 'https://www.91-img.com/gallery_images_uploads/c/3/c32cff8945621ad06c929f50af9f7c55f978c726.jpg'),
  MobileImage(id: 2, mobileId: 1, url: 'https://www.91-img.com/gallery_images_uploads/c/3/c32cff8945621ad06c929f50af9f7c55f978c726.jpg'),
  MobileImage(id: 3, mobileId: 1, url: 'https://www.91-img.com/gallery_images_uploads/c/3/c32cff8945621ad06c929f50af9f7c55f978c726.jpg'),
];

void main() {
  late DetailBloc detailBloc;
  late MockMobileService mockService;

  setUp(() {
    mockService = MockMobileService();
    detailBloc = DetailBloc(mobileService: mockService, mobile: mobile);
  });

  group('test GetMobileDataEvent', () {
    blocTest<DetailBloc, DetailState>(
      'Success',
      setUp: () {
        when(mockService.getMobileImages(any)).thenAnswer((_) async => imageList);
      },
      build: () => detailBloc,
      act: (bloc) => bloc.add(GetMobileImageEvent()),
      expect: () => [
        isA<LoadingState>(),
        DetailState(mobile: mobile, imageList: imageList),
      ],
    );

    blocTest<DetailBloc, DetailState>(
      'Dio Error : response',
      setUp: () {
        when(mockService.getMobileImages(any)).thenThrow(DioError(requestOptions: RequestOptions(path: ''), type: DioErrorType.response, error: '404 Error'));
      },
      build: () => detailBloc,
      act: (bloc) => bloc.add(GetMobileImageEvent()),
      expect: () => [
        isA<LoadingState>(),
        ExceptionState(detailBloc.state, errorMsg: '404 Error'),
      ],
    );

    blocTest<DetailBloc, DetailState>(
      'Dio Error : other',
      setUp: () {
        when(mockService.getMobileImages(any)).thenThrow(DioError(requestOptions: RequestOptions(path: ''), type: DioErrorType.other, error: 'unknown Error'));
      },
      build: () => detailBloc,
      act: (bloc) => bloc.add(GetMobileImageEvent()),
      expect: () => [
        isA<LoadingState>(),
        ExceptionState(detailBloc.state, errorMsg: 'An error occurred in the system.'),
      ],
    );
  });

  tearDown(() => detailBloc.close());
}
