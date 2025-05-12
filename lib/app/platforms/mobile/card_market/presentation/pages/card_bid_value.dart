import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_loader_screen.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';

class CardValueArgs {
  final CardModel cardData;
  final List<UserPreference>? userSelections;
  final String? audioValue;
  final bool editMode;

  CardValueArgs(
      {this.audioValue,
      required this.cardData,
      this.userSelections,
      this.editMode = false});
}

class CardValuePage extends StatefulWidget {
  @override
  State<CardValuePage> createState() => _CardValuePageState();
}

class _CardValuePageState extends State<CardValuePage> {
  String minimumBid = '';
  final FocusNode _focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool editMode = false; // Variable to track edit mode

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as CardValueArgs;
      if (args.editMode) {
        setState(() {
          editMode = true;
          controller = TextEditingController(text: args.cardData.cardValue);
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
          _focusNode.requestFocus();
        });
      } else {
        controller = TextEditingController(text: '1');
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CardValueArgs;
    final cardData = args.cardData;
    final userSelections = args.userSelections;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Text(
          'Card Value',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Figtree',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
        child: Column(
          children: [
            const SizedBox(height: 64.63),
            SizedBox(
              width: 327,
              child: Text(
                'Set a value for your \n${cardData.brandName} preference card',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            const SizedBox(
              width: 300.54,
              child: Text(
                'Once sharing is completed, the money will be deposited into your private wallet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF118CFD),
                  fontSize: 14,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: 150,
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: controller,
                  decoration: InputDecoration(
                      prefixText: Utils().getCurrencyFromCurrencySymbol(
                                  cardData.cardCurrency)
                              ?.shorten() ??
                          sl<HomePageBloc>().currency.shorten(),
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 52,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                      errorText: (int.tryParse(minimumBid) == 0)
                          ? 'Please enter value more than 0'
                          : null,
                      errorMaxLines: 2),
                  cursorColor: Colors.white,
                  onChanged: (String value) {
                    setState(() {
                      minimumBid = value; // Update the minimumBid variable
                    });
                  },
                  style: const TextStyle(
                    fontSize: 52,
                    height: 1.5,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.light,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () {
                    _focusNode.unfocus();
                    FocusScope.of(context).unfocus();
                    if ((int.tryParse(minimumBid) == 0)) {
                      return;
                    }
                    if (args.editMode) {
                      sl<CardMarketBloc>().add(UpdateMinimumBidValueEvent(
                          context,
                          cardData,
                          controller.text,
                          Utils().getCurrencyFromCurrencySymbol(
                                  cardData.cardCurrency) ??
                              sl<HomePageBloc>().currency));
                    } else {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.cardMarketPlace.cardLoader,
                        arguments: CardLoaderScreenArgs(
                          cardData: cardData,
                          audioValue: args.audioValue,
                          coins: controller.text,
                          userSelections: userSelections!,
                          cardCoins: controller.text.toString(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 327.30,
                    height: 48.63,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.96, vertical: 13.09),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color:
                          (int.tryParse(minimumBid) == 0) ? Colors.grey : null,
                      gradient: (int.tryParse(minimumBid) == 0)
                          ? null
                          : const LinearGradient(
                              begin: Alignment(-1.00, 0.05),
                              end: Alignment(1, -0.05),
                              colors: [Color(0xFFE54D60), Color(0xFFA342FF)],
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(67),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Color(0xFFF6F6F6),
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.w700,
                            height: 1,
                            letterSpacing: 0.20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
