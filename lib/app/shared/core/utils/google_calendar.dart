import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gapi;
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleCalendar {
  static Future<Tuple2<String?, String?>?> insert({
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    required bool hasConferenceSupport,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    void prompt(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }

    String calendarId = "primary";
    Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    if (hasConferenceSupport) {
      ConferenceData conferenceData = ConferenceData();
      CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
      conferenceRequest.requestId =
          "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
      conferenceData.createRequest = conferenceRequest;

      event.conferenceData = conferenceData;
    }

    EventDateTime start = EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    EventDateTime end = EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: <String>[gapi.CalendarApi.calendarScope],
      );

      GoogleSignInAccount? currentUser;

      final value = await _googleSignIn.isSignedIn();

      if (!value) {
        currentUser = await _googleSignIn.signInSilently();
      } else {
        currentUser = await _googleSignIn.signIn();
      }

      currentUser ??= await _googleSignIn.signIn();

      if (currentUser != null) {
        final GoogleAPIClient httpClient =
            GoogleAPIClient(await currentUser.authHeaders);
        final gapi.CalendarApi calendar = gapi.CalendarApi(httpClient);

        final value = await calendar.events
            .insert(event, calendarId,
            sendNotifications: true,
            conferenceDataVersion: hasConferenceSupport ? 1 : 0,
            sendUpdates: shouldNotifyAttendees ? "all" : "none");

        if (value.status == "confirmed") {
          String? joiningLink = hasConferenceSupport
              ? "https://meet.google.com/${value.conferenceData?.conferenceId}"
              : null;
          String? eventId = value.id;

          return Tuple2<String?, String?>(eventId, joiningLink);
        } else {
        }
      }
    } catch (e) {
    }

    return null;
  }
}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}
