class ProductController < ApplicationController
  def index
    @products = Product.all
    @hours = {
      "Lundi" => "07h30 – 20h00",
      "Mardi" => "07h30 – 20h00",
      "Mercredi" => "07h30 – 20h00",
      "Jeudi" => "07h30 – 20h00",
      "Vendredi" => "07h30 – 20h00",
      "Samedi" => "07h30 – 19h30",
      "Dimanche" => "Fermé"
    }
    @services = [
      "Paiement CB — Mastercard, Visa",
      "Click & Collect sans attente",
      "Paiement en ligne Stripe",
      "Livraison Deliveroo 7j/7",
      "Petit-déjeuner & déjeuner sur place",
      "Terrasse extérieure",
      "Commandes spéciales 48h"
    ]
    @bakery = {
      name: "Boulangerie Sainte Périne",
      address: "118 avenue de Versailles, 75016 Paris",
      phone: "01 45 27 26 55",
      phone_href: "tel:+33145272655",
      email: "laboulabgeriesainteperine@gmail.com",
      metro: "Métro Michel-Ange Auteuil (L9/L10) · Bus 22, 72",
      parking: "Stationnement disponible avenue de Versailles",
      map_url: "https://www.google.com/maps/dir/?api=1&destination=118+Avenue+de+Versailles,+75016+Paris,+France",
      map_embed: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2625.384!2d2.259628!3d48.846534!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47e6701a97c7e6fb%3A0xb52a6ea2af06a7de!2s118+Av.+de+Versailles%2C+75016+Paris!5e0!3m2!1sfr!2sfr!4v1700000000000"
    }
  end
end
