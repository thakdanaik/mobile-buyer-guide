import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_buyer_guide/bloc/detail/detail_bloc.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/models/mobile_image.dart';
import 'package:mobile_buyer_guide/screens/detail.dart';
import 'package:mockito/mockito.dart';

import '../mock_service/mobile_service.mocks.dart';


void main() {
  LiveTestWidgetsFlutterBinding();

  late DetailBloc detailBloc;
  late MockMobileService mockService;

  final Mobile mobile = Mobile(id: 1, name: 'Iphone SE', rating: 4.9, brand: 'Apple', price: 499.99, description: 'This is description of Iphone SE');
  final List<MobileImage> imageList = [
    MobileImage(id: 1, mobileId: 1, url: 'https://www.91-img.com/gallery_images_uploads/f/c/fc3fba717874d64cf15d30e77a16617a1e63cc0b.jpg'),
    MobileImage(id: 2, mobileId: 1, url: 'https://www.91-img.com/gallery_images_uploads/c/3/c32cff8945621ad06c929f50af9f7c55f978c726.jpg'),
  ];

  setUp(() {
    HttpOverrides.global = null;
    mockService = MockMobileService();
    detailBloc = DetailBloc(mobileService: mockService, mobile: mobile);
  });

  _createWidget(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      title: 'Test',
      home: DetailView(
        detailBloc: detailBloc,
      ),
    ));
  }

  testWidgets('test DetailView', (WidgetTester tester) async {
    when(mockService.getMobileImages(any)).thenAnswer((_) async => imageList);

    await _createWidget(tester);
    await tester.pumpAndSettle();

    //Check Layout
    expect(find.text(mobile.name!), findsOneWidget);
    expect(find.byWidgetPredicate((Widget widget) => widget is RichText && widget.text.toPlainText() == 'Brand : ${mobile.brand}'), findsOneWidget);
    expect(find.text(mobile.description!), findsOneWidget);

    final Image image = find.byType(Image).evaluate().single.widget as Image;
    expect((image.image as NetworkImage).url, imageList.first.url);

    await tester.drag(find.byType(Image), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();
    final Image image2 = find.byType(Image).evaluate().single.widget as Image;
    expect((image2.image as NetworkImage).url, imageList.last.url);
  });

  tearDown(() {
    detailBloc.close();
  });
}
