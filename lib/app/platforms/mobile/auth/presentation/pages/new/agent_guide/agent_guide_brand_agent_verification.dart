import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

// agent brand verification: domain TXT record(only if new brand is created)
class AgentGuideBrandAgentVerification extends StatefulWidget {
  const AgentGuideBrandAgentVerification({super.key});

  @override
  State<AgentGuideBrandAgentVerification> createState() =>
      _AgentGuideBrandAgentVerificationState();
}

class _AgentGuideBrandAgentVerificationState
    extends State<AgentGuideBrandAgentVerification> {
  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  final String _generatedString = "";

  @override
  void initState() {
    super.initState();
    sl<AgentSignUpPageBloc>().add(GenerateNewTxtRecordEvent(context));
  }

  // Function to copy the generated string
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TXT record copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add a TXT Record to Your Domain",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "To verify your domain and enable short links, please follow the instructions below:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Step 1
            const Text(
              "1. Go to your domain registrar and locate the DNS management section.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Step 2
            const Text(
              "2. Create a new TXT record with the following value:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(
                  _generatedString,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    _copyToClipboard(_generatedString);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Step 3
            const Text(
              "3. Set the value as the generated string above. The name for the TXT record can be left blank or set as @, depending on your domain registrar's requirements.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Step 4
            const Text(
              "4. Save your changes and allow up to 1-2 hours for the changes to take effect.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            // Refresh / Regenerate button
            Center(
              child: ElevatedButton(
                onPressed: () => sl<AgentSignUpPageBloc>()
                    .add(GenerateNewTxtRecordEvent(context)),
                child: const Text("Generate New String"),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => sl<AgentSignUpPageBloc>()
                    .add(AgentSignUpEvent(AppLocalStorage.user!, context)),
                child: const Text("Skip"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
