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
