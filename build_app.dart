import 'dart:io';

import 'package:yaml/yaml.dart';

const String BUILD_INFO_FILE = 'build_info.yaml';
const String DEFAULT_ENV = 'PROD';

Future<void> main(List<String> arguments) async {
  var os = '';
  var build = '';
  var env = DEFAULT_ENV;
  var type = '';
  var increment = false;

  for (var arg in arguments) {
    var parts = arg.split('=');
    if (parts.length == 2) {
      switch (parts[0]) {
        case '-os':
          os = parts[1].toUpperCase();
          break;
        case '-build':
          build = parts[1];
          break;
        case '-env':
          env = parts[1].toUpperCase();
          break;
        case '-type':
          type = parts[1].toUpperCase();
          break;
      }
    } else if (arg == '--increment') {
      increment = true;
    }
  }

  if (os.isEmpty || type.isEmpty) {
    print(
        'Usage: dart run build_app.dart -os=<OS> -type=<TYPE> [-build=<BUILD>] [--increment] [-env=<ENV>]');
    print('OS and TYPE parameters are mandatory.');
    print('ENV defaults to PROD if not specified.');
    exit(1);
  }

  var buildInfo = loadBuildInfo();

  if (build.isEmpty) {
    if (increment) {
      build = incrementBuild(buildInfo, os);
    } else {
      build = getBuildFromYaml(buildInfo, os);
    }
  }

  if (build.isEmpty) {
    print('Build parameter is required or use --increment to auto-increment.');
    exit(1);
  }

  var buildParts = build.split('+');
  if (buildParts.length != 2) {
    print('Invalid build format. Use format like 1.0.1+32');
    exit(1);
  }

  var buildName = buildParts[0];
  var buildNumber = buildParts[1];

  var envFile = 'env/${env.toLowerCase()}.json';

  var entrypoint = 'lib/${type.toLowerCase()}.dart';

  var command = '';

  switch (os) {
    case 'ANDROID':
      command =
          'flutter build apk --release --dart-define-from-file=$envFile --build-number=$buildNumber --build-name=$buildName --flavor ${type.toLowerCase()} -t $entrypoint';
      break;
    case 'APPBUNDLE':
      command =
          'flutter build appbundle --release --dart-define-from-file=$envFile --build-number=$buildNumber --build-name=$buildName --flavor ${type.toLowerCase()} -t $entrypoint';
      break;
    case 'IOS':
      command =
          'flutter build ipa --dart-define-from-file=$envFile --build-number=$buildNumber --build-name=$buildName --flavor ${type.toLowerCase()} -t $entrypoint';
      break;
    case 'WEB':
      command =
          'flutter build web --web-renderer html --dart-define-from-file=$envFile -t $entrypoint';
      break;
    default:
      print('Invalid OS. Use ANDROID, APPBUNDLE, IOS, or WEB.');
      exit(1);
  }

  print('Executing command: $command');

  var process = await Process.start('/bin/sh', ['-c', command]);

  // Pipe the output streams to stdout and stderr
  process.stdout.listen((event) {
    stdout.add(event);
  });
  process.stderr.listen((event) {
    stderr.add(event);
  });

  // Wait for the process to complete
  var exitCode = await process.exitCode;

  if (exitCode == 0) {
    updateBuildInfo(buildInfo, os, build);
  }

  exit(exitCode);
}

Map<String, dynamic> loadBuildInfo() {
  return {};
  // var file = File(BUILD_INFO_FILE);
  // if (!file.existsSync()) {
  //   return {};
  // }
  // var yamlString = file.readAsStringSync();
  // return Map<String, dynamic>.fromEntries((loadYaml(yamlString) as YamlMap).entries as List<MapEntry<String, dynamic>>);
}

String getBuildFromYaml(Map<String, dynamic> buildInfo, String os) {
  return buildInfo[os] ?? '';
}

String incrementBuild(Map<String, dynamic> buildInfo, String os) {
  var currentBuild = getBuildFromYaml(buildInfo, os);
  if (currentBuild.isEmpty) {
    return '';
  }
  var parts = currentBuild.split('+');
  var buildName = parts[0];
  var buildNumber = int.parse(parts[1]);
  return '$buildName+${buildNumber + 1}';
}

void updateBuildInfo(Map<String, dynamic> buildInfo, String os, String build) {
  buildInfo[os] = build;
  var yaml = buildInfo.map((key, value) => MapEntry(key, value));
  var yamlString = yaml.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  File(BUILD_INFO_FILE).writeAsStringSync(yamlString);
}
//flutter build ipa --dart-define-from-file=env/prod.json --build-number=68 --build-name=1.0.1 --flavor user -t lib/user.dart