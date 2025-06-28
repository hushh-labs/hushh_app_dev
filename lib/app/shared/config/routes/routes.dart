import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/main_page.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/card_created_success_page.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/otp_verification.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/agent_market_place.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/audio_notes.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/business_card_questions.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_bid_value.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_loader_screen.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_market_place.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_questions.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/edit_card_questions.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/introducing_agents.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/share_your_preferences.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_dashboard.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_edit_profile.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_hushh_meet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/create_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_meeting_info.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_order_checkout.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_products.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_profile.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/shared_assets_receipts.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/inventory/inventory_products_page.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/inventory/manage_inventory.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/new_task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/notifications.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/user_hushh_meet.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/ai_chat.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/chat.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/invite_users.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/agent_home.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/agent_status.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/coins_dashboard.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/home.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_dashboard.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/receipt_radar_insights.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_items.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_onboarding.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_search.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/recipt_radar_brand_dashboard.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/browsing_analytics.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/delete_account.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/permissions.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/settings.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/wishlist_products.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/pages/new-tutorial.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/pages/splash.dart';
import 'package:hushh_app/app/shared/config/routes/card_market_place_routes.dart';
import 'package:hushh_app/app/shared/config/routes/card_wallet_routes.dart';
import 'package:hushh_app/app/shared/config/routes/chat_routes.dart';
import 'package:hushh_app/app/shared/config/routes/receipt_radar_routes.dart';
import 'package:hushh_app/app/shared/config/routes/shared_routes.dart';
import 'package:hushh_app/app/shared/core/components/payment_methods.dart';
import 'package:hushh_app/app/shared/core/components/pdf_network_viewer.dart';
import 'package:hushh_app/app/shared/core/components/pdf_viewer.dart';
import 'package:hushh_app/app/shared/core/components/text_viewer.dart';
import 'package:hushh_app/app/shared/core/components/web_viewer.dart';

class AppRoutes {
  static const String initial = '/';

  // static const String tutorial = '/onboarding';
  static const String splash = '/splash';
  static const String share = '/share';

  // static const String auth = '/auth';
  // static const String agentSignUp = '/agent-sign-up';
  // static const String agentCategories = '/agent-categories';
  static const String userSignUp = '/user-sign-up';
  static const String emailVerification = '/email-verification';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String inviteUsersToHushh = '/invite-to-hushh';
  static const String permissions = '/permissions';
  static const String deleteAccount = '/delete-account';
  static ChatRoutes chat = ChatRoutes();
  static CardMarketPlace cardMarketPlace = CardMarketPlace();
  static CardWalletRoutes cardWallet = CardWalletRoutes();
  static ReceiptRadarRoutes receiptRadar = ReceiptRadarRoutes();
  static SharedRoutes shared = SharedRoutes();
  static const String agentHome = '/agent-home';
  static const String agentStatus = '/agent-status';
  static const String agentDashboard = '/agent-dashboard';
  static const String agentNewTask = '/agent-new-task';
  static const String agentCreateMeeting = '/agent-meeting';
  static const String agentMeetingInfo = '/agent-meeting-info';
  static const String agentProfile = '/agent-profile';
  static const String agentLookbook = '/agent-lookbook';
  static const String createLookbook = '/create-lookbook';
  static const String agentProducts = '/agent-products';
  static const String agentOrderCheckout = '/agent-order-checkout';
  static const String agentHushhMeet = '/agent-hushh-meet';
  static const String userHushhMeet = '/user-hushh-meet';
  static const String browsingAnalytics = '/browsing-analytics';
  static const String wishlistProducts = '/wishlist-products';
  static const String agentEditProfile = '/agent-edit-profile';
  static const String manageInventory = '/manage-inventory';
  static const String inventoryProductsPage = '/create-inventory';

  static const String mainAuth = '/main-auth';
  static const String newTutorial = '/new-tutorial';
  static const String userGuidePage = '/user-guide-create-first-card';
  static const String cardCreatedSuccessPage = '/card-created-success-page';
}

class WebRoutes {
  static const String initial = '/';
  static const String cardInfo = '/card-info';
  static const String cardWalletInfo = '/card-wallet-info';
  static const String paymentMethods = '/payment-methods';
}

