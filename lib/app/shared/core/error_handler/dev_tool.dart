import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SupabaseLogger extends TalkerLog {
  SupabaseLogger(String message, StackTrace? stackTrace, error)
      : super(message, stackTrace: stackTrace, exception: error);

  /// Your custom log title
  @override
  String get title => 'Supabase';

  /// Your custom log color
  @override
  AnsiPen get pen => AnsiPen()..red();
}

class SupabaseObserver extends TalkerObserver {
  SupabaseObserver();

  @override
  Future<void> onError(err) async {
    await Supabase.instance.client.from('app_logs').insert({
      'hushh_id': AppLocalStorage.hushhId,
      'log_type': 'ERROR',
      'log_title': err.title,
      'log_message': err.displayMessage,
      'additional_info': err.stackTrace?.toString(),
      'duration': err.displayTime().split(' ')[1]
    });
  }

  @override
  Future<void> onException(err) async {
    await Supabase.instance.client.from('app_logs').insert({
      'hushh_id': AppLocalStorage.hushhId,
      'log_type': 'EXCEPTION',
      'log_title': err.title,
      'log_message': err.displayMessage,
      'additional_info': err.stackTrace?.toString(),
      'duration': err.displayTime().split(' ')[1]
    });
  }

  @override
  Future<void> onLog(log) async {
    String? info;
    try {
      info =  log.generateTextMessage().split(' | ').sublist(1).join("").split('\n').sublist(2).join('\n');
    } catch(_) {}
    await Supabase.instance.client.from('app_logs').insert({
      'hushh_id': AppLocalStorage.hushhId,
      'log_type': 'INFO',
      'log_title': log.title,
      'log_message': log.displayMessage,
      'additional_info': info,
      'duration': log.displayTime().split(' ')[1]
    });
  }
}

final supabaseObserver = SupabaseObserver();

Talker customLogger() => TalkerFlutter.init(observer: supabaseObserver);
