import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/agent_horizontal_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/discover_section_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/discover_page_header.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/discover_page_search.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final controller = sl<CardMarketBloc>();
  CardModel? selectedCard;

  @override
  void initState() {
    controller.add(FetchAgentsEvent());
    super.initState();
  }

  List<AgentModel> get filteredAgents => selectedCard == null
      ? controller.agents ?? []
      : (controller.agents ?? [])
          .where((element) => element.agentCard?.id == selectedCard!.id)
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              pinned: true,
              actions: const [
                Icon(Icons.shopping_bag_outlined),
                SizedBox(width: 16)
              ],
              expandedHeight: 36.h + kTextTabBarHeight + kToolbarHeight,
              flexibleSpace: const DiscoverPageHeader(),
              backgroundColor: Colors.white,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                child: Container(
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 16, left: 12, right: 12),
                    child: DiscoverPageSearch(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12)
                      .copyWith(top: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  DiscoverSectionView(
                      heading: 'Hot Selling Products',
                      description: 'Browse the most popular products',
                      products: [
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image1.jpg',
                          productName: 'Smart Watch Series 5',
                          productSkuUniqueId: 'SKU12345',
                          productPrice: 299.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Stay connected with style with the latest Smart Watch Series 5.',
                          lookbookId: 'LB001',
                          productId: 'PRD001',
                          hushhId: 'HS001',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image2.jpg',
                          productName: 'Wireless Earbuds Pro',
                          productSkuUniqueId: 'SKU12346',
                          productPrice: 199.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Experience immersive sound with these noise-canceling earbuds.',
                          lookbookId: 'LB002',
                          productId: 'PRD002',
                          hushhId: 'HS002',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image3.jpg',
                          productName: 'Portable Bluetooth Speaker',
                          productSkuUniqueId: 'SKU12347',
                          productPrice: 89.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Take your music anywhere with this portable speaker.',
                          lookbookId: 'LB003',
                          productId: 'PRD003',
                          hushhId: 'HS003',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image4.jpg',
                          productName: 'High-Definition Smart TV',
                          productSkuUniqueId: 'SKU12348',
                          productPrice: 499.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Enjoy an immersive viewing experience with this HD smart TV.',
                          lookbookId: 'LB004',
                          productId: 'PRD004',
                          hushhId: 'HS004',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image5.jpg',
                          productName: 'Home Security Camera',
                          productSkuUniqueId: 'SKU12349',
                          productPrice: 149.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Monitor your home with this easy-to-use security camera.',
                          lookbookId: 'LB005',
                          productId: 'PRD005',
                          hushhId: 'HS005',
                        ),
                      ]),
                  DiscoverSectionView(
                      heading: 'New Arrivals',
                      description: 'Fresh & Dynamic feel',
                      products: [
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image6.jpg',
                          productName: 'Eco-Friendly Water Bottle',
                          productSkuUniqueId: 'SKU12350',
                          productPrice: 29.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Stay hydrated with our eco-friendly, reusable water bottle.',
                          lookbookId: 'LB006',
                          productId: 'PRD006',
                          hushhId: 'HS006',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image7.jpg',
                          productName: 'Organic Cotton T-Shirt',
                          productSkuUniqueId: 'SKU12351',
                          productPrice: 24.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Feel the comfort of 100% organic cotton.',
                          lookbookId: 'LB007',
                          productId: 'PRD007',
                          hushhId: 'HS007',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image8.jpg',
                          productName: 'Portable Laptop Stand',
                          productSkuUniqueId: 'SKU12352',
                          productPrice: 39.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Work comfortably with this adjustable laptop stand.',
                          lookbookId: 'LB008',
                          productId: 'PRD008',
                          hushhId: 'HS008',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image9.jpg',
                          productName: 'Noise-Canceling Headphones',
                          productSkuUniqueId: 'SKU12353',
                          productPrice: 149.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Immerse yourself in sound with these noise-canceling headphones.',
                          lookbookId: 'LB009',
                          productId: 'PRD009',
                          hushhId: 'HS009',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image10.jpg',
                          productName: 'Smart Thermostat',
                          productSkuUniqueId: 'SKU12354',
                          productPrice: 199.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Control your home’s temperature with ease.',
                          lookbookId: 'LB010',
                          productId: 'PRD010',
                          hushhId: 'HS010',
                        ),
                      ]),
                  BlocBuilder(
                      bloc: sl<CardMarketBloc>(),
                      builder: (context, state) {
                        final agents = sl<CardMarketBloc>().agents;
                        if (agents != null) {
                          return AgentHorizontalView(agents: agents);
                        }
                        return const SizedBox();
                      }),
                  DiscoverSectionView(
                      heading: 'Trending Now',
                      description: 'Our trending products',
                      products: [
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image11.jpg',
                          productName: 'Minimalist Wall Clock',
                          productSkuUniqueId: 'SKU12355',
                          productPrice: 49.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Add a touch of minimalism to your space with this wall clock.',
                          lookbookId: 'LB011',
                          productId: 'PRD011',
                          hushhId: 'HS011',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image12.jpg',
                          productName: 'Essential Oil Diffuser',
                          productSkuUniqueId: 'SKU12356',
                          productPrice: 39.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Relax with your favorite essential oils.',
                          lookbookId: 'LB012',
                          productId: 'PRD012',
                          hushhId: 'HS012',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image13.jpg',
                          productName: 'Wireless Charging Pad',
                          productSkuUniqueId: 'SKU12357',
                          productPrice: 24.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Charge your devices wirelessly with ease.',
                          lookbookId: 'LB013',
                          productId: 'PRD013',
                          hushhId: 'HS013',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image14.jpg',
                          productName: 'Stainless Steel Travel Mug',
                          productSkuUniqueId: 'SKU12358',
                          productPrice: 19.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Keep your drinks hot or cold on the go.',
                          lookbookId: 'LB014',
                          productId: 'PRD014',
                          hushhId: 'HS014',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image15.jpg',
                          productName: 'Yoga Mat',
                          productSkuUniqueId: 'SKU12359',
                          productPrice: 29.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Achieve peace and relaxation on this high-quality yoga mat.',
                          lookbookId: 'LB015',
                          productId: 'PRD015',
                          hushhId: 'HS015',
                        ),
                      ]),
                  DiscoverSectionView(
                      heading: 'Best in Footwear',
                      description: 'Our trending products',
                      products: [
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image16.jpg',
                          productName: 'Running Sneakers',
                          productSkuUniqueId: 'SKU12360',
                          productPrice: 79.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Stay active with these comfortable running sneakers.',
                          lookbookId: 'LB016',
                          productId: 'PRD016',
                          hushhId: 'HS016',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image17.jpg',
                          productName: 'Leather Loafers',
                          productSkuUniqueId: 'SKU12361',
                          productPrice: 99.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Classic leather loafers for a touch of elegance.',
                          lookbookId: 'LB017',
                          productId: 'PRD017',
                          hushhId: 'HS017',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image18.jpg',
                          productName: 'Casual Slip-Ons',
                          productSkuUniqueId: 'SKU12362',
                          productPrice: 59.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Easy slip-ons for everyday comfort.',
                          lookbookId: 'LB018',
                          productId: 'PRD018',
                          hushhId: 'HS018',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image19.jpg',
                          productName: 'Hiking Boots',
                          productSkuUniqueId: 'SKU12363',
                          productPrice: 129.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Tough and durable boots for your outdoor adventures.',
                          lookbookId: 'LB019',
                          productId: 'PRD019',
                          hushhId: 'HS019',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image20.jpg',
                          productName: 'Stylish Sandals',
                          productSkuUniqueId: 'SKU12364',
                          productPrice: 49.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Beat the heat with these stylish, comfortable sandals.',
                          lookbookId: 'LB020',
                          productId: 'PRD020',
                          hushhId: 'HS020',
                        ),
                      ]),
                  DiscoverSectionView(
                      heading: 'Luxury & Premium Picks',
                      description: 'Our trending products',
                      products: [
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image21.jpg',
                          productName: 'Luxury Leather Handbag',
                          productSkuUniqueId: 'SKU12365',
                          productPrice: 499.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Crafted with the finest leather for a touch of luxury.',
                          lookbookId: 'LB021',
                          productId: 'PRD021',
                          hushhId: 'HS021',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image22.jpg',
                          productName: 'Diamond Stud Earrings',
                          productSkuUniqueId: 'SKU12366',
                          productPrice: 799.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Elegant diamond earrings for special occasions.',
                          lookbookId: 'LB022',
                          productId: 'PRD022',
                          hushhId: 'HS022',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image23.jpg',
                          productName: 'Designer Sunglasses',
                          productSkuUniqueId: 'SKU12367',
                          productPrice: 249.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Shield your eyes with style and sophistication.',
                          lookbookId: 'LB023',
                          productId: 'PRD023',
                          hushhId: 'HS023',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image24.jpg',
                          productName: 'Luxury Watch',
                          productSkuUniqueId: 'SKU12368',
                          productPrice: 999.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Timeless elegance with a luxury brand watch.',
                          lookbookId: 'LB024',
                          productId: 'PRD024',
                          hushhId: 'HS024',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image25.jpg',
                          productName: 'Silk Scarf',
                          productSkuUniqueId: 'SKU12369',
                          productPrice: 149.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Soft, elegant scarf made from the finest silk.',
                          lookbookId: 'LB025',
                          productId: 'PRD025',
                          hushhId: 'HS025',
                        ),
                      ]),
                  DiscoverSectionView(
                      heading: 'Top-Rated',
                      description: 'Our trending products',
                      products: [
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image26.jpg',
                          productName: 'Ergonomic Office Chair',
                          productSkuUniqueId: 'SKU12370',
                          productPrice: 299.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Top-rated ergonomic chair for maximum comfort.',
                          lookbookId: 'LB026',
                          productId: 'PRD026',
                          hushhId: 'HS026',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image27.jpg',
                          productName: 'Electric Toothbrush',
                          productSkuUniqueId: 'SKU12371',
                          productPrice: 89.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Highly recommended electric toothbrush with smart features.',
                          lookbookId: 'LB027',
                          productId: 'PRD027',
                          hushhId: 'HS027',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image28.jpg',
                          productName: 'Kitchen Blender',
                          productSkuUniqueId: 'SKU12372',
                          productPrice: 59.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Powerful blender for all your kitchen needs.',
                          lookbookId: 'LB028',
                          productId: 'PRD028',
                          hushhId: 'HS028',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image29.jpg',
                          productName: 'Noise-Reducing Curtains',
                          productSkuUniqueId: 'SKU12373',
                          productPrice: 39.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Block out noise and light with these high-quality curtains.',
                          lookbookId: 'LB029',
                          productId: 'PRD029',
                          hushhId: 'HS029',
                        ),
                        AgentProductModel(
                          productImage: 'https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png', // : 'https://example.com/image30.jpg',
                          productName: 'Professional Camera',
                          productSkuUniqueId: 'SKU12374',
                          productPrice: 799.99,
                          productCurrency: 'USD',
                          productDescription:
                              'Capture high-quality images with this professional-grade camera.',
                          lookbookId: 'LB030',
                          productId: 'PRD030',
                          hushhId: 'HS030',
                        ),
                      ]),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
