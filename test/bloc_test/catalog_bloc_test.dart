import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_buyer_guide/bloc/catalog/catalog_bloc.dart';
import 'package:mobile_buyer_guide/constants/constant.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mockito/mockito.dart';

import 'mobile_service.mocks.dart';

final Mobile iphone = Mobile(id: 1, name: 'Iphone SE', rating: 4.9, brand: 'Apple', price: 499.99);
final Mobile samsung = Mobile(id: 2, name: 'Galaxy Note', rating: 4.7, brand: 'Samsung', price: 399.99);
final Mobile motorola = Mobile(id: 3, name: 'Moto E5', rating: 4.6, brand: 'Motorola', price: 199.99);
final Mobile xiaomi = Mobile(id: 4, name: 'MI 6', rating: 4.5, brand: 'Xiaomi', price: 299.99);

void main() {
  late CatalogBloc catalogBloc;
  late MockMobileService mockService;

  setUp(() {
    mockService = MockMobileService();
    catalogBloc = CatalogBloc(mobileService: mockService);
  });

  group('test GetMobileDataEvent', () {
    blocTest<CatalogBloc, CatalogState>(
      'Success',
      setUp: () {
        when(mockService.getMobiles()).thenAnswer((_) async => [iphone, samsung, motorola, xiaomi]);
      },
      build: () => catalogBloc,
      act: (bloc) => bloc.add(GetMobileDataEvent()),
      expect: () => [
        isA<LoadingState>(),
        CatalogState(mobileList: [motorola, xiaomi, samsung, iphone], currentPage: catalogBloc.state.currentPage),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'Dio Error : response',
      setUp: () {
        when(mockService.getMobiles()).thenThrow(DioError(requestOptions: RequestOptions(path: ''), type: DioErrorType.response, error: '404 Error'));
      },
      build: () => catalogBloc,
      act: (bloc) => bloc.add(GetMobileDataEvent()),
      expect: () => [
        isA<LoadingState>(),
        ExceptionState(catalogBloc.state, errorMsg: '404 Error'),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'Dio Error : other',
      setUp: () {
        when(mockService.getMobiles()).thenThrow(DioError(requestOptions: RequestOptions(path: ''), type: DioErrorType.other, error: 'unknown Error'));
      },
      build: () => catalogBloc,
      act: (bloc) => bloc.add(GetMobileDataEvent()),
      expect: () => [
        isA<LoadingState>(),
        ExceptionState(catalogBloc.state, errorMsg: 'An error occurred in the system.'),
      ],
    );
  });

  blocTest<CatalogBloc, CatalogState>(
    'test ChangePageViewEvent',
    setUp: () {},
    build: () => catalogBloc,
    act: (bloc) => bloc.add(ChangePageViewEvent(pageIndex: 2)),
    expect: () => [const CatalogState(currentPage: 2)],
  );

  blocTest<CatalogBloc, CatalogState>(
    'test AddFavoriteEvent',
    setUp: () {
      when(mockService.getMobiles()).thenAnswer((_) async => [iphone, samsung, motorola, xiaomi].map((e) => e..isFavorite = false).toList());
    },
    build: () => catalogBloc,
    act: (bloc) => bloc
      ..add(GetMobileDataEvent())
      ..add(AddFavoriteEvent(mobile: iphone))
      ..add(AddFavoriteEvent(mobile: samsung))
      // //Add Old Mobile, Must not duplicate
      ..add(AddFavoriteEvent(mobile: iphone)),
    skip: 2,
    expect: () => [
      CatalogState(mobileList: [motorola, xiaomi, samsung, iphone], favoriteList: [iphone], currentPage: catalogBloc.state.currentPage),
      //Samsung First Because default sort by price low to high
      CatalogState(mobileList: [motorola, xiaomi, samsung, iphone], favoriteList: [samsung, iphone], currentPage: catalogBloc.state.currentPage),
    ],
  );

  blocTest<CatalogBloc, CatalogState>(
    'test RemoveFavoriteEvent',
    setUp: () {
      when(mockService.getMobiles()).thenAnswer((_) async => [iphone, samsung, motorola, xiaomi].map((e) => e..isFavorite = false).toList());
    },
    build: () => catalogBloc,
    act: (bloc) => bloc
      ..add(GetMobileDataEvent())
      ..add(AddFavoriteEvent(mobile: iphone))
      ..add(AddFavoriteEvent(mobile: samsung))
      ..add(RemoveFavoriteEvent(mobile: iphone)),
    skip: 4,
    expect: () => [
      CatalogState(mobileList: [motorola, xiaomi, samsung, iphone], favoriteList: [samsung], currentPage: catalogBloc.state.currentPage),
    ],
  );

  group('test SortDataEvent', () {
    blocTest<CatalogBloc, CatalogState>(
      'Sort By Rating',
      setUp: () {
        when(mockService.getMobiles()).thenAnswer((_) async => [iphone, samsung, motorola, xiaomi].map((e) => e..isFavorite = false).toList());
      },
      build: () => catalogBloc,
      act: (bloc) => bloc
        ..add(GetMobileDataEvent())
        ..add(AddFavoriteEvent(mobile: iphone))
        ..add(AddFavoriteEvent(mobile: samsung))
        ..add(SortDataEvent(sortBy: SortBy.rating)),
      skip: 4,
      expect: () => [
        isA<LoadingState>(),
        CatalogState(mobileList: [iphone, samsung, motorola, xiaomi], favoriteList: [iphone, samsung], currentPage: catalogBloc.state.currentPage, sortBy: SortBy.rating),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'Sort By Price (High to Low)',
      setUp: () {
        when(mockService.getMobiles()).thenAnswer((_) async => [iphone, samsung, motorola, xiaomi].map((e) => e..isFavorite = false).toList());
      },
      build: () => catalogBloc,
      act: (bloc) => bloc
        ..add(GetMobileDataEvent())
        ..add(AddFavoriteEvent(mobile: xiaomi))
        ..add(AddFavoriteEvent(mobile: samsung))
        ..add(SortDataEvent(sortBy: SortBy.priceHighToLow)),
      skip: 4,
      expect: () => [
        isA<LoadingState>(),
        CatalogState(mobileList: [iphone, samsung, xiaomi, motorola], favoriteList: [samsung, xiaomi], currentPage: catalogBloc.state.currentPage, sortBy: SortBy.priceHighToLow),
      ],
    );

    blocTest<CatalogBloc, CatalogState>(
      'Sort By Price (Low to High)',
      setUp: () {
        when(mockService.getMobiles()).thenAnswer((_) async => [iphone, samsung, motorola, xiaomi].map((e) => e..isFavorite = false).toList());
      },
      build: () => catalogBloc,
      act: (bloc) => bloc
        ..add(GetMobileDataEvent())
        ..add(AddFavoriteEvent(mobile: xiaomi))
        ..add(AddFavoriteEvent(mobile: motorola))
        ..add(SortDataEvent(sortBy: SortBy.rating))
        ..add(SortDataEvent(sortBy: SortBy.priceLowToHigh)),
      skip: 6,
      expect: () => [
        isA<LoadingState>(),
        CatalogState(mobileList: [motorola, xiaomi, samsung, iphone], favoriteList: [motorola, xiaomi], currentPage: catalogBloc.state.currentPage, sortBy: SortBy.priceLowToHigh),
      ],
    );
  });

  tearDown(() => catalogBloc.close());
}
