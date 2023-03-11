import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart' as ci;
import '../providers/cart.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
      // await Provider.of<Categories>(context, listen: false)
      //     .fetchAndSetCategories();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => ci.Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              //Column sử dụng chính xác kích thước cần thiết để hiển thị các widget con, không phải kích thước tối đa có thể như trường hợp mainAxisSize là MainAxisSize.max.
              mainAxisSize: MainAxisSize.min,
              //widget con bên trong Column được căn chỉnh ngang với chiều rộng của Column.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Categories",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26),
                ),
                CategoryList(),
                Text(
                  "Sản phẩm nổi bật",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26),
                ),
                Expanded(
                  child: ProductsGrid(_showOnlyFavorites),
                ),
              ],
            ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<Categories>(context);
    return Container(
      width: double.infinity,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          // width: 80,
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                debugPrint('Category tap');
              },
              child: SizedBox(
                width: 200,
                height: 100,
                child: GridTile(
                  child: Image.network(
                    'https://cdn2.cellphones.com.vn/x,webp,q100/media/wysiwyg/mobile/dien-thoai-9.jpg',
                    fit: BoxFit.cover,
                  ),
                  footer: GridTileBar(
                      title: Text(
                    'Dien Thoai',
                    style: TextStyle(fontSize: 18),
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
