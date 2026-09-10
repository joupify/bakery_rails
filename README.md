# Bakery Rails

Application de commande en ligne pour les commerces de proximité, avec panier,
réservation, paiement Stripe et confirmation par e-mail.

## Fonctionnalités implementées

- Authentification (Devise)
- Panier (`has_one :cart`)
- Réservations
- Paiement en boutique
- Paiement Stripe
- Webhooks Stripe
- Stripe Products
- Stripe Prices
- Stripe Customers
- Vidage panier (Stripe)
- Emails de confirmation
- Page "Mes réservations"
- Déploiement Render
- Statistiques produits (Stripe)

## Stack technique

- Ruby on Rails 8.1
- PostgreSQL
- Stripe (paiements et webhooks)
- Hotwire Turbo (interactions dynamiques)
- Bootstrap 5 (interface responsive)
- Active Storage (gestion des images)
- Dotenv (gestion des variables d'environnement)
- Devise (authentification)
- Kamal (déploiement)
- Letter Opener (emails en développement)

Fonctionnalités visibles
✅ Historique des réservations
✅ Statut (paid/pending)
✅ Date de retrait
✅ Mode de paiement (en ligne / en boutique)
✅ Total
✅ Produits commandés

## Fonctionnalités prévues pour les commerçants du quartier

### Fidélisation

- Carte de fidélité numérique avec points ou tampons par achat.
- Coupons promotionnels valables sur une période ou certains créneaux.
- Notifications pour les nouveautés, offres du jour et fermetures exceptionnelles.

### Visibilité locale

- Page dédiée à chaque commerçant avec horaires, adresse, photos, téléphone et produits.
- Carte interactive des commerces du quartier.
- Recherche par catégorie : boulangerie, restaurant, épicerie, coiffeur, etc.
- Page regroupant les offres du jour des commerces locaux.

### Gestion commerçant

- Tableau de bord avec commandes, chiffre d'affaires et produits populaires.
- Gestion des stocks avec masquage automatique des produits indisponibles.
- Gestion des horaires, congés et fermetures exceptionnelles.
- Export des commandes en CSV ou PDF.

### Communauté

- Avis clients vérifiés après une commande.
- Programme de parrainage.
- Commandes groupées entre voisins.
- Calendrier des événements du quartier.

## Fonctionnalités à développer

### Priorité 1 — Espace commerçant

- [ ] Tableau de bord avec commandes, chiffre d'affaires et produits populaires.
- [ ] Gestion des produits et des stocks.
- [ ] Masquage automatique des produits indisponibles.
- [ ] Gestion des horaires, congés et fermetures exceptionnelles.
- [ ] Gestion des promotions et offres du jour.
- [ ] Export des commandes en CSV ou PDF.

### Priorité 2 — Fidélisation et communauté

- [ ] Carte de fidélité numérique avec points ou tampons par achat.
- [ ] Coupons promotionnels valables sur une période ou certains créneaux.
- [ ] Notifications pour les nouveautés, offres et fermetures exceptionnelles.
- [ ] Avis clients vérifiés après une commande.
- [ ] Programme de parrainage.

### Priorité 3 — Développement local

- [ ] Page dédiée à chaque commerçant avec horaires, adresse, photos, téléphone et produits.
- [ ] Recherche par catégorie : boulangerie, restaurant, épicerie, coiffeur, etc.
- [ ] Carte interactive des commerces du quartier.
- [ ] Page regroupant les offres du jour des commerces locaux.
- [ ] Commandes groupées entre voisins.
- [ ] Calendrier des événements du quartier.

### Prochaines étapes possibles

Tests automatisés (RSpec)

Interface admin pour gérer les réservations

Notifications (SMS, push)

Statistiques (produits stars, CA)

Déploiement final sur Render

La priorité recommandée est de créer l'espace commerçant afin de transformer
l'application en outil quotidien de gestion, au-delà d'une simple vitrine en ligne.
