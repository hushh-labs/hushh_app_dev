import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/audio_transcription.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String? audioUrl;
  final AudioTranscription? audioTranscription;

  const AudioPlayerWidget({
    Key? key,
    this.audioUrl,
    this.audioTranscription,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.audioUrl != null) {
      _initAudioPlayer();
    }
  }

  Future<void> _initAudioPlayer() async {
    // Listen to audio duration changes
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() => _duration = duration);
      }
    });

    // Listen to audio position changes
    _audioPlayer.positionStream.listen((position) {
      setState(() => _position = position);
    });

    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });

    // Set the audio source
    await _audioPlayer.setUrl(widget.audioUrl!);
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: .85,
                    child: IconButton(
                      style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF5865F2)),
                      icon: Icon(
                        _isPlaying ? IonIcons.pause : IonIcons.play,
                        size: 22,
                      ),
                      onPressed: () {
                        if (_isPlaying) {
                          _audioPlayer.pause();
                        } else {
                          _audioPlayer.play();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                        trackHeight: 4,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 0),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                      ),
                      child: Slider(
                        value: _position.inMilliseconds.toDouble(),
                        min: 0,
                        max: _duration.inMilliseconds.toDouble(),
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey[400],
                        onChanged: (value) {
                          _audioPlayer
                              .seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(_position),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    IonIcons.volume_high,
                    color: Color(0xFF515151),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              style: IconButton.styleFrom(
                  foregroundColor: Colors.black54,
                  backgroundColor: Colors.grey[200]),
              icon: const Icon(
                Icons.edit,
                size: 20,
              ),
              onPressed: () {
                if (_isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.play();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: AudioHighlightText(
            audioTranscription: widget.audioTranscription,
            duration: _position,
          ),
        ).animate().fadeIn().slideY()
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

class AudioHighlightText extends StatefulWidget {
  final AudioTranscription? audioTranscription;
  final Duration duration;

  const AudioHighlightText({
    Key? key,
    required this.audioTranscription,
    required this.duration,
  }) : super(key: key);

  @override
  State<AudioHighlightText> createState() => _AudioHighlightTextState();
}

class _AudioHighlightTextState extends State<AudioHighlightText> {
  bool _isExpanded = false;

  TextSpan _buildTextSpan() {
    if (widget.audioTranscription == null) {
      return const TextSpan(text: '');
    }

    List<TextSpan> textSpans = [];
    final words = widget.audioTranscription!.words;
    final currentSeconds = widget.duration.inMilliseconds / 1000.0;

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final bool isCurrentWord = word.start <= currentSeconds;

      textSpans.add(
        TextSpan(
          text: '${word.text}${i < words.length - 1 ? ' ' : ''}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isCurrentWord ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xff171717),
          ),
        ),
      );
    }

    // Add read more/less button
    textSpans.add(
      TextSpan(
        text: _isExpanded ? ' read less' : ' read more',
        style: const TextStyle(
          color: Color(0xFFE51A5E),
          fontWeight: FontWeight.w400,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
      ),
    );

    return TextSpan(children: textSpans);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = _buildTextSpan();
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: _isExpanded ? null : 2,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        return GestureDetector(
          onTap: () {
            if (textPainter.didExceedMaxLines) {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }
          },
          child: RichText(
            maxLines: _isExpanded ? null : 2,
            overflow: TextOverflow.fade,
            text: textSpan,
          ),
        );
      },
    );
  }
}
