import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';  // Import de GetWidget

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemple de progression du niveau de l'utilisateur (valeur entre 0.0 et 1.0)
    double userProgress = 0.7; // 70% de progression

    // Exemple de liste d'historique de parties
    final List<String> gameHistory = [
      'Partie contre un ami - Gagnée',
      'Partie aléatoire - Perdue',
      'Partie contre un ami - Gagnée',
      'Partie aléatoire - Gagnée',
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2), // Bleu clair en haut
              Color(0xFF1E88E5), // Bleu plus foncé en bas
            ],
          ),
        ),
        child: Column(
          children: [
            // Barre de progression avec GetWidget et personnalisation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progression du niveau',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  // Utilisation de GFProgressBar pour une barre animée et stylisée
                  GFProgressBar(
                    percentage: userProgress, // La valeur de progression (70%)
                    backgroundColor: Colors.grey.withOpacity(0.3), // Couleur de fond
                    lineHeight: 20, // Hauteur de la barre
                    progressBarColor: GFColors.SUCCESS, // Couleur de la progression
                    animation: true, // Animation active
                    animationDuration: 2000, // Durée de l'animation
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        '${(userProgress * 100).round()}%', // Pourcentage de progression
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    leading: const Icon(Icons.star, color: Colors.yellow), // Icône à gauche
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Espace avant les boutons
            // Boutons stylisés avec GetWidget
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFButton(
                  onPressed: () {
                    print('Aléatoire button pressed');
                  },
                  text: 'Aléatoire',
                  color: GFColors.WHITE, // Couleur de fond blanc
                  textStyle: const TextStyle(color: Colors.black, fontSize: 18), // Texte noir
                  shape: GFButtonShape.pills, // Boutons arrondis en forme de pilules
                  type: GFButtonType.outline2x, // Bouton avec contour épais
                  borderSide: const BorderSide(color: Colors.black, width: 2), // Bordure noire
                ),
                const SizedBox(width: 20), // Espace entre les deux boutons
                GFButton(
                  onPressed: () {
                    print('Contre un ami button pressed');
                  },
                  text: 'Contre un ami',
                  color: GFColors.WHITE, // Couleur de fond blanc
                  textStyle: const TextStyle(color: Colors.black, fontSize: 18), // Texte noir
                  shape: GFButtonShape.pills, // Boutons arrondis en forme de pilules
                  type: GFButtonType.outline2x, // Bouton avec contour épais
                  borderSide: const BorderSide(color: Colors.black, width: 2), // Bordure noire
                ),
              ],
            ),
            const SizedBox(height: 20), // Espace après les boutons
            // Historique des parties
            Expanded(
              child: ListView.builder(
                itemCount: gameHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history, color: Colors.white),
                    title: Text(
                      gameHistory[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
