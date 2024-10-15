# GoalDigger
Application Quizz Foot

## BDD

| **Solution**               | **Coût**                                                  | **Usage recommandé**                                                                                       | **Performance**                                                                 |
|----------------------------|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| **Amazon Athena (S3)**     | Pay-per-query ($5/To analysé)                             | Analyses occasionnelles, large volume de données, flexibilité de format (JSON/CSV/Parquet).                | Bon pour des requêtes ad-hoc, pas idéal pour de l'accès en temps réel fréquent. |
| **SQLite (local)**         | Gratuit                                                   | Données locales, sans synchronisation. Peu de requêtes fréquentes.                                         | Très rapide pour des petites/moyennes bases de données locales.                 |
| **Firebase (Firestore)**   | Gratuit jusqu'à un certain seuil, puis payant             | Synchronisation temps réel, gestion facile de petites/moyennes données, applications mobiles interactives. | Très performant pour des applications mobiles avec synchronisation.             |
| **DynamoDB (AWS)**         | Pay-per-usage                                             | Applications en temps réel nécessitant une grande scalabilité.                                             | Très rapide pour des requêtes fréquentes et à grande échelle.                   |
| **JSON statique sur S3**   | Gratuit (si hébergé sur S3, coût minime pour le stockage) | Si les données sont statiques et peu mises à jour, application simple avec peu de requêtes en temps réel.  | Rapide pour une petite application sans requêtes complexes.                     |

### Stockage des données

- Format de stockage des questions : Comment les questions seront-elles structurées ? Chaque question devrait avoir :
-- Un identifiant unique.
-- Le texte de la question.
-- Quatre réponses possibles.
-- L'indice ou l'identifiant de la bonne réponse.

**Exemple de question en JSON**
```json
{
  "id": 1,
  "question": "What is the capital of France?",
  "options": ["Berlin", "Madrid", "Paris", "Lisbon"],
  "correctAnswerIndex": 2
}
```

## Scénario de MAJ

- **Mises à jour des questions** : Si les questions sont mises à jour fréquemment, tu dois réfléchir à la manière de mettre à jour les données sans obliger les utilisateurs à télécharger une nouvelle version de l'application. Si tu utilises Firebase ou un autre service cloud, il est facile de faire des mises à jour sans toucher au code source de l'application.

## Choisir un modèle économique (Monétisation)

- **Publicités** : Si tu veux inclure des publicités, tu peux envisager d'utiliser des plateformes comme Google AdMob.
- **Version gratuite/premium** : Tu pourrais avoir une version gratuite avec les pubs qui apparaissent assez régulièrement, et une version premium sans les pubs (Payement de 3€).

## Gérer les autorisations et la sécurité
- **Gestion des autorisations** : Si ton application nécessite des fonctionnalités comme l'accès à Internet, pense à bien les déclarer dans le fichier de configuration de Flutter (AndroidManifest.xml pour Android et Info.plist pour iOS).
- **Sécurité des données** : Si tu stockes des données sensibles, comme les résultats des utilisateurs, assure-toi d'utiliser des techniques de cryptage appropriées et de respecter les meilleures pratiques en matière de sécurité des données.
- **Sécurité des comptes Utilisateur** : si tu stockes des données sensible, assure-toi d'utiliser des techniques de cryptage appropriées et de respecter les meilleures pratiques en matière de sécurité des données.
