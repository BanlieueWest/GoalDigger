# Stockage sécurisé des informations utilisateurs avec AWS DynamoDB

Utiliser **AWS DynamoDB** pour stocker les informations des utilisateurs, y compris les adresses e-mail et les mots de passe, est une bonne solution, surtout si tu recherches une base de données NoSQL évolutive et gérée. Cependant, DynamoDB, en tant que service NoSQL, ne gère pas directement la sécurité des mots de passe et des e-mails, donc tu devras implémenter des mesures de sécurité spécifiques pour assurer la protection des données des utilisateurs.

## 1. Stocker les informations des utilisateurs de manière sécurisée dans DynamoDB

### A. Hashing des mots de passe avant stockage

Comme mentionné précédemment, il est impératif de **ne jamais** stocker les mots de passe en texte clair. Même dans un environnement sécurisé comme AWS, tu dois hasher les mots de passe avant de les sauvegarder dans DynamoDB.

1. **Hashing avec Bcrypt** : Utilise une bibliothèque de **hashing sécurisée** (comme Bcrypt) pour hasher les mots de passe avant de les envoyer à DynamoDB.

   - En Node.js (backend), tu pourrais utiliser `bcryptjs` ou `bcrypt` pour générer un hash sécurisé.

   Exemple en Node.js pour hasher un mot de passe :

   ```javascript
   const bcrypt = require('bcrypt');
   const saltRounds = 10;

   const hashPassword = async (password) => {
     const hashedPassword = await bcrypt.hash(password, saltRounds);
     return hashedPassword;
   };
   ```

   - Après avoir généré le hash, tu l'envoies à DynamoDB avec les autres informations de l'utilisateur.

### B. Stockage des données dans DynamoDB

Pour stocker les informations des utilisateurs dans DynamoDB, tu créeras une table avec les attributs suivants :

- **userId** (partition key) : Un identifiant unique pour chaque utilisateur (tu peux utiliser un **UUID**).
- **email** : L'adresse e-mail de l'utilisateur.
- **passwordHash** : Le mot de passe hashé (pas en clair).
- **otherInfo** : D'autres informations comme le nom de l'utilisateur, etc.

Voici un exemple de structure JSON d'un utilisateur à stocker dans DynamoDB :

```json
{
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "email": "user@example.com",
  "passwordHash": "$2b$10$abc123hashValue...",
  "firstName": "John",
  "lastName": "Doe"
}
```

### C. Créer une table DynamoDB

1. Va sur la console **AWS DynamoDB**.
2. Crée une nouvelle table appelée `Users` avec `userId` comme **Partition Key** (ou `email` si tu veux identifier les utilisateurs par e-mail, bien que `userId` soit plus recommandé pour la gestion des utilisateurs à long terme).
3. Configure les autres paramètres selon tes besoins (indexation secondaire, etc.).

### D. Ajouter les données dans DynamoDB

Une fois le mot de passe hashé, tu peux insérer les données dans DynamoDB. Voici un exemple en Node.js utilisant le SDK AWS pour insérer les informations de l'utilisateur dans DynamoDB :

```javascript
const AWS = require('aws-sdk');
const bcrypt = require('bcrypt');
const dynamoDB = new AWS.DynamoDB.DocumentClient();

const tableName = "Users";

const createUser = async (email, password, firstName, lastName) => {
  const hashedPassword = await bcrypt.hash(password, 10);
  
  const params = {
    TableName: tableName,
    Item: {
      userId: AWS.util.uuid.v4(), // Générer un UUID unique pour l'utilisateur
      email: email,
      passwordHash: hashedPassword,
      firstName: firstName,
      lastName: lastName,
    },
  };

  try {
    await dynamoDB.put(params).promise();
    console.log("User created successfully.");
  } catch (error) {
    console.error("Error creating user:", error);
  }
};
```

## 2. Authentification et validation des utilisateurs

Quand un utilisateur se connecte, tu dois comparer son mot de passe saisi avec le mot de passe hashé stocké dans DynamoDB.

1. **Récupérer l'utilisateur à partir de l'adresse e-mail** :
   Utilise l'API de DynamoDB pour récupérer l'enregistrement d'un utilisateur en fonction de son e-mail.

