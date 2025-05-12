// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart';
//
// import 'package:intl/intl.dart';
// import 'package:date_time_format/date_time_format.dart';
//
// class GoogleNews {
//   late String __key;
//   late List<String> __texts;
//   late List<String> __links;
//   late List<Map<String, dynamic>> __results;
//   late int __totalcount;
//   late bool __exception;
//   late String __version;
//   late String __lang;
//   late String __period;
//   late String __start;
//   late String __end;
//   late String __encode;
//
//   GoogleNews(
//       {String lang = "en",
//         String period = "",
//         String start = "",
//         String end = "",
//         String encode = "utf-8"}) {
//     this.__texts = [];
//     this.__links = [];
//     this.__results = [];
//     this.__totalcount = 0;
//     this.__exception = false;
//     this.__version = '1.6.14';
//     this.__lang = lang;
//     this.__period = period;
//     this.__start = start;
//     this.__end = end;
//     this.__encode = encode;
//   }
//
//   String getVersion() {
//     return this.__version;
//   }
//
//   void enableException({bool enable = true}) {
//     this.__exception = enable;
//   }
//
//   void setLang(String lang) {
//     this.__lang = lang;
//   }
//
//   void setPeriod(String period) {
//     this.__period = period;
//   }
//
//   void setTimeRange(String start, String end) {
//     this.__start = start;
//     this.__end = end;
//   }
//
//   void setEncode(String encode) {
//     this.__encode = encode;
//   }
//
//   void search(String key) {
//     this.__key = key;
//     if (this.__encode != "") {
//       this.__key = Uri.encodeComponent(this.__key);
//     }
//     this.getPage();
//   }
//
//   Future<void> buildResponse(Document document) async {
//     // Parse and process the document to get necessary data
//     List<Element> items = document.querySelectorAll('your_selector_here');
//     // Iterate through items and extract required data
//     for (var item in items) {
//       // Extract title, link, date, etc.
//       String title = item.querySelector('your_title_selector')!.innerHtml;
//       String link = item.querySelector('your_link_selector')!.attributes['href']!;
//       // Add extracted data to results
//       this.__results.add({
//         'title': title,
//         'link': link,
//         // Add more data as required
//       });
//     }
//   }
//
//   String removeAfterLastFullstop(String s) {
//     int lastPeriodIndex = s.lastIndexOf('.');
//     return lastPeriodIndex != -1 ? s.substring(0, lastPeriodIndex + 1) : s;
//   }
//
//   Future<void> getPage({int page = 1}) async {
//     // Construct the URL based on page number and search parameters
//     String url = '';
//     try {
//       if (this.__start != "" && this.__end != "") {
//         url = "https://www.google.com/search?q=${Uri.encodeComponent(this.__key)}&lr=lang_${this.__lang}&biw=1920&bih=976&source=lnt&&tbs=lr:lang_1${this.__lang},cdr:1,cd_min:${this.__start},cd_max:${this.__end},sbd:1&tbm=nws&start=${10 * (page - 1)}";
//       } else if (this.__period != "") {
//         url = "https://www.google.com/search?q=${Uri.encodeComponent(this.__key)}&lr=lang_${this.__lang}&biw=1920&bih=976&source=lnt&&tbs=lr:lang_1${this.__lang},qdr:${this.__period},,sbd:1&tbm=nws&start=${10 * (page - 1)}";
//       } else {
//         url = "https://www.google.com/search?q=${Uri.encodeComponent(this.__key)}&lr=lang_${this.__lang}&biw=1920&bih=976&source=lnt&&tbs=lr:lang_1${this.__lang},sbd:1&tbm=nws&start=${10 * (page - 1)}";
//       }
//     } catch (e) {
//       throw Exception("You need to run a search() before using getPage().");
//     }
//
//     try {
//       // Send the request and get the response
//       http.Response response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         // Parse the HTML content
//         var document = parse(response.body);
//         // Process the document to extract necessary data
//         await buildResponse(document);
//       } else {
//         throw Exception('Failed to load page: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(e);
//       if (this.__exception) {
//         throw Exception(e);
//       }
//     }
//   }
//
//   Future<void> getNews(String key, {bool deamplify = false}) async {
//     // Construct the URL based on search parameters
//     String url = '';
//     if (key != '') {
//       if (this.__period != "") {
//         key += " when:${this.__period}";
//       }
//     } else {
//       if (this.__period != "") {
//         key += "when:${this.__period}";
//       }
//     }
//     key = Uri.encodeComponent(key);
//     String start = '${this.__start.substring(6)}-${this.__start.substring(0, 2)}-${this.__start.substring(3, 5)}';
//     String end = '${this.__end.substring(6)}-${this.__end.substring(0, 2)}-${this.__end.substring(3, 5)}';
//
//     if (this.__start == '' || this.__end == '') {
//       url = 'https://news.google.com/search?q=${Uri.encodeComponent(key)}&hl=${this.__period}';
//     } else {
//       url = 'https://news.google.com/search?q=${Uri.encodeComponent(key)}+before:${end}+after:${start}&hl=${this.__period}';
//     }
//
//     try {
//       // Send the request and get the response
//       http.Response response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         // Parse the HTML content
//         var document = parse(response.body);
//         // Process the document to extract necessary data
//         await buildResponse(document);
//       } else {
//         throw Exception('Failed to load page: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(e);
//       if (this.__exception) {
//         throw Exception(e);
//       }
//     }
//   }
//
//   int totalCount() {
//     return this.__totalcount;
//   }
//
//   List<Map<String, dynamic>> results({bool sort = false}) {
//     List<Map<String, dynamic>> results = this.__results;
//     if (sort) {
//       try {
//         results.sort((a, b) => b['datetime'].compareTo(a['datetime']));
//       } catch (e) {
//         print(e);
//         if (this.__exception) {
//           throw Exception(e);
//         }
//       }
//     }
//     return results;
//   }
//
//   List<String> getTexts() {
//     return this.__texts;
//   }
//
//   List<String> getLinks() {
//     return this.__links;
//   }
//
//   void clear() {
//     this.__texts = [];
//     this.__links = [];
//     this.__results = [];
//     this.__totalcount = 0;
//   }
// }
