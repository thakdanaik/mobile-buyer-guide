import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_buyer_guide/bloc/catalog/catalog_bloc.dart';

import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/screens/catalog.dart';
import 'package:mockito/mockito.dart';

import '../mock_service/mobile_service.mocks.dart';


void main() {
  LiveTestWidgetsFlutterBinding();

  late CatalogBloc catalogBloc;
  late MockMobileService mockService;

  final List<Mobile> mobileList = [
    Mobile(id: 1, name: 'Iphone SE', rating: 4.9, brand: 'Apple', price: 499.99, description: 'This is description of Iphone SE'),
    Mobile(id: 2, name: 'Galaxy Note', rating: 4.7, brand: 'Samsung', price: 399.99, description: 'This is description of Galaxy Note'),
    Mobile(id: 3, name: 'Moto E5', rating: 4.6, brand: 'Motorola', price: 199.99, description: 'This is description of Moto E5'),
    Mobile(id: 4, name: 'MI 6', rating: 4.5, brand: 'Xiaomi', price: 299.99, description: 'This is description of MI 6'),
  ];

  setUp(() {
    mockService = MockMobileService();
    catalogBloc = CatalogBloc(mobileService: mockService);
  });

  _createWidget(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      title: 'Test',
      home: CatalogView(
        catalogBloc: catalogBloc,
      ),
    ));
  }

  testWidgets('test CatalogView', (WidgetTester tester) async {
    when(mockService.getMobiles()).thenAnswer((_) async => mobileList.map((e) => e..isFavorite = false).toList());

    await _createWidget(tester);
    await tester.pumpAndSettle();

    //Check Layout
    expect(find.text('Mobile List'), findsOneWidget);
    expect(find.text('List'), findsOneWidget);
    expect(find.text('Favorite'), findsOneWidget);

    //Check Item after Bloc
    await expectLater(find.text('Iphone SE'), findsOneWidget);
    await expectLater(find.byWidgetPredicate((Widget widget) => widget is RichText && widget.text.toPlainText() == 'Price : \$499.99'), findsOneWidget);

    //Tap Favorite
    await tester.tap(find.byIcon(Icons.favorite_outline).first);
    await tester.pump(const Duration(seconds: 5));
    await expectLater((tester.firstWidget(find.byType(Icon)) as Icon).color, Colors.redAccent);

    //Change to Favorite View
    await tester.tap(find.text('Favorite'));
    await tester.pumpAndSettle();
    expect(find.text('Moto E5'), findsOneWidget);

    //Dismiss Item
    await tester.drag(find.byType(Dismissible).first, const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text('Moto E5'), findsNothing);

    //Check Popup Sort
    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();
    expect(find.text('Price (Low to High)'), findsOneWidget);
    expect(find.text('Price (High to Low)'), findsOneWidget);
    expect(find.text('Rating (5 to 1)'), findsOneWidget);

  });

  tearDown(() {
    catalogBloc.close();
  });
}
