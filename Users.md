# Gestion des utilisateurs dans une application de jeu en ligne avec Flutter et AWS DynamoDB

Cette documentation explique comment gérer les utilisateurs, les amis, les jeux en ligne, la recherche de personnes en ligne, la vérification de la connexion Internet, et le stockage des résultats des dernières parties dans une application Flutter avec **AWS DynamoDB** comme base de données. Les utilisateurs peuvent ajouter des amis, jouer contre eux, ou contre d'autres joueurs aléatoires en ligne.

## 1. Gestion des utilisateurs

### A. Stocker les informations des utilisateurs dans DynamoDB

Les informations des utilisateurs doivent être stockées dans une **table Users** dans DynamoDB. Chaque utilisateur est représenté par un document JSON contenant des informations de base comme l'email, l'ID utilisateur, le nom d'utilisateur et la liste de ses amis.

Exemple de structure d'un utilisateur dans la table `Users` :

```json
{
  "userId": "user_12345",
  "email": "user@example.com",
  "username": "JohnDoe",
  "friends": ["user_67890", "user_09876"],
  "currentGames": ["game_abc123", "game_xyz456"],
  "lastResults": [
    {
      "gameId": "game_123",
      "result": "win",
      "score": 100,
      "opponent": "user_987"
    },
    {
      "gameId": "game_456",
      "result": "lose",
      "score": 80,
      "opponent": "user_654"
    }
  ]
}
```

### B. Authentification avec Amazon Cognito

Pour gérer l'authentification des utilisateurs, tu peux utiliser **Amazon Cognito**, qui permet de créer un pool d'utilisateurs et d'assurer la gestion des sessions.

1. **Inscription** : L'utilisateur crée un compte avec son adresse e-mail ou via des réseaux sociaux (Google, Facebook).
2. **Connexion** : Une fois inscrit, il se connecte et obtient un token JWT.
3. **Sécurité** : Cognito gère les sessions, le chiffrement, et le renouvellement des tokens.

### C. Gestion des amis

Chaque utilisateur peut ajouter d'autres utilisateurs comme amis. Pour cela, tu peux stocker une liste de `userId` dans l'attribut `friends` de chaque utilisateur.

1. **Ajouter un ami** : Lorsqu'un utilisateur envoie une demande d'ajout d'ami, tu peux créer un lien dans DynamoDB dans la liste `friends` de chaque utilisateur.

   Exemple :
   ```json
   {
     "userId": "user_12345",
     "friends": ["user_67890", "user_09876"]
   }
   ```

2. **Rechercher des amis** : Pour rechercher des amis, tu peux utiliser **AWS DynamoDB Query** en cherchant par `username`.

3. **Accepter une demande d'ami** : Lorsque l'utilisateur accepte une demande d'ami, tu mets à jour la liste des amis de chaque utilisateur dans la table `Users`.

## 2. Jeux en ligne contre des amis

### A. Créer une partie contre un ami

Lorsqu'un utilisateur veut jouer contre un ami, il peut créer une nouvelle entrée dans la **table Games**. Cette table stockera les informations sur la partie, les joueurs impliqués, et l'état de la partie.

Exemple de document dans la table `Games` :

```json
{
  "gameId": "game_abc123",
  "players": [
    {
      "userId": "user_12345",
      "score": 100,
      "status": "waiting"
    },
    {
      "userId": "user_67890",
      "score": 80,
      "status": "playing"
    }
  ],
  "status": "in-progress",
  "currentQuestion": "question_001"
}
```

### B. Démarrer une partie

1. **Créer une partie** : L'utilisateur sélectionne un ami dans sa liste d'amis et envoie une invitation. Un nouvel enregistrement est créé dans la table `Games` avec les deux `userId`.
2. **Accepter l'invitation** : Lorsque l'ami accepte, la partie démarre et le statut passe à `in-progress`.

### C. Synchronisation des jeux

Pour synchroniser les actions en temps réel entre les deux utilisateurs (par exemple, réponses aux questions, scores), tu peux utiliser :
- **Amazon API Gateway avec WebSocket** : Permet la communication bidirectionnelle en temps réel entre les appareils.
- **AWS AppSync** : Offre une solution **GraphQL** en temps réel pour la synchronisation des données.

## 3. Recherche de joueurs en ligne

Si un utilisateur veut jouer contre une personne aléatoire en ligne, tu dois créer un mécanisme pour rechercher des joueurs disponibles.

### A. Stocker l'état en ligne des utilisateurs

Chaque fois qu'un utilisateur est connecté à l'application, tu peux mettre à jour son état en ligne dans DynamoDB avec un attribut `isOnline`.

Exemple de structure de l'utilisateur avec état en ligne :

```json
{
  "userId": "user_12345",
  "isOnline": true,
  "lastActive": "2024-10-14T10:00:00Z"
}
```