2. **Comparer le mot de passe saisi avec le hash stocké** :
   Utilise `bcrypt.compare` pour comparer le mot de passe saisi par l'utilisateur avec le mot de passe hashé stocké.

   Exemple :

   ```javascript
   const loginUser = async (email, password) => {
     const params = {
       TableName: tableName,
       Key: {
         email: email,
       },
     };

     const result = await dynamoDB.get(params).promise();

     if (!result.Item) {
       console.log("User not found");
       return;
     }

     const isPasswordValid = await bcrypt.compare(password, result.Item.passwordHash);
     if (isPasswordValid) {
       console.log("Login successful");
     } else {
       console.log("Invalid password");
     }
   };
   ```

## 3. Envoyer des e-mails lors de la création d'un compte

Pour envoyer des e-mails de confirmation ou de bienvenue lors de la création d'un compte, tu peux utiliser **AWS SES (Simple Email Service)**, qui est un service d'envoi d'e-mails géré par AWS.

### A. Configurer AWS SES

1. **Vérification de domaine ou d'e-mail** :
   - Avant de pouvoir envoyer des e-mails avec SES, tu dois vérifier ton domaine ou l'adresse e-mail d'envoi dans la console AWS SES.
   - Cela permet de s'assurer que tu es bien propriétaire du domaine ou de l'e-mail expéditeur.

2. **Configurer SES pour l'envoi d'e-mails** :
   - Crée une configuration pour envoyer des e-mails depuis ton adresse ou ton domaine vérifié.

### B. Envoyer un e-mail de confirmation après création du compte

Voici un exemple de code Node.js utilisant le SDK AWS pour envoyer un e-mail de bienvenue après la création du compte :

```javascript
const AWS = require('aws-sdk');
const ses = new AWS.SES({ region: 'us-east-1' });

const sendWelcomeEmail = async (email, firstName) => {
  const params = {
    Destination: {
      ToAddresses: [email],
    },
    Message: {
      Body: {
        Text: {
          Charset: "UTF-8",
          Data: `Hello ${firstName},nnWelcome to our platform! We're excited to have you on board.nnBest regards,nYour Team`,
        },
      },
      Subject: {
        Charset: "UTF-8",
        Data: "Welcome to Our Platform",
      },
    },
    Source: "no-reply@yourdomain.com",
  };

  try {
    const result = await ses.sendEmail(params).promise();
    console.log("Welcome email sent:", result);
  } catch (error) {
    console.error("Error sending email:", error);
  }
};
```

## 4. Autres aspects de sécurité

### A. Utiliser Amazon Cognito pour la gestion des utilisateurs

AWS Cognito peut gérer l'authentification des utilisateurs sans que tu aies à implémenter toi-même la gestion des mots de passe et des comptes. Il prend en charge :
- La gestion des utilisateurs.
- L'authentification par mot de passe.
- La connexion via des fournisseurs externes (Google, Facebook, etc.).
- L'envoi automatique d'e-mails de vérification ou de réinitialisation de mot de passe.

Si tu utilises Cognito, tu n'as pas besoin de gérer les mots de passe ou de hasher les mots de passe toi-même. Il intègre également une gestion d'envoi d'e-mails par défaut pour la confirmation des comptes.

### B. Configurer les permissions avec IAM
Assure-toi que les permissions IAM utilisées pour interagir avec DynamoDB et SES sont correctement configurées pour éviter des accès non autorisés.

## Conclusion

En résumé, pour stocker des informations comme l'adresse e-mail et le mot de passe des utilisateurs de manière sécurisée avec AWS DynamoDB, tu dois :

1. **Hasher les mots de passe** avant de les stocker dans DynamoDB avec un algorithme sécurisé comme Bcrypt.
2. **Utiliser DynamoDB** pour stocker les informations utilisateur (e-mail, hash du mot de passe, et autres données).
3. **Envoyer un e-mail de confirmation** lors de la création du compte avec **AWS SES**.
4. **Vérifier l'authentification** des utilisateurs lors de la connexion en comparant le mot de passe saisi avec le hash stocké.

En implémentant ces bonnes pratiques, tu assureras une gestion sécurisée des informations des utilisateurs tout en permettant une expérience fluide et sécurisée.
