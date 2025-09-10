import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nextrep/core/entities/exercise/exercise_model.dart';
import 'package:nextrep/core/services/shared_preferences/shared_preferences.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:url_launcher/url_launcher.dart';

class AIAssistantPopup {
  static void show(BuildContext context, {required Exercise exercise}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AIAssistantView(exercise: exercise),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

class AIAssistantView extends StatefulWidget {
  final Exercise exercise;
  const AIAssistantView({super.key, required this.exercise});

  @override
  State<AIAssistantView> createState() => _AIAssistantViewState();
}

class _AIAssistantViewState extends State<AIAssistantView> {
  String? _apiKey;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _promptController;

  bool _isLoading = false;
  String _responseText = '';
  GenerativeModel? _model;

  Timer? _cooldownTimer;
  int _remainingCooldown = 0;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
    _promptController = TextEditingController();
    _loadApiKey();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _apiKeyController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _loadApiKey() async {
    final storedKey = await AuthPrefs.getApiKey();
    if (storedKey != null && storedKey.isNotEmpty) {
      setState(() {
        _apiKey = storedKey;
        _initializeModel();
      });
    }
  }

  void _initializeModel() {
    if (_apiKey != null) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey!,
      );
    }
  }

  Future<void> _saveApiKeyAndInitializeModel() async {
    if (_apiKeyController.text.trim().isNotEmpty) {
      final keyToSave = _apiKeyController.text.trim();
      await AuthPrefs.saveApiKey(keyToSave);
      setState(() {
        _apiKey = keyToSave;
        _initializeModel();
        _apiKeyController.clear();
      });
    }
  }

  Future<void> _clearApiKey() async {
    await AuthPrefs.clearApiKey();
    setState(() {
      _apiKey = null;
      _model = null;
      _responseText = '';
    });
  }

  void _startCooldown() {
    setState(() {
      _remainingCooldown = 30;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingCooldown > 0) {
        setState(() {
          _remainingCooldown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _generateContent() async {
    if (_isLoading ||
        _remainingCooldown > 0 ||
        _promptController.text.trim().isEmpty ||
        _model == null) {
      return;
    }

    final userPrompt = _promptController.text;
    _promptController.clear();

    setState(() {
      _isLoading = true;
      _responseText = '';
    });

    final fullPrompt =
        """
      You are a world-class fitness coach providing helpful advice.
      Be concise and encouraging.

      CONTEXT for the user's current exercise:
      - Name: ${widget.exercise.name}
      - Description: ${widget.exercise.description}
      - Instructions:\n- ${widget.exercise.instructions.join('\n- ')}

      Based on the context above, answer the user's question below.
      
      User Question: "$userPrompt"
    """;

    try {
      final content = [Content.text(fullPrompt)];
      final response = await _model!.generateContent(content);
      setState(() {
        _responseText =
            response.text ?? 'Sorry, I could not generate a response.';
      });
    } catch (e) {
      setState(() {
        _responseText =
            'An error occurred. Please check your API key and network connection.\n\nError: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _startCooldown();
    }
  }

  Future<void> _launchApiKeyURL() async {
    final uri = Uri.parse('https://aistudio.google.com/app/apikey');
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'AI Assistant',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (_apiKey == null) _buildApiKeyForm() else _buildChatInterface(),
        ],
      ),
    );
  }

  Widget _buildApiKeyForm() {
    return Column(
      children: [
        const Text(
          'To use the AI assistant, please provide your Google Generative AI API key.',
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: _launchApiKeyURL,
          child: const Text(
            'Get your API Key from Google AI Studio',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _apiKeyController,
          decoration: const InputDecoration(
            labelText: 'Paste your API Key here',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveApiKeyAndInitializeModel,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Save and Continue'),
        ),
      ],
    );
  }

  Widget _buildChatInterface() {
    final bool isDisabled = _isLoading || _remainingCooldown > 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Chat with AI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: _clearApiKey,
              child: const Text('Change Key'),
            ),
          ],
        ),
        Container(
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Text(
                    _responseText.isEmpty
                        ? 'Ask me anything about "${widget.exercise.name}"!\n\nFor example:\n• What are common mistakes?\n• Suggest an alternative exercise.\n• How can I improve my form?'
                        : _responseText,
                  ),
                ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _promptController,
                enabled: !isDisabled,
                decoration: InputDecoration(
                  hintText: _remainingCooldown > 0
                      ? 'Please wait $_remainingCooldown seconds...'
                      : 'Ask a question...',
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: isDisabled ? null : (_) => _generateContent(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: isDisabled ? null : _generateContent,
              icon: Icon(
                _remainingCooldown > 0 ? Icons.timer_outlined : Icons.send,
              ),
              style: IconButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ],
    );
  }
}
