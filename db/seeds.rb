# db/seeds.rb
products = [
  {
    name: "Baguette de Tradition",
    description: "Dorée, craquante, façonnée à la main. Croûte épaisse, mie alvéolée.",
    price_cents: 120,
    image: "image_2.jpg"
  },
  {
    name: "Tarte aux Fruits Rouges",
    description: "Framboises, mûres, fraises sur crème pâtissière vanille.",
    price_cents: 650,
    image: "image_4.jpg"
  },
  {
    name: "Cake Chocolat & Brioches",
    description: "Cake moelleux intense et brioches dorées au beurre.",
    price_cents: 380,
    image: "image_5.jpg"
  },
  {
    name: "Petits Gâteaux Glacés",
    description: "Entremets de saison à la finition miroir.",
    price_cents: 550,
    image: "image_6.jpg"
  },
  {
    name: "Formule Petit-Déjeuner",
    description: "Café, croissant pur beurre et jus d'orange pressé.",
    price_cents: 690,
    image: "image_7.jpg"
  },
  {
    name: "Tarte Halloween",
    description: "Tarte caramel araignée et miroir orange.",
    price_cents: 750,
    image: "hallloeeen.jpg"
  },
  {
    name: "Poussins de Pâques",
    description: "Tartelettes citron, crème yuzu et chocolat blanc.",
    price_cents: 450,
    image: "poussins_de_paques.jpg"
  },
  {
    name: "Salade riz et poulet",
    description: "Salade riz et poulet avec vinaigrette maison.",
    price_cents: 700,
    image: "salade_riz_et_poulet.jpg"
  },
  {
    name: "Salade poulet avocat",
    description: "Salade poulet avocat avec vinaigrette maison.",
    price_cents: 650,
    image: "salade_poulet_avocat.jpg"
  }
]

products.each do |attributes|
  Product.find_or_create_by!(name: attributes[:name]) do |product|
    product.description = attributes[:description]
    product.price_cents = attributes[:price_cents]
    product.image = attributes[:image]  # 👈 Utiliser la colonne existante
  end
end

puts "#{Product.count} produits présents."