### B. Rechercher des utilisateurs disponibles

Pour rechercher des joueurs disponibles en ligne, tu peux utiliser une **requête DynamoDB** sur l'attribut `isOnline`.

1. L'utilisateur envoie une demande pour rechercher un joueur.
2. DynamoDB retourne une liste d'utilisateurs qui sont actuellement en ligne (`isOnline` = true).
3. Un nouveau jeu est créé avec l'utilisateur sélectionné.

### C. Gestion des parties multijoueurs

Les parties multijoueurs aléatoires peuvent être gérées de la même manière que les jeux contre des amis, en créant un nouvel enregistrement dans la table `Games` et en ajoutant les `userId` des joueurs sélectionnés.

## 4. Détection de la connexion Internet

Dans une application Flutter, il est essentiel de vérifier si l'utilisateur est connecté à Internet avant de lancer une partie en ligne.

### A. Utiliser le package `connectivity_plus`

Le package `connectivity_plus` te permet de vérifier l'état de la connexion Internet (Wi-Fi ou données mobiles) de l'utilisateur.

1. **Installation du package** :
   ```yaml
   dependencies:
     connectivity_plus: ^2.3.1
   ```

2. **Exemple de code pour vérifier la connexion** :

   ```dart
   import 'package:connectivity_plus/connectivity_plus.dart';

   Future<bool> isUserConnected() async {
     var connectivityResult = await (Connectivity().checkConnectivity());
     if (connectivityResult == ConnectivityResult.mobile ||
         connectivityResult == ConnectivityResult.wifi) {
       return true;
     } else {
       return false;
     }
   }
   ```

3. Si l'utilisateur n'est pas connecté, affiche un message pour lui indiquer qu'une connexion Internet est nécessaire pour jouer en ligne.

## 5. Stocker les derniers résultats des parties

Pour permettre aux utilisateurs de consulter les résultats de leurs dernières parties, tu peux stocker un historique des parties jouées dans l'attribut `lastResults` de la table `Users`.

### A. Stocker les résultats des parties

Après chaque partie, les résultats peuvent être ajoutés à la liste `lastResults` de l'utilisateur dans DynamoDB. Cette liste contient les informations sur chaque partie, y compris l'adversaire, le score et le résultat (victoire ou défaite).

Exemple de structure des résultats dans `Users` :

```json
{
  "userId": "user_12345",
  "lastResults": [
    {
      "gameId": "game_123",
      "result": "win",
      "score": 100,
      "opponent": "user_987"
    },
    {
      "gameId": "game_456",
      "result": "lose",
      "score": 80,
      "opponent": "user_654"
    }
  ]
}
```

### B. Limiter le nombre de résultats stockés

Pour limiter la taille des données stockées, tu peux conserver uniquement les **n derniers résultats** en utilisant une logique pour supprimer les anciens résultats lorsque la liste atteint une certaine taille (par exemple, 10 derniers résultats).

Exemple de logique en Dart pour limiter à 10 résultats :

```dart
void updateLastResults(List<Map<String, dynamic>> lastResults, Map<String, dynamic> newResult) {
  if (lastResults.length >= 10) {
    lastResults.removeAt(0); // Supprime le plus ancien résultat
  }
  lastResults.add(newResult);
}
```

## 6. Notifications en temps réel

Pour notifier les utilisateurs en temps réel (par exemple, lorsqu'un ami invite à une partie ou lorsqu'un adversaire a terminé son tour), tu peux utiliser **AWS SNS (Simple Notification Service)** ou **AWS Pinpoint**.

### A. Notifications push avec AWS SNS

1. Configure **AWS SNS** pour envoyer des notifications push aux appareils Android et iOS via **Firebase Cloud Messaging (FCM)** et **Apple Push Notification Service (APNS)**.
2. Utilise les notifications pour informer les utilisateurs de nouveaux événements, tels qu'une invitation à une partie ou la fin d'une partie.

Exemple de code pour envoyer une notification via AWS SNS (en Node.js) :

```javascript
const AWS = require('aws-sdk');
const sns = new AWS.SNS();

const sendNotification = async (message, targetArn) => {
  const params = {
    Message: message,
    TargetArn: targetArn
  };

  try {
    await sns.publish(params).promise();
    console.log('Notification sent');
  } catch (error) {
    console.error('Error sending notification', error);
  }
};
```

## Conclusion

Cette documentation explique comment structurer ton application Flutter avec **AWS DynamoDB** pour gérer les utilisateurs, les amis, les jeux en ligne contre d'autres joueurs, la recherche de personnes en ligne, la détection de la connexion Internet, et le stockage des derniers résultats des parties. Grâce à **AWS Lambda**, **API Gateway**, **AppSync**, et **SNS**, tu peux créer une application multijoueur fluide et réactive sur Android et iOS, avec une gestion robuste des utilisateurs et des parties.
