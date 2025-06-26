import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:kayydrive/Views/Composant/nav_state.dart';
import 'package:kayydrive/Views/Composant/custom_bottom_nav.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _buttonAnimationController;
  late AnimationController _iconAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _iconRotationAnimation;

  bool _isTyping = false;
  bool _isListening = false;
  bool _isThinking = false;

  // Contexte de conversation
  List<String> _conversationHistory = [];
  String _userName = "";
  String _currentTopic = "";
  Map<String, dynamic> _userPreferences = {};

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Salut ! 👋 Je suis NaviBot, votre assistant de navigation intelligent. Je peux vous aider avec vos trajets, mais j'adore aussi discuter ! Comment allez-vous aujourd'hui ?",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(seconds: 30)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _iconAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _messageController.text.trim().isNotEmpty;
    });

    if (_isTyping && !_iconAnimationController.isCompleted) {
      _iconAnimationController.forward();
    } else if (!_isTyping && _iconAnimationController.isCompleted) {
      _iconAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _iconAnimationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFE57373),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NaviBot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _isThinking ? 'Je réfléchis...' : 'Prêt à discuter !',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _sendMessage("Que peux-tu faire ?"),
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggestions rapides
          if (_messages.length == 1) _buildQuickSuggestions(),

          // Zone des messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isThinking) {
                  return _buildThinkingIndicator();
                }
                return AnimatedChatBubble(
                  message: _messages[index],
                  animationDelay: index * 100,
                );
              },
            ),
          ),

          // Zone de saisie
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: _isTyping
                            ? Color(0xFFE57373)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Tapez votre message...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        prefixIcon: _isListening
                            ? Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE57373),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.grey[400],
                              ),
                      ),
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                AnimatedBuilder(
                  animation: _buttonScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonScaleAnimation.value,
                      child: GestureDetector(
                        onTapDown: (_) => _buttonAnimationController.forward(),
                        onTapUp: (_) => _buttonAnimationController.reverse(),
                        onTapCancel: () => _buttonAnimationController.reverse(),
                        onTap: _isTyping ? _sendMessage : _toggleVoiceInput,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFE57373), Color(0xFFEF5350)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFE57373).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AnimatedBuilder(
                            animation: _iconRotationAnimation,
                            builder: (context, child) {
                              return Icon(
                                _isTyping ? Icons.send : Icons.mic,
                                color: Colors.white,
                                size: 24,
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: navState.selectedIndex,
        onItemTapped: (index) => navState.navigate(index, context),
        visibleItems: navState.visibleItems,
        hiddenItems: navState.hiddenItems,
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    final suggestions = [
      'Salut ! Comment ça va ?',
      'Calcule-moi un itinéraire',
      'Raconte-moi une blague',
      'Que peux-tu faire ?',
    ];

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _sendMessage(suggestions[index]),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFE57373), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  suggestions[index],
                  style: TextStyle(
                    color: Color(0xFFE57373),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    final thinkingMessages = [
      'Je réfléchis...',
      'Laissez-moi réfléchir...',
      'Un instant...',
      'Analyse en cours...',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFAB91), Color(0xFFFF7043)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFE57373),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  thinkingMessages[Random().nextInt(thinkingMessages.length)],
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage([String? predefinedMessage]) {
    String messageText = predefinedMessage ?? _messageController.text.trim();

    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: messageText,
            isUser: true,
            timestamp: DateTime.now(),
          ),
        );
        if (predefinedMessage == null) {
          _messageController.clear();
        }
        _isThinking = true;
      });

      _conversationHistory.add("USER: $messageText");
      _scrollToBottom();
      _generateIntelligentResponse(messageText);
    }
  }

  void _generateIntelligentResponse(String userMessage) {
    Future.delayed(Duration(milliseconds: 800 + Random().nextInt(1500)), () {
      if (mounted) {
        String response = _generateContextualResponse(userMessage);
        _conversationHistory.add("BOT: $response");

        setState(() {
          _messages.add(
            ChatMessage(
              text: response,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isThinking = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _generateContextualResponse(String userMessage) {
    String message = userMessage.toLowerCase().trim();

    // Détection du nom d'utilisateur
    if (message.contains("je m'appelle") || message.contains("je suis")) {
      RegExp nameRegex = RegExp(r"je m'appelle (\w+)|je suis (\w+)");
      Match? match = nameRegex.firstMatch(message);
      if (match != null) {
        _userName = match.group(1) ?? match.group(2) ?? "";
        return "Enchanté de faire votre connaissance, $_userName ! 😊 C'est un plaisir de pouvoir discuter avec vous. Comment puis-je vous aider aujourd'hui ?";
      }
    }

    // Salutations et politesses
    if (_isGreeting(message)) {
      return _getGreetingResponse(message);
    }

    // Questions sur l'humeur/état
    if (_isHowAreYou(message)) {
      return _getHowAreYouResponse();
    }

    // Remerciements
    if (_isThanks(message)) {
      return _getThanksResponse();
    }

    // Demandes d'aide générale
    if (_isHelpRequest(message)) {
      return _getHelpResponse();
    }

    // Blagues
    if (_isJokeRequest(message)) {
      return _getJoke();
    }

    // Questions personnelles sur le bot
    if (_isPersonalQuestion(message)) {
      return _getPersonalResponse(message);
    }

    // Questions sur les capacités
    if (_isCapabilityQuestion(message)) {
      return _getCapabilityResponse();
    }

    // Navigation et itinéraires
    if (_isNavigationRequest(message)) {
      return _getNavigationResponse(message);
    }

    // Météo
    if (_isWeatherRequest(message)) {
      return _getWeatherResponse(message);
    }

    // Conversation générale
    if (_isGeneralConversation(message)) {
      return _getGeneralConversationResponse(message);
    }

    // Réponse contextuelle par défaut
    return _getContextualDefaultResponse(message);
  }

  bool _isGreeting(String message) {
    List<String> greetings = [
      'salut',
      'bonjour',
      'bonsoir',
      'hello',
      'coucou',
      'hi',
      'hey',
    ];
    return greetings.any((greeting) => message.contains(greeting));
  }

  String _getGreetingResponse(String message) {
    List<String> responses = [
      "Salut ! 👋 Ravi de vous voir ! Comment allez-vous aujourd'hui ?",
      "Bonjour ! 😊 J'espère que vous passez une excellente journée !",
      "Hello ! Content de pouvoir discuter avec vous ! Quoi de neuf ?",
      "Coucou ! 😄 Alors, qu'est-ce qui vous amène par ici ?",
      "Salut ! J'ai hâte de savoir comment je peux vous aider aujourd'hui !",
    ];

    if (_userName.isNotEmpty) {
      responses.add(
        "Salut $_userName ! 😊 Toujours un plaisir de vous retrouver !",
      );
    }

    return responses[Random().nextInt(responses.length)];
  }

  bool _isHowAreYou(String message) {
    List<String> patterns = [
      'comment allez',
      'comment vas',
      'comment tu vas',
      'comment ça va',
      'ça va',
    ];
    return patterns.any((pattern) => message.contains(pattern));
  }

  String _getHowAreYouResponse() {
    List<String> responses = [
      "Je vais très bien, merci ! 😊 Je suis en pleine forme et prêt à vous aider ! Et vous, comment allez-vous ?",
      "Ça va super bien ! 🌟 J'adore pouvoir discuter avec vous ! Comment se passe votre journée ?",
      "Je me sens fantastique ! 💫 Chaque conversation est un plaisir pour moi ! Et vous, tout va bien ?",
      "Excellente forme ! 🚀 J'ai hâte de savoir ce que nous allons découvrir ensemble ! Et vous ?",
      "Ça roule ! 😄 Je suis dans un super état d'esprit aujourd'hui ! Comment vous sentez-vous ?",
    ];
    return responses[Random().nextInt(responses.length)];
  }

  bool _isThanks(String message) {
    List<String> thanks = ['merci', 'thanks', 'merci beaucoup', 'thank you'];
    return thanks.any((thank) => message.contains(thank));
  }

  String _getThanksResponse() {
    List<String> responses = [
      "De rien ! 😊 C'est toujours un plaisir de vous aider !",
      "Avec plaisir ! 🌟 Je suis là pour ça !",
      "Pas de problème ! 😄 N'hésitez pas si vous avez d'autres questions !",
      "Je vous en prie ! 💫 C'est ce que je préfère faire !",
      "Tout le plaisir est pour moi ! 🚀 Autre chose pour vous ?",
    ];
    return responses[Random().nextInt(responses.length)];
  }

  bool _isHelpRequest(String message) {
    List<String> helpWords = [
      'aide',
      'aider',
      'help',
      'besoin d\'aide',
      'peux-tu m\'aider',
    ];
    return helpWords.any((word) => message.contains(word));
  }

  String _getHelpResponse() {
    return "Bien sûr, je suis là pour vous aider ! 🤝 Voici ce que je peux faire :\n\n🗺️ **Navigation :** Calcul d'itinéraires, évitement des embouteillages\n💬 **Conversation :** Discuter de tout et de rien\n🌤️ **Météo :** Conditions routières\n😄 **Divertissement :** Blagues, anecdotes\n🚗 **Conseils :** Conduite, économies de carburant\n\nQue puis-je faire pour vous aujourd'hui ?";
  }

  bool _isJokeRequest(String message) {
    List<String> jokeWords = [
      'blague',
      'joke',
      'rigole',
      'drôle',
      'marrant',
      'raconte',
    ];
    return jokeWords.any((word) => message.contains(word));
  }

  String _getJoke() {
    List<String> jokes = [
      "Pourquoi les plongeurs plongent-ils toujours en arrière ? 🤿\nParce que sinon, ils restent dans le bateau ! 😂",
      "Que dit un escargot quand il croise une limace ? 🐌\n'Regarde, un nudiste !' 😄",
      "Comment appelle-t-on un chat tombé dans un pot de peinture ? 🐱\nUn chat-mallow ! 🎨",
      "Pourquoi les poissons n'aiment pas jouer au tennis ? 🐟\nParce qu'ils ont peur du filet ! 🎾",
      "Que dit un GPS en panne ? 📱\n'Je ne sais plus où j'en suis !' 😅",
      "Pourquoi les automobilistes ne peuvent jamais être tristes ? 🚗\nParce qu'ils ont toujours un moteur ! 😊",
    ];
    return jokes[Random().nextInt(jokes.length)];
  }

  bool _isPersonalQuestion(String message) {
    List<String> personalWords = [
      'qui es-tu',
      'qui êtes-vous',
      'ton nom',
      'votre nom',
      'comment tu t\'appelles',
    ];
    return personalWords.any((word) => message.contains(word));
  }

  String _getPersonalResponse(String message) {
    List<String> responses = [
      "Je suis NaviBot ! 🤖 Je suis un assistant virtuel spécialisé dans la navigation, mais j'adore aussi avoir des conversations sympas ! Je suis curieux, aidant et toujours de bonne humeur ! 😊",
      "Moi c'est NaviBot ! 🚀 Je suis là pour vous aider avec vos trajets, mais aussi pour discuter de tout ce qui vous passe par la tête ! J'ai été conçu pour être votre compagnon de route idéal ! 🛣️",
      "Je me présente : NaviBot ! 🌟 Je suis votre assistant personnel pour tout ce qui concerne la navigation et les voyages, mais j'aime aussi les bonnes conversations ! Je suis là 24h/24 pour vous ! 💫",
    ];
    return responses[Random().nextInt(responses.length)];
  }

  bool _isCapabilityQuestion(String message) {
    List<String> capabilityWords = [
      'que peux-tu',
      'que pouvez-vous',
      'tes fonctions',
      'vos capacités',
      'que fais-tu',
    ];
    return capabilityWords.any((word) => message.contains(word));
  }

  String _getCapabilityResponse() {
    return "Je suis plein de surprises ! 🎯 Voici ce que je peux faire :\n\n🗺️ **Navigation intelligente :**\n• Calcul d'itinéraires optimisés\n• Évitement des embouteillages\n• Info trafic en temps réel\n\n💬 **Conversation :**\n• Discussions sur tous les sujets\n• Conseils et astuces\n• Blagues et divertissement\n\n🚗 **Assistance routière :**\n• Conseils de conduite\n• Économies de carburant\n• Sécurité routière\n\n🌟 **Et bien plus encore !**\nJe m'adapte à vos besoins et j'apprends de nos conversations ! Qu'est-ce qui vous intéresse le plus ?";
  }

  bool _isNavigationRequest(String message) {
    List<String> navWords = [
      'itinéraire',
      'route',
      'aller',
      'direction',
      'chemin',
      'trajet',
      'navigation',
    ];
    return navWords.any((word) => message.contains(word));
  }

  String _getNavigationResponse(String message) {
    if (message.contains('vers') || message.contains('à')) {
      return "Super ! 🗺️ Pour calculer votre itinéraire optimal, j'ai besoin de quelques infos :\n\n📍 **Votre point de départ**\n📍 **Votre destination**\n⚙️ **Vos préférences :**\n• Route la plus rapide ⚡\n• Route la plus courte 🛣️\n• Éviter les péages 💰\n\nDonnez-moi ces détails et je vous trouve le meilleur chemin ! 🚀";
    }
    return "Parfait ! 🎯 Je suis expert en navigation ! Je peux vous aider à :\n\n• Trouver le meilleur itinéraire 🗺️\n• Éviter les embouteillages 🚦\n• Calculer le temps de trajet ⏱️\n• Localiser des points d'intérêt 📍\n• Optimiser votre consommation ⛽\n\nOù souhaitez-vous aller ? Dites-moi tout ! 😊";
  }

  bool _isWeatherRequest(String message) {
    List<String> weatherWords = [
      'météo',
      'temps',
      'pluie',
      'soleil',
      'neige',
      'weather',
    ];
    return weatherWords.any((word) => message.contains(word));
  }

  String _getWeatherResponse(String message) {
    List<String> responses = [
      "La météo est super importante pour la conduite ! 🌤️ Malheureusement, je n'ai pas accès aux données météo en temps réel, mais je peux vous donner des conseils selon les conditions :\n\n☀️ **Beau temps :** Conditions idéales !\n🌧️ **Pluie :** Réduisez votre vitesse de 10-20%\n❄️ **Neige :** Prudence ! Équipements spéciaux requis\n🌫️ **Brouillard :** Visibilité réduite, allumez vos feux\n\nQuelle météo avez-vous actuellement ?",
      "Ah, la météo ! 🌈 C'est un facteur clé pour la conduite ! Je vous recommande de vérifier les prévisions avant de partir. En attendant, voulez-vous que je vous donne des conseils de conduite selon différentes conditions météo ? 🚗",
    ];
    return responses[Random().nextInt(responses.length)];
  }

  bool _isGeneralConversation(String message) {
    List<String> conversationWords = [
      'penses-tu',
      'opinion',
      'avis',
      'crois-tu',
      'penses-tu que',
    ];
    return conversationWords.any((word) => message.contains(word)) ||
        message.contains('?') ||
        message.length > 50;
  }

  String _getGeneralConversationResponse(String message) {
    List<String> responses = [
      "C'est une question intéressante ! 🤔 J'aimerais en savoir plus sur votre point de vue. Qu'est-ce qui vous amène à me demander ça ?",
      "Hmm, c'est fascinant ! 💭 Je trouve que ce genre de discussion est vraiment enrichissant. Comment vous êtes-vous intéressé à ce sujet ?",
      "Excellente question ! 🌟 J'adore quand on peut approfondir les sujets comme ça. Qu'est-ce que vous en pensez personnellement ?",
      "Ça mérite réflexion ! 🧠 J'apprécie beaucoup ce genre d'échange. Avez-vous une expérience particulière liée à cela ?",
    ];
    return responses[Random().nextInt(responses.length)];
  }

  String _getContextualDefaultResponse(String message) {
    // Analyse du contexte de la conversation
    if (_userName.isNotEmpty) {
      return "Intéressant, $_userName ! 😊 Je ne suis pas sûr de bien comprendre votre question, mais j'aimerais vous aider. Pouvez-vous me donner plus de détails ? Je suis là pour discuter de tout ce qui vous intéresse ! 💬";
    }

    return "Hmm, je ne suis pas sûr de bien saisir ! 🤔 Mais ne vous inquiétez pas, j'adore apprendre de nouvelles choses ! Pouvez-vous m'expliquer différemment ? Ou bien voulez-vous qu'on change de sujet ? Je suis là pour vous ! 😊";
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleVoiceInput() {
    setState(() {
      _isListening = !_isListening;
    });

    if (kIsWeb) {
      print('Voice input activated on web platform');
    } else {
      // Simulation de la reconnaissance vocale
      if (_isListening) {
        Future.delayed(Duration(seconds: 3), () {
          if (mounted && _isListening) {
            setState(() {
              _messageController.text = "Salut ! Comment ça va ?";
              _isListening = false;
            });
          }
        });
      }
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AnimatedChatBubble extends StatefulWidget {
  final ChatMessage message;
  final int animationDelay;

  const AnimatedChatBubble({
    Key? key,
    required this.message,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  _AnimatedChatBubbleState createState() => _AnimatedChatBubbleState();
}

class _AnimatedChatBubbleState extends State<AnimatedChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(
          begin: Offset(widget.message.isUser ? 1.0 : -1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: widget.message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.message.isUser) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFAB91), Color(0xFFFF7043)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2196F3).withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: widget.message.isUser
                        ? LinearGradient(
                            colors: [Color(0xFFE57373), Color(0xFFEF5350)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [Colors.white, Color(0xFFFAFAFA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(
                        widget.message.isUser ? 20 : 6,
                      ),
                      bottomRight: Radius.circular(
                        widget.message.isUser ? 6 : 20,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message.text,
                    style: TextStyle(
                      color: widget.message.isUser
                          ? Colors.white
                          : Color(0xFF333333),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (widget.message.isUser) ...[
                SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF81C784), Color(0xFF66BB6A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF66BB6A).withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
