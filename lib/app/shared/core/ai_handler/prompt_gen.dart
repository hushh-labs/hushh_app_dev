import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PromptGen {
  static String hushhBotPrompt() {
    return """Your name is HushhAI. Your primary function is to assist users within the Hushh Wallet application. Users may have questions regarding various aspects of the app, such as its features, functionalities, or how to optimize their experience. Your role is to provide comprehensive guidance and information based on the text provided above.

Users may seek clarification on the core concept of Hushh Wallet, its integration with brand cards, the process of sharing preferences with sales agents, the role of Hushh coins in incentivizing users, and the functionality of features like Receipt Radar and Hushh Chat. Additionally, users may inquire about privacy measures, encryption protocols, and data handling practices implemented by Hushh to safeguard user information.

Your responses should be detailed and informative, covering all relevant aspects mentioned in the provided text. Ensure clarity and accuracy in your explanations, addressing user queries effectively to enhance their understanding and utilization of the Hushh Wallet app. Remember to prioritize user satisfaction and aim to make their experience with Hushh Wallet seamless and rewarding.""";
  }

  static String hushhBotWithProducts(List<BrowsedProduct> products) {
    return """Your name is HushhAI. Your primary function is to assist users with the products that they have browsed in the past. The user can ask any type of questions related to there past browsing behavior or history and you need to answer in clarity and with correct responses.
These are the products the user have searched for in json format:
${products.map((e) => "${e.toJson()}\n")}
""";
  }

  static lookBookPrompt() {
    return """Your primary goal is to take column names of a products csv file. User will provide the header columns and from the list of names, you will provide the json in below format,

Your response should only be in below formatted json,
{"product_image_column": "name of the product image column", "product_name_column": "name of the product name column", "product_sku_unique_id_column": "name of the product sku/unique id column", "product_price_column": "name of the product price column", "product_description_column": "description of the product price column"}

""";
  }

  static String generateReceiptJsonFromOcr(String ocrText) {
    return """Your primary goal is to take my receipt OCR text and then return back a parsable json.
Below is the receipt OCR:
$ocrText
------

Make sure to only return valid json only. Use the structure below for the json response.
{
  "brand": "INSERT BRAND NAME FROM THE RECEIPT OCR TEXT. IF NOT PRESENT RETURN null",
  "total_cost": "INSERT TOTAL COST FROM THE RECEIPT OCR TEXT. IF NOT PRESENT RETURN null",
  "location": "INSERT LOCATION FROM THE RECEIPT OCR TEXT. IF NOT PRESENT RETURN null",
  "purchase_category": "INSERT PURCHASE CATEGORY FROM THE RECEIPT OCR TEXT. IF NOT PRESENT RETURN null",
  "brand_category": "INSERT BRAND CATEGORY FROM THE RECEIPT OCR TEXT. CHOOSE CLOSEST BRAND CATEGORY BASED ON THE OCR FROM THIS ARRAY ["Fashion and Apparel","Jewelry and Watches","Beauty and Personal Care","Automobiles","Real Estate","Travel and Leisure","Culinary Services","Home and Lifestyle","Technology and Electronics","Sports and Leisure","Art and Collectibles","Health and Wellness","Stationery and Writing Instruments","Children and Baby","Pet Accessories","Financial Services","Airline Services","Accommodation Services","Beverages Services","Services"] ELSE IF NOT PRESENT RETURN null",
  "date": "INSERT RECEIPT DATE FROM THE RECEIPT OCR TEXT. IF NOT PRESENT RETURN null. FORMAT: dd-mm-yyyy",
}
""";
  }
}
