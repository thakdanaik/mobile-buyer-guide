import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';
import 'package:mobile_buyer_guide/theme/theme.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final PageController _pageController = PageController();
  List<Mobile> _mobileList = <Mobile>[];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _getMobileData();
    });
  }

  Future<void> _getMobileData() async {
    _mobileList = await MobileService(Dio()).getMobiles();
    setState(()  {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile List'),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMobileListView(context),
          const Center(
            child: Text('Fav Page'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }

  Widget _buildMobileListView(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _mobileList.length,
      itemBuilder: (context, index) {
        Mobile mobile = _mobileList[index];

        return Column(
          children: [
            _buildItemBox(context, mobile),
            const Divider(height: 1, thickness: 1.5),
          ],
        );
      },
    );
  }

  Widget _buildItemBox(BuildContext context, Mobile mobile) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network(
              mobile.thumbImageURL!,
              width: 80,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mobile.name!,
                        style: Theme.of(context).textTheme.large,
                      ),
                    ],
                  ),
                  Text(
                    mobile.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.normal,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: 'Price : ', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(text: '\$${mobile.price!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.normal),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: 'Rating : ', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(text: mobile.rating!.toStringAsFixed(1), style: Theme.of(context).textTheme.normal),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