class NavigationManager {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.initial: (context) => const SplashPage(),
    // AppRoutes.tutorial: (context) => const TutorialPage(),
    AppRoutes.splash: (context) => const SplashPage(),
    // AppRoutes.share: (context) => const ShareExtension(),
    // AppRoutes.auth: (context) => const AuthPage(),
    AppRoutes.mainAuth: (context) => const MainAuthPage(),
    AppRoutes.newTutorial: (context) => const NewTutorialPage(),
    AppRoutes.userGuidePage: (context) => const UserGuidePage(),
    AppRoutes.cardCreatedSuccessPage: (context) =>
        const CardCreatedSuccessPage(),
    // AppRoutes.agentSignUp: (context) => const AgentSignUpPage(),
    // AppRoutes.agentCategories: (context) => const AgentCategoriesPage(),
    // AppRoutes.userSignUp: (context) => const UserSignUpPage(),
    // AppRoutes.emailVerification: (context) => const EmailVerificationPage(),
    AppRoutes.otpVerification: (context) => const OtpVerificationPage(),
    AppRoutes.home: (context) => const HomePage(),
    AppRoutes.inviteUsersToHushh: (context) => const InviteUsersToHushhPage(),
    AppRoutes.permissions: (context) => const PermissionsView(),
    AppRoutes.deleteAccount: (context) => const DeleteMyAccountView(),
    AppRoutes.chat.main: (context) => const ChatPage(),
    AppRoutes.chat.ai: (context) => const AiChatPage(),
    AppRoutes.cardMarketPlace.main: (context) => const CardMarketPlacePage(),
    AppRoutes.cardMarketPlace.agentMarketPlace: (context) =>
        const AgentMarketPlace(),
    AppRoutes.cardMarketPlace.shareYourPreference: (context) =>
        const ShareYourPreferences(),
    AppRoutes.cardMarketPlace.cardQuestions: (context) =>
        const CardQuestionsPage(),
    AppRoutes.cardMarketPlace.businessCardQuestions: (context) =>
    const BusinessCardQuestionsPage(),
    AppRoutes.cardMarketPlace.cardEditQuestions: (context) =>
        const EditCardQuestionsPage(),
    // AppRoutes.cardMarketPlace.introducingAssets: (context) =>
    //     const IntroducingAssetsPage(),
    AppRoutes.cardMarketPlace.cardLoader: (context) => const CardLoaderPage(),
    // AppRoutes.cardMarketPlace.coffeeQuestionnaire: (context) =>
    //     CoffeeQuestionnairePage(),
    AppRoutes.cardMarketPlace.cardValue: (context) => CardValuePage(),
    AppRoutes.cardMarketPlace.audioNotes: (context) => AudioNotes(),
    // AppRoutes.cardMarketPlace.coffeeLoader: (context) => CoffeeOrderLoader(),
    AppRoutes.cardWallet.main: (context) => const HomePage(),
    AppRoutes.cardWallet.notifications: (context) => const NotificationsPage(),
    AppRoutes.cardWallet.coins: (context) => const CoinsDashboard(),
    AppRoutes.cardWallet.settings: (context) => const SettingsPage(),
    AppRoutes.cardWallet.info.main: (context) => const CardWalletInfoPage(),
    AppRoutes.cardWallet.info.sharedAgentAssets: (context) =>
        const SharedAssetsReceiptsPage(),
    AppRoutes.receiptRadar.dashboard: (context) =>
        const ReceiptRadarDashboardPage(),
    AppRoutes.receiptRadar.search: (context) => const ReceiptRadarSearchPage(),
    AppRoutes.receiptRadar.onboarding: (context) =>
        const ReceiptRadarOnboarding(),
    AppRoutes.receiptRadar.brandDashboard: (context) =>
        const ReceiptRadarBrandDashboard(),
    AppRoutes.receiptRadar.receiptItems: (context) => const ReceiptItems(),
    AppRoutes.receiptRadar.insights: (context) => const ReceiptRadarInsights(),
    AppRoutes.shared.pdfViewer: (context) => const PDFViewerPage(),
    AppRoutes.shared.pdfNetworkViewer: (context) =>
        const PDFNetworkViewerPage(),
    AppRoutes.shared.webViewer: (context) => const WebViewerPage(),
    AppRoutes.shared.textViewer: (context) => TextViewerPage(),
    AppRoutes.shared.paymentMethodsViewer: (context) =>
        const PaymentMethodsPage(),
    AppRoutes.agentHome: (context) => const AgentHomePage(),
    AppRoutes.agentStatus: (context) => const AgentStatusPage(),
    AppRoutes.agentDashboard: (context) => const AgentDashboardPage(),
    AppRoutes.agentNewTask: (context) => const AgentNewTaskPage(),
    AppRoutes.agentCreateMeeting: (context) => const AgentMeetingPage(),
    AppRoutes.agentMeetingInfo: (context) => const AgentMeetingInfoPage(),
    AppRoutes.agentProfile: (context) => const AgentProfile(),
    AppRoutes.agentLookbook: (context) => const AgentLookBookPage(),
    AppRoutes.createLookbook: (context) => const CreateLookbookPage(),
    AppRoutes.agentProducts: (context) => const AgentProducts(),
    AppRoutes.agentOrderCheckout: (context) => const AgentOrderCheckout(),
    AppRoutes.agentHushhMeet: (context) => const AgentHushhMeet(),
    AppRoutes.userHushhMeet: (context) => const UserHushhMeet(),
    AppRoutes.browsingAnalytics: (context) => const BrowsingAnalytics(),
    AppRoutes.wishlistProducts: (context) => const WishlistProducts(),
    AppRoutes.agentEditProfile: (context) => const AgentEditProfilePage(),
    AppRoutes.manageInventory: (context) => const ManageInventory(),
    AppRoutes.inventoryProductsPage: (context) => const InventoryProductsPage(),
  };

  static final Map<String, WidgetBuilder> webRoutes = {
    WebRoutes.initial: (context) => const SplashPage(),
    WebRoutes.cardInfo: (context) => const SplashPage(),
    WebRoutes.cardWalletInfo: (context) => const CardWalletInfoPage(),
    WebRoutes.paymentMethods: (context) => const PaymentMethodsPage(),
    AppRoutes.cardWallet.info.sharedAgentAssets: (context) =>
        const SharedAssetsReceiptsPage(),
    AppRoutes.shared.pdfViewer: (context) => const PDFViewerPage(),
    AppRoutes.shared.pdfNetworkViewer: (context) =>
        const PDFNetworkViewerPage(),
    AppRoutes.receiptRadar.insights: (context) => const ReceiptRadarInsights(),
  };
}
